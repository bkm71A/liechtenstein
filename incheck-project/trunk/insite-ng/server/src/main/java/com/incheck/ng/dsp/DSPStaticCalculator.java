package com.incheck.ng.dsp;

import static com.incheck.ng.model.ChannelConfigConstant.PRIMARY_CHANNEL_ENGINEERING_UNITS;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.incheck.ng.dao.ChannelDao;
import com.incheck.ng.dsp.library.UnitConverter;
import com.incheck.ng.model.Channel;
import com.incheck.ng.model.ChannelConfigConstant;
import com.incheck.ng.model.data.ChannelState;
import com.incheck.ng.model.data.ProcessedStaticData;
import com.incheck.ng.model.data.RawData;

public class DSPStaticCalculator implements DSPCalculator {
    private int recentTrendBufferSize = 100;
    private ChannelDao channelDao;
    private List<Double> recentTrend = new LinkedList<Double>();
    private List<Double> recentTrendLabels = new LinkedList<Double>();

    public ChannelDao getChannelDao() {
        return channelDao;
    }

    public void setChannelDao(ChannelDao channelDao) {
        this.channelDao = channelDao;
    }

    @Override
    public ChannelState processData(RawData rawData) {
        Date dateTimeStamp = rawData.getDateTimeStamp();
        long channelId = rawData.getChannelId();
        Channel chanel = channelDao.get(channelId);
        Map<String, String> channelConfig = chanel.getChannelConfig();
        int noOfDataBinsToAverage = Integer.parseInt(channelConfig.get(ChannelConfigConstant.NO_OF_DATA_BINS_TO_AVERAGE));
        String primaryEU = channelConfig.get(ChannelConfigConstant.PRIMARY_CHANNEL_ENGINEERING_UNITS);
        UnitConverter unitConverter = DSPFactory.newUnitConverter(channelConfig);
        double convertedData[] = unitConverter.convertToGs(rawData.getData());
        ProcessedStaticData data = new ProcessedStaticData(rawData.getChannelId(), convertedData, dateTimeStamp, rawData.getSamplingRate());
        data.setEngineeringUnits(channelConfig.get(PRIMARY_CHANNEL_ENGINEERING_UNITS));
        // convert data to engineering units
        // average of the first N data points
        double sum = 0, avg;
        int i;
        for (i = 0; (i < noOfDataBinsToAverage) && (i < data.getData().length); i++) {
            sum = sum + data.getData()[i];
        }
        avg = sum / i;
        data.addOverall(primaryEU, new Double(avg));
        // add calculated value to the recent trend queue, and add a time label
        recentTrend.add(new Double(avg));
        recentTrendLabels.add(new Double(dateTimeStamp.getTime()));
        List<Double> newTrend = new LinkedList<Double>();
        List<Double> newTrendLbl = new LinkedList<Double>();
        // remove elements older than specified buffer limit in seconds
        for (int k = 0; k < recentTrendLabels.size(); k++) {
            if (recentTrendLabels.get( k ) > (dateTimeStamp.getTime() - recentTrendBufferSize * 1000)) {
                newTrend.add( recentTrend.get( k ) );
                newTrendLbl.add( recentTrendLabels.get( k ) );
            }
        }
        recentTrend = newTrend;
        recentTrendLabels = newTrendLbl;
        List<Double> vec = new Vector<Double>( recentTrend.size() );
        for( int j = 0; j < recentTrend.size(); j++ ) {
            vec.add( new Double( recentTrend.get( recentTrend.size() - j - 1 ) ) );
        }
        List<Double> labels = new Vector<Double>( recentTrendLabels.size() );
        for( int j = 0; j < recentTrendLabels.size(); j++ ) {
            labels.add( new Double( recentTrendLabels.get( recentTrendLabels.size() - j - 1 ) ) );
        }

        // data.setData( vec );
        // data.setDataLabels( labels );
        ChannelState channelState = null;
        // channelState.addProcessedData( ProcessedData.KEY_TREND, data );
        // channelState.setOverallTrendKey( ProcessedData.KEY_TREND );
        // }
        // catch( Exception e ) {
        // throw new RuntimeException(
        // "com.incheck.dpm.dsp.DSPStaticCalculator: CHANNEL # " +
        // this.channelId
        // + ": Error processing static channel data from the controller.\n\t "
        // + e );
        // }
        return channelState;
    }
}
