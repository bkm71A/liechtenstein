package com.inchecktech.dpm.common;

import java.util.List;

import com.inchecktech.dpm.beans.UserRole;
import com.inchecktech.dpm.persistence.PersistRoleManager;
import com.inchecktech.dpm.utils.Logger;

public class RoleManagerImpl implements RoleManager {

	private static Logger logger = new Logger(UserManagerImpl.class);

	public UserRole createRole(String roleName, String roleDescription) {

		UserRole role = new UserRole(roleName);
		role.setRoleDescription(roleDescription);
		boolean result = PersistRoleManager.createRole(roleName,
				roleDescription);

		if (result) {
			role = getRole(roleName);
		}else{
			logger.error("Unable to create role");	
		}

		return role;
	}

	public void deleteRole(UserRole role) {
		PersistRoleManager.deleteRole(role.getRoleName());
	}

	public UserRole getRole(String roleName) {
		return PersistRoleManager.getRole(roleName);
	}

	public void updateRole(UserRole role) {
		if (null != role){
			logger.info("updating role:" + role);
			PersistRoleManager.updateRole(role.getRoleName(), role.getRoleDescription());	
		}else{
			logger.error("unable to update role, role is null");
		}
	}

	public List<UserRole> getRoles() {
		return PersistRoleManager.getRoles();
	}

	public int getRoleId(String roleName) {
		return PersistRoleManager.getRoleId(roleName);

	}

	public List<UserRole> getRolesForUser(int userid) {
		// TODO
		return null;

	}
}
