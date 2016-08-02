package com.inchecktech.dpm.utils;

public class PassEncoder {
	public static void main(String[] args) {
		String clear = args[0];
		String passwordHash = HashUtil.hashString(clear);
		System.out.println("Encoded Pass=\"" + passwordHash + "\""
				+ " for clear string=\"" + clear + "\"");
	}
}
