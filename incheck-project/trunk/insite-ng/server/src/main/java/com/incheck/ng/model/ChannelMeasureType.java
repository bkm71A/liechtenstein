package com.incheck.ng.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

@Entity
@Table(name = "channel_measure_type")
@XmlRootElement
public class ChannelMeasureType extends BaseObject implements Serializable {
    private static final long serialVersionUID = -8921932282965687848L;
    private Long id;
    private String code;
    private String description;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)    
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    @Column(name = "code", nullable = false)    
    public String getCode() {
        return code;
    }
    public void setCode(String code) {
        this.code = code;
    }
    @Column(name = "description", nullable = false)    
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    /**
     * @see java.lang.Object#equals(Object)
     */
    public boolean equals(Object object) {
        if (!(object instanceof ChannelMeasureType)) {
            return false;
        }
        ChannelMeasureType rhs = (ChannelMeasureType) object;
        return new EqualsBuilder().append(this.id, rhs.id).append(this.description, rhs.description)
                .append(this.code, rhs.code).isEquals();
    }
    /**
     * @see java.lang.Object#hashCode()
     */
    public int hashCode() {
        return new HashCodeBuilder(-1230031975, -1280789707).append(this.id).append(this.description).append(
                this.code).toHashCode();
    }
    /**
     * @see java.lang.Object#toString()
     */
    public String toString() {
        return new ToStringBuilder(this).append("description", this.description).append("code", this.code).append("id", this.id).toString();
    }
    
}
