package com.incheck.ng.dao.hibernate.interceptor;

import java.io.Serializable;
import java.util.Date;

import org.hibernate.EmptyInterceptor;
import org.hibernate.type.Type;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;

import com.incheck.ng.model.AuditBaseObject;
import com.incheck.ng.model.User;

public class AuditInterceptor extends EmptyInterceptor {
    private static final long serialVersionUID = 2187444109100131594L;

    @Override
    public boolean onFlushDirty(Object entity, Serializable id, Object[] currentState, Object[] previousState, String[] propertyNames,
            Type[] types) {
        if (entity instanceof AuditBaseObject) {
            audit((AuditBaseObject) entity);
        }
        return super.onFlushDirty(entity, id, currentState, previousState, propertyNames, types);
    }

    private void audit(AuditBaseObject entity) {
        User user = getUser();
        if (entity.getCreatedOn() == null) {
            entity.setCreatedBy(user);
            entity.setCreatedOn(new Date());
        }
        entity.setUpdatedBy(user);
        entity.setUpdatedOn(new Date());
    }

    protected User getUser() {
        SecurityContext securityContext = SecurityContextHolder.getContext();
        if (securityContext != null && securityContext.getAuthentication() != null
                && securityContext.getAuthentication().getPrincipal() instanceof User) {
            return (User) securityContext.getAuthentication().getPrincipal();
        }
        return null;
    }
}
