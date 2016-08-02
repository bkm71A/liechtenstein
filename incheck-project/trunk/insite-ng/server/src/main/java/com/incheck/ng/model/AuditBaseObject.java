package com.incheck.ng.model;


import java.util.Date;

import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

@MappedSuperclass
public abstract class AuditBaseObject extends BaseObject 
{
    private static final long serialVersionUID = -6128419064331827834L;
    private boolean isEnabled;
    private Date createdOn;
    private User createdBy;
    private Date updatedOn;
    private User updatedBy;
    
    @Column(name = "is_enabled")
    public boolean isEnabled() {
        return isEnabled;
    }
    
    public void setEnabled(boolean isEnabled) {
        this.isEnabled = isEnabled;
    }

    @Temporal(TemporalType.TIMESTAMP)   
    @Column(name="created_on")  
    public Date getCreatedOn() 
    {
        return createdOn;
    }
    
    public void setCreatedOn(Date createdOn) 
    {
        this.createdOn = createdOn;
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="created_by")
    public User getCreatedBy() 
    {
        return createdBy;
    }
    
    public void setCreatedBy(User createdBy) 
    {
        this.createdBy = createdBy;
    }
    @Column(name="updated_on")  
    public Date getUpdatedOn() 
    {
        return updatedOn;
    }
    
    public void setUpdatedOn(Date updatedOn) 
    {
        this.updatedOn = updatedOn;
    }
    
    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="updated_by")
    public User getUpdatedBy() 
    {
        return updatedBy;
    }
    
    public void setUpdatedBy(User updatedBy) 
    {
        this.updatedBy = updatedBy;
    }
    
    @SuppressWarnings("unchecked")
    @Transient
    public Class getEntityClass()
    {
        return this.getClass();
    }
}

