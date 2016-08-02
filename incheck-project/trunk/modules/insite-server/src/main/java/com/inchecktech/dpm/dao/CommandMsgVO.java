package com.inchecktech.dpm.dao;

//import com.inchecktech.dpm.connectionController.DataProtocol.CommandMsgProps;

public class CommandMsgVO  {
	
	
/*
	private static final int CMD_MSG_HEADER_SIZE = 33; //in bytes
	
	//DPM -> MC Message types
	private static final int GET_STATIC_DATA_MSG = 1;
	private static final int GET_DYNAMIC_DATA_MSG = 2;
	private static final int REST_MSG = 3;
	private static final int RARL_MSG = 4;
	private static final int PWDN_MSG = 5;
	private static final int CONFIG_MSG = 6; //to update MC w/ new Config file data
	private static final int GLOG_MSG = 7;
	private static final int CHCF_MSG = 8; //To start protocol

	private int message_length;
	private int dpm_soft_curr_ver;
	private int dam_soft_curr_ver;
	private int protocol_curr_ver;
	private int msg_type;
	private int dam_id;
	private int dpm_id;
	private int timestamp;
	private int channel_id;
	private int alarm_mask;
	private int delay_reset;
	private int message_id;
	private int config_data_size;
	private int delay_alarms;
	private int sample_rate;
	private int num_of_samples;
	
	//The CONFIGURATION FILE
	private static final int CONFIG_FILE_SIZE = 69;   //in bytes
	
	private int config_file_len;
	private int s_data_low;
	private int s_data_high;
	private int s_data_alarm_det; 
	private int rpm_alarm_low; 
	private int alarm_bitmask;
	private int dam_task_bitmask;	
	private int c_dpm_soft_curr_ver; 
	private int c_dam_soft_curr_ver;
	private int c_protocol_curr_ver;
	private int clock_start_time;
	private int c_dam_id;
	private int c_dpm_id;
	private int c_channel_id;
	private int max_num_analog_ch;
	private int dam_ip_add1;
	private int dam_ip_add2;
	private int dam_ip_add3;
	private int dam_ip_add4;
	private int dam_port_num;
	private int new_network_mask1;
	private int new_network_mask2;
	private int new_network_mask3;
	private int new_network_mask4;
	private int new_dpm_ip_add1;
	private int new_dpm_ip_add2;
	private int new_dpm_ip_add3;
	private int new_dpm_ip_add4;
	private int dpm_port_num;
	private int def_gateway_ip1;
	private int def_gateway_ip2;
	private int def_gateway_ip3;
	private int def_gateway_ip4;
	private int s_data_report_period;
	private int d_data_report_period;
	private int rpm_report_period;
	private int config_file_timestamp;
	private int data_files_exp_time;
	private int config_file_sign;
	
	public byte[] buildCommandMsg(CommandMsgProps cmdMsgProps)
	{
		byte[] msg = new byte[CMD_MSG_HEADER_SIZE+CONFIG_FILE_SIZE];
		
		//Big-Endian conversion done here, so the MC can read message correctly in hex bytes
		//ex.  0x1277 should be sent as -> byte[0]=77  byte[1]=12 (flipped)
		message_length = CMD_MSG_HEADER_SIZE+CONFIG_FILE_SIZE;
		msg[0] = (byte) (message_length & 0x00FF);
		msg[1] = (byte) ((message_length >> 8) & 0x000000FF);
		
		dpm_soft_curr_ver = cmdMsgProps.getDpm_soft_curr_ver();
		msg[2] = (byte) (dpm_soft_curr_ver & 0x00FF);
		msg[3] = (byte) ((dpm_soft_curr_ver >> 8) & 0x000000FF);

		dam_soft_curr_ver = cmdMsgProps.getDam_soft_curr_ver();
		msg[4] = (byte) (dam_soft_curr_ver & 0x00FF);
		msg[5] = (byte) ((dam_soft_curr_ver >> 8) & 0x000000FF);
		
		protocol_curr_ver = cmdMsgProps.getProtocol_curr_ver();
		msg[6] = (byte) (protocol_curr_ver & 0x00FF);
		msg[7] = (byte) ((protocol_curr_ver >> 8) & 0x000000FF);

		msg_type = CHCF_MSG;
		msg[8] = (byte) (msg_type & 0x00FF);
		
		dam_id = cmdMsgProps.getDam_id();
		msg[9] = (byte) (dam_id & 0x00FF);
		msg[10] = (byte) ((dam_id >> 8) & 0x000000FF);
		
		dpm_id = cmdMsgProps.getDpm_id();
		msg[11] = (byte) (dpm_id & 0x00FF);
		msg[12] = (byte) ((dpm_id >> 8) & 0x000000FF);
		
		timestamp = cmdMsgProps.getTimestamp();
		msg[13] = (byte) (timestamp & 0x00FF);
		msg[14] = (byte) ((timestamp >> 8) & 0x000000FF);
		msg[15] = (byte) ((timestamp >> 16) & 0x000000FF);
		msg[16] = (byte) ((timestamp >> 24) & 0x000000FF);
		
		channel_id = cmdMsgProps.getChannel_id();
		msg[17] = (byte) (channel_id & 0x00FF);
		msg[18] = (byte) ((channel_id >> 8) & 0x000000FF);
		
		alarm_mask = cmdMsgProps.getAlarm_mask();
		msg[19] = (byte) (alarm_mask & 0x00FF);
		msg[20] = (byte) ((alarm_mask >> 8) & 0x000000FF);
		
		delay_reset = cmdMsgProps.getDelay_reset();
		msg[21] = (byte) (delay_reset & 0x00FF);
		msg[22] = (byte) ((delay_reset >> 8) & 0x000000FF);
		
		message_id = 0;
		msg[23] = (byte) (message_id & 0x00FF);
		msg[24] = (byte) ((message_id >> 8) & 0x000000FF);
		
		config_data_size = CONFIG_FILE_SIZE;
		msg[25] = (byte) (config_data_size & 0x00FF);
		msg[26] = (byte) ((config_data_size >> 8) & 0x000000FF);
		
		delay_alarms = cmdMsgProps.getDelay_alarms();
		msg[27] = (byte) (delay_alarms & 0x00FF);
		msg[28] = (byte) ((delay_alarms >> 8) & 0x000000FF);
		
		sample_rate = cmdMsgProps.getSample_rate();
		msg[29] = (byte) (sample_rate & 0x00FF);
		msg[30] = (byte) ((sample_rate >> 8) & 0x000000FF);
		
		num_of_samples = cmdMsgProps.getNum_of_samples();
		msg[31] = (byte) (num_of_samples & 0x00FF);
		msg[32] = (byte) ((num_of_samples >> 8) & 0x000000FF);

		//
		//Build Config file section
		//
		config_file_len = CONFIG_FILE_SIZE;
		msg[33] = (byte) (config_file_len & 0x00FF);
		msg[34] = (byte) ((config_file_len >> 8) & 0x000000FF);
		
		s_data_low = cmdMsgProps.getS_data_low();
		msg[35] = (byte) (s_data_low & 0x00FF);
		msg[36] = (byte) ((s_data_low >> 8) & 0x000000FF);
		
		s_data_high = cmdMsgProps.getS_data_high();
		msg[37] = (byte) (s_data_high & 0x00FF);
		msg[38] = (byte) ((s_data_high >> 8) & 0x000000FF);
		
		s_data_alarm_det = cmdMsgProps.getS_data_alarm_det();
		msg[39] = (byte) (s_data_alarm_det & 0x00FF);
		msg[40] = (byte) ((s_data_alarm_det >> 8) & 0x000000FF);
		
		rpm_alarm_low = cmdMsgProps.getRpm_alarm_low();
		msg[41] = (byte) (rpm_alarm_low & 0x00FF);
		msg[42] = (byte) ((rpm_alarm_low >> 8) & 0x000000FF);
		
		alarm_bitmask = cmdMsgProps.getAlarm_bitmask();
		msg[43] = (byte) (alarm_bitmask & 0x00FF);
		msg[44] = (byte) ((alarm_bitmask >> 8) & 0x000000FF);
		
		dam_task_bitmask = cmdMsgProps.getDam_task_bitmask();
		msg[45] = (byte) (dam_task_bitmask & 0x00FF);
		msg[46] = (byte) ((dam_task_bitmask >> 8) & 0x000000FF);
		
		c_dpm_soft_curr_ver = cmdMsgProps.getC_dpm_soft_curr_ver();
		msg[47] = (byte) (c_dpm_soft_curr_ver & 0x00FF);
		msg[48] = (byte) ((c_dpm_soft_curr_ver >> 8) & 0x000000FF);
		
		c_dam_soft_curr_ver = cmdMsgProps.getC_dam_soft_curr_ver();
		msg[49] = (byte) (c_dam_soft_curr_ver & 0x00FF);
		msg[50] = (byte) ((c_dam_soft_curr_ver >> 8) & 0x000000FF);
		
		c_protocol_curr_ver = cmdMsgProps.getC_protocol_curr_ver();
		msg[51] = (byte) (c_protocol_curr_ver & 0x00FF);
		msg[52] = (byte) ((c_protocol_curr_ver >> 8) & 0x000000FF);
		
		clock_start_time = 0;
		msg[53] = (byte) (clock_start_time & 0x00FF);
		msg[54] = (byte) ((clock_start_time >> 8) & 0x000000FF);
		msg[55] = (byte) ((clock_start_time >> 16) & 0x000000FF);
		msg[56] = (byte) ((clock_start_time >> 24) & 0x000000FF);
		
		c_dam_id = cmdMsgProps.getC_dam_id();
		msg[57] = (byte) (c_dam_id & 0x00FF);
		msg[58] = (byte) ((c_dam_id >> 8) & 0x000000FF);
		
		c_dpm_id = cmdMsgProps.getC_dpm_id();
		msg[59] = (byte) (c_dpm_id & 0x00FF);
		msg[60] = (byte) ((c_dpm_id >> 8) & 0x000000FF);
		
		c_channel_id = cmdMsgProps.getC_channel_id();
		msg[61] = (byte) (c_channel_id & 0x00FF);
		msg[62] = (byte) ((c_channel_id >> 8) & 0x000000FF);
		
		max_num_analog_ch = cmdMsgProps.getMax_num_analog_ch();
		msg[63] = (byte) (max_num_analog_ch & 0x00FF);
		
		dam_ip_add1  = cmdMsgProps.getDam_ip_add1();
		dam_ip_add2  = cmdMsgProps.getDam_ip_add2();
		dam_ip_add3  = cmdMsgProps.getDam_ip_add3();
		dam_ip_add4  = cmdMsgProps.getDam_ip_add4();
		msg[64] = (byte) (dam_ip_add4 & 0x00FF);
		msg[65] = (byte) (dam_ip_add3 & 0x00FF);
		msg[66] = (byte) (dam_ip_add2 & 0x00FF);
		msg[67] = (byte) (dam_ip_add1 & 0x00FF);
		
		dam_port_num = cmdMsgProps.getDam_port_num();
		msg[68] = (byte) (dam_port_num & 0x00FF);
		msg[69] = (byte) ((dam_port_num >> 8) & 0x000000FF);
		
		new_network_mask1 = cmdMsgProps.getNew_network_mask1();
		new_network_mask2 = cmdMsgProps.getNew_network_mask2();
		new_network_mask3 = cmdMsgProps.getNew_network_mask3();
		new_network_mask4 = cmdMsgProps.getNew_network_mask4();
		msg[70] = (byte) (new_network_mask4 & 0x00FF);
		msg[71] = (byte) (new_network_mask3 & 0x00FF);
		msg[72] = (byte) (new_network_mask2 & 0x00FF);
		msg[73] = (byte) (new_network_mask1 & 0x00FF);
		
		new_dpm_ip_add1 = cmdMsgProps.getNew_dpm_ip_add1();
		new_dpm_ip_add2 = cmdMsgProps.getNew_dpm_ip_add2();
		new_dpm_ip_add3 = cmdMsgProps.getNew_dpm_ip_add3();
		new_dpm_ip_add4 = cmdMsgProps.getNew_dpm_ip_add4();
		msg[74] = (byte) (new_dpm_ip_add4 & 0x00FF);
		msg[75] = (byte) (new_dpm_ip_add3 & 0x00FF);
		msg[76] = (byte) (new_dpm_ip_add2 & 0x00FF);
		msg[77] = (byte) (new_dpm_ip_add1 & 0x00FF);
		
		dpm_port_num = cmdMsgProps.getDpm_port_num();
		msg[78] = (byte) (dpm_port_num & 0x00FF);
		msg[79] = (byte) ((dpm_port_num >> 8) & 0x000000FF);
		
		def_gateway_ip1 = cmdMsgProps.getDef_gateway_ip1();
		def_gateway_ip2 = cmdMsgProps.getDef_gateway_ip2();
		def_gateway_ip3 = cmdMsgProps.getDef_gateway_ip3();
		def_gateway_ip4 = cmdMsgProps.getDef_gateway_ip4();
		msg[80] = (byte) (def_gateway_ip4 & 0x00FF);
		msg[81] = (byte) (def_gateway_ip3 & 0x00FF);
		msg[82] = (byte) (def_gateway_ip2 & 0x00FF);
		msg[83] = (byte) (def_gateway_ip1 & 0x00FF);
		
		s_data_report_period = cmdMsgProps.getS_data_report_period();
		msg[84] = (byte) (s_data_report_period & 0x00FF);
		msg[85] = (byte) ((s_data_report_period >> 8) & 0x000000FF);
		
		d_data_report_period = cmdMsgProps.getD_data_report_period();
		msg[86] = (byte) (d_data_report_period & 0x00FF);
		msg[87] = (byte) ((d_data_report_period >> 8) & 0x000000FF);
		
		rpm_report_period = cmdMsgProps.getRpm_report_period();
		msg[88] = (byte) (rpm_report_period & 0x00FF);
		msg[89] = (byte) ((rpm_report_period >> 8) & 0x000000FF);
		
		config_file_timestamp = 0;
		msg[90] = (byte) (config_file_timestamp & 0x00FF);
		msg[91] = (byte) ((config_file_timestamp >> 8) & 0x000000FF);
		msg[92] = (byte) ((config_file_timestamp >> 16) & 0x000000FF);
		msg[93] = (byte) ((config_file_timestamp >> 24) & 0x000000FF);
		
		data_files_exp_time = cmdMsgProps.getData_files_exp_time();
		msg[94] = (byte) (data_files_exp_time & 0x00FF);
		msg[95] = (byte) ((data_files_exp_time >> 8) & 0x000000FF);
		msg[96] = (byte) ((data_files_exp_time >> 16) & 0x000000FF);
		msg[97] = (byte) ((data_files_exp_time >> 24) & 0x000000FF);
		
		config_file_sign = 0;
		msg[98] = (byte) (config_file_sign & 0x00FF);
		msg[99] = (byte) ((config_file_sign >> 8) & 0x000000FF);
		msg[100] = (byte) ((config_file_sign >> 16) & 0x000000FF);
		msg[101] = (byte) ((config_file_sign >> 24) & 0x000000FF);
		
		return msg;
	}*/
		
}
