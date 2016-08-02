package com.inchecktech.dpm.common;

import java.util.Date;
import java.util.List;

import com.inchecktech.dpm.beans.LoginProcessor;
import com.inchecktech.dpm.beans.RegistrationProcessor;
import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.beans.User;
import com.inchecktech.dpm.beans.UserRole;
import com.inchecktech.dpm.notifications.MailProxy;
import com.inchecktech.dpm.persistence.PersistAuditLog;
import com.inchecktech.dpm.persistence.PersistUserManager;
import com.inchecktech.dpm.utils.HashUtil;
import com.inchecktech.dpm.utils.Logger;

public class UserManagerImpl implements UserManager {

	private static Logger logger = new Logger(UserManagerImpl.class);
	RoleManager rm = new RoleManagerImpl();
	SessionManagerImpl sm = SessionManagerImpl.getInstance();

	public User getUser(String userName) {
		logger.info("getting user for username " + userName);
		User user = PersistUserManager.getUser(userName);

		if (null != user) {
			// set user roles if any
			user.setUserroles(getRolesForUser(user.getUserName()));

		} else {
			logger.info("User with userName=" + userName + " does not exist");
		}
		return user;
	}

	public List<User> getUsers() {
		logger.info("start getUsers()");
		List<User> users = PersistUserManager.getUsers();
		populateUsersWithRoles(users);
		return users;
	}

	private void populateUsersWithRoles(List<User> users) {
		logger.info("populateUsersWithRoles");
		if (null != users) {
			for (User user : users) {
				user.setUserroles(getRolesForUser(user.getUserName()));
			}
		}
	}

	public LoginProcessor processUserLogon(String username, String password) {

		String message = UserManager.STATUS_ERROR_DURING_LOGIN;
		LoginProcessor lp = new LoginProcessor();
		String passwordHash;

		try {
			passwordHash = HashUtil.hashString(password);
		} catch (Exception e) {
			lp.setStatus(Status.STATUS_ERROR);
			lp.setMessage("An error occured while trying to log in the user");
			return lp;
		}

		logger.info("Logging in user with userid " + username
				+ " and password " + passwordHash);

		User user = PersistUserManager.processUserLogon(username, passwordHash);
		if (null == user) {
			message = UserManager.STATUS_USER_BAD_PASS_OR_ID;
			logger.error(message);
			lp.setStatus(LoginProcessor.STATUS_ERROR);
			lp.setMessage(message);

			PersistAuditLog.writeMessage(0, PersistAuditLog.LOGIN_FAILED,
					new Date(), UserManager.STATUS_USER_BAD_PASS_OR_ID);

		} else {
			message = UserManager.STATUS_USER_LOGIN_SUCCESS;
			lp.setStatus(LoginProcessor.STATUS_SUCCESS);
			lp.setMessage(message);

			// create/modify session here
			Status s = sm.createUserSession(username);

			if (s.getStatus() == Status.STATUS_ERROR) {
				lp.setStatus(LoginProcessor.STATUS_ERROR);
				lp.setMessage(UserManager.STATUS_USER_SESSION_ERROR);

				PersistAuditLog.writeMessage(user.getUserId(),
						PersistAuditLog.LOGIN_FAILED, new Date(),
						UserManager.STATUS_USER_SESSION_ERROR);
			} else {

				PersistAuditLog.writeMessage(user.getUserId(),
						PersistAuditLog.LOGIN_SUCCESS, new Date(),
						UserManager.STATUS_USER_LOGIN_SUCCESS);
			}
		}

		lp.setMessage(message);
		lp.setUser(user);
		return lp;

	}

	public Status processUserLogout(String userName) {

		Status status = new Status();
		String message = "";
		logger.info("processUserLogout for user " + userName);
		User user = getUser(userName);

		if (null == user) {
			message = "Looks like the session for user never existed because the user provided was not found, consider the user logged out.";
			logger.info(message);
			status.setStatus(Status.STATUS_SUCCESS);
			status.setMessage(message);

			return status;
		}

		sm.invalidate(userName);
		message = "user session was invalidated";
		status.setStatus(Status.STATUS_SUCCESS);
		status.setMessage(message);

		return status;
	}

	public boolean isUserInRole(String userName, String roleName) {
		logger.info("isUserInRole for userName=" + userName + " for roleName="
				+ roleName);
		return PersistUserManager.isUserInRole(userName, roleName);
	}

