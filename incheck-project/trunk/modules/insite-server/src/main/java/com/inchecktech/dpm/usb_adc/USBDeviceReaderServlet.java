package com.inchecktech.dpm.usb_adc;

import java.util.Timer;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;

import com.inchecktech.dpm.utils.Logger;

/**
 * Servlet for reading USB device data
 * 
 */
public class USBDeviceReaderServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {
    private static final long serialVersionUID = 4027300793673100750L;
    private static final Logger logger = new Logger(USBDeviceReaderServlet.class);
    // time in milliseconds to try to restart USB Device Reader
    private static final long rerunPeriod = 5000;
    private final Timer usbDeviceReaderTimer = new Timer("USB Device Reader Timer");

    public void init(ServletConfig config) throws ServletException {
        boolean isWindows = System.getProperty("os.name").toUpperCase().contains("WINDOWS");
        if (isWindows) {
//          Config values are hard-coded for now  
//          ConfigItem item = PersistDPMConfig.getConfigItem("SiteConfig", "USB-Device", "device-name");
            String deviceName = "Master Volume target port";//item.getPropertyValue();
            logger.info(String.format("Starting USBDeviceReaderServlet for device %s",deviceName));
            usbDeviceReaderTimer.scheduleAtFixedRate(new USBDeviceReader(deviceName), 0, rerunPeriod);
            logger.info("USBDeviceReaderServlet started.");
        }
    }
}
