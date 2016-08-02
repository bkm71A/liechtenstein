package com.inchecktech.dpm.alarmEngine;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.Event;
import com.inchecktech.dpm.beans.EventsThresholds;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.OverallLevels;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.persistence.PersistEventData;
import com.inchecktech.dpm.utils.Logger;

public class AlarmEngine {

    private static final Logger                      logger            = new Logger( AlarmEngine.class );
    private final Map<String, OverallAlarmProcessor> overallProcessors = new Hashtable<String, OverallAlarmProcessor>();
    private ICNode                                   node              = null;
	private List<EventsThresholds> eventsThresholds;
	
    public void initAlarmEngine( ICNode chNode )  {
        this.node = chNode;
        try {
            // read from DB alarm rules
            reloadThresholds();
        }
        catch(Exception e ) {
            logger.error( "AlarmEngine.initAlarmEngine(): " + e );
        }
    }

    public void reloadThresholds( )  {
        logger.debug( "in reloadThresholds" );
        eventsThresholds = (List<EventsThresholds>) PersistEventData.getEventsThresholds( node.getChannelid());
        // split list by overall types
        Map<String, List<EventsThresholds>> thresholdsPerOverall = new Hashtable<String, List<EventsThresholds>>();
        for( EventsThresholds threshold : eventsThresholds ) {
            String overall = threshold.getOverall_tr_type();
            List<EventsThresholds> thresholds = thresholdsPerOverall.get( overall );
            if( thresholds == null ) {
                thresholds = new ArrayList<EventsThresholds>();
                thresholdsPerOverall.put( overall, thresholds );
            }
            thresholds.add( threshold );
        }
        // Create OverallAlarmProcessor only for those overall values for which
        // Thresholds entry exist
        for( String overallValue : thresholdsPerOverall.keySet() ) {
            overallProcessors.put( overallValue, new OverallAlarmProcessor( overallValue,
                                                                            thresholdsPerOverall.get( overallValue ) ) );
        }
    }

    // evaluate each processed data set against OverAlls for the given channel
    // from the DSP
    // against the predefined thresholds retrieved from the DB.
    // Issue an Event (Alarm) for each overAll level that exceeds the threshold.

    public void evaluateThresholds( ChannelState chanState ){
        long startAll = System.currentTimeMillis();
		if ((chanState.getPrimaryProcessedData() == null)) {
			return;
		}
        OverallLevels overallLevels = chanState.getPrimaryProcessedData().getOveralls();
        if(overallLevels == null) {
            return;
        }
        try {
            // keys here are: RMS, P2P, etc...
            List<String> overallkeys = overallLevels.getKeys();
            logger.debug( "ALERTSTEST: AlarmEngine: overallLevels.getChannelId()=" + overallLevels.getChannelId()
                          + " ; overallkeys.size()=" + overallkeys.size() );
            // 1. Check if an event already exist for this channel and
            // overallLevels type (overall_tr_type = RMS/P2P..):
            // if overAllValue < threshold then post event(with new severity=0)
            // and clear it from the list.
            for( String overallKey : overallkeys ) {
                OverallAlarmProcessor processor = overallProcessors.get( overallKey );
                if( processor != null ) {
                    processor.evaluateThresholds( overallLevels.getOverall( overallKey ), chanState );
                }
            }
            logger.debug( "ALERTSTEST: AlarmEngine: events size =" + overallProcessors.size());
            List<Event> events = new ArrayList<Event>();
            for( OverallAlarmProcessor processor : overallProcessors.values() ) {
                Event event = processor.getEvent();
                if( event != null ) {
                    events.add( event );
                    logger.debug( "ALERTSTEST: "+ event.toString());
                }
            }
            node.setEvents( events );
        }
        catch(Exception e ) {
            logger.error( "AlarmEngine.evaluateThresholds(): " + e );
        }
        logger.debug( "AlarmEngineTimer WHOLE METHOD " + (System.currentTimeMillis() - startAll) );
    }

    public void setAckedEvent(int eventId) {
        List<Event> events = DataBucket.getEvents(node.getChannelid());
        for (Event event : events) {
            if (eventId == event.getEventId()) {
                event.setAcked(true);
                logger.info("Set acked for " + event.getEventId());
                return;
            }
        }
    }

	public List<EventsThresholds> getEventsThresholds() {
		return eventsThresholds;
	}
}
