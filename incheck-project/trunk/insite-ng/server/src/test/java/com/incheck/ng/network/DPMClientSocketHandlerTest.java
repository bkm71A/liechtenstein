package com.incheck.ng.network;

import static com.incheck.ng.network.DPMClientSocketHandler.CRLF;
import static com.incheck.ng.network.DPMClientSocketHandler.DAMMessageType.REGISTER;
import static junit.framework.Assert.assertTrue;
import static junit.framework.Assert.fail;
import java.io.BufferedWriter;
import java.io.DataInputStream;
import java.io.OutputStreamWriter;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;

import org.junit.Test;

import com.incheck.ng.test.AbstractSpringTestContextEnabledIntegrationTestSupport;
import com.incheck.ng.test.TestConstants;
import com.incheck.ng.test.TestDataDefinition;

@TestDataDefinition(dataSetDTD = "test-data/data_channel.dtd", dataSetXML = "test-data/data_channel.xml")
public class DPMClientSocketHandlerTest extends AbstractSpringTestContextEnabledIntegrationTestSupport {
    private final int SERVER_PORT = 54321;
    private final int SOCKET_BUFFER_SIZE = 8192;
    private final static String REGISTER_REQUEST_MESSAGE =
            REGISTER.toString() + " " 
            + TestConstants.DAM_SERIAL_NUMBER + " DDP/1.0" + CRLF
            + "To:192.168.1.11:23181" + CRLF 
            + "From:192.168.1.11:54645+" + CRLF 
            + "Message-ID:1 " + REGISTER.toString() + CRLF
            + "Content-Length:0" + CRLF + CRLF;
    private final static String REGISTER_RESPONSE_START = "DDP/1.0 200 OK";
    private final static String REGISTER_RESPONSE_PARTS[] = { "UPDATE ", " DDP/1.0", "Content-Type:config" };
    private final static byte DATA_ARRAY[] = {68, 65, 84, 65, 32, 53, 32, 68, 68, 80, 47, 49, 46, 48, 13, 10, 77, 101, 115, 115, 97, 103, 101, 45, 73, 68, 58, 50, 13, 10, 83, 97, 109, 112, 108, 105, 110, 103, 45, 82, 97, 116, 101, 58, 53, 49, 50, 48, 13, 10, 83, 97, 109, 112, 108, 101, 115, 58, 49, 50, 56, 13, 10, 67, 104, 97, 110, 110, 101, 108, 45, 73, 68, 58, 51, 13, 10, 67, 111, 110, 116, 101, 110, 116, 45, 84, 121, 112, 101, 58, 115, 97, 109, 112, 108, 101, 115, 13, 10, 67, 111, 110, 116, 101, 110, 116, 45, 76, 101, 110, 103, 116, 104, 58, 50, 53, 54, 13, 10, 76, 97, 115, 116, 45, 77, 101, 115, 115, 97, 103, 101, 58, 116, 114, 117, 101, 13, 10, 84, 105, 109, 101, 45, 83, 116, 97, 109, 112, 58, 49, 50, 48, 57, 56, 54, 54, 53, 54, 54, 13, 10, 84, 105, 109, 101, 45, 79, 102, 102, 115, 101, 116, 58, 49, 48, 57, 49, 54, 13, 10, 67, 83, 101, 113, 58, 49, 13, 10, 13, 10};
    private final static String DATA_MESSAGE = "DATA 5 DDP/1.0" + CRLF
            + "Message-ID:2" + CRLF
            + "Sampling-Rate:2560" + CRLF
            + "Samples:8192" + CRLF
            + "Channel-ID:1" + CRLF
            + "Content-Type:samples" + CRLF
            + "Content-Length:" + DATA_ARRAY.length + CRLF
            + "Last-Message:true" + CRLF
            + "Time-Stamp:1209866566" + CRLF
            + "Time-Offset:60057" + CRLF
            + "CSeq:1" + CRLF + CRLF;
    private DPMClientSocketHandler clientSocketHandler;

    @Test
    public void testDPMServerSocket() throws Exception {
        Socket clientSocket = null;
        new Thread(new Runnable(){
            @Override
            public void run() {
                try {
                    runClientSocket();
                } catch (Exception e) {
                    fail(e.toString());
                }
            }}).start();
        if ((clientSocket = new ServerSocket(SERVER_PORT).accept()) != null) {
            clientSocket.setKeepAlive(true);
            clientSocketHandler = new DPMClientSocketHandler(clientSocket, SERVER_PORT, "DPMClientSocketHandler");
            clientSocketHandler.run();
        }        
    }

    private void runClientSocket() throws Exception{
        Thread.sleep(300);
        Socket clientSocket = new Socket();
        clientSocket.setReceiveBufferSize(SOCKET_BUFFER_SIZE);
        clientSocket.setSendBufferSize(SOCKET_BUFFER_SIZE);
        clientSocket.connect(new InetSocketAddress("127.0.0.1", SERVER_PORT));
        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(clientSocket.getOutputStream()));
        DataInputStream dis = new DataInputStream(clientSocket.getInputStream());
        testRegisterMessage(clientSocket, bw, dis);
        clientSocketHandler.setShouldRun(false);
        testDataMessage(clientSocket, bw, dis);
    }
    
    private void testRegisterMessage(Socket clientSocket, BufferedWriter bw, DataInputStream dis) throws Exception {
        bw.write(REGISTER_REQUEST_MESSAGE);
        bw.flush();
        byte bbuf[] = new byte[190];
        dis.readFully(bbuf);
        String response = new String(bbuf);
        assertTrue(response.startsWith(REGISTER_RESPONSE_START));
        assertTrue(response.indexOf(REGISTER.toString()) > 1);
        for (String msgPart : REGISTER_RESPONSE_PARTS) {
            assertTrue(response.indexOf(msgPart) > 1);
        }
    }

    private void testDataMessage(Socket clientSocket, BufferedWriter bw, DataInputStream dis) throws Exception {
        bw.write(DATA_MESSAGE);
        bw.write(new String(DATA_ARRAY));
        bw.flush();
    }
}
