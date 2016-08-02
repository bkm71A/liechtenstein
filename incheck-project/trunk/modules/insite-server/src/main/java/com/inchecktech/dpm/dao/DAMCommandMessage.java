package com.inchecktech.dpm.dao;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import java.util.BitSet;

import com.inchecktech.dpm.utils.Logger;

public class DAMCommandMessage {
	
	private static final Logger logger = new Logger(DAMCommandMessage.class);

	char DPMSoftwareVersion=0;
	char DAMSoftwareVersion=0;
	char ProtocolCurrentVersion=0;
	byte messageType=new Integer(6).byteValue();
	
	
	char DamId=0;
	char DpmId=0;
	// sec since 1970
	int timeStamp=0;//(int)(System.currentTimeMillis()/1000);
	char channelId=4;
	char alarmMask=0;
	char delayReset=0;
	char configDataSize=73;
	char messageId=1;
	char delayAlarms=1;
	char SampleRate=512;
	char NumberOfSamples=512;
	/*
	char SampleRate=128;
	char NumberOfSamples=32;
	*/
	
	public char getAlarmMask() {
		return alarmMask;
		
	}
	public void setAlarmMask(char alarmMask) {
		this.alarmMask = alarmMask;
	}
	public char getChannelId() {
		return channelId;
	}
	public void setChannelId(char channelId) {
		this.channelId = channelId;
	}
	public char getConfigDataSize() {
		return configDataSize;
	}
	public void setConfigDataSize(char configDataSize) {
		this.configDataSize = configDataSize;
	}
	public char getDamId() {
		return DamId;
	}
	public void setDamId(char damId) {
		DamId = damId;
	}
	public char getDAMSoftwareVersion() {
		return DAMSoftwareVersion;
	}
	public void setDAMSoftwareVersion(char softwareVersion) {
		DAMSoftwareVersion = softwareVersion;
	}
	public char getDelayAlarms() {
		return delayAlarms;
	}
	public void setDelayAlarms(char delayAlarms) {
		this.delayAlarms = delayAlarms;
	}
	public char getDelayReset() {
		return delayReset;
	}
	public void setDelayReset(char delayReset) {
		this.delayReset = delayReset;
	}
	public char getDpmId() {
		return DpmId;
	}
	public void setDpmId(char dpmId) {
		DpmId = dpmId;
	}
	public char getDPMSoftwareVersion() {
		return DPMSoftwareVersion;
	}
	public void setDPMSoftwareVersion(char softwareVersion) {
		DPMSoftwareVersion = softwareVersion;
	}
	public byte getMessageType() {
		return messageType;
	}
	public void setMessageType(byte messageType) {
		this.messageType = messageType;
	}
	public char getNumberOfSamples() {
		return NumberOfSamples;
	}
	public void setNumberOfSamples(char numberOfSamples) {
		NumberOfSamples = numberOfSamples;
	}
	public char getProtocolCurrentVersion() {
		return ProtocolCurrentVersion;
	}
	public void setProtocolCurrentVersion(char protocolCurrentVersion) {
		ProtocolCurrentVersion = protocolCurrentVersion;
	}
	public char getSampleRate() {
		return SampleRate;
	}
	public void setSampleRate(char sampleRate) {
		SampleRate = sampleRate;
	}
	public int getTimeStamp() {
		return timeStamp;
	}
	public void setTimeStamp(int timeStamp) {
		this.timeStamp = timeStamp;
	}
	
	
	public byte[] getCommandMessageBytes(){
		short msgSize=41+73;
		logger.debug("messageType:"+messageType);
		
		ByteBuffer bb = ByteBuffer.allocate(msgSize);
		bb.order(ByteOrder.LITTLE_ENDIAN);
		bb.putChar((char)msgSize);
		bb.putChar(DPMSoftwareVersion);
		bb.putChar(DAMSoftwareVersion);
		bb.putChar(ProtocolCurrentVersion);
		bb.put(messageType);
		bb.putChar(DamId);
		bb.putChar(DpmId);
		bb.putInt(timeStamp);
		bb.putChar(channelId);
		bb.putChar(alarmMask);
		bb.putChar(delayReset);
		bb.putChar(messageId);
		bb.putChar(configDataSize);
		bb.putChar(delayAlarms);
		bb.putChar(SampleRate);
		bb.putChar(NumberOfSamples);
		bb.put((byte)255);
		//config
		//1
		bb.putChar((char)73);
		//2
		bb.putChar((char)1);
		//3
		bb.putChar((char)1);
		//4
		bb.putChar((char)1);
		//5
		bb.putChar((char)1);
		//6
		bb.putChar((char)1);
		//7
		bb.putChar((char)1);
		//8
		bb.putChar((char)1);
		//9
		bb.putChar((char)1);
		//10
		bb.putChar((char)1);
//		11
		bb.putInt(0);
//		12
		bb.putChar((char)1);
//		13
		bb.putChar((char)1);
//		14
		bb.putChar((char)1);
		
		bb.putChar((char)4);//15
		// max sample
		bb.putChar((char)20000);//15
		
		bb.put(new Integer(192).byteValue());//16
		bb.put(new Integer(168).byteValue());//16
		bb.put(new Integer(1).byteValue());//16
		bb.put(new Integer(60).byteValue());//16
		
		bb.putChar((char)30159);//17
		
		bb.put(new Integer(255).byteValue());//18
		bb.put(new Integer(255).byteValue());//18
		bb.put(new Integer(255).byteValue());//18
		bb.put(new Integer(0).byteValue());//18
		
		//76.238.126.97
		
		bb.put(new Integer(192).byteValue());//19
		bb.put(new Integer(168).byteValue());//19
		bb.put(new Integer(1).byteValue());//19
		bb.put(new Integer(11).byteValue());//19
		
		
		bb.putChar((char)30167);//20
		
		bb.put(new Integer(192).byteValue());//21
		bb.put(new Integer(168).byteValue());//21
		bb.put(new Integer(1).byteValue());//21
		bb.put(new Integer(254).byteValue());//21
		
		bb.putChar((char)1);//22
		bb.putChar((char)1);//23
		bb.putChar((char)1);//24
		
		bb.putInt(0);//25
		bb.putInt(0);//26
		bb.putInt(0);//27
		
		
		// use 1 for now .... first bit is true rest if false.
		//bb.putChar((char)1);
		bb.put(new Integer(0).byteValue());
		
		
		
		
		/*
		try {
			FileOutputStream fos= new FileOutputStream("c:\\config.bin");
			fos.write(bb.array());
			fos.flush();
			fos.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		
		}
		
		
		*/
		
		
		
		
		
		return bb.array();
		
	}
	
