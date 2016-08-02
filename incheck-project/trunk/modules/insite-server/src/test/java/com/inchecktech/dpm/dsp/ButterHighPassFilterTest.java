package com.inchecktech.dpm.dsp;

import java.util.List;
import java.util.Vector;

import junit.framework.TestCase;

public class ButterHighPassFilterTest extends TestCase {
	Filter filter = null;
	
	public ButterHighPassFilterTest(String name) {
		super(name);
	}

	protected void setUp() throws Exception {
		filter = new ButterHighPassFilter();
		super.setUp();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}

	public void testFilter() throws Exception {
		Vector<Double> retVal = new Vector<Double>();
		Double a = new Double(0);
		retVal.add(a);
		
		List<Double> result = filter.filter(getTestVector(), getTestSamplingRate());
		assertEquals(result, retVal);
		
	}
	
	private List<Double> getTestVector(){
		Double a = new Double(12345);
		List<Double> vec = new Vector<Double>();
		vec.add(a);
		return vec;
	}
	
	private int getTestSamplingRate(){
		return 1024;
	}

}
