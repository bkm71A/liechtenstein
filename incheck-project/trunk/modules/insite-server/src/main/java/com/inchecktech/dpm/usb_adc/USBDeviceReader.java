package com.inchecktech.dpm.usb_adc;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.TimerTask;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Line;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.Mixer;
import javax.sound.sampled.TargetDataLine;

import com.inchecktech.dpm.utils.Logger;

public class USBDeviceReader extends TimerTask {
    public static final String MESSAGE_PREFIX = "{USB Device}";
    public static final int TIME_TO_WAIT = 5000;// milliseconds
    public static final int CHANNEL_OFFSET = 1000;
    private static final Logger logger = new Logger(USBDeviceReader.class);
    private final String deviceName;
    private boolean running = false;
    private USBDataSender dataSender;

    /**
     * @param deviceName USB ADC Device Name String like "iMic USB audio"
     */
    public USBDeviceReader(String deviceName) {
        super();
        this.deviceName = deviceName;
    }

    private void start() {
        if (isRunning()) {
            logger.error(String.format("%s %s is already running !", MESSAGE_PREFIX, deviceName));
            return;
        }
        TargetDataLine targetDataLine = null;
        Mixer.Info[] infos = AudioSystem.getMixerInfo();
        String mixerName = "";
        for (Mixer.Info info : infos) {
            Mixer mx = AudioSystem.getMixer(info);
            //if (info.getName().indexOf(deviceName) >= 0) {
                for (Line.Info lineInfo : mx.getTargetLineInfo()) {
                    try {
                        Line line = mx.getLine(lineInfo);
                        if (line instanceof TargetDataLine) {
                            targetDataLine = (TargetDataLine) line;
                            mixerName = info.getName();
                        }
                    } catch (LineUnavailableException e) {
                        logger.error(MESSAGE_PREFIX, e);
                    }
                    break;
                }
            //}
        }
        if (targetDataLine == null) {
            logger.warn(String.format("%s '%s' not found !!!", MESSAGE_PREFIX, deviceName));
        } else {
            setRunning(true);
            readBytesFromMixer(targetDataLine, mixerName);
        }
    }

    private synchronized void setRunning(boolean running) {
        this.running = running;
    }

    private boolean isRunning() {
        return running;
    }

    private void readBytesFromMixer(TargetDataLine targetDataLine, String mixerName) {
        try {
            targetDataLine.open();
            if (targetDataLine.isOpen()) {
                targetDataLine.start();
                AudioFormat audioFormat = targetDataLine.getFormat();
                if (audioFormat.getSampleSizeInBits() != 16) {
                    throw new UnsupportedOperationException(String.format("Only 16 bit channels are supported, not %d bits !!!", audioFormat
                            .getSampleSizeInBits()));
                }
                dataSender = new USBDataSender(audioFormat.getChannels(), audioFormat.getSampleRate());
                byte[] buffer = new byte[dataSender.getSamplingSize() * audioFormat.getFrameSize()];
                logger.info(String.format("%s='%s';AudioFormat=%s;", MESSAGE_PREFIX, mixerName, audioFormat));
                while (isRunning()) {
                    int bytesRead = targetDataLine.read(buffer, 0, buffer.length);
                    if (bytesRead > 0) {
                        double[][] channelData = byteArrayToDoubleArrays(buffer, bytesRead, audioFormat.isBigEndian(), audioFormat.getChannels());
                        dataSender.processData(channelData);
                        Thread.sleep(TIME_TO_WAIT);
                        targetDataLine.flush();
                    }
                }
            }
        } catch (Throwable e) {
            logger.error(MESSAGE_PREFIX + " - read exception.", e);
        } finally {
            if (targetDataLine != null && targetDataLine.isRunning()) {
                targetDataLine.stop();
            }
            if (targetDataLine != null && targetDataLine.isOpen()) {
                targetDataLine.close();
            }
            setRunning(false);
        }
        logger.info(MESSAGE_PREFIX + " - reading stopped.");
    }

    /**
     * Converts array of row bytes to channel short arrays
     * 
     * @param paRawBytes
     *            - raw data bytes red from USB device
     * @param arraySize
     *            - raw array size, actual data , might be less than paRawBytes.size
     * @param pbBigEndian
     *            - byte order /BIG_ENDIAN,LITTLE_ENDIAN/
     * @param channels
     *            - number of channels
     * @return array (one per channel) of double arrays
     */
    private static double[][] byteArrayToDoubleArrays(byte[] paRawBytes, int arraySize, boolean pbBigEndian, int channels) {
        int numberOfShorts = arraySize / 2;
        double[][] dataArray = new double[channels][];
        for (int i = 0; i < channels; i++) {
            dataArray[i] = new double[numberOfShorts / channels];
        }
        ByteBuffer bb = ByteBuffer.wrap(paRawBytes, 0, arraySize);
        bb.order(pbBigEndian ? ByteOrder.BIG_ENDIAN : ByteOrder.LITTLE_ENDIAN);
        for (int j = 0; j < numberOfShorts; j++) {
            dataArray[j % channels][j / channels] = (double)bb.getShort(j * 2);
        }
        return dataArray;
    }

    public void run() {
        if (!isRunning()) {
            start();
        }
    }
}
