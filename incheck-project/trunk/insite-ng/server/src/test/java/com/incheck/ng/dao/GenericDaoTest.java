package com.incheck.ng.dao;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SessionFactory;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.incheck.ng.dao.hibernate.GenericDaoHibernate;
import com.incheck.ng.model.User;
import com.incheck.ng.test.AbstractSpringTestContextEnabledIntegrationTestSupport;
import com.incheck.ng.test.TestConstants;
import com.incheck.ng.test.TestDataDefinition;


@TestDataDefinition(dataSetDTD = "test-data/data_incheck_user.dtd", dataSetXML = "test-data/data_incheck_user.xml")
public class GenericDaoTest extends AbstractSpringTestContextEnabledIntegrationTestSupport {

    Log log = LogFactory.getLog(GenericDaoTest.class);
    GenericDao<User, Long> genericDao;
    @Autowired
    SessionFactory sessionFactory;

    @Before
    public void setUp() {
        genericDao = new GenericDaoHibernate<User, Long>(User.class, sessionFactory);
    }

    @Test
    public void getUser() {
        User user = genericDao.get(TestConstants.EXISTING_TEST_USER_ID);
        assertNotNull(user);
        assertEquals(TestConstants.TEST_USERNAME, user.getUsername());
    }
}
