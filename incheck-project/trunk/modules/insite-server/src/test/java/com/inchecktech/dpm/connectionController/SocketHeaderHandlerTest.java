//package com.inchecktech.dpm.connectionController;
//
//import java.io.DataInputStream;
//import java.io.InputStream;
//import java.util.List;
//
//import junit.framework.TestCase;
//
//import org.junit.Test;
//
//import com.inchecktech.dpm.connectionController.DataRequestHandler.DataPair;
//
//public class SocketHeaderHandlerTest extends TestCase {
//
//  private final static String REQUEST_FILES[] = {"short_data.bin", "discover.bin", "long_data.bin", "register.bin"};
//
//  @Test
//  public final void testHeaderParsing() throws Exception {
//    for (String dataFile : REQUEST_FILES) {
//      parseRequestType(dataFile);
//    }
//  }
//
//  private void parseRequestType(String resourceName) throws Exception {
//    InputStream is = this.getClass().getResourceAsStream(resourceName);
//    DataInputStream dis = new DataInputStream(is);
//    DamRequestHeader header = SocketHeaderHandler.parseHeader(dis);
//    if (header instanceof DataRequestHeader) {
//      List<DataPair> parsedData = DataRequestHandler.process((DataRequestHeader) header, dis);
//      assertNotNull(parsedData);
//    }
//  }
//}
