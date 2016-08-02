package com.incheck.ng.dao;

import static com.incheck.ng.test.TestConstants.DAM_SERIAL_NUMBER;
import static com.incheck.ng.test.TestConstants.EXISTING_TEST_DAM_ID;
import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.incheck.ng.model.DataAcquisitionModule;
import com.incheck.ng.test.AbstractSpringTestContextEnabledIntegrationTestSupport;
import com.incheck.ng.test.TestDataDefinition;

@TestDataDefinition(dataSetDTD = "test-data/data_channel.dtd", dataSetXML = "test-data/data_channel.xml")
public class DataAcquisitionModuleDaoTest extends AbstractSpringTestContextEnabledIntegrationTestSupport {

    @Autowired
    private DataAcquisitionModuleDao dataAcquisitionModuleDao;

    @Test
    public void testGetDamBySerialNumber() throws Exception {
        DataAcquisitionModule dam = dataAcquisitionModuleDao.getBySerialNumber(DAM_SERIAL_NUMBER);
        assertEquals(new Long(EXISTING_TEST_DAM_ID), dam.getId());
    }
}
