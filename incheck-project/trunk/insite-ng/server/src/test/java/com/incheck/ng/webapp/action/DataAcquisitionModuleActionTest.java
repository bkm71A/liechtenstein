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

import com.incheck.ng.model.DataAcquisitionModule;
import com.incheck.ng.service.GenericManager;
import com.incheck.ng.test.TestDataDefinition;
import com.opensymphony.xwork2.ActionSupport;

@TestDataDefinition(dataSetDTD = "test-data/data_channel.dtd", dataSetXML = "test-data/data_channel.xml")
public class DataAcquisitionModuleActionTest extends BaseActionTestCase {
    private DataAcquisitionModuleAction action;

    @SuppressWarnings("unchecked")
    @Before
    public void onSetUp() {
        super.onSetUp();

        action = new DataAcquisitionModuleAction();
        GenericManager<DataAcquisitionModule,Long> dataAcquisitionModuleManager = (GenericManager<DataAcquisitionModule,Long>) applicationContext.getBean("dataAcquisitionModuleManager");
        action.setDataAcquisitionModuleManager(dataAcquisitionModuleManager);

        // add a test dataAcquisitionModule to the database
        DataAcquisitionModule dataAcquisitionModule = new DataAcquisitionModule();

        // enter all required fields
        dataAcquisitionModule.setDescription("Test Description");
        dataAcquisitionModule.setDeviceType(new Short("0"));
        dataAcquisitionModule.setSerialNumber("Test Serial Number");

        dataAcquisitionModuleManager.save(dataAcquisitionModule);
    }

    @Test
    public void testGetAllDataAcquisitionModules() throws Exception {
        assertEquals(action.list(), ActionSupport.SUCCESS);
        assertTrue(action.getDataAcquisitionModules().size() >= 1);
    }

    @Test
    public void testEdit() throws Exception {
        log.debug("testing edit...");
        action.setId(-1L);
        assertNull(action.getDataAcquisitionModule());
        assertEquals("success", action.edit());
        assertNotNull(action.getDataAcquisitionModule());
        assertFalse(action.hasActionErrors());
    }

    @Test
    public void testSave() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        ServletActionContext.setRequest(request);
        action.setId(-1L);
        assertEquals("success", action.edit());
        assertNotNull(action.getDataAcquisitionModule());

        DataAcquisitionModule dataAcquisitionModule = action.getDataAcquisitionModule();
        // update required fields
        dataAcquisitionModule.setDescription("Test Description");
        dataAcquisitionModule.setDeviceType(new Short("0"));
        dataAcquisitionModule.setSerialNumber("Test Serial Number");

        action.setDataAcquisitionModule(dataAcquisitionModule);

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
        DataAcquisitionModule dataAcquisitionModule = new DataAcquisitionModule();
        dataAcquisitionModule.setId(-1L);
        action.setDataAcquisitionModule(dataAcquisitionModule);
        assertEquals("success", action.delete());
        assertNotNull(request.getSession().getAttribute("messages"));
    }
}