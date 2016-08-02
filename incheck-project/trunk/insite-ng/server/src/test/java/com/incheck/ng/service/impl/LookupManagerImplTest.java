package com.incheck.ng.service.impl;

import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.List;

import org.jmock.Expectations;
import org.junit.Before;
import org.junit.Test;

import com.incheck.ng.dao.LookupDao;
import com.incheck.ng.model.LabelValue;
import com.incheck.ng.model.Role;
import com.incheck.ng.model.RoleTypes;


public class LookupManagerImplTest extends BaseManagerMockTestCase {
    private LookupManagerImpl mgr = new LookupManagerImpl();
    private LookupDao lookupDao;

    @Before
    public void setUp() throws Exception {
        lookupDao = context.mock(LookupDao.class);
        mgr.dao = lookupDao;
    }

    @Test
    public void testGetAllRoles() {
        log.debug("entered 'testGetAllRoles' method");

        // set expected behavior on dao
        Role role = new Role(RoleTypes.ROLE_ADMIN.toString());
        final List<Role> testData = new ArrayList<Role>();
        testData.add(role);
        context.checking(new Expectations() {{
            one(lookupDao).getRoles();
            will(returnValue(testData));
        }});

        List<LabelValue> roles = mgr.getAllRoles();
        assertTrue(roles.size() > 0);
    }
}
