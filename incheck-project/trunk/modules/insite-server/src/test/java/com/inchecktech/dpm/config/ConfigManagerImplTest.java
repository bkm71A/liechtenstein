package com.inchecktech.dpm.config;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.inchecktech.dpm.beans.Channel;
import com.inchecktech.dpm.beans.Device;

public class ConfigManagerImplTest {

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	// @Test
	// public final void testGetSpectrumAnalysisConfig() {
	//
	// //First get all possible values
	// List<SpectrumAnalysisConfig> configList =
	// ConfigManagerImpl.getSpectrumAnalysisConfig(1000);
	// System.out.println("\n");
	// for (SpectrumAnalysisConfig config: configList){
	// System.out.println(config.getAnalysisBandwidth());
	// System.out.println(config.getSpectrumLines());
	// System.out.println(config.isCurrent());
	// System.out.println("\n");
	// }
	//		
	//		
	//		
	// }

	// @Test
	// public final void testGetSpectrumAnalysisConfigUserItems(){
	//		
	// SpectrumAnalysisConfigUserItems items =
	// PersistSpecAnalysisConfig.getSpectrumAnalysisConfigUserItems();
	// System.out.println("items=" + items);
	// }
	//
	// @Test
	// public final void testGetChannelConfig() {
	// List<String> channelTypes = new ArrayList<String>();
	// channelTypes.add("DYNAMIC");
	//		
	// ChannelConfig config = ConfigManagerImpl.getChannelConfig(channelTypes);
	// ArrayList<ChannelConfigItem> items = config.getChannelConfigItems();
	//		
	// System.out.println(config.getConfigType());
	// System.out.println(config.getConfigGroup());
	//
	// if (null != items) {
	// for (ChannelConfigItem item : items) {
	// System.out.println(item);
	// }
	// }else{
	// System.out.println("LIST OF ITEMS IS NULL");
	//			
	// }
	// }

	@Test
	public final void testGetDevice() {
		String macAddress = "ABCDEFG";
		Device device = ChannelConfigFactory.getDevice(macAddress);

		for (Channel channel : device.getChannels()) {
			ChannelConfig cconfig = channel.getChannelConfig();

			if (null != cconfig.getChannelConfigItems()) {
				for (ChannelConfigItem item : cconfig.getChannelConfigItems()) {
					if (item.getPropertyName().equals("com.inchecktech.dpm.dam.SamplingRate")){
						System.out.println("DAM_SAMPLE_RATE=" +  item.getPropertyValue());
					}
					if (item.getPropertyName().equals("com.inchecktech.dpm.dam.BlockSize")){
						System.out.println("DAM_SAMPLE_SIZE=" +  item.getPropertyValue());
					}
				}
			}
		}
	}

}
