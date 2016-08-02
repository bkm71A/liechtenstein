package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.security.Principal;

public class UserRole implements Principal, Serializable{
	
	private static final long serialVersionUID = 1L;
	private int roleId;
	private String roleName;
	private String roleDescription;
	private String delim = ";";
	
	@Override
	public String toString() {
		StringBuilder str = new StringBuilder("USERROLE:");
		str.append("roleid=")
		.append(roleId)
		.append(delim)
		.append("roleName=")
		.append(roleName);
		
		return str.toString();
		
	}

	public int getRoleId() {
		return roleId;
	}
	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}
	public String getRoleDescription() {
		return roleDescription;
	}
	public void setRoleDescription(String roleDescription) {
		this.roleDescription = roleDescription;
	}
	public UserRole(String roleName){
		this.roleName=roleName;
	}
	
	/**
	 * Stay away from this constructor
	 */
	public UserRole(){
	
	}
	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}

	public String getName() {
		return this.roleName; 
	}
}
