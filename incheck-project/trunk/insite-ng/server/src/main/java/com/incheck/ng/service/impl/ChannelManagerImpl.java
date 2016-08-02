package com.incheck.ng.service.impl;

import javax.jws.WebService;

import org.springframework.stereotype.Service;

import com.incheck.ng.model.Channel;
import com.incheck.ng.service.ChannelManager;
import com.incheck.ng.service.ChannelService;

@Service("channelManager")
@WebService(serviceName = "ChannelService", endpointInterface = "com.incheck.ng.service.ChannelService")
public class ChannelManagerImpl extends GenericManagerImpl<Channel, Long> implements ChannelManager, ChannelService {

}
