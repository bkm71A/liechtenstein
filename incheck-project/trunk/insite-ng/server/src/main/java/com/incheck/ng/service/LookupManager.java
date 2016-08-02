package com.incheck.ng.service;

import com.incheck.ng.model.LabelValue;

import java.util.List;

/**
 * Business Service Interface to talk to persistence layer and
 * retrieve values for drop-down choice lists.
 *
 */
public interface LookupManager {
    /**
     * Retrieves all possible roles from persistence layer
     * @return List of LabelValue objects
     */
    List<LabelValue> getAllRoles();
}
