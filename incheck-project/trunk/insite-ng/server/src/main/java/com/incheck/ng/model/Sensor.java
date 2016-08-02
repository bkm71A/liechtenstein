package com.incheck.ng.model;

import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "sensor")
@XmlRootElement
public class Sensor {
    private Long id;
    private String name;
    private String comments;
    private DataAcquisitionModule dam;
    private Set<Channel> channels;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dam_id")
    public DataAcquisitionModule getDam() {
        return dam;
    }

    public void setDam(DataAcquisitionModule dam) {
        this.dam = dam;
    }

    public Sensor() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "name", nullable = false, length = 100)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "comments", nullable = true, length = 100)
    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    @OneToMany(fetch = FetchType.EAGER)
    @JoinColumn(name = "sensor_id")
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    public Set<Channel> getChannels() {
        return channels;
    }

    public void setChannels(Set<Channel> channels) {
        this.channels = channels;
    }
}
