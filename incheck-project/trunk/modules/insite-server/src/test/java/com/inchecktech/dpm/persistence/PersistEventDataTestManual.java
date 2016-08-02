package com.inchecktech.dpm.persistence;

import com.inchecktech.dpm.util.TestUtil;

public class PersistEventDataTestManual {

	public static void main(String[] args) throws Exception{
		for (int i = 0; i < 100; i++) {
			System.out.println("Storing event #" + i);
			PersistEventData.persistEvent(TestUtil.getTestEvent(1));
		}
	}

}
