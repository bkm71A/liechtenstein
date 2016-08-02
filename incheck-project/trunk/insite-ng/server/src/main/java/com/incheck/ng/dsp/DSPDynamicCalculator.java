package com.incheck.ng.dsp;

import static com.incheck.ng.model.ChannelConfigConstant.DCFILTER_SMOOTHING_FACTOR;
import static com.incheck.ng.model.ChannelConfigConstant.FREQUENCY_ADJUSTMENT_FACTOR;
import static com.incheck.ng.model.ChannelConfigConstant.GAIN_ADJUSTMENT_FACTOR;
import static com.incheck.ng.model.ChannelConfigConstant.OVERALL_TYPE_TO_CALCULATE;
import static com.incheck.ng.model.ChannelConfigConstant.PRIMARY_CHANNEL_ENGINEERING_UNITS;
import static com.incheck.ng.model.ChannelConfigConstant.TICKS_PER_REVOLUTION;

import java.security.InvalidAlgorithmParameterException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.incheck.ng.dao.ChannelDao;
import com.incheck.ng.dsp.library.DSPProcessor;
import com.incheck.ng.dsp.library.DSPUtils;
import com.incheck.ng.dsp.library.HanningWeightingAlg;
import com.incheck.ng.dsp.library.UnitConverter;
import com.incheck.ng.dsp.library.WeightingAlg;
import com.incheck.ng.dsp.library.impl.DCFilter;
import com.incheck.ng.model.Band;
import com.incheck.ng.model.Channel;
import com.incheck.ng.model.data.AccelerationByFrequencyData;
import com.incheck.ng.model.data.AccelerationByTimeData;
import com.incheck.ng.model.data.ChannelState;
import com.incheck.ng.model.data.DataBucket;
import com.incheck.ng.model.data.DataConstant;
import com.incheck.ng.model.data.RawData;
import com.incheck.ng.model.data.VelocityByFrequencyData;
import com.incheck.ng.model.data.VelocityByTimeData;

public class DSPDynamicCalculator implements DSPCalculator {
    protected final static Log log = LogFactory.getLog(DSPDynamicCalculator.class);
    private ChannelDao channelDao;
    private Filter dcFilter = new DCFilter();
    private WeightingAlg weightingAlg = new HanningWeightingAlg();

    public ChannelDao getChannelDao() {
        return channelDao;
    }

    public void setChannelDao(ChannelDao channelDao) {
        this.channelDao = channelDao;
    }

    @Override
    public ChannelState processData(RawData rawData) {
        long channelId = rawData.getChannelId();
        Channel chanel = channelDao.get(channelId);
        Map<String, String> channelConfig = chanel.getChannelConfig();
        double adjFactorFreq = Double.parseDouble(channelConfig.get(FREQUENCY_ADJUSTMENT_FACTOR));
        double adjFactorGain = Double.parseDouble(channelConfig.get(GAIN_ADJUSTMENT_FACTOR));
        int ticksPerRevolution = Integer.parseInt(channelConfig.get(TICKS_PER_REVOLUTION));
        int dcFltrSmoothingFactor = Integer.parseInt(channelConfig.get(DCFILTER_SMOOTHING_FACTOR));
        
        String overallSubType = channelConfig.get(OVERALL_TYPE_TO_CALCULATE);
        dcFilter.setCutoffFreq(dcFltrSmoothingFactor);
        UnitConverter converter = DSPFactory.newUnitConverter(channelConfig);

        int samplingRate = (int) Math.round(rawData.getSamplingRate() * adjFactorFreq);
        double rpm = DSPUtils.calculateRPM(rawData.getDataTicks(), samplingRate, ticksPerRevolution);
        double[] gsConvertedData = converter.convertToGs(rawData.getData());
        double factoredData[] = DSPUtils.multiplyByFactor(gsConvertedData, adjFactorGain);
        Date dateTimeStamp = rawData.getDateTimeStamp();
        try {
            double filteredData[] = dcFilter.filter(factoredData, samplingRate);
            AccelerationByTimeData accelerationByTimeData = new AccelerationByTimeData(channelId, filteredData, dateTimeStamp, samplingRate);
            
            VelocityByTimeData velocityByTimeData = DSPProcessor.calculateTimeWaveVel(channelId, filteredData, samplingRate,
                    dateTimeStamp, 0, dcFilter);
            velocityByTimeData.setEngineeringUnits(channelConfig.get(PRIMARY_CHANNEL_ENGINEERING_UNITS));
            
            AccelerationByFrequencyData accelerationByFrequencyData = DSPProcessor.calculateSpectrumAccel(channelId, filteredData,
                    samplingRate, weightingAlg, dcFilter, dateTimeStamp);
            accelerationByFrequencyData.setEngineeringUnits(channelConfig.get(PRIMARY_CHANNEL_ENGINEERING_UNITS));
            
            VelocityByFrequencyData velocityByFrequencyData = DSPProcessor.calculateSpectrumVel(channelId, accelerationByFrequencyData.getData(), samplingRate,
                    weightingAlg, dcFilter, dateTimeStamp);
            velocityByFrequencyData.setEngineeringUnits(channelConfig.get(PRIMARY_CHANNEL_ENGINEERING_UNITS));
            
            List<Band> bands = chanel.getBands();
            accelerationByTimeData.setAccBandOveralls(BandCalculator.getBandOveralls(accelerationByFrequencyData, bands));
            accelerationByTimeData.setVelBandOveralls(BandCalculator.getBandOveralls(velocityByFrequencyData, bands));
//  TODO          List<ProcessedDynamicData> processedData = Arrays.asList(accelerationByTimeData, accelerationByFrequencyData,
//                    velocityByFrequencyData);
            ChannelState channelState = DataBucket.getChannelState(channelId);
            if (channelState == null) {
                channelState = new ChannelState(channelId, dateTimeStamp, rpm, rawData.getDataTicks());
                DataBucket.putChannelState(channelId, channelState);
            }
// TODO           channelState.setProcessedData(processedData);
            channelState.setOverallKey(overallSubType);
            double startTime = (double) dateTimeStamp.getTime();
            channelState.addRecentOverallsTrend(accelerationByTimeData, startTime, channelConfig);
            channelState.addRecentOverallsTrend(velocityByTimeData, startTime, channelConfig);
            channelState.addRecentOverallsTrend(accelerationByFrequencyData, startTime, channelConfig);
            channelState.addRecentOverallsTrend(velocityByFrequencyData, startTime, channelConfig);
            // store not re-sampled data
            channelState.addProcessedData( DataConstant.KEY_TIMEWAVE_ACC, accelerationByTimeData);
            return channelState;
        } catch (InvalidAlgorithmParameterException e) {
            log.fatal(e);
            return null;
        }
    }
}
