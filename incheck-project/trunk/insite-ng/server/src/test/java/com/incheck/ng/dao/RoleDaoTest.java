package com.incheck.ng.dao;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.util.HashMap;
import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.incheck.ng.model.Role;
import com.incheck.ng.model.RoleTypes;
import com.incheck.ng.test.AbstractSpringTestContextEnabledIntegrationTestSupport;
import com.incheck.ng.test.TestDataDefinition;

@TestDataDefinition(dataSetDTD = "test-data/data_role.dtd", dataSetXML = "test-data/data_role.xml")
public class RoleDaoTest extends AbstractSpringTestContextEnabledIntegrationTestSupport {
    @Autowired
    private RoleDao dao;

    @Test
    public void testGetRoleInvalid() throws Exception {
        Role role = dao.getRoleByName("badrolename");
        assertNull(role);
    }

    @Test
    public void testGetRole() throws Exception {
        Role role = dao.getRoleByName(RoleTypes.ROLE_USER.toString());
        assertNotNull(role);
    }

    @Test
    public void testUpdateRole() throws Exception {
        Role role = dao.getRoleByName("ROLE_TEST_USER");
        role.setDescription("test descr");
        dao.save(role);
        flush();
        role = dao.getRoleByName("ROLE_TEST_USER");
        assertEquals("test descr", role.getDescription());
    }

    @Test
    public void testAddAndRemoveRole() throws Exception {
        Role role = new Role("testrole");
        role.setDescription("new role descr");
        dao.save(role);
        flush();
        
        role = dao.getRoleByName("testrole");
        assertNotNull(role.getDescription());

        dao.removeRole("testrole");
        flush();

        role = dao.getRoleByName("testrole");
        assertNull(role);
    }

    @Test
    public void testFindByNamedQuery() {
        HashMap<String, Object> queryParams = new HashMap<String, Object>();
        queryParams.put("name", RoleTypes.ROLE_USER.toString());
        List<Role> roles = dao.findByNamedQuery("findRoleByName", queryParams);
        assertNotNull(roles);
        assertTrue(roles.size() > 0);
    }
}
