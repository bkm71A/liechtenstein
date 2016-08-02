package com.slava.test.incheck;

 

import java.net.DatagramPacket;

import java.net.DatagramSocket;

import java.net.InetAddress;

 

public class DatagramTest

{

      public static void main(String[] args) throws Exception

      {

            DatagramSocket socket;

            DatagramPacket packet;

            InetAddress address;

            byte[] message = new byte[256];

            int port = 13;

 

            //

            // Send empty request

            //

            socket = new DatagramSocket();

            address = InetAddress.getByName("moria.sdsu.edu");

            packet = new DatagramPacket(message, message.length, address, port);

            socket.send(packet);

 

            //

            // Receive reply and print

            //

            packet = new DatagramPacket(message, message.length);

            socket.receive(packet);

            String received = new String(packet.getData(), 0);

            System.out.println("Received: " + received);

            socket.close();

      }

      //http://www.javafaq.nu/java-example-code-668.html

      //http://www.javafaq.nu/java-example-code-653.html

      /*

       *  InetAddress host = InetAddress.getByName ( "http://www.kickjava.com" ) ; 

 int port = 27015; 

  

  

 // data that you want sent to the host 

 byte buf [  ]  = new byte [ 1024 ] ; 

 DatagramPacket packet = new DatagramPacket ( buf,buf.length,host,port ) ; 

  

  

 // your UDP socket that will send the packet 

 DatagramSocket udp = new DatagramSocket (  ) ; 

  

  

 // send the packet to the host  ( throws IOException )  

 upd.send ( packet ) ;

       */

 

}

 

