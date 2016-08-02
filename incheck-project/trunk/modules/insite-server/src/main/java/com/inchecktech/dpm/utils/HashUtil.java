package com.inchecktech.dpm.utils;

import java.util.Random;

import org.apache.commons.codec.digest.DigestUtils;

import sun.misc.BASE64Encoder;

public class HashUtil {
	private static Logger logger = new Logger(HashUtil.class);
	
	public static String getRegistrationToken(String username, String firstname, String lastname){
		String tohash = username + firstname + lastname  + getRandom(System.currentTimeMillis());
		return hashString(tohash).replaceAll("\\W", "");
	}
	
	public static double getRandom(long time) {
		Random rnd = new Random();
		double s = rnd.nextDouble()  * time ;
		return s;
	}

	public static String hashString (String string) {
	
		String encoded=null;
		
		try{
			
			byte[] bytes = DigestUtils.sha(string);
			BASE64Encoder encoder = new BASE64Encoder();
			encoded= encoder.encode(bytes);

		}catch(Exception e){
			logger.error("Exception occured while hashing string " , e);
		}
		
		return encoded;
	}
	
	private static String hashString(int integer){
		return hashString(String.valueOf(integer));
	}
	
	public static String getRandomHash(int salt){
		String sessionid=null;
		sessionid = hashString(salt);
		return sessionid;
	}
	
	public static double getRandom(double start, double end) {
		Random rnd = new Random();
		double s = rnd.nextDouble() * end + start;
		return s;
	}
	
	public static int[] getRandom(double start, double end, int size) {
		int[]retval = new int[size]; 
		for (int i =0; i < size; i++){
			Double retnum = getRandom(start, end);
			retval[i]=retnum.intValue();
		}
		return retval;
	}
	
	public static String generateRandomPassword(String username){
		String password = new String("ajFjgl3s");
		password = getRegistrationToken(username, "A", "Z");
		password = password.toLowerCase();
		password = password.replaceAll("\\W", "");
		password= password.subSequence(0, 10).toString();
	
		return password;
	}
}