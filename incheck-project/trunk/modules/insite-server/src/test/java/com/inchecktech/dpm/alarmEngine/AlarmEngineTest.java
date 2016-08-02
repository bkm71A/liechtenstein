package com.inchecktech.dpm.alarmEngine;

import junit.framework.TestCase;

import org.junit.Test;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.util.TestUtil;

public class AlarmEngineTest extends TestCase {

	public static final int ChID = 3;

	@Test	
	public void testAlarmEng1() throws Exception {
		AlarmEngine alarmEngine = DataBucket.getAlarmEngine(ChID);
		ICNode node = TestUtil.getNode(ChID);
		ChannelState st = TestUtil.getTestChannelState(ChID);
		if (alarmEngine == null) {
			alarmEngine = new AlarmEngine();
			System.out.println("PASSING NODE " + node + " to ALARM ENGINE INIT METHOD");
			alarmEngine.initAlarmEngine(node);
			DataBucket.addOrReplaceAlarmEngine(ChID, alarmEngine);
		}
		System.out.println("st=" + st);
		System.out.println("st.getPrimaryProcessedData=" + st.getPrimaryProcessedData());
		alarmEngine.evaluateThresholds(st);
		alarmEngine.evaluateThresholds(st);
		//node.setEvents(alarmEngine.getEvents());
		assertNotNull(alarmEngine);
		assertNotNull(node);
		assertNotNull(st);
	}

	public AlarmEngineTest(String name) {
		super(name);
	}

	public void testInitAlarmEngine() {
	}

	public void testEvaluateThresholds() {
	}

	public void testGetEvents() {
	}

	public void testClearAllEvents() {
	}
}
