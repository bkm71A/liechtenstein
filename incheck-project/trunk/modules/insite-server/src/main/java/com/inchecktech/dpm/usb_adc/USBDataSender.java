package com.inchecktech.dpm.usb_adc;

import java.security.InvalidAlgorithmParameterException;
import java.util.Date;
import java.util.Map;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.EUnit;
import com.inchecktech.dpm.beans.FunctionDataVO;
import com.inchecktech.dpm.beans.GraphDataVO;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.ProcessDataVO;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.beans.UIProcessedData;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.dsp.DSPCalculator;
import com.inchecktech.dpm.dsp.DSPFactory;
import com.inchecktech.dpm.dsp_library.ButterworthCoefficients;
import com.inchecktech.dpm.dsp_library.ButterworthCoefficients.Butterworth6PoleCoefficientSet;
import com.inchecktech.dpm.dsp_library.DSPLibrary;
import com.inchecktech.dpm.flex.DPMFlexProxy;
import com.inchecktech.dpm.persistence.PersistChannelConfig;
import com.inchecktech.dpm.persistence.PersistTreeNode;
import com.inchecktech.dpm.utils.Logger;

public class USBDataSender {
    private static final Logger logger = new Logger(USBDataSender.class);
    private DSPCalculator calc[];
    private int samplingRate;
    private int channelBlockSize;
    private int channelSamplingRate;

    /**
	 * 
	 */
	public USBDataSender() {
		// TODO Auto-generated constructor stub
	}
	
    /**
     * @param channels
     * @param sampleRate
     *            - number of samples per second, for example 44100
     * @param bytesPerDataSample
     */
    public USBDataSender(int channels, float samplingRate) {
        calc = new DSPCalculator[channels];
        for (int channelId = 0; channelId < channels; channelId++) {
            int dpmChannelNumber = USBDeviceReader.CHANNEL_OFFSET + channelId;
            logger.debug(USBDeviceReader.MESSAGE_PREFIX + " - Retrieving DSP Calculator for USB channel " + dpmChannelNumber);
            calc[channelId] = DataBucket.getDSPCalculator(dpmChannelNumber);
            if (calc[channelId] == null) {
                calc[channelId] = DSPFactory.newDSPCalculator(dpmChannelNumber);
                DataBucket.addOrReplaceDSPCalculator(dpmChannelNumber, calc[channelId]);
            }
        }
        this.samplingRate = (int) samplingRate;
        init(USBDeviceReader.CHANNEL_OFFSET);
    }

