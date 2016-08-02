package com.inchecktech.dpm.common;

import java.util.List;

import com.inchecktech.dpm.beans.LoginProcessor;
import com.inchecktech.dpm.beans.RegistrationProcessor;
import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.beans.User;
import com.inchecktech.dpm.beans.UserRole;

public interface UserManager {

	public static final String STATUS_USER_ALREADY_EXIST = "Username you chosen already exist, please select another name";
	public static final String STATUS_USER_REGISTERED_SUCCESS = "Registration successful, please check your email for confirmation";
	public static final String STATUS_USER_CREATED_SUCCESS = "User created";
	public static final String STATUS_USER_BAD_PASS_OR_ID = "Incorrect username or password, please try again.";
	public static final String STATUS_USER_EMAIL_VALIDATION_SUCCESS = "Thank you, please processed to logon";
	public static final String STATUS_ERROR_DURING_LOGIN = "Problem on a server, please email demo@inchecktech.net";
	public static final String STATUS_USER_EMAIL_VALIDATION_ERROR = "There was an error validating your registration, please email demo@inchecktech.net";
	public static final String STATUS_USER_LOGIN_SUCCESS = "USER_LOGIN_SUCCESS";
	public static final String STATUS_USER_PASSWORD_CHANGED_SUCCESS = "Password successfully changed";
	public static final String STATUS_USER_PASSWORD_CHANGED_ERROR = "Error while trying to change password";
	public static final String STATUS_ERROR_DURING_REGISTRATION="Unexpected error occured while trying to complete the registration process, please contact demo@inchecktech.net";
	public static final String STATUS_ERROR_DURING_PASSWORD_RESET="Unexpected error occured while trying to reset password, please contact demo@inchecktech.net";
	
	public static final String STATUS_USER_ENABLED_SUCCESS = "Successfully enabled user";
	public static final String STATUS_USER_ENABLED_ERROR = "Error while trying to enable user";
	
	public static final String STATUS_USER_SESSION_ERROR = "An error occured while creating a user session";

	/**
	 * This method will update user details, excluding password.
	 * 
	 * @param user
	 * @return status
	 */
	public Status updateUser(User user);

	/**
	 * This user will update user's password
	 * 
	 * @param userName
	 * @param userPass
	 * @return status
	 */
	public Status updateUserPass(String userName, String userPass);
	
	

	/**
	 * 
	 * @param userName
	 * @return user
	 */
	public User getUser(String userName);

	/**
	 * 
	 * @param username
	 * @return userid
	 */
	public int getUserId(String username);

	/**
	 * 
	 * @return list
	 */
	public List<User> getUsers();
	
	/**
	 * 
	 * @param username
	 * @param password
	 * @return LoginProcessor
	 */
	public LoginProcessor processUserLogon(String username, String password);

	/**
	 * 
	 * @param userName
	 * @return status
	 */
	public Status processUserLogout(String userName);

	/**
	 * 
	 * @param userName
	 * @param roleName
	 * @return
	 */
	public boolean isUserInRole(String userName, String roleName);

	/**
	 * 
	 * @param userName
	 * @return list
	 */
	public List<UserRole> getRolesForUser(String userName);

	/**
	 * @return status
	 */
	public Status createUser(User user);

	/**
	 * 
	 * @param userName
	 * @return status
	 */
	public Status deleteUser(String userName);

	/**
	 * 
	 * @param userName
	 * @param roleName
	 * @return status
	 */
	public Status addUserToRole(String userName, String roleName);

	/**
	 * 
	 * @param userName
	 * @param roleName
	 * @return status
	 */
	public Status removeUserFromRole(String userName, String roleName);

	/**
	 * 
	 * @param userName
	 * @return status
	 */
	public Status removeUserFromRoles(String userName);

	/**
	 * 
	 * @param userName
	 * @return
	 */
	public boolean enableUser(String userName);

	/**
	 * 
	 * @param userName
	 * @return
	 */
	public boolean disableUser(String userName);

	/**
	 * 
	 * @param regtoken
	 * @return status
	 */
	public Status verifyUser(String regtoken);

	/**
	 * 
	 * @param userName
	 * @param userPass
	 * @param firstName
	 * @param lastName
	 * @param email
	 * @param organization
	 * @param industry
	 * @param howdidyouhear
	 * @param addtomail
	 * @param contactbyrep
	 * @param serverurl
	 * @return RegistrationProcessor
	 */
	public RegistrationProcessor registerUser(String userName, String userPass,
			String firstName, String lastName, String email,
			String organization, String industry, String howdidyouhear,
			boolean addtomail, boolean contactbyrep, String serverurl, String timezone);

	/**
	 * 
	 * @param username
	 * @return LoginProcessor
	 */
	public LoginProcessor resetUserPassword(String userName);

	/**
	 * 
	 * @param userName
	 * @param roles
	 * @return status
	 */
	public Status updateUserRoles(String userName, List<UserRole> roles);
	
	/**
	 * 
	 * @param user
	 * @return status
	 */
	public Status validateUser(User user);
	
	/**
	 * 
	 * @param roleId
	 * @return
	 */
	public boolean isAllowed(int roleId);
	
	/**
	 * 
	 * @param roleId
	 * @return
	 */
	public boolean isAllowed(int[] roleId);
}