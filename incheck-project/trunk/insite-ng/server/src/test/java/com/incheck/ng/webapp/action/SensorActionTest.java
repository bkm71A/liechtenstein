package com.incheck.ng.webapp.action;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static com.incheck.ng.test.TestConstants.EXISTING_TEST_SENSOR_ID;
import org.apache.struts2.ServletActionContext;
import org.junit.Before;
import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;

import com.incheck.ng.model.Sensor;
import com.incheck.ng.service.GenericManager;
import com.incheck.ng.test.TestDataDefinition;
import com.opensymphony.xwork2.ActionSupport;
@TestDataDefinition(dataSetDTD = "test-data/data_channel.dtd", dataSetXML = "test-data/data_channel.xml")
public class SensorActionTest extends BaseActionTestCase {
    private SensorAction action;

    @SuppressWarnings("unchecked")
    @Before
    public void onSetUp() {
        super.onSetUp();
        action = new SensorAction();
        GenericManager<Sensor, Long> sensorManager = (GenericManager<Sensor, Long>) applicationContext.getBean("sensorManager");
        action.setSensorManager(sensorManager);
    }

    @Test
    public void testGetAllSensors() throws Exception {
        assertEquals(action.list(), ActionSupport.SUCCESS);
        assertTrue(action.getSensors().size() >= 1);
    }

    @Test
    public void testEdit() throws Exception {
        log.debug("testing edit...");
        action.setId(EXISTING_TEST_SENSOR_ID);
        assertNull(action.getSensor());
        assertEquals("success", action.edit());
        assertNotNull(action.getSensor());
        assertFalse(action.hasActionErrors());
    }

    @Test
    public void testSave() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        ServletActionContext.setRequest(request);
        action.setId(EXISTING_TEST_SENSOR_ID);
        assertEquals("success", action.edit());
        assertNotNull(action.getSensor());
        Sensor sensor = action.getSensor();
        // update required fields
        sensor.setName("Test Sensor Name");
        action.setSensor(sensor);
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
        Sensor sensor = new Sensor();
        sensor.setId(EXISTING_TEST_SENSOR_ID);
        action.setSensor(sensor);
        assertEquals("success", action.delete());
        assertNotNull(request.getSession().getAttribute("messages"));
    }
}