package com.incheck.ng.network;

import static com.incheck.ng.model.ChannelConfigConstant.BLOCK_SIZE;
import static com.incheck.ng.model.ChannelConfigConstant.SAMPLING_RATE;
import static com.incheck.ng.model.ChannelType.DYNAMIC;

import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.incheck.ng.dao.DataAcquisitionModuleDao;
import com.incheck.ng.dsp.DSPCalculator;
import com.incheck.ng.model.Channel;
import com.incheck.ng.model.ChannelType;
import com.incheck.ng.model.DataAcquisitionModule;
import com.incheck.ng.model.Sensor;
import com.incheck.ng.model.data.ChannelState;
import com.incheck.ng.model.data.RawData;
import com.incheck.ng.util.Pair;
import com.incheck.ng.webapp.ApplicationContextProvider;

public class DPMClientSocketHandler extends Thread {

    private final Log log = LogFactory.getLog(DPMClientSocketHandler.class);
    public Socket socket = null;
    static final String CRLF = "\r\n";
    private DataOutputStream dout = null;
    private static final byte CR = 13;
    private static final byte LF = 10;
    private DataInputStream din = null;
    private DataAcquisitionModule dam = null;
    private boolean shouldRun = true;
    private int serverPort;
    private Map<Long, Pair<Long, ChannelType>> deviceChannelMap = new HashMap<Long, Pair<Long, ChannelType>>();

    public DPMClientSocketHandler(Socket s, int serverPort, String threadName) {
        super(threadName);
        this.socket = s;
        this.serverPort = serverPort;
    }

    @Override
    public void run() {
        try {
            din = new DataInputStream(socket.getInputStream());
            dout = new DataOutputStream(socket.getOutputStream());
        } catch (Throwable e) {
            log.error(e);
            return;
        }
        List<int[]> intHolder = new ArrayList<int[]>();
        try {
            while (shouldRun) {
                try {
                    ByteArrayOutputStream bos = new ByteArrayOutputStream();
                    boolean stillLookingForHeader = true;
                    int cntr = -1;
                    while (stillLookingForHeader) {
                        cntr++;
                        if (cntr > 300) {
                            log.error("Couldnt find header after reading 200 bytes.. exiting.. " + this.getName());
                            return;
                        }
                        bos.write(din.readByte());
                        if (cntr > 3) {
                            byte headerArray[] = bos.toByteArray();
                            if (headerArray[cntr - 3] == CR && headerArray[cntr - 2] == LF && headerArray[cntr - 1] == CR
                                    && headerArray[cntr] == LF) {
                                String header = new String(headerArray);
                                log.debug("HERE IS THE HEADER :" + header + ":" + this.getName());
                                stillLookingForHeader = false;
                                DAMMessageType type = getDAMMessageType(header);
                                if (type == null) {
                                    log.error("Unknown Message type " + header + "\t" + this.getName());
                                    System.err.println("Unknown Message type " + header);
                                } else {
                                    switch (type) {
                                    case REGISTER:
                                        String mac = header.split("\n")[0].trim().split(" ")[1].trim();
                                        processRegisterMessage(mac);
                                        break;
                                    case DISCOVER:
                                        log.error("Message Type " + type + " is not supported");
                                        break;
                                    case DATA:
                                        processDataMessage(intHolder, header);
                                        break;
                                    default:
                                        log.error("Wrong message type :" + type);
                                    }
                                }
                            }
                        }
                    }
                } catch (Throwable e) {
                    String message = "Exception for " + (dam == null ? getName() : dam.getSerialNumber());
                    log.error(message, e);
                    return;
                }
            }
        } finally {
            try {
                socket.close();
            } catch (Throwable e2) {
                log.error(e2);
            }
        }
    }

    private int[] getIntArr(byte[] bin) {
        ByteBuffer finalBuffer = ByteBuffer.wrap(bin);
        finalBuffer.order(ByteOrder.LITTLE_ENDIAN);
        finalBuffer.rewind();
        int[] dataArray = new int[bin.length / 2];
        for (int i = 0; i < dataArray.length; i++) {
            int data = finalBuffer.getChar() & 0xffff;
            dataArray[i] = data;
        }
        return dataArray;
    }

