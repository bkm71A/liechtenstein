package com.incheck.ng.webapp.action;

import com.opensymphony.xwork2.Preparable;
import com.incheck.ng.service.GenericManager;
import com.incheck.ng.model.DataAcquisitionModule;
import com.incheck.ng.webapp.action.BaseAction;

import java.util.List;

public class DataAcquisitionModuleAction extends BaseAction implements Preparable {
    private static final long serialVersionUID = 8292699618161838579L;
    private GenericManager<DataAcquisitionModule, Long> dataAcquisitionModuleManager;
    private List<DataAcquisitionModule> dataAcquisitionModules;
    private DataAcquisitionModule dataAcquisitionModule;
    private Long id;

    public void setDataAcquisitionModuleManager(GenericManager<DataAcquisitionModule, Long> dataAcquisitionModuleManager) {
        this.dataAcquisitionModuleManager = dataAcquisitionModuleManager;
    }

    public List<DataAcquisitionModule> getDataAcquisitionModules() {
        return dataAcquisitionModules;
    }

    /**
     * Grab the entity from the database before populating with request parameters
     */
    public void prepare() {
        if (getRequest().getMethod().equalsIgnoreCase("post")) {
            // prevent failures on new
            String dataAcquisitionModuleId = getRequest().getParameter("dataAcquisitionModule.id");
            if (dataAcquisitionModuleId != null && !dataAcquisitionModuleId.equals("")) {
                dataAcquisitionModule = dataAcquisitionModuleManager.get(new Long(dataAcquisitionModuleId));
            }
        }
    }

    public String list() {
        dataAcquisitionModules = dataAcquisitionModuleManager.getAll();
        return SUCCESS;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public DataAcquisitionModule getDataAcquisitionModule() {
        return dataAcquisitionModule;
    }

    public void setDataAcquisitionModule(DataAcquisitionModule dataAcquisitionModule) {
        this.dataAcquisitionModule = dataAcquisitionModule;
    }

    public String delete() {
        dataAcquisitionModuleManager.remove(dataAcquisitionModule.getId());
        saveMessage(getText("dataAcquisitionModule.deleted"));

        return SUCCESS;
    }

    public String edit() {
        if (id != null) {
            dataAcquisitionModule = dataAcquisitionModuleManager.get(id);
        } else {
            dataAcquisitionModule = new DataAcquisitionModule();
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

        boolean isNew = (dataAcquisitionModule.getId() == null);

        dataAcquisitionModuleManager.save(dataAcquisitionModule);

        String key = (isNew) ? "dataAcquisitionModule.added" : "dataAcquisitionModule.updated";
        saveMessage(getText(key));

        if (!isNew) {
            return INPUT;
        } else {
            return SUCCESS;
        }
    }
}