	public List<UserRole> getRolesForUser(String userName) {
		logger.info("getRolesForUser " + userName);
		return PersistUserManager.getRolesForUser(userName);

	}

	public Status deleteUser(String userName) {

		Status status = new Status();
		String message = "";
		logger.info("deleting user " + userName);

		logger.info("\tremoving user " + userName + " from roles");
		removeUserFromRoles(userName);

		boolean deleted = PersistUserManager.deleteUser(userName);

		if (deleted) {
			status.setStatus(Status.STATUS_SUCCESS);
			status.setMessage("deletedUser:" + userName);
		} else {
			message = "An error occured while deleting user " + userName;
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage(message);
		}
		return status;
	}

	public Status addUserToRole(String userName, String roleName) {

		logger.info("start addUserToRole");
		Status status = new Status();

		int roleId = rm.getRoleId(roleName);
		int userId = getUserId(userName);
		boolean result = PersistUserManager.addUserToRole(userId, roleId);

		if (result) {
			String message = "added user " + userName + " to role " + roleName;
			logger.info(message);
			status.setMessage(message);
			status.setStatus(Status.STATUS_SUCCESS);
		} else {
			String message = "unable to add user " + userName + " to role "
					+ roleName;
			logger.info(message);
			status.setMessage(message);
			status.setStatus(Status.STATUS_ERROR);
		}

		return status;
	}

	public Status removeUserFromRoles(String userName) {

		Status status = new Status();
		logger.info("Removing user " + userName + " from all roles");

		int userId = getUserId(userName);
		boolean result = PersistUserManager.removeUserFromRoles(userId);

		if (result) {
			String message = "removed user " + userName + " from roles";
			logger.info(message);
			status.setStatus(Status.STATUS_SUCCESS);
			status.setMessage(message);
		} else {
			String message = "unable to remove user " + userName
					+ " from roles";
			logger.info(message);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage(message);
		}

		return status;
	}

	public Status removeUserFromRole(String userName, String roleName) {

		Status status = new Status();
		String message = "";

		int roleId = rm.getRoleId(roleName);
		int userId = getUserId(userName);
		logger.info("removing user " + userName + " from role " + roleName);

		boolean result = PersistUserManager.removeUserFromRole(userId, roleId);

		if (result) {
			message = "removed user " + userName + " from role " + roleName;
			logger.info(message);
			status.setStatus(Status.STATUS_SUCCESS);
			status.setMessage(message);
		} else {
			message = "unable to remove user " + userName + " from role "
					+ roleName;
			logger.info(message);
			status.setStatus(Status.STATUS_SUCCESS);
			status.setMessage(message);
		}
		return status;
	}

	public Status updateUser(User user) {

		Status status = new Status();
		status.setMessage("user updated");
		status.setStatus(Status.STATUS_SUCCESS);

		logger.info("updateUser: " + user);
		PersistUserManager.updateUser(user);

		if (null != user.getPassword() && !user.getPassword().equals("")) {
			status = updateUserPass(user.getUserName(), user.getPassword());
		}

		List<UserRole> roles = user.getUserroles();
		if (null != roles && !roles.isEmpty()) {
			status = updateUserRoles(user.getUserName(), roles);
		}

		return status;
	}

