/**
 * Copyright 2008, Incheck Tech, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck Tech,
 * Inc. The copyright notice above does not evidence any actual or intended publication of such source code.
 */

package com.inchecktech.dpm.tests;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.EOFException;
import java.io.FileInputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

/**
 * A collection of tests to test various DSP (Digital SIgnal Processing) algorithms TODO: Use JUnit to design and
 * implement unit tests in the future
 */
public class MTalkerTests {

    /**
     * @param args
     */
    public static void main( String[] args ) {

        // readMachineTalkerFile();
        
        convertBinaryFiles( );

    }

    // read binary machine talker file and output data to console
    protected static void readMachineTalkerFile( ) {

        String fileName = "c008-0.bin";

        try {

            DataInputStream in = new DataInputStream( new BufferedInputStream( new FileInputStream( fileName ) ) );

            // buffer for reversing bytes
            ByteBuffer bb = ByteBuffer.allocate( 2 );

            // //////////////////////////////////////////////////////
            // READ DATA
            // Month
            int month = in.readUnsignedByte();
            System.out.println( "Month: " + month );
            // Day
            int day = in.readUnsignedByte();
            System.out.println( "Day: " + day );
            // Year
            int year = in.readUnsignedByte();
            System.out.println( "Year: " + year );
            // Hour
            int hour = in.readUnsignedByte();
            System.out.println( "Hour: " + hour );
            // Min
            int min = in.readUnsignedByte();
            System.out.println( "Min: " + min );
            // Sec
            int sec = in.readUnsignedByte();
            System.out.println( "Sec: " + sec );
            // Talker Sensor # for Aux Port #1
            int chIdPressure = in.readUnsignedByte();
            System.out.println( "Talker Sensor # for Aux Port #1: " + chIdPressure );
            // Aux Port #1 Data Byte 0 (Pressure)
            // Aux Port #1 Data Byte 1 (Pressure)
            int pressure = flip2Bytes(bb, (short) in.readUnsignedShort());
            System.out.println( "Pressure: " + pressure );
            // Talker Sensor # for Aux Port #2
            int chIdTemperature = in.readUnsignedByte();
            System.out.println( "Talker Sensor # for Aux Port #2: " + chIdTemperature );
            // Aux Port #2 Data Byte 0 (Temperature)
            // Aux Port #2 Data Byte 1 (Temperature)
            int temperature = flip2Bytes(bb, (short) in.readUnsignedShort());
            System.out.println( "Temperature: " + temperature );
            // Talker Sensor # for Vibration Data
            int chIdVibration = in.readUnsignedByte();
            System.out.println( "Talker Sensor # for Vibration Data: " + chIdVibration );
            // Vibration Sample Duration (Byte 0)
            // Vibration Sample Duration (Byte 1)
            int duration = flip2Bytes(bb, (short) in.readUnsignedShort());
            System.out.println( "Duration: " + duration );
            // Vibration Sample Interval (Byte 0)
            // Vibration Sample Interval (Byte 1)
            int interval = flip2Bytes(bb, (short) in.readUnsignedShort());
            System.out.println( "Interval: " + interval );
            // Number of Vibration Samples Taken (Byte 0)
            // Number of Vibration Samples Taken (Byte 1)
            int noOfSamples = flip2Bytes(bb, (short) in.readUnsignedShort());
            System.out.println( "No Of Samples: " + noOfSamples );
            // Begin Vibration Data (2 bytes/sample) (most significant byte first)

            System.out.println( "Samples Data" );
            while( true ) {
                try {
                    System.out.println( (int) in.readUnsignedShort() );
                }
                catch( EOFException eof ) {
                    break;
                }

            }

            in.close();

        }
        catch( Exception e ) {

        }

    }
    
    
    protected static void convertBinaryFiles( ) {
        
        String fileName = "data_42_12";
        
        // buffer for reversing bytes
        ByteBuffer bb = ByteBuffer.allocate( 2 );
        
        try {

            DataInputStream in = new DataInputStream( new BufferedInputStream( new FileInputStream( fileName ) ) );

            // buffer for reversing bytes
            // ByteBuffer bb = ByteBuffer.allocate( 2 );
            
            while( true ) {
                try {
                    System.out.println( (int) in.readUnsignedShort() );
                    // System.out.println( flip2Bytes(bb, (short) in.readShort()) );
                }
                catch( EOFException eof ) {
                    break;
                }

            }

            in.close();

        }
        catch( Exception e ) {

        }

        
    }
    

    private static short flip2Bytes( ByteBuffer bb, short value ) {
        bb.order( ByteOrder.BIG_ENDIAN );
        bb.putShort( 0, value );
        bb.order( ByteOrder.LITTLE_ENDIAN ); // flip bytes
        return bb.getShort( 0 );
    }

}
