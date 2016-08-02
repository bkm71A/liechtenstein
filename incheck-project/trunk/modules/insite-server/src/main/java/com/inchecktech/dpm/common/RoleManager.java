package com.inchecktech.dpm.common;

import java.util.List;

import com.inchecktech.dpm.beans.UserRole;

public interface RoleManager {

	public UserRole createRole(String roleName, String roleDescription);
	public UserRole getRole(String roleName);
	public void deleteRole(UserRole role);
	public void updateRole(UserRole role);
	public List<UserRole> getRoles();
	public int getRoleId(String roleName);
	public List<UserRole> getRolesForUser(int userid);
}
