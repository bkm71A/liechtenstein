/**
 * 
 */
package com.inchecktech.dpm.flex;

import junit.framework.TestCase;

import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.beans.UserPreference;

/**
 * @author Yury Kiulo
 * 
 */
public class DPMFlexProxyTest extends TestCase {

    public void testGetUserPreferences() {
	int userId = 5;
	UserPreference preference = DPMFlexProxy.getUserPreference(userId, userId + UserPreference.ACCELERATION_AVERAGE_KEY_PREFIX);
	assertNotNull(preference);
	assertNotNull(preference.getKey());
    }
    
    public void testSetUserPreferences() {
	int userId = 5;
	// test case to save correct value
	Status result = DPMFlexProxy.setUserPreference(userId, UserPreference.ACCELERATION_AVERAGE_KEY_PREFIX, "10");
	assertNotNull(result);
	assertEquals(0, result.getStatus());
	
	// test case to set incorrect value
	result = DPMFlexProxy.setUserPreference(userId, UserPreference.ACCELERATION_AVERAGE_KEY_PREFIX, "s7g72bf");
	assertNull(result);
    }
}
