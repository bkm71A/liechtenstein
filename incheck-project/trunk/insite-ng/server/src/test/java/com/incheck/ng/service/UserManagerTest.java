package com.incheck.ng.service;

import static com.incheck.ng.test.TestConstants.EXISTING_TEST_USER_ID;
import static com.incheck.ng.test.TestConstants.TEST_USERNAME;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.annotation.ExpectedException;
import org.springframework.test.context.ContextConfiguration;

import com.incheck.ng.model.RoleTypes;
import com.incheck.ng.model.User;
import com.incheck.ng.test.AbstractSpringTestContextEnabledIntegrationTestSupport;
import com.incheck.ng.test.TestDataDefinition;

@ContextConfiguration(locations = { "classpath:/applicationContext-test.xml" })
@TestDataDefinition(dataSetDTD = "test-data/data_incheck_user.dtd", dataSetXML = "test-data/data_incheck_user.xml")
public class UserManagerTest extends AbstractSpringTestContextEnabledIntegrationTestSupport {
    private Log log = LogFactory.getLog(UserManagerTest.class);
    @Autowired
    @Qualifier("userManager")
    private UserManager mgr;
    @Autowired
    private RoleManager roleManager;
    private User user;

    @Before
    public void setUp() {
        setAuthentication(mgr.get(EXISTING_TEST_USER_ID));
    }

    @Test
    public void testGetUser() throws Exception {
        user = mgr.getUserByUsername(TEST_USERNAME);
        assertNotNull(user);
        log.debug(user);
        assertEquals(3, user.getRoles().size());
    }

    @Test
    public void testSaveUser() throws Exception {
        final String phoneNumber = "303-555-1212";
        user = mgr.getUserByUsername(TEST_USERNAME);
        user.setPhoneNumber(phoneNumber);
        log.debug("saving user with updated phone number: " + user);
        user = mgr.saveUser(user);
        assertEquals(phoneNumber, user.getPhoneNumber());
        assertEquals(3, user.getRoles().size());
    }

    @Test
    public void testAddAndRemoveUser() throws Exception {
        User adminUser = mgr.get(EXISTING_TEST_USER_ID);
        user = new User();

        // call populate method in super class to populate test data
        // from a properties file matching this class name
        user = (User) populate(user);

        user.addRole(roleManager.getRole(RoleTypes.ROLE_USER.toString()));
        user.setCreatedBy(adminUser);
        user.setUpdatedBy(adminUser);
        user.setCreatedOn(new Date());
        user.setUpdatedOn(new Date());
        user = mgr.saveUser(user);
        assertEquals("john", user.getUsername());
        assertEquals(1, user.getRoles().size());

        log.debug("removing user...");

        mgr.removeUser(user.getId().toString());

        try {
            user = mgr.getUserByUsername("john");
            fail("Expected 'Exception' not thrown");
        } catch (Exception e) {
            log.debug(e);
            assertNotNull(e);
        }
    }

    @Test
    @ExpectedException(UserSaveException.class)
    public void testAddExistingUser() throws Exception {
        log.debug("entered 'testAddExistingUser' method");
        assertNotNull(mgr);
        User user = mgr.get(EXISTING_TEST_USER_ID);
        // create new object with null id - Hibernate doesn't like setId(null)
        User anotherUser = new User();
        BeanUtils.copyProperties(user, anotherUser);
        anotherUser.setId(null);
        anotherUser.setVersion(null);
        anotherUser.setRoles(null);
        // try saving as new user, this should fail UserSaveException b/c of
        // unique keys
        mgr.saveUser(anotherUser);
    }
}
