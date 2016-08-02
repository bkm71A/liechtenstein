package com.inchecktech.dpm.persistence;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class PersistChannelConfigTest {

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public final void testGetAvailableChannels() {
		List<Integer> chids = PersistChannelConfig.getAvailableChannels();
		System.out.println("getAvailableChannelsChannelIds:");
		for (Integer chid : chids){
			System.out.print(chid + ",");
		}
		System.out.println("\n");
		assertNotNull(chids);
	}

	@Test
	public final void testDeleteChannelConfigValue() {
		//fail("Not yet implemented"); // TODO
	}

	@Test
	public final void testInsertUpdateChannelConfigValue() {
		//fail("Not yet implemented"); // TODO
	}

	@Test
	public final void testDeleteChannelConfig() {
		//fail("Not yet implemented"); // TODO
	}

	@Test
	public final void testUpdateChannelConfig() {
		//fail("Not yet implemented"); // TODO
	}

	@Test
	public final void testCreateChannelConfig() {
		//fail("Not yet implemented"); // TODO
	}

	@Test
	public final void testReadChannelConfig() {
		
		int chid=1000;
		System.out.println("getting values for channel " + chid);
		Map<String, String> config = PersistChannelConfig.readChannelConfig(chid);
		for (String key : config.keySet()){
			System.out.println("key="+ key +", value=" + config.get(key));
		}
		
		assertNotNull(config);
	}
	
	

}
