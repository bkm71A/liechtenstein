package com.inchecktech.dpm.network;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.Map;

import com.inchecktech.dpm.beans.Device;
import com.inchecktech.exception.DPMClientSocketException;

/**
 * Manage client sockets
 * 
 * @author
 * 
 */
public interface DPMClientSocketHandlerHelper {

	Device getDevice(byte headerArray[], Socket socket) throws IOException;
	
	void processRegisterMessage(Map<Integer, Integer> deviceChannelMap,
			DataOutputStream dout, Device device, Socket socket) throws DPMClientSocketException,
			IOException;

	void processDataMessage(byte headerArray[], DataInputStream din, Map<Integer, Integer> deviceChannelMap)
			throws DPMClientSocketException, IOException;
}