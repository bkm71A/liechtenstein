package com.inchecktech.dpm.mtalker;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.EOFException;
import java.io.FileInputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.utils.Logger;

import java.io.File;
import java.io.IOException;

public class MTalkerFileReader {

    private static final Logger logger        = new Logger( MTalkerFileReader.class );

    /**
     * @param fileDir
     * @param fileName
     * @return populated RawData object, or null if the file does not exist or no change was detected
     */
    public RawData loadData( String fileDir, String fileName, int channelId, double freqAdjFactor ) {

        try {
            
            if ( !FileUtils.prepDataFile( fileDir, fileName )) {
                logger.debug( "MachineTalker: IOException during file preparation: " + fileDir + "\\" + fileName
                              + " Channel Id: " + channelId );
                return null;
            }
            
            // check if the file exists
            /*File f = new File( fileDir + "\\" + fileName );

            if( !f.exists() ) {
                logger.debug( "MachineTalker: File does not exist: " + fileDir + "\\" + fileName + " Channel Id: "
                              + channelId );
                return null;
            }

            // check if the file was modified
            /*
             * if (this.fileTimestamp == f.lastModified()) { logger.debug( "MachineTalker: File was not modified since
             * last read. Skipping... : " + fileDir + "\\" + fileName + " Channel Id: " + channelId); return null; }
             */

            // this.fileTimestamp = f.lastModified();

        }
        catch( IOException e ) {
            logger.debug( "MachineTalker: IOException during file pre-checks: " + fileDir + "\\" + fileName
                          + " Channel Id: " + channelId );
            return null;
        }

        try {

            DataInputStream in = new DataInputStream( new BufferedInputStream( new FileInputStream( fileDir + "\\"
                                                                                                    + fileName ) ) );

            // read the file, populate RawData object
            try {

                RawData rawData = new RawData( channelId );

                // in = new DataInputStream( new BufferedInputStream( new FileInputStream( fileName ) ) );

                // buffer for reversing bytes
                ByteBuffer bb = ByteBuffer.allocate( 2 );

                // //////////////////////////////////////////////////////
                // READ DATA
                // Month
                int month = in.readUnsignedByte();
                // Day
                int day = in.readUnsignedByte();
                // Year
                int year = in.readUnsignedByte();
                // Hour
                int hour = in.readUnsignedByte();
                // Min
                int min = in.readUnsignedByte();
                // Sec
                int sec = in.readUnsignedByte();
                // Talker Sensor # for Aux Port #1
                int chIdPressure = in.readUnsignedByte();
                // Aux Port #1 Data Byte 0 (Pressure)
                // Aux Port #1 Data Byte 1 (Pressure)
                int pressure = flip2Bytes( bb, (short) in.readUnsignedShort() );
                // Talker Sensor # for Aux Port #2
                int chIdTemperature = in.readUnsignedByte();
                // Aux Port #2 Data Byte 0 (Temperature)
                // Aux Port #2 Data Byte 1 (Temperature)
                int temperature = flip2Bytes( bb, (short) in.readUnsignedShort() );
                // Talker Sensor # for Vibration Data
                int chIdVibration = in.readUnsignedByte();
                
                // check if this is the data for current channel
                /*if (chIdVibration != channelId) {
                    logger.debug( "MachineTalker: This is not the file for channlel: " + channelId + ".  This is the file for channel: " + chIdVibration + " Skipping...");
                    in.close();
                    return null;
                }*/
                
                
                // Vibration Sample Duration (Byte 0)
                // Vibration Sample Duration (Byte 1)
                int duration = flip2Bytes( bb, (short) in.readUnsignedShort() );
                // Vibration Sample Interval (Byte 0)
                // Vibration Sample Interval (Byte 1)
                int interval = flip2Bytes( bb, (short) in.readUnsignedShort() );
                // Number of Vibration Samples Taken (Byte 0)
                // Number of Vibration Samples Taken (Byte 1)
                int noOfSamples = flip2Bytes( bb, (short) in.readUnsignedShort() );

                // Begin Vibration Data (2 bytes/sample) (most significant byte first)
                int[] data = new int[noOfSamples];

                int i = 0;
                while( true ) {
                    try {
                        data[i] = (int) in.readUnsignedShort();
                        i++;
                    }
                    catch( EOFException eof ) {
                        break;
                    }

                }

                in.close();

                // check that all expected samples were read
                if( i != noOfSamples ) {
                    logger
                          .debug( "MachineTalker: Number of expected samples does not match samples read.  Skipping data feed...: "
                                  + " Channel Id: "
                                  + channelId
                                  + " Samples read="
                                  + i
                                  + " Samples expected="
                                  + noOfSamples );
                    
                    // Delete incomplete files (i.e. skip if there is a problem)
                    deleteBinAndCtrlFiles(fileDir, fileName, channelId);
                    
                    return null;
                }

                // dummy ticks - all false
                boolean[] ticks = new boolean[noOfSamples];
                for( int k = 0; k < noOfSamples; k++ ) {
                    ticks[k] = false;
                }

                // populate raw data object
                rawData.setChannelId( channelId );
                rawData.setData( data );
                rawData.setDataTicks( ticks );
                double adjustedFreq = (noOfSamples * 1000 / duration) * freqAdjFactor;
                rawData.setSamplingRate( (int) Math.round( adjustedFreq ));
                rawData.setDateTimeStamp( new java.util.Date( System.currentTimeMillis() ) );
                
                
                // delete control and data files once done reading
                try {
                    
                    File f = new File( fileDir + "\\" + fileName );

                    if( f.exists() ) {
                        f.delete();
                    }
                    
                    File c = new File (fileDir + "\\" + fileName.substring( 0, fileName.length() - 4 ) + ".cntl");
                    if ( c.exists() ) {
                        c.delete();
                    }

                }
                catch( RuntimeException e ) {
                    logger.debug( "MachineTalker: IOException during file delete operation: " + fileDir + "\\" + fileName
                                  + " Channel Id: " + channelId );
                    return null;
                }
                

                return rawData;

            }
            catch( RuntimeException re ) {
                try {
                    if( (in != null) && in instanceof DataInputStream )
                        in.close();
                }
                catch( IOException ex ) {
                }
                logger.debug( "MachineTalker: IOException during file read and load operation: " + fileDir + "\\"
                              + fileName + " Channel Id: " + channelId );
                return null;
            }

        }
        catch( IOException e ) {
            logger.debug( "MachineTalker: IOException during file openning operation: " + fileDir + "\\" + fileName
                          + " Channel Id: " + channelId );
            return null;
        }

    }

    private short flip2Bytes( ByteBuffer bb, short value ) {
        bb.order( ByteOrder.BIG_ENDIAN );
        bb.putShort( 0, value );
        bb.order( ByteOrder.LITTLE_ENDIAN ); // flip bytes
        return bb.getShort( 0 );
    }
    
    private void deleteBinAndCtrlFiles(String fileDir, String fileName, int channelId) {
        
     // delete control and data files once done reading
        try {
            
            File f = new File( fileDir + "\\" + fileName );

            if( f.exists() ) {
                f.delete();
            }
            
            File c = new File (fileDir + "\\" + fileName.substring( 0, fileName.length() - 4 ) + ".cntl");
            if ( c.exists() ) {
                c.delete();
            }

        }
        catch( RuntimeException e ) {
            logger.debug( "MachineTalker: IOException during file delete operation: " + fileDir + "\\" + fileName
                          + " Channel Id: " + channelId );
        }
        
    }

}
