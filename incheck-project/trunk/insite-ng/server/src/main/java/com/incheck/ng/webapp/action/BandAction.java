package com.incheck.ng.webapp.action;

import com.opensymphony.xwork2.Preparable;
import com.incheck.ng.service.GenericManager;
import com.incheck.ng.model.Band;
import com.incheck.ng.webapp.action.BaseAction;

import java.util.List;

public class BandAction extends BaseAction implements Preparable {
    private static final long serialVersionUID = 1257950118201508313L;
    private GenericManager<Band, Long> bandManager;
    private List<Band> bands;
    private Band band;
    private Long id;

    public void setBandManager(GenericManager<Band, Long> bandManager) {
        this.bandManager = bandManager;
    }

    public List<Band> getBands() {
        return bands;
    }

    /**
     * Grab the entity from the database before populating with request parameters
     */
    public void prepare() {
        if (getRequest().getMethod().equalsIgnoreCase("post")) {
            // prevent failures on new
            String bandId = getRequest().getParameter("band.id");
            if (bandId != null && !bandId.equals("")) {
                band = bandManager.get(new Long(bandId));
            }
        }
    }

    public String list() {
        bands = bandManager.getAll();
        return SUCCESS;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Band getBand() {
        return band;
    }

    public void setBand(Band band) {
        this.band = band;
    }

    public String delete() {
        bandManager.remove(band.getId());
        saveMessage(getText("band.deleted"));

        return SUCCESS;
    }

    public String edit() {
        if (id != null) {
            band = bandManager.get(id);
        } else {
            band = new Band();
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

        boolean isNew = (band.getId() == null);

        bandManager.save(band);

        String key = (isNew) ? "band.added" : "band.updated";
        saveMessage(getText(key));

        if (!isNew) {
            return INPUT;
        } else {
            return SUCCESS;
        }
    }
}