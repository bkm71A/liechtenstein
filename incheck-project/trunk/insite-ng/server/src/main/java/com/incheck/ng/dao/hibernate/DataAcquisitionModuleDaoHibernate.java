package com.incheck.ng.dao.hibernate;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.incheck.ng.dao.DataAcquisitionModuleDao;
import com.incheck.ng.model.DataAcquisitionModule;

@Repository("damDao")
public class DataAcquisitionModuleDaoHibernate extends GenericDaoHibernate<DataAcquisitionModule, Long> implements DataAcquisitionModuleDao {

    public DataAcquisitionModuleDaoHibernate() {
        super(DataAcquisitionModule.class);
    }

    @SuppressWarnings("unchecked")
    @Override
    public DataAcquisitionModule getBySerialNumber(String serialNumber) {
        List<DataAcquisitionModule> dams = getHibernateTemplate().find("from DataAcquisitionModule where serialNumber=?", serialNumber);
        return (dams == null || dams.isEmpty()) ? null : dams.get(0);
    }
}
