package com.incheck.ng.dao;

import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.incheck.ng.model.Role;

/**
 * This class tests the current LookupDao implementation class
 */
public class LookupDaoTest extends BaseDaoTestCase {
    @Autowired
    LookupDao lookupDao;

    @Test
    public void testGetRoles() {
        List<Role> roles = lookupDao.getRoles();
        log.debug(roles);
        assertTrue(roles.size() > 0);
    }
}
