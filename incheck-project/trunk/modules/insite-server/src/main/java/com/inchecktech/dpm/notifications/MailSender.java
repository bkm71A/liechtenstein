package com.inchecktech.dpm.notifications;

import com.inchecktech.dpm.beans.Event;

/**
 * Provide mail notifications functionality
 * @author Administrator
 *
 */
public interface MailSender {

    /**
	 * Send simple mail alarm notifications
	 * @param event - event to fill data to send the notifications
	 */
	void sendAlarmNotification(Event event);
}
