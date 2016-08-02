package com.inchecktech.dpm.tests;

import com.inchecktech.dpm.persistence.PersistProcessedData;
import com.inchecktech.dpm.utils.Logger;

public class TestDBHelper {
	private static Logger logger = new Logger(TestDBHelper.class);
	
	
	public static void main(String[] args) {

		/**
		 * Get alert for displaying purpose
		 * 
		 */
		// System.out.println(PersistAlarmData.getAlertData(2, 100));
		/**
		 * Insert AlaramData
		 */
		// AlarmData d1 = new AlarmData();
		// d1.setAlarm_id(1);
		// d1.setAlarm_value(12345324232L);
		// //d1.setChannel_id(1);
		// d1.setColor(3);
		// d1.setDescription("Fatal Error occured in module blah");
		// d1.setLongdescription("Module blah gone bad");
		// d1.setOverall_type("BS");
		// d1.setSeverity(5);
		// d1.setUnit("test");
		//		
		// PersistAlarmData.persistAlarmData(d1);
		/**
		 * Test to get all alarm data
		 */
		// List<AlarmData> alarmDataList = PersistAlarmData.getAlarmData();
		// for(AlarmData ad : alarmDataList){
		// System.out.println(ad);
		// }
		/**
		 * Test to get alarm data for some channel
		 */
		// alarmDataList = PersistAlarmData.getAlarmData(1);
		// for(AlarmData ad : alarmDataList){
		// System.out.println(ad);
		// }
		// Connection conn = DAOFactory.getLocalSharedMemoryConnection();
//		UserManager um = new UserManagerImpl();
//		RoleManager rm = new RoleManagerImpl();
//		SessionManager sm = new SessionManagerImpl();

		// System.out.println(um.processUserLogout("vlad"));

		// process user login
		// System.out.println(um.processUserLogin("vlad", "password"));

		// is user in role
		// System.out.println(um.isUserInRole("vlad", "admin"));

		// insert user
		// um.createUser("aforkosh", "password", "Alex", "Forkosh", "user");
		// um.addUserToRole("aforkosh", "admin");
		//		 
		// um.createUser("vgusev", "password", "Vlad", "Gusev", "user");
		// um.addUserToRole("vgusev", "admin");
		//		 
		// um.createUser("guest", "password", "Guest", "User", "user");
		// um.addUserToRole("guest", "guest");
		//		 
		// um.createUser("afridland", "password", "Alex", "Fridland", "user");
		// um.addUserToRole("afridland", "admin");
		//		 
		// um.createUser("tobrovolsky", "password", "Taras", "Dobrovolsky",
		// "user");
		// um.addUserToRole("tobrovolsky", "admin");
		//		 
		// um.createUser("ykhazanov", "password", "Yuri", "Khazanov", "user");
		// um.addUserToRole("ykhazanov", "admin");

		// um.addUserToRole(userName, roleName)

		// delete user
		// um.deleteUser("vlad");

		// create role
		// rm.createRole("admin", "Administrator");
		// rm.createRole("guest", "Guest");
		// rm.createRole("superuser", "God");

		// System.out.println(um.getUsers());

		// add user to role
		// um.addUserToRole("alex", "guest");

		// um.removeUserFromRole("vlad", "admin");

		// System.out.println("password hash=" +
		// HashUtil.hashString("password"));
		// System.out.println(um.isUserInRole("vlad", "admin"));
		// um.processUserLogin("vlad", "password");
		// System.out.println(um.processUserLogout("vlad"));

		// is session valid?
		// System.out.println(sm.isValidSession("Kh0ypf1CMoC4uT2ZssMTDX8iFV4="));

		// SessionManager sm = new SessionManagerImpl();
		// sm.createSession(user);

		// User user = um.getUser("vlad");
		// user.setFirstName("Vladislav");
		// um.updateUser(user);
		// System.out.println(user);

		// System.out.println(PersistEventData.getEventsThresholds(3));
		// System.out.println(PersistEventData.getEvent());

		// System.out.println(PersistEventData.getEvent(3, 100));
		
//		FlexChartDataService ds = new FlexChartDataService();
//		Double tval =  ds.getThresholdValue(2, 2, "RMS");
//		System.out.println("value=" + tval.doubleValue());
//		
//		
//		System.out.println("updating now");
//		ds.updateThresholdValue(2, 2, "RMS", tval  + 1);
//		
//		Double tval2 =  ds.getThresholdValue(2, 2, "RMS");
//		System.out.println("new value=" + tval2.doubleValue());
		
		//PersistEventData.updateEventsThreshold(2, 2, "RMS", 2);
		//System.out.println(PersistEventData.getEventsThresholds(3));
		
//		List<EventsThresholds> eventsThresholds = (ArrayList<EventsThresholds>) PersistEventData.getEventsThresholds(3);		
//		System.out.println(eventsThresholds);
		
		
		//DPMFlexProxy proxy = new DPMFlexProxy();
//		List<Date> dates = proxy.getAvailDatesForProcDynData(3, new Date("2/4/2007 10:07:57 PM"), new Date());
		//System.out.println(dates);
/*		System.out.println(proxy.retrieveProcessedDynamicData(3, 3));
		ProcessedDynamicData data = PersistDynamicData.retrieveProcessedDynamicData(3, dates.get(1));
		System.out.println("data=" + data);
		System.out.println("labels=" + data.getDataLabels());
		
		
		*/
		
		logger.info("Test INfo Message");
		logger.debug("test debug message");
		try {
			PersistProcessedData.retrieveProcessedData(10, 10000);
		} catch (Exception e) {
			logger.error("Exception occured 1", e);
		}
		for(int i=10;i<1500;i=i+10)
		{
			long start = System.nanoTime();
			try {
				PersistProcessedData.retrieveProcessedData(10, i);
			} catch (Exception e) {
				logger.error("Exception occured 2", e);
			}
			long tookTime=((System.nanoTime() - start) / 1000000) ;
			
			double avg=tookTime/i;
			System.out.println("ZAEBLO  "+i+" = " +  tookTime + " ms" +" AVG "+avg );
		}
		
		
		

		
		
		

		
	}

}
