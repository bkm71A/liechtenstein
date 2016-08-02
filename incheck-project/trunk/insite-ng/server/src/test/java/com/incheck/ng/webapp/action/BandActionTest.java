package com.incheck.ng.webapp.action;

import org.junit.Test;

import com.incheck.ng.test.TestDataDefinition;

@TestDataDefinition(dataSetDTD = "test-data/data_band.dtd", dataSetXML = "test-data/data_band.xml")
public class BandActionTest extends BaseActionTestCase {
    @SuppressWarnings("unused")
    private BandAction action;

    @Test
    public void testGetAllBands() throws Exception {
//        assertEquals(action.list(), ActionSupport.SUCCESS);
//        assertTrue(action.getBands().size() == 1);
    }

    @Test
    public void testList() throws Exception {
//        assertEquals(action.list(), ActionSupport.SUCCESS);
//        assertEquals(2, action.getBands().size());
    }

    @Test
    public void testEdit() throws Exception {
//        log.debug("testing edit...");
//        action.setId(-1L);
//        assertNull(action.getBand());
//        assertEquals("success", action.edit());
//        assertNotNull(action.getBand());
//        assertFalse(action.hasActionErrors());
    }

    @Test
    public void testSave() throws Exception {
//        MockHttpServletRequest request = new MockHttpServletRequest();
//        ServletActionContext.setRequest(request);
//        action.setId(-1L);
//        assertEquals("success", action.edit());
//        assertNotNull(action.getBand());
//        Band band = action.getBand();
//        // update required fields
//        band.setBandCoefficient(1);
//        band.setEndFrequency(1500L);
//        band.setName("Band Test");
//        band.setStartFrequency(0L);
//        action.setBand(band);
//        assertEquals("input", action.save());
//        assertFalse(action.hasActionErrors());
//        assertFalse(action.hasFieldErrors());
//        assertNotNull(request.getSession().getAttribute("messages"));
    }

    @Test
    public void testRemove() throws Exception {
//        MockHttpServletRequest request = new MockHttpServletRequest();
//        ServletActionContext.setRequest(request);
//        action.setDelete("");
//        Band band = new Band();
//        band.setId(-2L);
//        action.setBand(band);
//        assertEquals("success", action.delete());
//        assertNotNull(request.getSession().getAttribute("messages"));
    }
}