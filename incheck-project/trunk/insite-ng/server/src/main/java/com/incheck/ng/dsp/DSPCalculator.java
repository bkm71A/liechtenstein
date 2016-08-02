package com.incheck.ng.dsp;

import com.incheck.ng.model.data.ChannelState;
import com.incheck.ng.model.data.RawData;

public interface DSPCalculator {
    ChannelState processData(RawData rawData);
}
