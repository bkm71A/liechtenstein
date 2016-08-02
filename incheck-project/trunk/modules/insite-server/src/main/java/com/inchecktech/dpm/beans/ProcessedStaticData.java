/**
 * Copyright 2007, Incheck, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;

import com.inchecktech.dpm.dsp.DSPUtils;
import com.inchecktech.dpm.dsp.EUnitConverter;

/**
 * This object represents a processed/calculated data for static channel
 * @author Taras Dobrovolsky Change History: 11/07/2007 Taras Dobrovolsky Initial release 03/19/2008 Taras Dobrovolsky
 *         Added min/max 07/11/2008 Taras Dobrovolsky Added methods for engineering units handling
 */
public class ProcessedStaticData implements ProcessedData, Serializable {

    static final long serialVersionUID = -358988865023369514L;

    /**
     * Default constructor that takes no parameters.
     */
    private ProcessedStaticData( ) {
        super();
    }

    /**
     * Default constructor that takes channelId as a parameters. The callers should use this method
     */
    public ProcessedStaticData( int channelId ) {
        this();
        this.channelId = channelId;
    }

    // TODO: Add more meta data so the client will have enough info to plot
    // different types of graph with proper labels and scales.
    // Leave it simple for the prototype.

    // PRIVATE PROPERTIES
    // meta-data
    private int                 channelId;
    private int                 samplingRate;
    private String              eu;

    // data and ticks
    private List<Double>        data;
    private OverallLevels       overalls;
    private List<Double>        dataLabels;

    private Double              min             = 0.0;
    private Double              max             = 0.0;

    private String              measurementUnit = ProcessedData.MEASUREMENT_UNIT_MS;
    private String              measurementType = ProcessedData.MEASUREMENT_TYPE_ABSOLUTE;

    private java.util.Date      dateTimeStamp   = new java.util.Date( System.currentTimeMillis() );
    private static final String delim           = ";";

    private String              sampleId        = null;                                             ;

    // engineering units for X and Y
    EUnit                       xEUnit;
    EUnit                       yEUnit;
    private String              xSymbol;
    private String              ySymbol;
    private String              xPhysDomain;
    private String              yPhysDomain;
    
    private int                 noOfAppendedZeros = 0;
    private HashMap<Integer, Double> accBandOveralls;
    private HashMap<Integer, Double> velBandOveralls;
    

    public EUnit getXEUnit( ) {
        return xEUnit;
    }

    /**
     * Get unique identifier of a channel that the dynamic data were processed for.
     * @return the channelId
     */
    public int getChannelId( ) {
        return channelId;
    }

    /**
     * Get unique identifier of a channel that the dynamic data were processed for.
     * @return the sa
     */
    public String getSampleId( ) {
        if( sampleId == null ) {
            sampleId = dateTimeStamp.getTime() + "-" + channelId;
        }
        return sampleId;

    }

    /**
     * Set unique identifier of a channel that the dynamic data were processed for.
     * @param channelId the channelId to set
     */
    public void setChannelId( int channelId ) {
        this.channelId = channelId;
    }

    /**
     * Get sampling rate read from controller and used in calculations
     * @return the samplingRate
     */
    public int getSamplingRate( ) {
        return samplingRate;
    }

    /**
     * Set sampling rate read from controller and used in calculations
     * @param samplingRate the samplingRate to set
     */
    public void setSamplingRate( int samplingRate ) {
        this.samplingRate = samplingRate;
    }

    /**
     * Get measurements units for the data set (EU - engineering units: A, V, D)
     * @return the dataUnits
     */
    public String getEU( ) {
        return eu;
    }

    /**
     * Set measurement units for the data set (EU - engineering units: A, V, D)
     * @param dataUnits the dataUnits to set
     */
    public void setEU( String eu ) {
        this.eu = eu;
    }

    /**
     * Get the processed data points for plotting graphs. Assume that they are equally spaced. TODO: confirm the
     * assumption with Yuri.
     * @return the data
     */
    public List<Double> getData( ) {
        return data;
    }

    /**
     * Set the processed data points for plotting graphs. Assume that they are equally spaced.
     * @param data the data to set
     */
    public void setData( List<Double> data ) {
        this.data = data;
        // set default labels
        DSPUtils.setLabels( this, 0, data.size() );
        updateMinMax();
    }