    private void processDataMessage(DAMDataMessage dm) {
        ArrayList<Integer> finarr = new ArrayList<Integer>();
        List<int[]> sourceArray = dm.getArrayOfIntArrays();
        for (int arin[] : sourceArray) {
            for (int i = 0; i < arin.length; i++) {
                finarr.add(arin[i]);
            }
        }
        int[] dataArray = new int[finarr.size()];
        for (int i = 0; i < dataArray.length; i++) {
            dataArray[i] = finarr.get(i);
        }
        Long damChannelId = dm.getDamChannelId();
        if (deviceChannelMap.get(damChannelId) == null) {
            log.error(" no mapping to  device channel id " + damChannelId + " for DAM " + dam.getId() + " with mac "
                    + dam.getSerialNumber() + "\t" + this.getName());
            return;
        }
        Long channelId = deviceChannelMap.get(damChannelId).getLeft();
        final RawData rawData = new RawData(channelId, dm.getSamplingRate(), dataArray);
        final DSPCalculator calculator = (DSPCalculator) ApplicationContextProvider.getApplicationContext().getBean(
                DYNAMIC == deviceChannelMap.get(damChannelId).getRight() ? "dynamicCalculator" : "staticCalculator");
        new Thread(new Runnable() {
            @Override
            public void run() {
                ChannelState channelState = calculator.processData(rawData);
//                TODO implement AlarmEngine 
                /*
                AlarmEngine alarmEngine = DataBucket.getAlarmEngine(DPMChannelId);
                if (alarmEngine == null) {
                    alarmEngine = new AlarmEngine();
                    alarmEngine.initAlarmEngine(node);
                    DataBucket.addOrReplaceAlarmEngine(DPMChannelId, alarmEngine);
                }
                alarmEngine.evaluateThresholds(channelState);
                */
            }
        }).start();
    }

    private DAMMessageType getDAMMessageType(String header) {
        String headerLines[] = header.split("\n");
        for (DAMMessageType eachType : DAMMessageType.values()) {
            if (headerLines[0].startsWith(eachType.toString())) {
                return eachType;
            }
        }
        return null;
    }

    private void processRegisterMessage(String mac) throws IOException {
        DataAcquisitionModuleDao damDao = (DataAcquisitionModuleDao) ApplicationContextProvider.getApplicationContext().getBean("damDao");
        DataAcquisitionModule dam = damDao.getBySerialNumber(mac);
        if (dam == null) {
            log.error("Cannot register DAM, serial/mac=" + mac + " not found!!!");
            return;
        }
        // DataBucket.addOrReplaceDevice(dam.getDeviceId()+"", dam, mac);
        this.dam = dam;
        String cont = "";
        for (Sensor sensor : dam.getSensors()) {
            for (Channel channel : sensor.getChannels()) {
                deviceChannelMap.put(channel.getDamChannelId(), new Pair<Long, ChannelType>(channel.getId(), channel.getChannelType()));
                String samplerate = channel.getChannelConfig().get(SAMPLING_RATE);
                String numOfsample = channel.getChannelConfig().get(BLOCK_SIZE);
                String chidstr = String.valueOf(channel.getId());
                if (chidstr.length() == 1) {
                    chidstr = "0" + chidstr;
                }
                if (samplerate != null && numOfsample != null && chidstr != null && !chidstr.equals("")) {
                    cont += "[CHANNEL-" + chidstr + "]" + CRLF + "SamplingRate=" + samplerate + CRLF + "SamplingInterval=10" + CRLF
                            + "Samples=" + numOfsample + CRLF;
                }
            }
        }
        log.info(String.format("DAM with id=%d and serial=%s connected.", dam.getId(), dam.getSerialNumber()));
        String response = "DDP/1.0 200 OK" + CRLF + "Controller-ID:" + dam.getId() + CRLF + "Time-Stamp:1209866566" + CRLF + "To:"
                + getIpAddress() + ":" + serverPort + CRLF + "From:" + socket.getRemoteSocketAddress().toString().replaceFirst("/", "")
                + CRLF + "Message-ID:1 REGISTER" + CRLF + "Content-Length:0" + CRLF + CRLF;
        log.debug("SENDING : \n" + response + "\n-------------------" + "\t" + this.getName());
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            log.error(e);
        }
        synchronized (dout) {
            dout.write(response.getBytes());
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                log.error(e);
            }
        }
        response = "UPDATE " + dam.getId() + " DDP/1.0" + CRLF + "Content-Type:config" + CRLF + "Message-ID:2 UPDATE" + CRLF
                + "Content-Length:" + cont.getBytes().length + CRLF + CRLF + cont + CRLF;
        log.info("UPDATING CONFIG WITH " + cont + "\t" + this.getName());
        synchronized (dout) {
            dout.write(response.getBytes());
        }
    }

    private void processDataMessage(List<int[]> intHolder, String header) throws IOException {
        log.debug("Message is DATA \n\t" + this.getName());
        DAMDataMessage msg = new DAMDataMessage(header);
        byte toReadNow[] = new byte[msg.getBytesToRead()];
        din.readFully(toReadNow);
        intHolder.add(getIntArr(toReadNow));
        if (msg.isLastMessage()) {
            msg.setArrayOfIntArrays(intHolder);
            processDataMessage(msg);
            intHolder.clear();
        }
    }

    public void setShouldRun(boolean shouldRun) {
        this.shouldRun = shouldRun;
    }

    static String getIpAddress() {
        try {
            return InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException e) {
            return "127.0.0.1";
        }
    }

    static enum DAMMessageType {
        REGISTER("REGISTER"), DISCOVER("DISCOVER"), DATA("DATA");
        private DAMMessageType(String name) {
            this.name = name;
        }

        private final String name;

        public String toString() {
            return name;
        }
    }
}
