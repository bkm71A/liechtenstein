package com.incheck.ng.webapp.action;
import static com.incheck.ng.test.TestConstants.TEST_USERNAME;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.subethamail.wiser.Wiser;

import com.incheck.ng.model.User;
import com.incheck.ng.service.UserManager;
import com.incheck.ng.test.TestDataDefinition;
import com.opensymphony.xwork2.Action;

@TestDataDefinition(dataSetDTD = "test-data/data_incheck_user.dtd", dataSetXML = "test-data/data_incheck_user.xml")
public class PasswordHintActionTest extends BaseActionTestCase {
    @Autowired
    private PasswordHintAction action;
    @Autowired
    private UserManager userManager;

    @Test
    public void testExecute() throws Exception {
        // start SMTP Server
        Wiser wiser = new Wiser();
        wiser.setPort(getSmtpPort());
        wiser.start();
        
        action.setUsername("user");
        assertEquals("success", action.execute());
        assertFalse(action.hasActionErrors());

        // verify an account information e-mail was sent
        wiser.stop();
        assertTrue(wiser.getMessages().size() == 1);

        // verify that success messages are in the request
        assertNotNull(action.getSession().getAttribute("messages"));
    }

    @Test
    public void testExecuteNoUserName() throws Exception {
        action.setUsername(null);
        assertEquals(Action.INPUT, action.execute());
        assertTrue(action.hasActionErrors());
    }

    @Test
    public void testExecuteWrongUserName() throws Exception {
        action.setUsername("UNKNOWN123");
        assertEquals(Action.INPUT, action.execute());
        assertTrue(action.hasActionErrors());
    }

    @Test
    public void testExecuteNoPasswordHintUserName() throws Exception {
        action.setUsername(TEST_USERNAME);
        final User user = userManager.getUserByUsername(TEST_USERNAME);
        user.setPasswordHint("  ");
        userManager.save(user);
        assertEquals(Action.INPUT, action.execute());
        assertTrue(action.hasActionErrors());
        user.setPasswordHint(null);
        userManager.save(user);
        assertEquals(Action.INPUT, action.execute());
        assertTrue(action.hasActionErrors());
    }
}
