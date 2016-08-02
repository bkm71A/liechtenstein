package com.incheck.ng.dao;

import static com.incheck.ng.test.TestConstants.DAM_SERIAL_NUMBER;
import static com.incheck.ng.test.TestConstants.EXISTING_DAM_ID;
import static com.incheck.ng.test.TestConstants.EXISTING_TEST_CHANNEL_ID;
import static com.incheck.ng.test.TestConstants.EXISTING_TEST_SENSOR_ID;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.incheck.ng.model.Channel;
import com.incheck.ng.model.ChannelType;
import com.incheck.ng.model.DataAcquisitionModule;
import com.incheck.ng.test.AbstractSpringTestContextEnabledIntegrationTestSupport;
import com.incheck.ng.test.TestDataDefinition;

@TestDataDefinition(dataSetDTD = "test-data/data_channel.dtd", dataSetXML = "test-data/data_channel.xml")
public class ChannelDaoTest extends AbstractSpringTestContextEnabledIntegrationTestSupport {

    @Autowired
    private ChannelDao dao;

    @Test
    public void testGetAll() throws Exception {
        assertTrue(dao.getAll().size() > 0);
    }

    @Test
    public void testGet() throws Exception {
        Channel channel = dao.get(EXISTING_TEST_CHANNEL_ID);
        assertEquals(new Long(EXISTING_TEST_SENSOR_ID), channel.getSensor().getId());
        assertTrue(channel.getChannelConfig().size() > 0);
        assertEquals(ChannelType.DYNAMIC, channel.getChannelType());
        DataAcquisitionModule dam = channel.getSensor().getDam();
        assertEquals(new Long(EXISTING_DAM_ID), dam.getId());
        assertEquals(DAM_SERIAL_NUMBER, dam.getSerialNumber());
    }

    @Test
    public void testExists() throws Exception {
        assertTrue(dao.exists(EXISTING_TEST_CHANNEL_ID));
        assertFalse(dao.exists(-100L));
    }
}
