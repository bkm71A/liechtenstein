package com.inchecktech.dpm.common;

import java.util.List;

import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.beans.UserPreference;
import com.inchecktech.dpm.persistence.PersistUserPreferences;

public class UserPreferenceImpl {

	public static UserPreference getUserPreference(int userId, String key) {
		return PersistUserPreferences.getUserPreference(userId, key);
	}
	
	public static List<UserPreference> getUserPreferences(String key) {
		return PersistUserPreferences.getUserPreferences(key);
	}

	public static List<UserPreference> getUserPreferences(int userId) {
		return PersistUserPreferences.getUserPreferences(userId);
	}

	public static Status setUserPreference(int userId, int preferenceId) {
		return PersistUserPreferences.setUserPreference(userId, preferenceId);
	}

	public static Status unsetUserPreference(int userId, int preferenceId) {
		return PersistUserPreferences.unsetUserPreference(userId, preferenceId);
	}
	
	public static List<UserPreference> getAvailableUserPreferences() {
		return PersistUserPreferences.getAvailableUserPreference();
	}
	
	public static Status createUserPreference(UserPreference preference) {
		return PersistUserPreferences.createUserPreference(preference);
	}
	public static Status updateUserPreference(UserPreference preference) {
		return PersistUserPreferences.updateUserPreference(preference);	
	}
	
	public static Status deleteUserPreference(int preferenceId) {
		return PersistUserPreferences.deleteUserPreference(preferenceId);
	}

}
