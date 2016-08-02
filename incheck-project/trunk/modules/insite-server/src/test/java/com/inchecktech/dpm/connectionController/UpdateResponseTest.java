//package com.inchecktech.dpm.connectionController;
//
//import junit.framework.TestCase;
//
//import org.junit.Test;
//
//import com.inchecktech.dpm.connectionController.UpdateResponse.ChannelConfig;
//import com.inchecktech.dpm.connectionController.UpdateResponse.DamConfig;
//
//public class UpdateResponseTest extends TestCase {
//
//  @Test
//  public final void testUpdateResponse() throws Exception {
//    DamConfig damConfig = new DamConfig();
//    damConfig.setServerIP("192.168.1.62");
//    damConfig.setServerPort(15210);
//    ChannelConfig channelConfig[] = new ChannelConfig[2];
//    channelConfig[0] = new ChannelConfig(2);
//    channelConfig[0].setSamplingRate(150);
//    channelConfig[0].setSamples(100);
//    channelConfig[1] = new ChannelConfig(3);
//    channelConfig[1].setSamplingRate(0);
//    channelConfig[1].setSamples(0);
//    channelConfig[1].setTachometer1(false);
//    channelConfig[1].setTachometer2(false);
//    String updateResponse = UpdateResponse.getResponse(1209866489, damConfig, channelConfig);
//    assertEquals(263, updateResponse.length());
//  }
//}
