package com.incheck.ng.webapp.action;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.apache.struts2.ServletActionContext;
import org.junit.Before;
import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;

import com.incheck.ng.model.ChannelMeasureType;
import com.incheck.ng.service.GenericManager;
import com.incheck.ng.test.TestDataDefinition;
import com.opensymphony.xwork2.ActionSupport;

@TestDataDefinition(dataSetDTD = "test-data/data_channel_measure_type.dtd", dataSetXML = "test-data/data_channel_measure_type.xml")
public class ChannelMeasureTypeActionTest extends BaseActionTestCase {
    private ChannelMeasureTypeAction action;

    @SuppressWarnings("unchecked")
    @Before
    public void onSetUp() {
        super.onSetUp();
        action = new ChannelMeasureTypeAction();
        GenericManager<ChannelMeasureType,Long> channelMeasureTypeManager = (GenericManager<ChannelMeasureType,Long>) applicationContext.getBean("channelMeasureTypeManager");
        action.setChannelMeasureTypeManager(channelMeasureTypeManager);
        // add a test channelMeasureType to the database
        ChannelMeasureType channelMeasureType = new ChannelMeasureType();
        // enter all required fields
        channelMeasureType.setCode("TestCode");
        channelMeasureType.setDescription("Test Measure Type Description");
        channelMeasureTypeManager.save(channelMeasureType);
    }

    @Test
    public void testGetAllChannelMeasureTypes() throws Exception {
        assertEquals(action.list(), ActionSupport.SUCCESS);
        assertTrue(action.getChannelMeasureTypes().size() >= 1);
    }

    @Test
    public void testEdit() throws Exception {
        log.debug("testing edit...");
        action.setId(-1L);
        assertNull(action.getChannelMeasureType());
        assertEquals("success", action.edit());
        assertNotNull(action.getChannelMeasureType());
        assertFalse(action.hasActionErrors());
    }

    @Test
    public void testSave() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        ServletActionContext.setRequest(request);
        action.setId(-1L);
        assertEquals("success", action.edit());
        assertNotNull(action.getChannelMeasureType());
        ChannelMeasureType channelMeasureType = action.getChannelMeasureType();
        // update required fields
        channelMeasureType.setCode("TestCode");
        channelMeasureType.setDescription("Test Measure Type Description");
        action.setChannelMeasureType(channelMeasureType);
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
        ChannelMeasureType channelMeasureType = new ChannelMeasureType();
        channelMeasureType.setId(-2L);
        action.setChannelMeasureType(channelMeasureType);
        assertEquals("success", action.delete());
        assertNotNull(request.getSession().getAttribute("messages"));
    }
}