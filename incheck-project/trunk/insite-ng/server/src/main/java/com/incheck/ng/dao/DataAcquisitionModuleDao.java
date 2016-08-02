package com.incheck.ng.dao;

import com.incheck.ng.model.DataAcquisitionModule;

public interface DataAcquisitionModuleDao extends GenericDao<DataAcquisitionModule, Long> {

    DataAcquisitionModule getBySerialNumber(String serialNumber);
}
