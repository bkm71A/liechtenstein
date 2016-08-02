package com.inchecktech.dpm.utils;

import java.net.URL;

import org.apache.log4j.Level;
import org.apache.log4j.helpers.Loader;
import org.apache.log4j.xml.DOMConfigurator;

public class Logger {

	private static final String WRAPPER_FQCN = Logger.class.getName();
	public static final int OFF = 0x7fffffff;
	public static final int FATAL = 50000;
	public static final int ERROR = 40000;
	public static final int WARN = 30000;
	public static final int INFO = 20000;
	public static final int DEBUG = 10000;
	public static final int TRACE = 5000;
	public static final int ALL = 0x80000000;
	private org.apache.log4j.Logger log4jLogger=null;
	private org.apache.log4j.Logger sysMonLogger=null;
	
    public Logger(String name) {
        log4jLogger = org.apache.log4j.Logger.getLogger(name);
		log4jLogger.setLevel(Level.INFO);
    }
    

	public Logger(Class<?> clazz) {
		log4jLogger = null;
		sysMonLogger = null;
		log4jLogger = org.apache.log4j.Logger.getLogger(clazz);
		log4jLogger.setLevel(Level.INFO);
	}

	public static void init() {
		URL url = Loader.getResource("log4j.xml");
		DOMConfigurator.configure(url);
	}

	public void fatal(Object message) {
		log4jLogger.log(WRAPPER_FQCN, Level.FATAL, message, null);
	}

	public void fatal(Object message, Throwable t) {
		log4jLogger.log(WRAPPER_FQCN, Level.FATAL, message, t);
	}

	public void error(Object message) {
		log4jLogger.log(WRAPPER_FQCN, Level.ERROR, message, null);
	}

	public void error(Object message, Throwable t) {
		log4jLogger.log(WRAPPER_FQCN, Level.ERROR, message, t);
	}

	public void warn(Object message) {
		log4jLogger.log(WRAPPER_FQCN, Level.WARN, message, null);
	}

	public void warn(Object message, Throwable t) {
		log4jLogger.log(WRAPPER_FQCN, Level.WARN, message, t);
	}

	public void info(Object message) {
		log4jLogger.log(WRAPPER_FQCN, Level.INFO, message, null);
	}

	public void info(Object message, Throwable t) {
		log4jLogger.log(WRAPPER_FQCN, Level.INFO, message, t);
	}

	public void debug(Object message) {
		log4jLogger.log(WRAPPER_FQCN, Level.DEBUG, message, null);
	}

	public void debug(Object message, Throwable t) {
		log4jLogger.log(WRAPPER_FQCN, Level.DEBUG, message, t);
	}

	public void trace(Object message) {
		log4jLogger.log(WRAPPER_FQCN, Level.TRACE, message, null);
	}

	public void trace(Object message, Throwable t) {
		log4jLogger.log(WRAPPER_FQCN, Level.TRACE, message, t);
	}

	public boolean isFatalEnabled() {
		return log4jLogger.isEnabledFor(Level.FATAL);
	}

	public boolean isErrorEnabled() {
		return log4jLogger.isEnabledFor(Level.ERROR);
	}

	public boolean isWarnEnabled() {
		return log4jLogger.isEnabledFor(Level.WARN);
	}

	public boolean isInfoEnabled() {
		return log4jLogger.isInfoEnabled();
	}

	public boolean isDebugEnabled() {
		return log4jLogger.isDebugEnabled();
	}

	public boolean isTraceEnabled() {
		return log4jLogger.isTraceEnabled();
	}

	public void alert(String msg) {
		ensureSysMonLogger();
		sysMonLogger.fatal(msg);
		log4jLogger.fatal((new StringBuilder()).append(
				"SYSTEM MONITORING ALERT has been raised:\n").append(msg)
				.toString());
	}

	public void alert(String msg, Throwable t) {
		ensureSysMonLogger();
		sysMonLogger.fatal(msg, t);
		log4jLogger.fatal((new StringBuilder()).append(
				"SYSTEM MONITORING ALERT has been raised:\n").append(msg)
				.toString(), t);
	}

	private void ensureSysMonLogger() {
		if (sysMonLogger == null)
			sysMonLogger = org.apache.log4j.Logger
					.getLogger("|SYSTEM_MONITORING|");
	}

}