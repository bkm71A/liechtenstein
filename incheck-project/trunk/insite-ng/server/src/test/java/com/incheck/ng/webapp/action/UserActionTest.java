package com.incheck.ng.webapp.action;

import static com.incheck.ng.test.TestConstants.EXISTING_TEST_USER_ID;
import static com.incheck.ng.test.TestConstants.TEST_USERNAME;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

import org.apache.struts2.ServletActionContext;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;

import com.incheck.ng.model.User;
import com.incheck.ng.service.UserManager;
import com.incheck.ng.test.TestDataDefinition;

@TestDataDefinition(dataSetDTD = "test-data/data_incheck_user.dtd", dataSetXML = "test-data/data_incheck_user.xml")
public class UserActionTest extends BaseActionTestCase {
    @Autowired
    private UserAction action;

    @Test
    public void testCancel() throws Exception {
        assertEquals(action.cancel(), "mainMenu");
        assertFalse(action.hasActionErrors());

        action.setFrom("list");
        assertEquals("cancel", action.cancel());
    }

    @Test
    public void testEdit() throws Exception {
        // so request.getRequestURL() doesn't fail
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/editUser.html");
        ServletActionContext.setRequest(request);
        action.setId(String.valueOf(EXISTING_TEST_USER_ID)); // regular user
        assertNull(action.getUser());
        assertEquals("success", action.edit());
        assertNotNull(action.getUser());
        assertFalse(action.hasActionErrors());
    }

    @Test
    public void testSave() throws Exception {
        UserManager userManager = (UserManager) applicationContext.getBean("userManager");
        User user = userManager.getUserByUsername(TEST_USERNAME);
        user.setPassword("user");
        user.setConfirmPassword("user");
        action.setUser(user);
        action.setFrom("list");

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addParameter("encryptPass", "true");
        ServletActionContext.setRequest(request);

        assertEquals("input", action.save());
        assertNotNull(action.getUser());
        assertFalse(action.hasActionErrors());
    }

    @Test
    public void testSaveConflictingUser() throws Exception {
        UserManager userManager = (UserManager) applicationContext.getBean("userManager");
        User user = userManager.getUserByUsername(TEST_USERNAME);
        user.setPassword("user");
        user.setConfirmPassword("user");
        // e-mail address from existing user
        User existingUser = (User) userManager.getUsers().get(0);
        user.setEmail(existingUser.getEmail());
        action.setUser(user);
        action.setFrom("list");

        Integer originalVersionNumber = user.getVersion();
        log.debug("original version #: " + originalVersionNumber);

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addParameter("encryptPass", "true");
        ServletActionContext.setRequest(request);

        assertEquals("input", action.save());
        assertNotNull(action.getUser());
//        assertTrue(action.hasActionErrors());
    }

    @Test
    public void testListUsers() throws Exception {
        assertNull(action.getUsers());
        assertEquals("success", action.list());
        assertNotNull(action.getUsers());
        assertFalse(action.hasActionErrors());
    }

    @Test
    public void testRemove() throws Exception {
        User user = new User(TEST_USERNAME);
        user.setId(EXISTING_TEST_USER_ID);
        action.setUser(user);
        assertEquals("success", action.delete());
        assertFalse(action.hasActionErrors());
    }
}
