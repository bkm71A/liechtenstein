package com.incheck.ng.model;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import javax.persistence.CascadeType;
import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.MapKeyColumn;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * Channel
 */
@Entity
@Table(name = "channel")
@XmlRootElement
public class Channel extends BaseObject implements Serializable {
    private static final long serialVersionUID = 7218098419015864216L;
    private Long id;
    private Sensor sensor;
    private Long damChannelId;
    private ChannelMeasureType measureType;
    private ChannelType channelType;
    private String comments;
    private List<Band> bands;
    private Map<String, String> channelConfig;

    public Channel() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sensor_id")
    public Sensor getSensor() {
        return sensor;
    }

    public void setSensor(Sensor sensor) {
        this.sensor = sensor;
    }

    @Column(name = "comments", nullable = true, length = 300)
    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    @ManyToOne(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    @JoinColumn(name = "channel_measure_type_id")
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    public ChannelMeasureType getMeasureType() {
        return measureType;
    }

    public void setMeasureType(ChannelMeasureType measureType) {
        this.measureType = measureType;
    }

    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(name = "channel_band", joinColumns = { @JoinColumn(name = "channel_id") }, inverseJoinColumns = { @JoinColumn(name = "band_id") })
    public List<Band> getBands() {
        return bands;
    }

    public void setBands(List<Band> bands) {
        this.bands = bands;
    }

    @Column(name = "device_channel_id", nullable = false)
    public Long getDamChannelId() {
        return damChannelId;
    }

    public void setDamChannelId(Long damChannelId) {
        this.damChannelId = damChannelId;
    }

    @ElementCollection(fetch = FetchType.LAZY)
    @MapKeyColumn(name = "name", insertable = false, updatable = false)
    @Column(name = "value")
    @CollectionTable(name = "v_channel_config", joinColumns = @JoinColumn(name = "channel_id"))
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    public Map<String, String> getChannelConfig() {
        return channelConfig;
    }

    public void setChannelConfig(Map<String, String> channelConfig) {
        this.channelConfig = channelConfig;
    }

    @Enumerated(EnumType.ORDINAL)
    @Column(name = "channel_type_id", nullable = false, updatable = true)
    public ChannelType getChannelType() {
        return channelType;
    }

    public void setChannelType(ChannelType channelType) {
        this.channelType = channelType;
    }

    /**
     * @see java.lang.Object#equals(Object)
     */
    public boolean equals(Object object) {
        if (!(object instanceof Channel)) {
            return false;
        }
        Channel rhs = (Channel) object;
        return new EqualsBuilder().append(this.sensor, rhs.sensor).append(this.id, rhs.id).append(
                this.bands, rhs.bands).append(this.channelType, rhs.channelType).append(this.channelConfig, rhs.channelConfig).append(
                this.measureType, rhs.measureType).append(this.damChannelId, rhs.damChannelId).append(this.comments, rhs.comments)
                .isEquals();
    }

    /**
     * @see java.lang.Object#hashCode()
     */
    public int hashCode() {
        return new HashCodeBuilder(-1760983935, 611801217).append(this.sensor).append(this.id).append(
                this.bands).append(this.channelType).append(this.channelConfig).append(this.measureType).append(this.damChannelId).append(
                this.comments).toHashCode();
    }

    /**
     * @see java.lang.Object#toString()
     */
    public String toString() {
        return new ToStringBuilder(this).append("damChannelId", this.damChannelId).append("channelType", this.channelType).append(
                "channelConfig", this.channelConfig).append("comments", this.comments).append("measureType", this.measureType).append(
                "bands", this.bands).append("sensor", this.sensor).append("id", this.id).toString();
    }
}
