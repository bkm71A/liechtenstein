package com.inchecktech.dpm.notifications;

import java.util.List;
import java.util.TimerTask;

import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.persistence.PersistNotifications;
import com.inchecktech.dpm.utils.Logger;

public class EventMailer extends TimerTask {
	private static Logger logger = new Logger(EventMailer.class);
	MailProxy proxy = new MailProxy();

	private static Status updateEventNotifStatus(EmailNotification notification) {
		Status status = PersistNotifications.updateNotifStatus(notification);
		return status;
	}

	public static Status sendEvent() {
		Status status = new Status();
		status.setMessage("");
		status.setStatus(Status.STATUS_WARNING);
		String[] to;

		// read all current notifications
		logger.debug("Starting to look for new notifications");
		List<EmailNotification> notifications = PersistNotifications
				.getNotifications();

		// send an email

		if (null != notifications && notifications.size() != 0) {
			for (EmailNotification notif : notifications) {
				StringBuilder subject = new StringBuilder("Alert level ");
				subject.append(notif.getNewSeverity());
				subject.append(" at ");
				subject.append(notif.getLocation());
				try {
//					StringTokenizer st = new StringTokenizer(notif
//							.getToAddress(), ",");
//					int i = 0;
//					to = new String[st.countTokens()];
//					while (st.hasMoreElements()) {
//						to[i] = st.nextToken();
//						i++;
//					}
                    to = getAddresses(notif.getToAddress());
					MailProxy.getInstance().sendSimpleEmail(
							notif.getFromName(), to,
							subject.toString(), notif.getMessageValue());
					status = updateEventNotifStatus(notif);
				} catch (Exception e) {
					String message = "An error occured while trying to send an email ";
					logger.error(message, e);

					status.setMessage(message);
					status.setStatus(Status.STATUS_ERROR);
				}
			}
		}
		return status;
	}

    private static String[] getAddresses(String to) {
        String [] toArr = to.split(",");
        return toArr;
    }

	@Override
	public void run() {

		Status status = sendEvent();
		if (null != status) {
			if (status.getStatus() != Status.STATUS_WARNING) {
				logger.debug(status);
			}
		}
	}
}
