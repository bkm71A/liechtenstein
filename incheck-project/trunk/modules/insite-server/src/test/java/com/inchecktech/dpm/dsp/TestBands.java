package com.inchecktech.dpm.dsp;

import java.util.ArrayList;
import java.util.List;

import com.inchecktech.dpm.beans.Band;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.ProcessedDynamicData;

public class TestBands {
	public static void main(String[] args) {
		BandCalculator c = new BandCalculator();
		ProcessedData processedData = new ProcessedDynamicData(1);
		List<Double> data = new ArrayList<Double>();
		data.add(-2d);
		data.add(-52d);
		data.add(-2d);
		data.add(-6d);
		data.add(-2d);
		data.add(-252d);
		data.add(-225d);
		data.add(-21d);
		Band b = new Band();
		b.setActive(true);
		b.setBandId(1);
		b.setBandName("test1");
		b.setStartFreq(2d);
		b.setEndFreq(225d);
		
		System.out.println(c.getBandOveralls(processedData));
	}
}
