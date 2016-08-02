package com.inchecktech.dpm.persistence;

import junit.framework.TestCase;

import com.inchecktech.dpm.util.TestUtil;

public class PersistChannelStateTest extends TestCase {

	public PersistChannelStateTest(String name) {
		super(name);
	}

	protected void setUp() throws Exception {
		super.setUp();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}

	public void testGetAvailDatesForChannelState() {
		
	}

	public void testStoreChannelState() {
		int stateId=0;
		try{
		stateId= PersistChannelState.storeChannelState(TestUtil.getTestChannelState(1), false, "testComment");
		}catch(Exception e){
			e.printStackTrace();
		}
		
		assertNotSame(stateId, 0);
		
	}

	public void testRetrieveChannelState() {
		
	}

	public void testRetrieveChannelStateList() {
	
	}

	

}
