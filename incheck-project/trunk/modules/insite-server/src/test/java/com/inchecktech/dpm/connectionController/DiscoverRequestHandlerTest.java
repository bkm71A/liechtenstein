//package com.inchecktech.dpm.connectionController;
//
//import java.net.DatagramPacket;
//import java.net.DatagramSocket;
//import java.net.InetAddress;
//
//import junit.framework.TestCase;
//
//import org.junit.Test;
//
//public class DiscoverRequestHandlerTest extends TestCase {
//
//  private static final String RESPONSE_TEMPLATE = "DISCOVER 1:6:17:4:37:0 DDP/1.0" + DamRequestHeader.CRLF
//      + "From:192.168.1.61:30165" + DamRequestHeader.CRLF + "Message-ID:1 DISCOVER" + DamRequestHeader.CRLF
//      + "Content-Length:0" + DamRequestHeader.CRLF + "" + DamRequestHeader.CRLF;
//  
//  private static final byte[] localHost = {127, 0, 0, 1};
//  private static final int TOTAL_THREADS = 50;
//
//  @Test
//  public final void testDiscoverRequestHandler() throws Exception {
//    DiscoverRequestHandler server = new DiscoverRequestHandler();
//    server.start();
//    final InetAddress address = InetAddress.getByAddress(localHost);
//    Thread clients[] = new Thread[TOTAL_THREADS];
//    for (int j = 0; j < TOTAL_THREADS; j++) {
//      clients[j] = new Thread() {
//        public void run() {
//          DatagramSocket socket;
//          try {
//            socket = new DatagramSocket();
//            DatagramPacket packet = new DatagramPacket(RESPONSE_TEMPLATE.getBytes(), RESPONSE_TEMPLATE.length(),
//                address, DiscoverRequestHandler.DISCOVER_PORT);
//            socket.send(packet);
//            byte[] buf = new byte[256];
//            packet = new DatagramPacket(buf, buf.length);
//            socket.receive(packet);
//            // display response
//            String received = new String(packet.getData(), 0, packet.getLength());
//            String expectedResponse = "DDP/1.0 200 OK" + DamRequestHeader.CRLF + "To:?:?" + DamRequestHeader.CRLF
//                + "From:192.168.1.61:30165" + DamRequestHeader.CRLF + "Message-ID:1 DISCOVER" + DamRequestHeader.CRLF
//                + "Content-Length:0" + DamRequestHeader.CRLF + DamRequestHeader.CRLF;
//            System.out.println("Received: " + received);
//            socket.close();
//            assertTrue(received.startsWith(expectedResponse.substring(0, 16)));
//            assertTrue(received.endsWith(expectedResponse.substring(40)));
//          } catch (Exception e) {
//            assertTrue(false);
//          }
//        }
//      };
//    }
//    for (int j = 0; j < TOTAL_THREADS; j++) {
//      clients[j].start();
//      clients[j].join();
//    }
//    server.setStopListen(true);
//  }
//}
