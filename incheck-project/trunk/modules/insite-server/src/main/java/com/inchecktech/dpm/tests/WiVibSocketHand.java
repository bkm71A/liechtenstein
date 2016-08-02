package com.inchecktech.dpm.tests;

import java.io.BufferedWriter;
import java.io.DataInputStream;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.nio.ByteBuffer;

import com.inchecktech.dpm.alarmEngine.AlarmEngine;
import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.dsp.DSPCalculator;
import com.inchecktech.dpm.dsp.DSPFactory;
import com.inchecktech.dpm.utils.Logger;

public class WiVibSocketHand extends Thread {

	private Socket socket;
	private static final Logger logger = new Logger(WiVibSocketHand.class);

	public WiVibSocketHand(Socket s) {
		this.socket = s;
	}

	@Override
	public void run() {

		System.err.println("Started WiVibSocketHand " + this.getName());
		try {
			
			int lastChannel=1;
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(
					socket.getOutputStream()));
			bw.write("CH1;SP1;GA10;SR 2560;AQ;BD?\n");
			bw.flush();

			InputStream is = socket.getInputStream();
			DataInputStream dis = new DataInputStream(is);

			byte bbuf[] = new byte[5];
			
			while (true) {
				
				dis.readFully(bbuf);
				String cmd = new String(bbuf);
				System.out.println(cmd);
				dis.readByte();
				if (cmd.equals("OK:AQ")) {
					// we know next result is BD
					byte bdbuf[] = new byte[3];
					dis.readFully(bdbuf);
					String bdcmd = new String(bdbuf);
					System.out.println("bdcmd=:" + bdcmd + ":");
					if (bdcmd.equals("BD=")) {

						System.out.println("IN BD");
						byte status = dis.readByte();
						byte range = dis.readByte();
						byte reserved = dis.readByte();
						int sensitivity = dis.readChar();
						int dataLen = dis.readChar();
						System.out.println("dataLen=" + dataLen);
						byte dbuf[] = new byte[dataLen * 2];
						dis.readFully(dbuf);
						ByteBuffer dataBuffer = ByteBuffer.wrap(dbuf);
						int dataArray[] = new int[dataLen];
						for (int i = 0; i < dataLen; i++) {
							int data = dataBuffer.getShort();
							dataArray[i] = data;

						}
						

						
						try {
							int ChID = 4+lastChannel;
							int devNum = 2;
							String name = "WiVib"+ChID;
							int SampRate = 2560;
							int TimeStamp = 0;
							ICNode node = DataBucket.getICNode(ChID);
							if (node == null) {
								
								System.out.println("CHANNEL ID "+ChID +" is not defined....  skipping");
								System.err.println("CHANNEL ID "+ChID +" is not defined....  skipping");
								continue;
								/*
								node = new ICNode();
								node.setName(name);
								node.setId(ChID + devNum);

								node.setDeviceId(devNum);
								node.setLabel(name);
								node.setChannelid(ChID);

								DataBucket.addOrReplaceICNode(name, node);*/
							}

							node.setSamplingRate(SampRate);
							long tstart = System.currentTimeMillis();
							// System.out.println("STARTING........
							// "+tstart+"\n\n\n");

							DSPCalculator calc = DataBucket
									.getDSPCalculator(ChID);

							if (calc == null) {
								/*
								 * if(msgType==1 && ChID!=4){
								 * System.out.println("\n\nChID="+ChID+" using
								 * DYNAMIC\n\nC"); calc=new
								 * DSPDynamicCalculator(ChID); }else{
								 * System.out.println("\n\nCChID="+ChID+" using
								 * STATIC\n\nC"); calc=new
								 * DSPStaticCalculator(ChID); }
								 */
								calc = DSPFactory.newDSPCalculator(ChID);
								DataBucket
										.addOrReplaceDSPCalculator(ChID, calc);
							}

							RawData raw = new RawData(ChID);
							raw.setChannelId(ChID);
							raw.setSamplingRate(SampRate);
							raw.setDateTimeStamp(new java.util.Date(System.currentTimeMillis()));
							// raw.setDataTicks(tickData);
							raw.setData(dataArray);

							ChannelState st = calc.processData(raw, null);

							if (calc.isDebugMode()) { // TD: DEBUG MODE - STORE DSP CORE DUMP FOR THE CHANNEL
								DataBucket.putDSPCoreDump(calc.getDspCoreDump()
										.getChannelId(), calc.getDspCoreDump());
							}

							//System.out.println("IN HERE!!!!!!!!!!!!\n\n\n");
							//node.setChannelState(st);
							DataBucket.putChannelState(node.getChannelid(), st);
							node.setProcessedDataKeysString(st
									.getProcessedData().keySet());

							//node.setlatestRawData(raw);
							//node.setTickData1(tickData1);
							//node.setTickData2(tickData2);

							// TLD: Alarm Engine integration - Start - 1/2/2008
							// Comment out this section if it is causing problems
							try {
								AlarmEngine alarmEngine = DataBucket
										.getAlarmEngine(ChID);

								if (alarmEngine == null) {
									alarmEngine = new AlarmEngine();
									alarmEngine.initAlarmEngine(node);

									DataBucket.addOrReplaceAlarmEngine(ChID,
											alarmEngine);
								}

								alarmEngine.evaluateThresholds(st);
								//node.setEvents(alarmEngine.getEvents());

							} catch (Exception ex) {
								logger.info(":Exception in Alarm Engine: "
										+ ex.getLocalizedMessage());
								ex.printStackTrace();
								ex.printStackTrace(System.out);
							}
							// TLD: Alarm Engine integration - End - 1/2/2008

							DataBucket.updateNotifier.notifyUpdate(node);

						} catch (Throwable e) {
							System.err.println("ERROR in WIVIB PROC");
							System.out.println("ERROR in WIVIB PROC");
							e.printStackTrace(); 
						}
						System.out.println("READ FULLY");
						
						if(lastChannel==2){
							bw.write("CH1;SP1;GA10;SR 2560;AQ;BD?\n");
							lastChannel=1;
						}else{
							bw.write("CH2;SP1;GA10;SR 2560;AQ;BD?\n");
							lastChannel=2;
							
						}
						
						//bw.write("AQ;BD?\n");
						bw.flush();

					}

				}
			}
			// System.out.println("DONE???????????????");

			/*
			 * System.out.println("BINARYDATA"); System.out.println("LL B
			 * "+line.length()); line=line.substring(3,line.length());
			 * System.out.println("LL A "+line.length()); int
			 * alreadyRead=line.length(); byte b[]=line.getBytes();
			 * 
			 * System.out.println(b.length); ByteBuffer bb = ByteBuffer.wrap(b);
			 * 
			 * byte status=bb.get(); byte range =bb.get(); byte reserved
			 * =bb.get(); int sensitivity =bb.getChar()& 0xffff; int dataLen
			 * =bb.getChar()& 0xffff; int StillToRead=dataLen-alreadyRead;
			 * 
			 * System.out.println(status); System.out.println(range);
			 * System.out.println(sensitivity); System.out.println(dataLen);
			 */

		} catch (Exception e) {

			System.err.println("error in WiVibSocketHand " + this.getName());
			e.printStackTrace();
		}

	}
}
