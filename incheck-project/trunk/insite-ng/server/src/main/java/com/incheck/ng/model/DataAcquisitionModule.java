package com.incheck.ng.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;

import org.hibernate.annotations.OrderBy;

@Entity
@Table(name = "dam")
@XmlRootElement
public class DataAcquisitionModule {
    private Long id;
    private String serialNumber;
    private String description;
    private Short deviceType;
    private List<Sensor> sensors = new ArrayList<Sensor>();    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)    
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    @Column(name = "description", nullable = false, length = 100)
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    @Column(name = "serial_number", nullable = false)    
    public String getSerialNumber() {
        return serialNumber;
    }
    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }
    @Column(name = "device_type", nullable = false)
    public Short getDeviceType() {
        return deviceType;
    }
    public void setDeviceType(Short deviceType) {
        this.deviceType = deviceType;
    }

    @OneToMany(fetch = FetchType.EAGER)
    @JoinColumn(name="dam_id")
    @OrderBy(clause="id")
    public List<Sensor> getSensors() {
        return sensors;
    }
    public void setSensors(List<Sensor> sensors) {
        this.sensors = sensors;
    }
}
