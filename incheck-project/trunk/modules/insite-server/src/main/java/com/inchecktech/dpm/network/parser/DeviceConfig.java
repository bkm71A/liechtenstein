package com.inchecktech.dpm.network.parser;

import com.inchecktech.dpm.network.parser.JsonFieldNameConstants.DAM_MESSAGE_TYPE;

public class DeviceConfig extends DamMessage {
    private int deviceChannelId;
    private ChannelConfig channelConfigs[];
    private int sendToUdpPort;
    private int sendToTcpPort;
    private int sendToHost;
    private String getUpdateFile;

    public DAM_MESSAGE_TYPE getDamMessageType() {
        return DAM_MESSAGE_TYPE.CONFIG;
    }

    public int getDeviceChannelId() {
        return deviceChannelId;
    }

    public void setDeviceChannelId(int deviceChannelId) {
        this.deviceChannelId = deviceChannelId;
    }

    public ChannelConfig[] getChannelConfigs() {
        return channelConfigs;
    }

    public void setChannelConfigs(ChannelConfig[] channelConfigs) {
        this.channelConfigs = channelConfigs;
    }

    public int getSendToUdpPort() {
        return sendToUdpPort;
    }

    public void setSendToUdpPort(int sendToUdpPort) {
        this.sendToUdpPort = sendToUdpPort;
    }

    public int getSendToTcpPort() {
        return sendToTcpPort;
    }

    public void setSendToTcpPort(int sendToTcpPort) {
        this.sendToTcpPort = sendToTcpPort;
    }

    public int getSendToHost() {
        return sendToHost;
    }

    public void setSendToHost(int sendToHost) {
        this.sendToHost = sendToHost;
    }

    public String getGetUpdateFile() {
        return getUpdateFile;
    }

    public void setGetUpdateFile(String getUpdateFile) {
        this.getUpdateFile = getUpdateFile;
    }

    public class ChannelConfig {
        private String chanelType;
        private int samplingInterval;
        private int samplingRate;
        private int numberOfSamples;
        public String getChanelType() {
            return chanelType;
        }
        public void setChanelType(String chanelType) {
            this.chanelType = chanelType;
        }
        public int getSamplingInterval() {
            return samplingInterval;
        }
        public void setSamplingInterval(int samplingInterval) {
            this.samplingInterval = samplingInterval;
        }
        public int getSamplingRate() {
            return samplingRate;
        }
        public void setSamplingRate(int samplingRate) {
            this.samplingRate = samplingRate;
        }
        public int getNumberOfSamples() {
            return numberOfSamples;
        }
        public void setNumberOfSamples(int numberOfSamples) {
            this.numberOfSamples = numberOfSamples;
        }
    }
}