	public Status updateUserPass(String userName, String userPass) {

		Status status = new Status();
		String message = "Sorry, you are not allowed to change your password, please contact administrator";
		status.setStatus(Status.STATUS_ERROR);
		logger.info("updating password for user " + userName);

		// ----start test code ----//
		int[] grpall = { 1, 2, 3, 4}; 
		boolean allowed = isAllowed(grpall);
		// ---- end test code ----//

		if (allowed) {
			int userid = getUserId(userName);
			if (userid == 0) {
				PersistAuditLog.writeMessage(userid,
						PersistAuditLog.USER_PASS_CHANGE, new Date(),
						UserManager.STATUS_USER_PASSWORD_CHANGED_ERROR);

			} else {
				try {
					String passwordHash = HashUtil.hashString(userPass);
					boolean result = PersistUserManager.resetUserPassword(
							userName, passwordHash);

					if (result) {

						message = "Password changed for user " + userName;
						logger.info(message);

						PersistAuditLog
								.writeMessage(
										userid,
										PersistAuditLog.USER_PASS_CHANGE,
										new Date(),
										UserManager.STATUS_USER_PASSWORD_CHANGED_SUCCESS);

						status.setStatus(Status.STATUS_SUCCESS);
						status.setMessage(message);

					} else {

						message = "unable to change password for user "
								+ userName;
						status.setStatus(Status.STATUS_ERROR);
						status.setMessage(message);

						PersistAuditLog.writeMessage(userid,
								PersistAuditLog.USER_PASS_CHANGE, new Date(),
								UserManager.STATUS_USER_PASSWORD_CHANGED_ERROR);

					}

				} catch (Exception de) {

					PersistAuditLog.writeMessage(userid,
							PersistAuditLog.USER_PASS_CHANGE, new Date(),
							UserManager.STATUS_USER_PASSWORD_CHANGED_ERROR);

					message = "DPM Exception occured";
					logger.error(message, de);
					status.setStatus(Status.STATUS_ERROR);
					status.setMessage(message);

				}
			}
		}
		
		return status;
	}

	public boolean enableUser(String userName) {

		logger.info("enabling user " + userName);
		int userid = getUserId(userName);
		boolean retval = false;

		if (userid == 0) {
			PersistAuditLog.writeMessage(userid, PersistAuditLog.USER_ENABLED,
					new Date(), UserManager.STATUS_USER_ENABLED_ERROR);
		} else {
			retval = PersistUserManager.enableUser(userName);
			if (retval) {
				PersistAuditLog.writeMessage(userid,
						PersistAuditLog.USER_ENABLED, new Date(),
						UserManager.STATUS_USER_ENABLED_SUCCESS);
			} else {
				PersistAuditLog.writeMessage(userid,
						PersistAuditLog.USER_ENABLED, new Date(),
						UserManager.STATUS_USER_ENABLED_ERROR);
			}
		}
		return retval;
	}

	public boolean disableUser(String userName) {
		logger.info("disableUser " + userName);
		return PersistUserManager.disableUser(userName);
	}

	public Status verifyUser(String regtoken) {

		Status status = new Status();
		String message = "";

		logger.info("verifying email information for token=" + regtoken);
		boolean result = PersistUserManager.verifyUser(regtoken);

		if (result) {
			message = UserManager.STATUS_USER_EMAIL_VALIDATION_SUCCESS;
			status.setStatus(Status.STATUS_SUCCESS);
			status.setMessage(message);

		} else {
			message = UserManager.STATUS_USER_EMAIL_VALIDATION_ERROR;
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage(message);
		}
		logger.info(status);
		return status;
	}

