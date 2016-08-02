package com.inchecktech.dpm.alarmEngine;

import java.util.Date;
import java.util.List;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.Event;
import com.inchecktech.dpm.beans.EventsThresholds;
import com.inchecktech.dpm.dsp.DSPConstants;
import com.inchecktech.dpm.engine.DPMEngine;
import com.inchecktech.dpm.notifications.MailSender;
import com.inchecktech.dpm.notifications.MailSenderImpl;
import com.inchecktech.dpm.persistence.PersistEventData;
import com.inchecktech.dpm.utils.Logger;

public class OverallAlarmProcessor {
	private static final Logger logger = new Logger(OverallAlarmProcessor.class);

	// Event thresholds for this overall key and the given channel
	private List<EventsThresholds> eventsThresholds;

	// Any event generated during calculations
	private Event event;
//	private ICNode                                   node              = null;
	// Smothing algorithm used for comparison
//	private EwmaMovingAverage smothingAlgorithm = new EwmaMovingAverage();

	/* Mail notifications sender */
	private MailSender mailSender;

	/* Contains previous alarms list. Key - is a channel id, value - is an last alarm event for the channel */
	//private Map<Integer, Event> previousAlarms;
	
	/* E-mail notifications interval in seconds*/
	private Long notificationInterval;
	
	/* Time of previous alarm */
	private Long previousAlarmTime;
	
	public enum change_type {
		no_alarm, same_alarm, gone_down, gone_up
	};

	/**
	 * Overall Alarm Processor
	 * @param overallKey
	 */
	public OverallAlarmProcessor(final String overallKey,
			List<EventsThresholds> eventsThresholds) {
		this.eventsThresholds = eventsThresholds;
		this.mailSender = new MailSenderImpl();
		initializeNotification();
	}

	/*
	 * Initialize alarm notifications time interval value
	 */
	private void initializeNotification() {
	    initializeTimeInterval();
	    initializePreviousAlarmTime();
    }
	
	/*
	 * Initialize alarm notifications time interval from properties file.
	 * If the parameter doesn't exist in the properties file - don't use it in work.
	 */
	private void initializeTimeInterval() {
        ResourceBundle res = ResourceBundle.getBundle(DSPConstants.CONFIG_FILE_NAME);
        try {
            /*
            this.notificationInterval = Long.parseLong(res
                    .getString(DSPConstants.MAIL_ALARM_NOTIFICATION_TIME_INTERVAL));
                    */
            this.notificationInterval = DPMEngine.mailTimeInterval;
        } catch (NumberFormatException exc) {
            logger
                    .error(
                            "mail.alarm.period.seconds parsing error. please adjust the parameter in dmp_mail.properties ",
                            exc);
            this.notificationInterval = -1l;
        } catch (MissingResourceException exc) {
            logger.error("dpm_mail.properties doesn't contains mail.alarm.period.seconds", exc);
            this.notificationInterval = -1l;
        }
    }

	/*
     * Previous alarm time initialization. Default is 0.
     */
    private void initializePreviousAlarmTime() {
        this.previousAlarmTime = 0L;
    }
	
