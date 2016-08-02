package com.inchecktech.dpm.utils;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;


public class DAMIPChanger {

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
	
	
	public byte[] getCommandMessageBytes( int newIp[], int newPort,int newGateWay[],int newSubnet[]){
		short msgSize=41+73;
	
		
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
		
		bb.put(new Integer(newIp[0]).byteValue());//16
		bb.put(new Integer(newIp[1]).byteValue());//16
		bb.put(new Integer(newIp[2]).byteValue());//16
		bb.put(new Integer(newIp[3]).byteValue());//16
		
		bb.putChar((char)newPort);//17
		
		bb.put(new Integer(newSubnet[0]).byteValue());//18
		bb.put(new Integer(newSubnet[1]).byteValue());//18
		bb.put(new Integer(newSubnet[2]).byteValue());//18
		bb.put(new Integer(newSubnet[3]).byteValue());//18
		
		//76.238.126.97
		
		bb.put(new Integer(192).byteValue());//19
		bb.put(new Integer(168).byteValue());//19
		bb.put(new Integer(1).byteValue());//19
		bb.put(new Integer(11).byteValue());//19
		
		
		bb.putChar((char)30167);//20
		
		bb.put(new Integer(newGateWay[0]).byteValue());//21
		bb.put(new Integer(newGateWay[1]).byteValue());//21
		bb.put(new Integer(newGateWay[2]).byteValue());//21
		bb.put(new Integer(newGateWay[3]).byteValue());//21
		
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
	
	public static int[] getIpArrFromString(String s){
		
		int retarr[]=new int[4];
		
		String vals[]=s.split("\\.");
		
		retarr[0]=Integer.parseInt(vals[0]);
		retarr[1]=Integer.parseInt(vals[1]);
		retarr[2]=Integer.parseInt(vals[2]);
		retarr[3]=Integer.parseInt(vals[3]);
		return retarr;
	}
	
	public static void main(String[] args) throws Throwable {
		//unit test...
		/*  inputs are:
		 * connectIP 0
		 * connectPort 1
		 * newIp 2
		 * newPort 3
 		 * newGateway 4
		 * newSubnet 5
 		*/	
		DAMIPChanger dcm=new DAMIPChanger();
		//dcm.setMessageId((char)3434);
		//dcm.setNumberOfSamples((char)3);
		byte b[]=dcm.getCommandMessageBytes(
				getIpArrFromString(args[2]), 
				Integer.parseInt(args[3]),
				getIpArrFromString(args[4]),
				getIpArrFromString(args[5])
				
		);

		
		//if(2>1)return;
		Socket s=new Socket(args[0],Integer.parseInt(args[1]));
		DataOutputStream out 	= new DataOutputStream(s.getOutputStream());
		out.write(b);
		System.out.println("CONFIG SENT WAITING");
		out.flush();
		Thread.sleep(5000);
		System.out.println("WE ARE DONE");
		s.close();
		
		
		
		
		
		
		
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
