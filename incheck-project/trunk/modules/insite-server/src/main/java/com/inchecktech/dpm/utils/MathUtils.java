package com.inchecktech.dpm.utils;

import java.math.BigDecimal;

public class MathUtils {
	
	public static final double roundValue(double value, Integer precision){
		if (precision == null){
			return value;
		}
		BigDecimal result = new BigDecimal(value);
		result = result.setScale(precision,BigDecimal.ROUND_UP);
		return result.doubleValue(); 
	}

}
