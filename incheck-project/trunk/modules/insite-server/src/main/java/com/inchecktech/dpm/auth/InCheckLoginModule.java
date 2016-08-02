package com.inchecktech.dpm.auth;

import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.security.auth.Subject;
import javax.security.auth.callback.Callback;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.callback.NameCallback;
import javax.security.auth.callback.PasswordCallback;
import javax.security.auth.callback.UnsupportedCallbackException;
import javax.security.auth.login.LoginException;
import javax.security.auth.spi.LoginModule;

import com.inchecktech.dpm.beans.LoginProcessor;
import com.inchecktech.dpm.beans.User;
import com.inchecktech.dpm.beans.UserRole;
import com.inchecktech.dpm.common.UserManager;
import com.inchecktech.dpm.common.UserManagerImpl;
import com.inchecktech.dpm.utils.Logger;

public class InCheckLoginModule implements LoginModule {
	private static final Logger logger = new Logger(LoginModule.class);

	private Subject subject;
	private CallbackHandler callbackHandler;
	private Map<String, ?> sharedState;
	private Map<String, ?> options;

	// the authentication status
	private boolean succeeded = true;
	private boolean principalsInSubject;
	private Vector<?> principalsBeforeCommit = new Vector();
	private UserManager um;
	private String userName;
	private char[] password;

	public boolean abort() throws LoginException {
		logger.debug("start abort login");
		if (principalsInSubject) {
			subject.getPrincipals().removeAll(principalsBeforeCommit);
			principalsInSubject = false;
		}
		logger.debug("end abort login");
		return true;

	}

	public boolean commit() throws LoginException {
		logger.debug("start commit login");

		if (!succeeded) {
			userName = null;
			logger.debug("login failed...");
			return false;
		}

		logger.debug("getting roles for user " + userName);
		List<UserRole> roles = um.getRolesForUser(userName);
		assignPrincipal(new User(userName));
		for (UserRole role : roles) {
			logger.debug("assigning role: " + role + " to user " + userName);
			assignPrincipal(role);
		}

		// Clean up internal state
		logger.debug("cleanning up the internal state");
		subject.getPrincipals().removeAll(principalsBeforeCommit);
		principalsInSubject = true;
		userName = null;
		succeeded = true;
		return true;
	}

	private void assignPrincipal(Principal p) {
		if (!subject.getPrincipals().contains(p)) {
			subject.getPrincipals().add(p);
		}
		logger.debug("Assigned principal " + p.getName() + " of type "
				+ p.getClass().getName() + " to user " + userName);
	}

	public void initialize(Subject subject, CallbackHandler callbackHandler,
			Map<String, ?> sharedState, Map<String, ?> options) {

		logger.debug("initialize loginModule");
		this.subject = subject;
		this.callbackHandler = callbackHandler;
		this.sharedState = sharedState;
		this.options = options;
		this.um = new UserManagerImpl();

	}

	public boolean login() throws LoginException {

		logger.debug("start user login");
		if (callbackHandler == null) {
			throw new LoginException("No callback handler is available");
		}

		Callback callbacks[] = new Callback[2];
		callbacks[0] = new NameCallback("username:");
		callbacks[1] = new PasswordCallback("password: ", false);

		try {
			logger.debug("getting username/password");
			callbackHandler.handle(callbacks);
			userName = ((NameCallback) callbacks[0]).getName();
			password = ((PasswordCallback) callbacks[1]).getPassword();

		} catch (java.io.IOException ioe) {
			throw new LoginException(ioe.toString());
		} catch (UnsupportedCallbackException ce) {
			throw new LoginException("Error: " + ce.getCallback().toString());
		}

		LoginProcessor lp = um.processUserLogon(userName, new String(password));
		if (lp.getStatus() == 0) {
			logger.debug(lp.getMessage());
			return true;
		} else {
			logger.debug(lp.getMessage());
			return false;
		}
	}

	public boolean logout() throws LoginException {
		logger.debug("start processing logout");
		um.processUserLogout(userName);
		logger.debug("done processing logout");
		return true;
	}
}