package com.inchecktech.dpm.tests;

import com.inchecktech.dpm.utils.HashUtil;

public class PasswordUtil {
	
	public static void main(String[] args) throws Exception{
		String passwordHash = HashUtil.hashString("spindle33");
		System.out.println(passwordHash);
	}
}
