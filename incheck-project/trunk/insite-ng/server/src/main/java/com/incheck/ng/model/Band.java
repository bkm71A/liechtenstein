package com.incheck.ng.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * Band
 */
@Entity
@Table(name = "band", uniqueConstraints = { @UniqueConstraint(columnNames = { "name" }) })
public class Band extends BaseObject implements Serializable {
    private static final long serialVersionUID = -6762234856135411773L;
    private Long id;
    private Integer bandCoefficient;
    private Long startFrequency;
    private Long endFrequency;
    private String name;

    public Band() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "band_coefficient", nullable = false)
    public Integer getBandCoefficient() {
        return bandCoefficient;
    }

    public void setBandCoefficient(Integer bandCoefficient) {
        this.bandCoefficient = bandCoefficient;
    }

    @Column(name = "low_frequency", nullable = false)
    public Long getStartFrequency() {
        return startFrequency;
    }

    public void setStartFrequency(Long startFrequency) {
        this.startFrequency = startFrequency;
    }

    @Column(name = "high_frequency", nullable = false)
    public Long getEndFrequency() {
        return endFrequency;
    }

    public void setEndFrequency(Long endFrequency) {
        this.endFrequency = endFrequency;
    }

    @Column(name = "name", nullable = false, length = 100)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    /**
     * @see java.lang.Object#equals(Object)
     */
    public boolean equals(Object object) {
        if (!(object instanceof Band)) {
            return false;
        }
        Band rhs = (Band) object;
        return new EqualsBuilder().append(this.id, rhs.id).append(this.endFrequency, rhs.endFrequency).append(this.name, rhs.name).append(
                this.bandCoefficient, rhs.bandCoefficient).append(this.startFrequency, rhs.startFrequency).isEquals();
    }

    /**
     * @see java.lang.Object#hashCode()
     */
    public int hashCode() {
        return new HashCodeBuilder(1885867493, -1648825297).append(this.id).append(this.endFrequency).append(this.name).append(
                this.bandCoefficient).append(this.startFrequency).toHashCode();
    }

    /**
     * @see java.lang.Object#toString()
     */
    public String toString() {
        return new ToStringBuilder(this).append("startFrequency", this.startFrequency).append("name", this.name).append("bandCoefficient",
                this.bandCoefficient).append("endFrequency", this.endFrequency).append("id", this.id).toString();
    }
}
