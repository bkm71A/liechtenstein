package com.inchecktech.dpm.notifications;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.MissingResourceException;
import java.util.ResourceBundle;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.inchecktech.dpm.beans.Event;
import com.inchecktech.dpm.dsp.DSPConstants;
import com.inchecktech.dpm.persistence.PersistUserPreferences;
import com.inchecktech.dpm.utils.Logger;
import com.inchecktech.dpm.utils.MathUtils;

/**
 * Implementation of <code>MailSender</code>
 * 
 * @author Administrator
 * 
 */
public class MailSenderImpl implements MailSender {

    /* Logger */
    private static final Logger LOGGER = new Logger(MailSenderImpl.class);

    /**
     * @see com.inchecktech.dpm.notifications.MailSender#sendAlarmNotification(com.inchecktech.dpm.beans.Event)
     */
    public void sendAlarmNotification(Event event) {
        try {
            ResourceBundle res = ResourceBundle.getBundle(DSPConstants.CONFIG_FILE_NAME);
            String from = res.getString(DSPConstants.MAIL_ALARM_ADDRESS_FROM);
            String to = res.getString(DSPConstants.MAIL_ALARM_ADDRESS_TO);
            String subject = res.getString(DSPConstants.MAIL_ALARM_SUBJECT);
            String datePattern = res.getString(DSPConstants.ALERT_DATE_PATTERN);
            if (isEmailParametersValid(from, to)) {
                MailProxy.getInstance().sendSimpleEmail(from, to, subject, getMailBody(event, datePattern));
            } else {
                LOGGER.error(res.getString(DSPConstants.MAIL_ALARM_VALIDATION_ERROR_MESSAGE));
            }
        } catch (MissingResourceException exc) {
            LOGGER.error("dpm_mail.properties doesn't contains e-mail parameters", exc);
        } catch (Exception exc) {
            LOGGER.error("Can not send e-mail alarm notification", exc);
        }
    }

    /*
     * Validate e-mail address @param emailAddress - address to validate @return <code>true</code> in case of valid
     * address, otherwise <code>false</code>.
     */
    private boolean isEmailAddressValid(String emailAddress) {
        boolean result = false;
        if (emailAddress != null) {
            Pattern emailPattern = Pattern.compile(".+@.+\\.[a-z]+");
            Matcher matcher = emailPattern.matcher(emailAddress);
            result = matcher.matches();
        }

        return result;
    }

    /*
     * Check email parameters @param emailFrom - email address 'from', to check @param emailTo - email address 'to', to
     * check @return <code>true</code> in case of valid parameters, otherwise <code>false</code>.
     */
    private boolean isEmailParametersValid(String emailFrom, String emailTo) {
        return (isEmailAddressValid(emailFrom) && isEmailAddressValid(emailTo));
    }

    /*
     * Get body of alert mail notification @param event - incoming data @return the mail notification body string
     */
    private String getMailBody(Event event, String datePattern) { 
        StringBuffer sb = new StringBuffer();
        if (event != null) {
        	sb.append(event.getChannelLocation()).append("\n");
        	sb.append("Alert Date: ").append(new SimpleDateFormat(datePattern).format(new Date(event.getTimeSatmp()))).append("\n");
        	sb.append("Description: ").append(event.getDecs()).append("\n");
        	sb.append("Severity: ").append(event.getSeverity() + (event.getSeverity()==2 ? " is Alarm" :  (event.getSeverity()==1 ? " is Warning" : ""))).append("\n");
        	sb.append("Alarm Value: ").append(MathUtils.roundValue(event.getEventValue(), PersistUserPreferences.getMinDisplayedPrecision())).append("\n");
        	sb.append("Threshold  Type: ").append(event.getOverall_tr_type() != null ? event.getOverall_tr_type().replace("_", " ") : "").append("\n");
        	sb.append("Threshold: ").append(event.getThreshold_tr_value()).append(" (g)\n");
        	sb.append("\n\nThis alert will repeat periodically until acknowledged or triggering parameter returns back to normal value.");
        }
        return (sb.length() > 0) ? sb.toString() : "Can not create body of the notification... Incoming object wrong.";
    }
}
