package com.incheck.ng.dao;

import static com.incheck.ng.test.TestConstants.EXISTING_TEST_USER_ID;
import static com.incheck.ng.test.TestConstants.NOT_EXISTING_TEST_USER_ID;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.annotation.ExpectedException;

import com.incheck.ng.model.Address;
import com.incheck.ng.model.Role;
import com.incheck.ng.model.RoleTypes;
import com.incheck.ng.model.User;
import com.incheck.ng.test.AbstractSpringTestContextEnabledIntegrationTestSupport;
import com.incheck.ng.test.TestDataDefinition;

@TestDataDefinition(dataSetDTD = "test-data/data_incheck_user.dtd", dataSetXML = "test-data/data_incheck_user.xml")
public class UserDaoTest extends AbstractSpringTestContextEnabledIntegrationTestSupport {

    @Autowired
    private UserDao dao;
    @Autowired
    private RoleDao rdao;

    @Before
    public void setUp() {
        setAuthentication(dao.get(EXISTING_TEST_USER_ID));
    }

    @Test
    @ExpectedException(DataAccessException.class)
    public void testGetUserInvalid() throws Exception {
        // should throw DataAccessException
        dao.get(NOT_EXISTING_TEST_USER_ID);
    }

    @Test
    public void testGetUser() throws Exception {
        User user = dao.get(EXISTING_TEST_USER_ID);
        assertNotNull(user);
        assertEquals(3, user.getRoles().size());
        assertTrue(user.isEnabled());
    }

    @Test
    public void testGetUserPassword() throws Exception {
        User user = dao.get(EXISTING_TEST_USER_ID);
        String password = dao.getUserPassword(user.getUsername());
        assertNotNull(password);
    }

    @Test
    @ExpectedException(DataIntegrityViolationException.class)
    public void testUpdateUser() throws Exception {
        User user = dao.get(EXISTING_TEST_USER_ID);
        Address address = user.getAddress();
        address.setAddress("new address");
        dao.saveUser(user);
        flush();
        user = dao.get(EXISTING_TEST_USER_ID);
        assertEquals(address, user.getAddress());
        assertEquals("new address", user.getAddress().getAddress());
        // verify that violation occurs when adding new user with same username
        User duplicateUser = new User();
        BeanUtils.copyProperties(user, duplicateUser);
        duplicateUser.setId(null);
        duplicateUser.setVersion(null);
        duplicateUser.setRoles(null);
        // should throw DataIntegrityViolationException
        dao.saveUser(duplicateUser);
        flush();
    }

    @Test
    public void testAddUserRole() throws Exception {
        User user = dao.get(EXISTING_TEST_USER_ID);
        assertEquals(3, user.getRoles().size());
        // Test Role
        Role role = rdao.get(-1L);
        user.addRole(role);
        dao.saveUser(user);
        flush();
        user = dao.get(EXISTING_TEST_USER_ID);
        assertEquals(4, user.getRoles().size());
        // add already assigned role twice - should result in no additional role
        role = rdao.getRoleByName(RoleTypes.ROLE_CONFIG_ADMIN.toString());
        user.addRole(role);
        dao.saveUser(user);
        flush();
        user.getRoles().remove(role);
        dao.saveUser(user);
        flush();
        user = dao.get(EXISTING_TEST_USER_ID);
        assertEquals(3, user.getRoles().size());
    }

    @Test
    @ExpectedException(DataAccessException.class)
    public void testAddAndRemoveUser() throws Exception {
        User user = new User("testuser");
        user.setPassword("testpass");
        user.setFirstName("Test");
        user.setLastName("Last");
        Address address = new Address();
        address.setCity("Northbrook");
        address.setProvince("IL");
        address.setCountry("USA");
        address.setPostalCode("60015");
        user.setAddress(address);
        user.setEmail("testuser@inchecktech.com");
        Role role = rdao.getRoleByName(RoleTypes.ROLE_USER.toString());
        assertNotNull(role.getId());
        user.addRole(role);

        user = dao.saveUser(user);
        flush();

        assertNotNull(user.getId());
        user = dao.get(user.getId());
        assertEquals("testpass", user.getPassword());

        dao.remove(user.getId());
        flush();

        // should throw DataAccessException
        dao.get(user.getId());
    }

    @Test
    public void testUserExists() throws Exception {
        boolean b = dao.exists(EXISTING_TEST_USER_ID);
        assertTrue(b);
    }

    @Test
    public void testUserNotExists() throws Exception {
        boolean b = dao.exists(NOT_EXISTING_TEST_USER_ID);
        assertFalse(b);
    }
}