    private void init(int channelId){
        Map<String, String> props = PersistChannelConfig.readChannelConfig(USBDeviceReader.CHANNEL_OFFSET);
        try {
            channelBlockSize = Integer.parseInt(props.get("com.inchecktech.dpm.dam.BlockSize"));
            channelSamplingRate = Integer.parseInt(props.get("com.inchecktech.dpm.dam.SamplingRate"));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    
    /*
     * One of the results of resampling is that the Block size gets proportionally smaller. That means that depending on
     * the required sampling rate and block size the number of samples that have to be acquired from the device will
     * vary. The formula is as follows: ABS=BS*ASR/SR Where ABS=Block Size for acquisition BS=Block Size required by the
     * app ASR=acquisition sampling rate (48000 in our case) SR=sampling rate required by the app
     */
    public int getSamplingSize() {
        return (int) (channelBlockSize * samplingRate / channelSamplingRate);
    }    
    
    public void processData(double[][] data) {
        for (int channelId = 0; channelId < data.length; channelId++) {
            double rowChannelData[] = data[channelId];
            int cornerFrequency = channelSamplingRate / 2;
            Butterworth6PoleCoefficientSet coefficients = ButterworthCoefficients.hardcodedSixPole44100Map.get(cornerFrequency);
            if (coefficients == null) {
                throw new IllegalArgumentException("No Butterworth coefficients for cornerFrequency=" + cornerFrequency + " is found !!!");
            }
            double filteredChannelData[] = DSPLibrary.butterworthSixPoleFilter(rowChannelData, coefficients.b, coefficients.a1, coefficients.a2);
            double downsampledChannelData[] = DSPLibrary.downSample(filteredChannelData, samplingRate, channelSamplingRate);
            // now cut off downsampledChannelData to be of length = dpmBlockSize
            int rowData[] = doubleArrayToIntArray(downsampledChannelData, Math.min(downsampledChannelData.length, channelBlockSize));
            int dpmChannelNumber = USBDeviceReader.CHANNEL_OFFSET + channelId;
            RawData raw = new RawData(dpmChannelNumber);
            raw.setSamplingRate(coefficients.sr);
            raw.setDateTimeStamp(new Date());
            raw.setData(rowData);
            try {
                ICNode node = DataBucket.getICNode(dpmChannelNumber);
                node.setIncomingDataTimestamp(new Date());
                node.setNumberOfSamples(channelBlockSize);
                if (node == null) {
                    logger.warn(USBDeviceReader.MESSAGE_PREFIX + " - CHANNEL ID " + dpmChannelNumber + " is not defined....  skipping");
                }
                node.setSamplingRate(samplingRate);
                PersistTreeNode.updateNodeIncomingDataTimestamp(node.getId(), raw.getDateTimeStamp());
                
                ChannelState st = calc[channelId].processData(raw, null);
                // data and overalls has calculated
                
                // save the data
                if (calc[channelId].isDebugMode()) { // TD: DEBUG MODE - STORE DSP CORE
                    // DUMP FOR THE CHANNEL
                    DataBucket.putDSPCoreDump(calc[channelId].getDspCoreDump().getChannelId(), calc[channelId].getDspCoreDump());
                }
                DataBucket.putChannelState(node.getChannelid(), st);
                node.setProcessedDataKeysString(st.getProcessedData().keySet());
                
                // prepare data for UI
                //prepareUIData(calc[channelId].getChannelId());
            } catch (InvalidAlgorithmParameterException e) {
                logger.error(USBDeviceReader.MESSAGE_PREFIX + " - USBDataSender - processData", e);
            } catch (RuntimeException e) {
                logger.error(USBDeviceReader.MESSAGE_PREFIX + " - USBDataSender - processData", e);
            }
        }
    }
    
    
      
    public ProcessDataVO prepareUIData(int channelId, String sampleId){
    	DPMFlexProxy flexProxy = new DPMFlexProxy();
		UIProcessedData accSpec = flexProxy.getUIProcessedData(channelId, DPMFlexProxy.SPECTRUM_ACCELERATION_PEAK_KEY, sampleId,
				EUnit.FreqHz.name(), EUnit.AccG.name());
		UIProcessedData accWave = flexProxy.getUIProcessedData(channelId, DPMFlexProxy.TIME_WAVEFORM_ACCELERATION_KEY, sampleId,
				EUnit.TimeSec.name(), EUnit.AccG.name());
		UIProcessedData velSpec = flexProxy.getUIProcessedData(channelId, DPMFlexProxy.SPECTRUM_VELOCITY_KEY, sampleId, EUnit.FreqHz.name(),
				EUnit.VelInSec.name());
		UIProcessedData velWave = flexProxy.getUIProcessedData(channelId, DPMFlexProxy.TIME_WAVEFORM_VELOCITY_KEY, sampleId, EUnit.TimeSec.name(),
				EUnit.VelInSec.name());
		ProcessDataVO result = new ProcessDataVO();
		GraphDataVO accSpecGraph = new GraphDataVO(accSpec);
		GraphDataVO accWaveGraph = new GraphDataVO(accWave);
		GraphDataVO velSpecGraph = new GraphDataVO(velSpec);
		GraphDataVO velWaveGraph = new GraphDataVO(velWave);
		FunctionDataVO accData = new FunctionDataVO();
		accData.setSpectrumData(accSpecGraph);
		accData.setWaveformData(accWaveGraph);
		FunctionDataVO velData = new FunctionDataVO();
		velData.setSpectrumData(velSpecGraph);
		velData.setWaveformData(velWaveGraph);
		result.setChannelId(channelId);
		// TODO: the parameter needs to be set from Flex side. Currently, set test value 'testSample'. 
		result.setSampleId("testSample");
		result.setDateTimeStamp(accSpec.getDateTimeStamp());
		result.setAccelerationData(accData);
		result.setVelocityData(velData);
		return result;
		
    }
    private int[] doubleArrayToIntArray(double array[],int length) {
        int intArray[] = new int[length];
        for (int j = 0; j < length; j++) {
            intArray[j] = (int)array[j];
        }
        return intArray;
    }    
}