    /**
     * @return the overalls
     */
    public OverallLevels getOveralls( ) {
        return overalls;
    }

    /**
     * @param overalls the overalls to set
     */
    public void setOveralls( OverallLevels overalls ) {
        this.overalls = overalls;
    }

    /**
     * Channel type: 2 - static
     * @return
     */
    public int getChannelType( ) {
        return 2;
    }

    /**
     * @return the dateTimeStamp
     */
    public java.util.Date getDateTimeStamp( ) {
        return dateTimeStamp;
    }

    /**
     * @param dateTimeStamp the dateTimeStamp to set
     */
    public void setDateTimeStamp( java.util.Date dateTimeStamp ) {
        this.dateTimeStamp = dateTimeStamp;
    }

    /**
     * @return the dateTimeStamp in milliseconds since 1970
     */
    public long getDateTimeStampMillis( ) {
        if( dateTimeStamp == null )
            return 0;
        else
            return dateTimeStamp.getTime();
    }

    /**
     * @param dateTimeStamp the dateTimeStamp to set in milliseconds since 1970
     */
    public void setDateTimeStampMillis( long millis ) {
        this.dateTimeStamp = new java.util.Date( millis );
    }

    @Override
    public String toString( ) {

        StringBuilder str = new StringBuilder( "ProcessedStaticData:" );
        str.append( "channelID=" ).append( channelId ).append( delim ).append( "samplingRate=" ).append( samplingRate )
           .append( delim ).append( "eu=" ).append( eu ).append( delim ).append( "data size=" ).append( data.size() )
           .append( delim ).append( "overalls=" ).append( overalls ).append( delim ).append( "date=" )
           .append( dateTimeStamp ).append( delim );
        return str.toString();
    }

    /**
     * @return the dataLabels
     */
    public List<Double> getDataLabels( ) {
        return dataLabels;
    }

    /**
     * @param dataLabels the dataLabels to set
     */
    public void setDataLabels( List<Double> dataLabels ) {
        this.dataLabels = dataLabels;
    }

    private List<ChartDataPoint> chartData = new Vector<ChartDataPoint>();

    public void setChartData( List<ChartDataPoint> d ) {
        this.chartData = d;

    }

    public List<ChartDataPoint> getChartData( ) {
        return this.chartData;
    }

    /**
     * @return the min
     */
    public Double getMin( ) {
        return min;
    }

    /**
     * @param min the min to set
     */
    public void setMin( Double min ) {
        this.min = min;
    }

    /**
     * @return the max
     */
    public Double getMax( ) {
        return max;
    }

    /**
     * @param max the max to set
     */
    public void setMax( Double max ) {
        this.max = max;
    }

    /**
     * Find new min/max values for data set
     */
    public void updateMinMax( ) {
        if( (data == null) || (data.size() < 1) ) {
            min = 0.0;
            max = 0.0;
            return;
        }

        min = data.get( 0 );
        max = data.get( 0 );

        for( int i = 1; i < data.size(); i++ ) {
            if( min > data.get( i ) )
                min = data.get( i );
            if( max < data.get( i ) )
                max = data.get( i );
        }

    }

    /**
     * @return the measurementUnit
     */
    public String getMeasurementUnit( ) {
        return measurementUnit;
    }

    /**
     * @param measurementUnit the measurementUnit to set
     */
    public void setMeasurementUnit( String measurementUnit ) {
        this.measurementUnit = measurementUnit;
    }

    /**
     * @return the measurementType
     */
    public String getMeasurementType( ) {
        return measurementType;
    }

    /**
     * @param measurementType the measurementType to set
     */
    public void setMeasurementType( String measurementType ) {
        this.measurementType = measurementType;
    }

