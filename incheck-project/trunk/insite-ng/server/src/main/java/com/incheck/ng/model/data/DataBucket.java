package com.incheck.ng.model.data;

import java.util.Hashtable;
import java.util.Map;

public class DataBucket {

    private static Map<Long, ChannelState> channelStateById = new Hashtable<Long, ChannelState>();

    public static ChannelState getChannelState(long channelId) {
        return channelStateById.get(channelId);
    }

    public static void putChannelState(long channelId, ChannelState channelState) {
        channelStateById.put(channelId, channelState);
    }
}
