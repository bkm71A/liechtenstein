package com.inchecktech.dpm.persistence;

import junit.framework.TestCase;

import com.inchecktech.dpm.util.TestUtil;

public class PersistEventDataTest extends TestCase {

	public PersistEventDataTest(String name) {
		super(name);
	}

	protected void setUp() throws Exception {
		super.setUp();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}

	public void testGetEventsThresholds() {
		
	}

	public void testGetEvent() throws Throwable{

		try{
		System.out.println(PersistEventData.getEvent(3, 20));
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

	public void testPersistEvent()throws Exception {
		
		for (int i=0; i < 100; i++){
			System.out.println("Storing event #" + i);
			PersistEventData.persistEvent(TestUtil.getTestEvent(1));
		}
	
	}

	public void testGetEventIntInt() {
	
	}
	

}
