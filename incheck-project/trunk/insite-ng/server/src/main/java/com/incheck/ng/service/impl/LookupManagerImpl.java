package com.incheck.ng.service.impl;

import com.incheck.ng.dao.LookupDao;
import com.incheck.ng.model.LabelValue;
import com.incheck.ng.model.Role;
import com.incheck.ng.service.LookupManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;


/**
 * Implementation of LookupManager interface to talk to the persistence layer.
 *
 */
@Service("lookupManager")
public class LookupManagerImpl implements LookupManager {
    @Autowired
    LookupDao dao;

    /**
     * {@inheritDoc}
     */
    public List<LabelValue> getAllRoles() {
        List<Role> roles = dao.getRoles();
        List<LabelValue> list = new ArrayList<LabelValue>();
        for (Role role1 : roles) {
            list.add(new LabelValue(role1.getName(), role1.getName()));
        }
        return list;
    }
}
