package com.inchecktech.dpm.beans;

import java.io.Serializable;

public class OverallTypes implements Serializable{

	private static final long serialVersionUID = 1L;
	public static final int OVERALL_TYPE_ACCEL_RMS = 1;
	public static final int OVERALL_TYPE_TRUE_PEAK = 2;
	public static final int OVERALL_TYPE_DERIVED_PEAK = 3;
	public static final int OVERALL_TYPE_DERIVED_PEAK_2_PEAK = 4;
	public static final int OVERALL_TYPE_TRUE_PEAK_2_PEAK = 5;
	public static final int OVERALL_TYPE_VEL_PEAK = 6;
	public static final int OVERALL_TYPE_VEL_PEAK_2_PEAK = 7;
	public static final int OVERALL_TYPE_VEL_RMS = 8;
	
	public static int getOverallType(String overallType) {

		if (null != overallType && !overallType.equals("")) {
			if (overallType.equals(OverallLevels.KEY_DERIVED_PEAK)) {
				return OVERALL_TYPE_DERIVED_PEAK;
			} else if (overallType
					.equals(OverallLevels.KEY_DERIVED_PEAK_TO_PEAK)) {
				return OVERALL_TYPE_DERIVED_PEAK_2_PEAK;
			} else if (overallType.equals(OverallLevels.KEY_ACCEL_PEAK)) {
				return OverallTypes.OVERALL_TYPE_TRUE_PEAK;
			} else if (overallType.equals(OverallLevels.KEY_ACCEL_PEAK_TO_PEAK)) {
				return OverallTypes.OVERALL_TYPE_TRUE_PEAK_2_PEAK;
			} else if (overallType.equals(OverallLevels.KEY_VEL_PEAK)) {
				return OverallTypes.OVERALL_TYPE_VEL_PEAK;
			} else if (overallType.equals(OverallLevels.KEY_VEL_PEAK_TO_PEAK)) {
				return OverallTypes.OVERALL_TYPE_VEL_PEAK_2_PEAK;
			} else if (overallType.equals(OverallLevels.KEY_VEL_RMS)) {
				return OverallTypes.OVERALL_TYPE_VEL_RMS;
			}
		}

		return OVERALL_TYPE_ACCEL_RMS;
	}

	public static String getOverallType(int overallType) {

		if (overallType == OVERALL_TYPE_TRUE_PEAK) {
			return OverallLevels.KEY_ACCEL_PEAK;
		} else if (overallType == OVERALL_TYPE_DERIVED_PEAK) {
			return OverallLevels.KEY_DERIVED_PEAK;
		} else if (overallType == OVERALL_TYPE_DERIVED_PEAK_2_PEAK) {
			return OverallLevels.KEY_DERIVED_PEAK_TO_PEAK;
		} else if (overallType == OVERALL_TYPE_TRUE_PEAK_2_PEAK) {
			return OverallLevels.KEY_ACCEL_PEAK_TO_PEAK;
		} else if (overallType == OVERALL_TYPE_VEL_PEAK) {
			return OverallLevels.KEY_VEL_PEAK;
		} else if (overallType == OVERALL_TYPE_VEL_PEAK_2_PEAK) {
			return OverallLevels.KEY_VEL_PEAK_TO_PEAK;
		} else if (overallType == OVERALL_TYPE_VEL_RMS) {
			return OverallLevels.KEY_VEL_RMS;
		}

		return OverallLevels.KEY_ACCEL_RMS;
	}

}
