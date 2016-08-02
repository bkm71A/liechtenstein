package com.incheck.ng.dsp;

import java.util.Map;

import com.incheck.ng.dsp.library.UnitConverter;
import com.incheck.ng.dsp.library.impl.AvgBiasUnitConverter;
import com.incheck.ng.model.ChannelConfigConstant;

public class DSPFactory {
    /**
     * This method creates an instance of the UnitConverter class. It is part of
     * the DSP Factory pattern that allows multiple implementations/methods
     * 
     * @param channelId
     *            channel unique identifier.
     * @return An instance of a class/algorithm that implements UnitConverter
     *         interface
     * @throws RuntimeException
     *             if the method cannot instantiate a class specified in
     *             configuration file that implements UnitConverter interface
     */
    public static UnitConverter newUnitConverter(Map<String, String> channelConfig) {
        int maxVoltage = Integer.parseInt(channelConfig.get(ChannelConfigConstant.CONVERTER_MAX_VOLTS));
        int bitResolution = Integer.parseInt(channelConfig.get(ChannelConfigConstant.CONVERTER_BIT_RESOLUTION));
        double sensorGain = Double.parseDouble(channelConfig.get(ChannelConfigConstant.CONVERTER_SENSOR_GAIN));
        double sensorOffset = Double.parseDouble(channelConfig.get(ChannelConfigConstant.CONVERTER_SENSOR_OFFSET));
        double sensorSensitivity = Double.parseDouble(channelConfig.get(ChannelConfigConstant.CONVERTER_SENSOR_SENSITIVITY));
        double sensorBiasVoltage = Double.parseDouble(channelConfig.get(ChannelConfigConstant.CONVERTER_SENSOR_BIAS_VOLTAGE));
        return new AvgBiasUnitConverter(maxVoltage, bitResolution, sensorSensitivity, sensorBiasVoltage, sensorGain, sensorOffset);
    }
}
