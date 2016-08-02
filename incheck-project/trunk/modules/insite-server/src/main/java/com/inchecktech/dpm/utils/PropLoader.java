package com.inchecktech.dpm.utils;

import java.io.IOException;
import java.net.URL;
import java.util.Properties;

public class PropLoader {
	private static Properties props = null;
	
	private static final Logger logger = new Logger(PropLoader.class);
	
	public static String getProperty(String name) {
	
		if (null == name) {
			throw new IllegalArgumentException("property name can't be null ");
		}

		if (props == null) {
			props = new Properties();
	
			URL url = Thread.currentThread().getContextClassLoader().getResource("db.properties");
			try {
				props.load(url.openStream());
			} catch (IOException e) {
				throw new IllegalArgumentException("Unable to read property file", e);
			}
		}
		
		
		if (null == props.getProperty(name)){
			throw new IllegalArgumentException("Unable to find property by the specified property name " + name);
		}else{
			return props.getProperty(name);
		}
	}
	
	public static Properties loadDbProps(){
		if (props == null) {
			props = new Properties();
	
			URL url = Thread.currentThread().getContextClassLoader().getResource("db.properties");
			try {
				props.load(url.openStream());
			} catch (IOException e) {
				logger.error("Unable to load/find db.properties", e);
			}
			
		}
		return props;
	}
	
	public static int getPropertyAsInt(String name){
		int result=0;
		result = Integer.parseInt(getProperty(name));
		return result;
	}
}