	public RegistrationProcessor registerUser(String userName, String userPass,
			String firstName, String lastName, String email,
			String organization, String industry, String howdidyouhear,
			boolean addtomail, boolean contactbyrep, String serverurl,
			String timezone) {

		String message = "";
		RegistrationProcessor rp = new RegistrationProcessor();
		rp.setStatus(RegistrationProcessor.STATUS_WARNING);
		logger.debug("Start register user");

		// TODO need to improve imput validation here.
		if (null == userName || userName == "") {
			message = "Error, username can't be empty";
			rp.setStatus(RegistrationProcessor.STATUS_ERROR);
			rp.setMessage(message);
			logger.debug(message);
			return rp;
		}

		if (null == userPass || userPass == "") {
			message = "Error, password can't be empty";
			rp.setStatus(RegistrationProcessor.STATUS_ERROR);
			rp.setMessage(message);
			logger.debug(message);
			return rp;
		}

		if (null == firstName || firstName == "") {
			message = "Error, first name can't be empty";
			rp.setStatus(RegistrationProcessor.STATUS_ERROR);
			rp.setMessage(message);
			logger.debug(message);
			return rp;
		}

		if (null == lastName || lastName == "") {
			message = "Error, last name can't be empty";
			rp.setStatus(RegistrationProcessor.STATUS_ERROR);
			rp.setMessage(message);
			logger.debug(message);
			return rp;
		}

		if (null == email || email == "") {
			message = "Error, email can't be empty";
			rp.setStatus(RegistrationProcessor.STATUS_ERROR);
			rp.setMessage(message);
			logger.debug(message);
			return rp;
		}

		if (null == serverurl || serverurl == "") {
			message = STATUS_ERROR_DURING_REGISTRATION;
			rp.setStatus(RegistrationProcessor.STATUS_ERROR);
			rp.setMessage(message);
			logger.debug(message);
			return rp;
		}

		try {

			String passwordHash = HashUtil.hashString(userPass);
			String regtoken = HashUtil.getRegistrationToken(userName,
					firstName, lastName);

			int userid = PersistUserManager.registerUser(userName,
					passwordHash, firstName, lastName, email, organization,
					industry, howdidyouhear, addtomail, contactbyrep,
					serverurl, timezone, regtoken);
			logger.info("registeredUser=" + userName + " inserted regtoken="
					+ regtoken);

			logger
					.debug("got the following url from flex (for registration confirmation) "
							+ serverurl);

			logger.info("seinding registration email to " + email);
			MailProxy proxy = new MailProxy();

			StringBuilder body = new StringBuilder();
			body.append("Dear ").append(firstName).append(" ").append(lastName)
					.append(",\n\n").append(MailProxy.REGISRATION_EMAIL_BODY)
					.append("\n").append(serverurl).append("?id=").append(
							regtoken).append("\n\n").append("Regards,").append(
							"\n").append("InCheck registration team.\n\n");

			proxy.sendSimpleEmail("demo@inchecktech.com", email.trim(),
					"Registartion Information", body.toString());

			// Audit it
			PersistAuditLog.writeMessage(userid, PersistAuditLog.NEW_USER_REG,
					new Date(), UserManager.STATUS_USER_REGISTERED_SUCCESS);

			message = UserManager.STATUS_USER_REGISTERED_SUCCESS;
			rp.setStatus(RegistrationProcessor.STATUS_SUCCESS);
			rp.setMessage(message);

			if (userid == 0) {
				message = "Error occured while trying to regester user ";
				rp.setStatus(RegistrationProcessor.STATUS_ERROR);
				rp.setMessage(message);
			}

		} catch (Exception e) {
			message = "Error occured while trying to regester user ";
			rp.setStatus(RegistrationProcessor.STATUS_ERROR);
			rp.setMessage(message);
			logger.error(message, e);
		}

		logger.debug(message);
		logger.debug("end register user");
		return rp;

	}

	public int getUserId(String userName) {

		return PersistUserManager.getUserId(userName);
	}

	public Status createUser(User user) {

		Status status = new Status();
		String message = "";
		logger.info("Creating user " + user);

		// validate user object
		status = validateUser(user);
		if (status.getStatus() == Status.STATUS_ERROR) {
			return status;
		}

		// create user
		try {

			String passwordHash = HashUtil.hashString(user.getPassword());

			String regtoken = HashUtil.getRegistrationToken(user.getUserName(),
					user.getFirstName(), user.getLastName());

			int userId = PersistUserManager
					.createUser(user.getUsername(), passwordHash, user
							.getFirstName(), user.getLastName(), user
							.getEmail(), user.getOrganization(), user
							.getIndustry(), user.getHowdidyouhear(), user
							.isMailist(), user.isContactlist(), regtoken, user
							.isEnabled(), user.isVerified(), user.getTimezone());

			if (userId > 0) {
				logger.info("created user=" + user.getUserName()
						+ " inserted regtoken=" + regtoken);

				// Audit it
				PersistAuditLog.writeMessage(userId,
						PersistAuditLog.NEW_USER_CREATED, new Date(),
						UserManager.STATUS_USER_CREATED_SUCCESS);

				message = UserManager.STATUS_USER_CREATED_SUCCESS;
				status.setStatus(Status.STATUS_SUCCESS);
				status.setMessage(message);
			}

			// update/add user to roles
			if (null != user.getUserroles()) {
				updateUserRoles(user.getUserName(), user.getUserroles());
			}

		} catch (Exception e) {
			message = "Error occured while trying to create user ";
			status.setStatus(RegistrationProcessor.STATUS_ERROR);
			status.setMessage(message);
			logger.error("Exception occured ", e);
		}

		logger.debug("end register user");
		return status;
	}