	public void evaluateThresholds(Double overAllValue, ChannelState chanState)	{
		//smothingAlgorithm.setNext(overAllValue);
		//double avgValue = smothingAlgorithm.getWeightedMovingAverage();
		/*if (Double.isNaN(avgValue) || eventsThresholds.size() == 0) {
			return;
		}*/
		
		double avgValue=overAllValue;
		// retrieve the OverallLevels that contains the thresholds for
		// the given
		// getProcessedData (each channel can contain multiple sets...and we want retrieve the set that the user picked)
		Event newEvent = null;
		for (EventsThresholds evThresholds : eventsThresholds) {
			// loop thru all available severities and
			// compare in descending order from highest
			// to lowest

			// 2.1 Check (and add the Event) if the
			// threshold has been crossed
			// logger.debug("ALRM : "+avgValue+" "+evThresholds.getEvent_tr_upper_bound()+" "+)
			if (avgValue <= evThresholds.getEvent_tr_lower_bound() || avgValue>=evThresholds.getEvent_tr_upper_bound()) {
				newEvent = new Event(evThresholds.getEvent_tr_id(),
						evThresholds.getChannel_id(), evThresholds.getChannel_location(), evThresholds
								.getOverall_tr_type(), evThresholds
								.getSeverity(), evThresholds.getDescription(),
						evThresholds.getLongdescription(), System
								.currentTimeMillis(), overAllValue,
						evThresholds.getEvent_tr_lower_bound(),evThresholds.getEvent_tr_upper_bound(), chanState, avgValue);
				logger.debug("AlarmProcessor , threshold crossed. Event = " + newEvent);
				break;
			}
		}
		change_type changeType = change_type.no_alarm;
		if (event == null && newEvent == null) {
			changeType = change_type.no_alarm;
		}
		if (event == null && newEvent != null) {
			changeType = change_type.gone_up;
		}
		if (event != null && newEvent == null) {
			changeType = change_type.gone_down;
		}
		if (event != null && newEvent != null) {
			if (event.getSeverity() == newEvent.getSeverity()) {
				changeType = change_type.same_alarm;
			} else {
				changeType = event.getSeverity() > newEvent.getSeverity() ? change_type.gone_down
						: change_type.gone_up;
			}
		}
        if (changeType == change_type.gone_up
				|| changeType == change_type.gone_down) {
            event = newEvent;
		    PersistEventData.persistEvent(event);
		}
		
		/* check e-mail notifications send criteria to send the notification */
        processMailNotification((change_type.same_alarm == changeType));
	}

	/*
     * Check e-mail notification for the alarm type and time period. If - a new type alarm occurred - send the
     * notification. If - a previous type alarm occurred - check time interval from dpm_mail.properties
     */
    private void processMailNotification(boolean sameType) {
        if (event == null) {
            logger.error("Alarm notification will not be sent, the event is null!\n");
            return;
        }

        // event has been acknowledged, don't need to send email 
        if (event.isAcked()) {
            logger.info("Event is acked, don't send notification " + event.getEventId());
            return;
        }

        // if the alarm time doesn't is zero - send the notification and
        // register the the alarm time in the variable
        if (this.previousAlarmTime == 0) {
            this.previousAlarmTime = event.getTimeSatmp();
            this.mailSender.sendAlarmNotification(event);
        } else {
            // check the alarm type
            if (sameType) {
                 /*
                     * an alarm has been occurred for the channel - check the time interval. If the alarm came after the
                     * time interval - send the e-mail notification
                     */
                if (this.notificationInterval > 0) {
                    if ((this.notificationInterval * 1000) < ((new Date()).getTime() - this.previousAlarmTime)) {
                        this.mailSender.sendAlarmNotification(event);
                        this.previousAlarmTime = event.getTimeSatmp();
                    }
                } else {
                    // wrong time interval parameter - don't use it in work.
                    this.mailSender.sendAlarmNotification(event);
                }
            } else {
                // a new alarm type occurred. Send the notification and reset
                // notification interval
                this.mailSender.sendAlarmNotification(event);
                this.previousAlarmTime = event.getTimeSatmp();
            }
        }

    }
	
	/**
	 * Get an event
	 * 
	 * @return the event
	 */
	public Event getEvent() {
		return event;
	}

    /**
	 * Get value of mailSender
	 * 
	 * @return value of the mailSender
	 */
    public MailSender getMailSender() {
        return mailSender;
    }

    /**
     * Set a new value for mailSender
     * @param mailSender the mailSender to set
     */
    public void setMailSender(MailSender mailSender) {
        this.mailSender = mailSender;
    }

    /**
     * Get value of notificationInterval
     * @return value of the notificationInterval
     */
    public Long getNotificationInterval() {
        return notificationInterval;
    }

    /**
     * Set a new value for notificationInterval
     * @param notificationInterval the notificationInterval to set
     */
    public void setNotificationInterval(Long notificationInterval) {
        this.notificationInterval = notificationInterval;
    }

    /**
     * Get value of previousAlarmTime
     * @return value of the previousAlarmTime
     */
    public Long getPreviousAlarmTime() {
        return previousAlarmTime;
    }

    /**
     * Set a new value for previousAlarmTime
     * @param previousAlarmTime the previousAlarmTime to set
     */
    public void setPreviousAlarmTime(Long previousAlarmTime) {
        this.previousAlarmTime = previousAlarmTime;
    }
}