    /**
     * Creates and new deep copy of the ProcessedDynamicData object
     * @return Deep copy of the object
     */
    public ProcessedStaticData deepCopy( ) {

        ProcessedStaticData copy = new ProcessedStaticData( this.channelId );

        copy.channelId = this.channelId;
        copy.dateTimeStamp = new java.util.Date( this.dateTimeStamp.getTime() );
        copy.samplingRate = this.samplingRate;
        copy.eu = this.eu;

        copy.min = this.min;
        copy.max = this.max;

        copy.measurementType = this.measurementType;
        copy.measurementUnit = this.measurementUnit;

        // data and labels
        Vector<Double> dataCopy = new Vector<Double>();
        for( int i = 0; i < this.data.size(); i++ ) {
            dataCopy.add( new Double( this.data.get( i ) ) );
        }
        copy.setData( dataCopy );

        Vector<Double> dataLabels = new Vector<Double>();
        for( int i = 0; i < this.dataLabels.size(); i++ ) {
            dataLabels.add( new Double( this.dataLabels.get( i ) ) );
        }
        copy.setDataLabels( dataLabels );

        // create a deep copy of overalls
        if( overalls != null ) {
            copy.overalls = new OverallLevels( this.overalls.getChannelId() );
            copy.overalls.setDateTimeStampMillis( this.getDateTimeStampMillis() );
            Vector<String> overallKeys = this.overalls.getKeys();
            for( int i = 0; i < overallKeys.size(); i++ ) {
                copy.overalls.addOverall( new String( overallKeys.elementAt( i ) ),
                                          new Double( this.overalls.getOverall( overallKeys.elementAt( i ) ) ) );
            }
        }

        copy.xEUnit = this.xEUnit;
        copy.yEUnit = this.yEUnit;

        copy.xSymbol = this.xSymbol;
        copy.ySymbol = this.ySymbol;
        copy.xPhysDomain = this.xPhysDomain;
        copy.yPhysDomain = this.yPhysDomain;
        
        copy.noOfAppendedZeros = this.noOfAppendedZeros;

        return copy;
    }

    /**
     * Convert the labels (X axis) to the target engineering units
     * @param targetUnits target engineering units
     */
    public void convertToEUnitsX( EUnit targetUnits ) {
        if( (xEUnit == null) || (targetUnits == null) || (xEUnit.equals( targetUnits )) || (this.dataLabels == null) ) {
            return;
        }
        EUnitConverter.convert( this.dataLabels, this.xEUnit, targetUnits );
        setXEUnit( targetUnits );
    }

    /**
     * COnvert data points (Y axis) to the target engineering units
     * @param targetUnits target engineering units
     */
    public void convertToEUnitsY( EUnit targetUnits ) {
        if( (yEUnit == null) || (targetUnits == null) || (yEUnit.equals( targetUnits )) || (this.data == null) ) {
            return;
        }
        EUnitConverter.convert( this.data, this.yEUnit, targetUnits );
        setYEUnit( targetUnits );
    }

    public void setXEUnit( EUnit unit ) {
        xEUnit = unit;
        this.xSymbol = unit.symbol();
        this.xPhysDomain = unit.domain().descr();
    }

    public EUnit getYEUnit( ) {
        return yEUnit;
    }

    public void setYEUnit( EUnit unit ) {
        yEUnit = unit;
        this.ySymbol = unit.symbol();
        this.yPhysDomain = unit.domain().descr();
    }

    public PhysicalDomain getXPhysicalDomin( ) {
        return xEUnit.domain();
    }

    public PhysicalDomain getYPhysicalDomain( ) {
        return yEUnit.domain();
    }

    public String getYSymbol( ) {
        return ySymbol;
    }

    public String getXSymbol( ) {
        return xSymbol;
    }

    public String getYPhysDomain( ) {
        return yPhysDomain;
    }

    public String getXPhysDomain( ) {
        return xPhysDomain;
    }

    public void setYSymbol( String s ) {

    }
    

    public int getNoOfAppendedZeros( ) {
        return noOfAppendedZeros;
    }

    public void setNoOfAppendedZeros( int noOfAppendedZeros ) {
        this.noOfAppendedZeros = noOfAppendedZeros;
    }

    /**
     * 
     * @return HashMap of bandId and OverallValue
     */
	public HashMap<Integer, Double> getAccBandOveralls() {
		return accBandOveralls;
	}

	/**
	 * 
	 * @param bandOveralls (A HashMap of bandId and OverallValue)
	 */
	public void setAccBandOveralls(HashMap<Integer, Double> bandOveralls) {
		this.accBandOveralls = bandOveralls;
	}

    public HashMap<Integer, Double> getVelBandOveralls() {
        return velBandOveralls;
    }

    public void setVelBandOveralls(HashMap<Integer, Double> bandOveralls) {
        this.velBandOveralls = bandOveralls;
    }
}
