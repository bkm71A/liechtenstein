package com.inchecktech.dpm.jms;




// This client going to subscribe to a topic and publish a message
/**
 * @deprecated
 */
@Deprecated public class TestClient {
	
	/*
	// Test on my local box
	private static final String PROVIDER_URL="jnp://localhost:1099";
	
	// Test on inCheck server
	//private static final String PROVIDER_URL="jnp://localhost:1099";
	
	
	private static final String alarmTopic = "topic/AlarmTopic";
	private static final String sensorTopic="topic/DurableSensorTopic";
	
	public static void main(String[] args) {
		Publisher alarm = new Publisher(PROVIDER_URL, alarmTopic);
		Publisher sensor = new Publisher(PROVIDER_URL, sensorTopic);
		
		// Generate 1000 alarms
		for (int i=0; i < 1000; i++){
			alarm.publish("this is a test alarm " +i);
		}
		
		
		// Generate a message with string array of 4000 elements
		List<String> sensorData = new ArrayList<String>();
		for(int i = 0; i <4000; i++){
			sensorData.add("\nData Element " + i);
		}
		
		
		sensor.publish(sensorData.toString());
		
		
	}
	
	*/

}
