package com.incheck.ng.dao.hibernate;

import com.incheck.ng.dao.RoleDao;
import com.incheck.ng.model.Role;
import org.springframework.stereotype.Repository;

import java.util.List;


/**
 * This class interacts with Spring's HibernateTemplate to save/delete and
 * retrieve Role objects.
 *
 */
@Repository(value="roleDao")
public class RoleDaoHibernate extends GenericDaoHibernate<Role, Long> implements RoleDao {

    /**
     * Constructor to create a Generics-based version using Role as the entity
     */
    public RoleDaoHibernate() {
        super(Role.class);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public Role getRoleByName(String rolename) {
        List<Role> roles = getHibernateTemplate().find("from Role where name=?", rolename);
        if (roles.isEmpty()) {
            return null;
        } else {
            return roles.get(0);
        }
    }

    /**
     * {@inheritDoc}
     */
    public void removeRole(String rolename) {
        Object role = getRoleByName(rolename);
        getHibernateTemplate().delete(role);
    }
}
