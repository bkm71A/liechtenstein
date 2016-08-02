package com.incheck.ng.webapp.action;

import com.opensymphony.xwork2.Preparable;
import com.incheck.ng.service.GenericManager;
import com.incheck.ng.model.OverallType;
import com.incheck.ng.webapp.action.BaseAction;

import java.util.List;

public class OverallTypeAction extends BaseAction implements Preparable {
    private static final long serialVersionUID = -7129431697085816509L;
    private GenericManager<OverallType, Long> overallTypeManager;
    private List<OverallType> overallTypes;
    private OverallType overallType;
    private Long id;

    public void setOverallTypeManager(GenericManager<OverallType, Long> overallTypeManager) {
        this.overallTypeManager = overallTypeManager;
    }

    public List<OverallType> getOverallTypes() {
        return overallTypes;
    }

    /**
     * Grab the entity from the database before populating with request parameters
     */
    public void prepare() {
        if (getRequest().getMethod().equalsIgnoreCase("post")) {
            // prevent failures on new
            String overallTypeId = getRequest().getParameter("overallType.id");
            if (overallTypeId != null && !overallTypeId.equals("")) {
                overallType = overallTypeManager.get(new Long(overallTypeId));
            }
        }
    }

    public String list() {
        overallTypes = overallTypeManager.getAll();
        return SUCCESS;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public OverallType getOverallType() {
        return overallType;
    }

    public void setOverallType(OverallType overallType) {
        this.overallType = overallType;
    }

    public String delete() {
        overallTypeManager.remove(overallType.getId());
        saveMessage(getText("overallType.deleted"));

        return SUCCESS;
    }

    public String edit() {
        if (id != null) {
            overallType = overallTypeManager.get(id);
        } else {
            overallType = new OverallType();
        }

        return SUCCESS;
    }

    public String save() throws Exception {
        if (cancel != null) {
            return "cancel";
        }

        if (delete != null) {
            return delete();
        }

        boolean isNew = (overallType.getId() == null);

        overallTypeManager.save(overallType);

        String key = (isNew) ? "overallType.added" : "overallType.updated";
        saveMessage(getText(key));

        if (!isNew) {
            return INPUT;
        } else {
            return SUCCESS;
        }
    }
}