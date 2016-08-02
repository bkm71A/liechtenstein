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

import com.incheck.ng.model.OverallType;
import com.incheck.ng.service.GenericManager;
import com.incheck.ng.test.TestDataDefinition;
import com.opensymphony.xwork2.ActionSupport;

@TestDataDefinition(dataSetDTD = "test-data/data_overall_type.dtd", dataSetXML = "test-data/data_overall_type.xml")
public class OverallTypeActionTest extends BaseActionTestCase {
    private OverallTypeAction action;

    @SuppressWarnings("unchecked")
    @Before
    public void onSetUp() {
        super.onSetUp();
        action = new OverallTypeAction();
        GenericManager<OverallType, Long> overallTypeManager = (GenericManager<OverallType, Long>) applicationContext
                .getBean("overallTypeManager");
        action.setOverallTypeManager(overallTypeManager);
        // add a test overallType to the database
        OverallType overallType = new OverallType();
        // enter all required fields
        overallType.setDescription("Test Description");
        overallType.setName("Test Name");
        overallTypeManager.save(overallType);
    }

    @Test
    public void testGetAllOverallTypes() throws Exception {
        assertEquals(action.list(), ActionSupport.SUCCESS);
        assertTrue(action.getOverallTypes().size() >= 1);
    }

    @Test
    public void testEdit() throws Exception {
        log.debug("testing edit...");
        action.setId(-1L);
        assertNull(action.getOverallType());
        assertEquals("success", action.edit());
        assertNotNull(action.getOverallType());
        assertFalse(action.hasActionErrors());
    }

    @Test
    public void testSave() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        ServletActionContext.setRequest(request);
        action.setId(-1L);
        assertEquals("success", action.edit());
        assertNotNull(action.getOverallType());

        OverallType overallType = action.getOverallType();
        // update required fields
        overallType
                .setDescription("PqZdTgKjCiZuNqCkFqFhYhOoKoXiVrCcXlEqGfSaYpPxBmHyXkSlEvEjXnFzKyNqDgOnXkKvZfDyJtMjYuFwOeFeIwYaCgHcEvEfAbYsAhIiHvKnKqBhSnAkGzItWoAaQyDzLlJqKyYdZlOzSrGdQjKcJjCmTtFyUsOsZuUsSxUeXdFrCuObQkSkUzQmKrDmXgApCuBvAoPwMuEtRaAzQcCbUwGmKeDsQmXjQwVgYzWzTlOlJhPgUcFlQvOyLtT");
        overallType.setName("ZuIoIeFrTmLwWgLrQiVfDdNxKuNkWaFsSiCzKgOqSnDeTiSlCr");

        action.setOverallType(overallType);

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
        OverallType overallType = new OverallType();
        overallType.setId(-2L);
        action.setOverallType(overallType);
        assertEquals("success", action.delete());
        assertNotNull(request.getSession().getAttribute("messages"));
    }
}