	public Status validateUser(User user) {
		logger.info("Validating user: " + user);
		Status status = new Status();
		String message = "";

		if (null == user) {
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("user is null");
		}

		String userName = user.getUserName();
		String userPass = user.getPassword();
		String firstName = user.getFirstName();
		String lastName = user.getLastName();
		String email = user.getEmail();

		if (null == userName || userName == "") {
			message = "Error, username can't be empty";
			status.setStatus(RegistrationProcessor.STATUS_ERROR);
			status.setMessage(message);
		}

		if (null == userPass || userPass == "") {
			message = "Error, password can't be empty";
			status.setStatus(RegistrationProcessor.STATUS_ERROR);
			status.setMessage(message);
		}

		if (null == firstName || firstName == "") {
			message = "Error, first name can't be empty";
			status.setStatus(RegistrationProcessor.STATUS_ERROR);
			status.setMessage(message);
		}

		if (null == lastName || lastName == "") {
			message = "Error, last name can't be empty";
			status.setStatus(RegistrationProcessor.STATUS_ERROR);
			status.setMessage(message);
		}

		if (null == email || email == "") {
			message = "Error, email can't be empty";
			status.setStatus(RegistrationProcessor.STATUS_ERROR);
			status.setMessage(message);
		}

		return status;
	}

	public LoginProcessor resetUserPassword(String username) {

		logger.info("resetting password for user " + username);
		LoginProcessor lp = new LoginProcessor();
		lp.setStatus(LoginProcessor.STATUS_WARNING);
		User user = getUser(username);
		boolean r = false;

		if (null != user) {
			logger.debug("generating password for user " + username);
			String clearpass = HashUtil.generateRandomPassword(username);

			try {
				String passwordHash = HashUtil.hashString(clearpass);
				logger.debug("updating db with new password");
				r = PersistUserManager
						.resetUserPassword(username, passwordHash);

			} catch (Exception de) {
				lp.setStatus(LoginProcessor.STATUS_ERROR);
				lp.setMessage(UserManager.STATUS_ERROR_DURING_PASSWORD_RESET);
				logger
						.error(UserManager.STATUS_ERROR_DURING_PASSWORD_RESET,
								de);
			}

			logger.debug("about to email password to user " + username
					+ " to email address " + user.getEmail());

			MailProxy mp = new MailProxy();
			try {
				mp.sendSimpleEmail("demo@inchecktech.com", user.getEmail()
						.trim(), "Password Reset", "Hi " + user.getFirstName()
						+ " \nYour password was changed to " + clearpass);
			} catch (Exception e) {
				lp.setStatus(LoginProcessor.STATUS_ERROR);
				lp.setMessage(UserManager.STATUS_ERROR_DURING_PASSWORD_RESET);
				logger.error(UserManager.STATUS_ERROR_DURING_PASSWORD_RESET, e);
				return lp;
			}

			if (r) {
				logger.debug("writing a message to audit log for tracking");
				PersistAuditLog.writeMessage(user.getUserId(),
						PersistAuditLog.USER_PASS_CHANGE, new Date(),
						"Password changed for user " + user.getUserName());

				lp.setStatus(LoginProcessor.STATUS_SUCCESS);
				lp
						.setMessage("The password was successfully changed.  It will be emailed to your email address.");

				logger.info("password changed for user " + username
						+ " and emaled to " + user.getEmail());
			}

		} else {

			lp.setStatus(LoginProcessor.STATUS_ERROR);
			lp.setMessage(UserManager.STATUS_ERROR_DURING_PASSWORD_RESET);
			logger.error(UserManager.STATUS_ERROR_DURING_PASSWORD_RESET);
			return lp;

		}
		return lp;
	}

	public Status updateUserRoles(String userName, List<UserRole> roles) {
		Status status = new Status();

		// remove user from roles
		status = removeUserFromRoles(userName);

		// add user to roles
		for (UserRole role : roles) {
			status = addUserToRole(userName, role.getRoleName());
		}

		return status;
	}

	public boolean isAllowed(int roleId) {
		
		String uName = sm.getUserNameForSession();
		logger.info("found this user in session table:" + uName);
		
		List<UserRole> rolesForuser = getRolesForUser(uName);
		logger.info("roles for user:" + rolesForuser);
		
		for (UserRole r : rolesForuser) {
			if (r.getRoleId() == roleId) {
				return true;
			}
		}
		
		return false;
	}

	public boolean isAllowed(int[] roleId) {
	
		for (int id: roleId){
			if ( isAllowed(id) == true){
				return true;
			}
		}
		return false;
	}
}
