package com.incheck.ng.webapp.action;

import com.opensymphony.xwork2.Preparable;
import com.incheck.ng.service.GenericManager;
import com.incheck.ng.model.Sensor;
import com.incheck.ng.webapp.action.BaseAction;

import java.util.List;

public class SensorAction extends BaseAction implements Preparable {
    private static final long serialVersionUID = 7676107464018127271L;
    private GenericManager<Sensor, Long> sensorManager;
    private List<Sensor> sensors;
    private Sensor sensor;
    private Long id;

    public void setSensorManager(GenericManager<Sensor, Long> sensorManager) {
        this.sensorManager = sensorManager;
    }

    public List<Sensor> getSensors() {
        return sensors;
    }

    /**
     * Grab the entity from the database before populating with request parameters
     */
    public void prepare() {
        if (getRequest().getMethod().equalsIgnoreCase("post")) {
            // prevent failures on new
            String sensorId = getRequest().getParameter("sensor.id");
            if (sensorId != null && !sensorId.equals("")) {
                sensor = sensorManager.get(new Long(sensorId));
            }
        }
    }

    public String list() {
        sensors = sensorManager.getAll();
        return SUCCESS;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Sensor getSensor() {
        return sensor;
    }

    public void setSensor(Sensor sensor) {
        this.sensor = sensor;
    }

    public String delete() {
        sensorManager.remove(sensor.getId());
        saveMessage(getText("sensor.deleted"));

        return SUCCESS;
    }

    public String edit() {
        if (id != null) {
            sensor = sensorManager.get(id);
        } else {
            sensor = new Sensor();
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

        boolean isNew = (sensor.getId() == null);

        sensorManager.save(sensor);

        String key = (isNew) ? "sensor.added" : "sensor.updated";
        saveMessage(getText(key));

        if (!isNew) {
            return INPUT;
        } else {
            return SUCCESS;
        }
    }
}