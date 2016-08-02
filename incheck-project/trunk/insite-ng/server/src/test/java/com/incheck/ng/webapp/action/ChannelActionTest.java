package com.incheck.ng.webapp.action;

import static com.incheck.ng.test.TestConstants.EXISTING_TEST_CHANNEL_ID;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.apache.struts2.ServletActionContext;
import org.junit.Before;
import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;

import com.incheck.ng.model.Channel;
import com.incheck.ng.model.ChannelType;
import com.incheck.ng.service.GenericManager;
import com.incheck.ng.test.TestDataDefinition;
import com.opensymphony.xwork2.ActionSupport;

@TestDataDefinition(dataSetDTD = "test-data/data_channel.dtd", dataSetXML = "test-data/data_channel.xml")
public class ChannelActionTest extends BaseActionTestCase {
    private ChannelAction action;

    @SuppressWarnings("unchecked")
    @Before
    public void onSetUp() {
        super.onSetUp();
        action = new ChannelAction();
        GenericManager<Channel, Long> channelManager = (GenericManager<Channel, Long>) applicationContext.getBean("channelManager");
        action.setChannelManager(channelManager);
    }

    @Test
    public void testGetAllChannels() throws Exception {
        assertEquals(action.list(), ActionSupport.SUCCESS);
        assertTrue(action.getChannels().size() >= 1);
    }

    @Test
    public void testEdit() throws Exception {
        log.debug("testing edit...");
        action.setId(EXISTING_TEST_CHANNEL_ID);
        assertNull(action.getChannel());
        assertEquals("success", action.edit());
        assertNotNull(action.getChannel());
        assertFalse(action.hasActionErrors());
    }

    @Test
    public void testSave() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        ServletActionContext.setRequest(request);
        action.setId(EXISTING_TEST_CHANNEL_ID);
        assertEquals("success", action.edit());
        assertNotNull(action.getChannel());
        Channel channel = action.getChannel();
        channel.setChannelType(ChannelType.STATIC);
        action.setChannel(channel);
        assertEquals("input", action.save());
        assertFalse(action.hasActionErrors());
        assertFalse(action.hasFieldErrors());
        assertNotNull(request.getSession().getAttribute("messages"));
    }

    @Test
    public void testRemove() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        ServletActionContext.setRequest(request);
        action.setDelete("");
        Channel channel = new Channel();
        channel.setId(EXISTING_TEST_CHANNEL_ID);
        action.setChannel(channel);
        assertEquals("success", action.delete());
        assertNotNull(request.getSession().getAttribute("messages"));
    }
}