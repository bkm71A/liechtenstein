package com.inchecktech.dpm.persistence;

import java.util.Date;
import java.util.Timer;

import com.inchecktech.dpm.config.ConfigItem;

import junit.framework.TestCase;

public class PersistDPMConfigTest extends TestCase {

	public PersistDPMConfigTest(String name) {
		super(name);
	}

	protected void setUp() throws Exception {
		super.setUp();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}

	public void testGetTimerValue() {
		Timer timer = new Timer("Systematic-Storing-Channel-State");
		int seconds = PersistDPMConfig.getTimerValue();
		System.out.println("Seconds = "  + seconds);
		timer.scheduleAtFixedRate(new PersistenceTimer(), new Date(), seconds*1000);
		
		assertEquals(seconds, 600);
	}
	
	public void testGetAveragesValue(){
	    ConfigItem item = PersistDPMConfig.getConfigItem("DPMCONFIG", "DPM", PersistDPMConfig.CONFIGURATION_AVERAGES_PARAM);
	    assertNotNull(item);
	    assertTrue(!item.getPropertyValue().equalsIgnoreCase("1"));
	}
	
	public void testUpdateAveragesValue(){
	    ConfigItem item = PersistDPMConfig.getConfigItem("DPMCONFIG", "DPM", PersistDPMConfig.CONFIGURATION_AVERAGES_PARAM);
	    assertNotNull(item);
	    assertNotNull(item.getPropertyValue());
	    String backUpValue = item.getPropertyValue();
	    String newValue = "-1";
	    PersistDPMConfig.updateRunValueOfConfigItem(PersistDPMConfig.CONFIGURATION_AVERAGES_PARAM, newValue, newValue);
	    item = PersistDPMConfig.getConfigItem("DPMCONFIG", "DPM", PersistDPMConfig.CONFIGURATION_AVERAGES_PARAM);
	    assertNotNull(item);
	    assertEquals(newValue, item.getPropertyValue());
	    
	    // set original value back
	    PersistDPMConfig.updateRunValueOfConfigItem(PersistDPMConfig.CONFIGURATION_AVERAGES_PARAM, backUpValue, backUpValue);
	}

}
