package com.inchecktech.dpm.tests;

	import java.io.DataInputStream; 
	import java.io.IOException; 
	import java.net.InetSocketAddress; 
	import java.net.Socket; 
	import java.nio.ByteBuffer; 
	import java.nio.ByteOrder; 


	public class DAMCommunicationTester { 


	        public static void main(String[] args) throws Exception{ 


	                Socket s = new Socket(); 
	                s.setReceiveBufferSize(8192); 
	                s.setSendBufferSize(8192); 
	                s.connect(new InetSocketAddress("76.238.126.97",30165)); 
	                DataInputStream b1 = new DataInputStream(s.getInputStream()); 
	                long start=System.currentTimeMillis(); 
	                while(true){ 
	                        byte[] first6 = new byte[6]; 
	                        b1.read(first6); 


	                        if(new String(first6).equals("qwerty")){ 
	                                System.out.println("START"); 
	                                int msgType=b1.readUnsignedByte(); 


	                                System.out.println("MSG Type="+msgType); 


	                                // read MSG Size 
	                                int size=readUnsignedInt16(b1); 
	                                System.out.println("SIZE="+size); 


	                                byte restOfThem[]=new byte[size-3]; 
	                                b1.readFully(restOfThem); 


	                                ByteBuffer bb=ByteBuffer.wrap(restOfThem); 
	                                bb.order(ByteOrder.LITTLE_ENDIAN); 


//	                              read proto verison 
	                                int protoVer=bb.get() &  0xFF; 
	                                System.out.println("PROTO VER="+protoVer); 


	                                // read Dev Number 
	                                int devNum=bb.getChar()& 0xffff; 
	                                System.out.println("Device Number="+devNum); 


	                                // read Chan id 
	                                int ChID=bb.get()&  0xFF; 
	                                System.out.println("ChID="+ChID); 


	                                // read msg num 
	                                int MsgNum=bb.get()&  0xFF; 
	                                System.out.println("MsgNum="+MsgNum); 


	                                // read alarm state 
	                                int AlarmS=bb.get()&  0xFF; 
	                                System.out.println("AlarmS="+AlarmS); 


	                                // read timestamp 
	                                int TimeStamp=bb.getInt(); 
	                                System.out.println("TimeStamp="+TimeStamp); 
	                                System.out.println("My Timer="+(System.currentTimeMillis()- 
	start)); 


	                                // read Num os samples in msg 
	                                int NumOfSampInMsgl=bb.getChar()& 0xffff; 
	                                System.out.println("NumOfSampInMsgl="+NumOfSampInMsgl); 


	                                int TotNumOfSamp=bb.get()&  0xFF; 
	                                System.out.println("TotNumOfSamp="+TotNumOfSamp); 


	                                // read Sample Rate 
	                                int SampRate=bb.getChar()& 0xffff; 
	                                System.out.println("SampRate="+SampRate); 


	                                // read trigger mode 
	                                int TrigMode=bb.get()&  0xFF; 
	                                System.out.println("TrigMode="+TrigMode); 


	                                // read RPM 
	                                int RPM=bb.getChar()& 0xffff; 
	                                System.out.println("RPM="+RPM); 


	                                int MachineStatus=bb.get()&  0xFF; 
	                                System.out.println("MachineStatus="+MachineStatus); 


	                                int InternalId=bb.get()&  0xFF; 
	                                System.out.println("InternalId="+InternalId); 


	                                System.out.println("HEADER DONE "); 
	                                System.out.print("Data "); 


	                                for(int i=0;i<(NumOfSampInMsgl);i++){ 
	                                        // read data int 
	                                        int data=bb.getChar()& 0xffff; 


	                                        System.out.print(data+"\n"); 
	                                } 


	                                System.out.print("\nExternalTicks "); 


	                                for(int i=0;i<(NumOfSampInMsgl/8);i++){ 
	                                        // read tick int 
	                                        int tick=bb.get()&  0xFF; 
	                                        System.out.print(tick+","); 
	                                } 


	                                System.out.println(); 


	                                byte eom[]=new byte[7]; 
	                                b1.read(eom); 
	                                String eomStr=new String(eom); 
	                                System.out.println("\nEOM=:"+eomStr+":"); 
	                                System.out.println("END OF MESSAGE\n"); 


	                                if(!eomStr.trim().equals("EOMEOM")){ 
	                                        System.out.println("BAD EOM MSG .. Exiting"); 
	                                        byte blahar[]=new byte[100]; 
	                                        b1.read(blahar); 
	                                        System.out.println(":"+new String(blahar)+":"); 
	                                        b1.close(); 
	                                        s.close(); 
	                                        return; 
	                                } 


	                        }else{ 
	                                System.out.println("first6 NOT qwerty"); 
	                                System.out.println(":"+new String(first6)+":"); 
	                                return;
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




}