	public static void main(String[] args) throws Throwable {
		//unit test...
		DAMCommandMessage dcm=new DAMCommandMessage();
		//dcm.setMessageId((char)3434);
		//dcm.setNumberOfSamples((char)3);
		byte b[]=dcm.getCommandMessageBytes();
		logger.debug(b.length);
		logger.debug(new String(b));
		
		//if(2>1)return;
		Socket s=new Socket("75.145.162.150",30159);
		DataOutputStream out 	= new DataOutputStream(s.getOutputStream());
		out.write(b);
		out.flush();
		
		
		
		
		DataInputStream b1 = new DataInputStream(s.getInputStream());
	
		while(true){
			try{
				byte[] first6 = new byte[6];
				b1.read(first6);

				if(new String(first6).equals("qwerty")){
					
					long start=System.currentTimeMillis();
					//DPMLogger.logger.info("START");
					int msgType=b1.readUnsignedByte();

					//DPMLogger.logger.info("MSG Type="+msgType);

					// read MSG Size
					int size=readUnsignedInt16(b1);
					logger.info("SIZE="+size);

					byte restOfThem[]=new byte[size-3];
					b1.readFully(restOfThem);

					ByteBuffer bb=ByteBuffer.wrap(restOfThem);
					bb.order(ByteOrder.LITTLE_ENDIAN);

					//                          read proto verison
					int protoVer=bb.get() &  0xFF;
					//DPMLogger.logger.info("PROTO VER="+protoVer);

					// read Dev Number
					int devNum=bb.getChar()& 0xffff;
					logger.info("Device Number="+devNum);

					// read Chan id
					int ChID=bb.get()&  0xFF;
					logger.info("ChID="+ChID);


					// read msg num
					int MsgNum=bb.get()&  0xFF;
					logger.info("MsgNum="+MsgNum);

					// read alarm state
					int AlarmS=bb.get()&  0xFF;
					logger.info("AlarmS="+AlarmS);

					// read timestamp
					int TimeStamp=bb.getInt();
					logger.info("TimeStamp="+TimeStamp);
					//DPMLogger.logger.info("My Timer="+(System.currentTimeMillis()-start));

					// read Num os samples in msg
					int NumOfSampInMsgl=bb.getChar()& 0xffff;
					logger.info("NumOfSampInMsgl="+NumOfSampInMsgl);

					int TotNumOfSamp=bb.get()&  0xFF;
					//DPMLogger.logger.info("TotNumOfSamp="+TotNumOfSamp);

					// read Sample Rate
					int SampRate=bb.getChar()& 0xffff;
					logger.info("SampRate="+SampRate);

					// read trigger mode
					int TrigMode=bb.get()&  0xFF;
					//DPMLogger.logger.info("TrigMode="+TrigMode);

					// read RPM
					int RPM=bb.getChar()& 0xffff;
					//DPMLogger.logger.info("RPM="+RPM);

					int MachineStatus=bb.get()&  0xFF;
					//DPMLogger.logger.info("MachineStatus="+MachineStatus);

					int InternalId=bb.get()&  0xFF;
					//DPMLogger.logger.info("InternalId="+InternalId);

					//DPMLogger.logger.info("HEADER DONE ");

					String dataSting="";
					int[] dataArray=new int[NumOfSampInMsgl];
					for(int i=0;i<(NumOfSampInMsgl);i++){
						// read data int
						int data=bb.getChar()& 0xffff;
						dataArray[i]=data;
						dataSting+=data+",";
					}

					
					//UnitConverter unitConv=DSPFactory.
					//Vector<Double> volts= unitConv.convertToVolts(dataArray);

					

					/*
					 * double dataInVolts[]=new double[volts.size()];
                           for(Double tm:volts){
                            	dataInVolts[index]=tm.doubleValue();
                            	index++;
                            }*/
					

					//DPMLogger.logger.info("Data "+dataSting);



					String tickString="";
					ArrayList<Boolean > tickData=new ArrayList<Boolean>();
					for(int i=0;i<(NumOfSampInMsgl/8);i++){
						// read tick int
						byte tick=bb.get();
						BitSet bset = new BitSet(1);
						for (int j=0; j<8; j++) {

							if ((tick&(1<<(j%8))) > 0) {
								tickData.add(true);
								bset.set(j);
							}else{
								tickData.add(false);
							}
						}

						for(int bind=0;bind<8;bind++){
							if(bset.get(bind)){
								tickString+="1,";
							}else{
								tickString+="0,";
							}

						}

					}

					//DPMLogger.logger.info("\nExternalTicks "+tickString);


					byte eom[]=new byte[7];
					b1.read(eom);
					String eomStr=new String(eom);
					//DPMLogger.logger.info("\nEOM=:"+eomStr+":");
					logger.debug("\nEOM=:"+eomStr+":");
					//DPMLogger.logger.info("END OF MESSAGE\n");

					if(!eomStr.trim().equals("EOMEOM")){
						logger.info("BAD EOM MSG .. Exiting");
						byte blahar[]=new byte[100];
						b1.read(blahar);
						logger.info(":"+new String(blahar)+":");
						b1.close();
						
						throw new Exception("BAD EOM MSG");
					}else{
						logger.debug("SENDING");
						
						out.write(dcm.getCommandMessageBytes());
						out.flush();
					}

				}else{
					logger.info("first6 NOT qwerty");
					logger.info(":"+new String(first6)+":");
					b1.read(first6);
					logger.info(" NEXT 6 :"+new String(first6)+":");
					
					if(2>1)return;
					throw new Exception("BAD FIRST 6");
					
				}
			}catch(Throwable e){
				e.printStackTrace();
			}
		} 
		
		
		
		
		
	}
	
	public static int readUnsignedInt16( DataInputStream s) throws
	IOException{
		byte tarr[]=new byte[2];
		s.read(tarr);
		ByteBuffer bb = ByteBuffer.wrap(tarr);
		bb.order(ByteOrder.LITTLE_ENDIAN);
		return (bb.getChar() & 0xffff);
	}

	
	
	public char getMessageId() {
		return messageId;
	}
	public void setMessageId(char messageId) {
		this.messageId = messageId;
	}
	
}
