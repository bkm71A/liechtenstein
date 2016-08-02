package com.incheck.ng.network;

import java.net.ServerSocket;
import java.net.Socket;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class DPMServerSocket extends Thread {

    private final Log log = LogFactory.getLog(DPMServerSocket.class);
    private int serverPort;

    public DPMServerSocket(int serverPort) {
        this.serverPort = serverPort;
    }

    @Override
    public void run() {
        try {
            ServerSocket s = new ServerSocket(serverPort);
            Socket clientSocket = null;
            while ((clientSocket = s.accept()) != null) {
                clientSocket.setKeepAlive(true);
                new DPMClientSocketHandler(clientSocket, serverPort, "DPMClientSocketHandler").start();
            }
        } catch (Throwable e) {
            log.fatal(e);
        }
    }
}
