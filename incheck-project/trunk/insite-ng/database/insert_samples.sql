insert into `insite`.incheck_user(id,account_expired,account_locked,address,city,country,postal_code,province,credentials_expired,email,is_enabled,first_name,last_name,password,password_hint,phone_number,username,version,created_on,created_by,updated_on,updated_by)
values (1,0,0,null,'Dearfield','US','60015','IL',0,'afridland@inchecktech.com',1,'Alex','Fridland','d033e22ae348aeb5660fc2140aec35850c4da997','Same as your role',null,'admin',1,current_timestamp,1,current_timestamp,1);

insert into `insite`.incheck_user(id,account_expired,account_locked,address,city,country,postal_code,province,credentials_expired,email,is_enabled,first_name,last_name,password,password_hint,phone_number,username,version,created_on,created_by,updated_on,updated_by)
values (2,0,0,null,'Dearfield','US','60015','IL',0,'slava.kovalenko@yahoo.com',1,'Slava','Kovalenko','12dea96fec20593566ab75692c9949596833adc9','Same as your role',null,'user',1,current_timestamp,1,current_timestamp,1);

insert into `insite`.incheck_user(id,account_expired,account_locked,address,city,country,postal_code,province,credentials_expired,email,is_enabled,first_name,last_name,password,password_hint,phone_number,username,version,created_on,created_by,updated_on,updated_by)
values (3,0,0,null,'Northbrook','US','60015','IL',0,'ykhazanov@inchecktech.com',1,'Yuri','Khazanov','dfba7aade0868074c2861c98e2a9a92f3178a51b','Same as your role',null,'config',1,current_timestamp,1,current_timestamp,1);

insert into `insite`.user_role (user_id,role_id) values (1,1);
insert into `insite`.user_role (user_id,role_id) values (1,2);
insert into `insite`.user_role (user_id,role_id) values (1,3);
insert into `insite`.user_role (user_id,role_id) values (2,1);
insert into `insite`.user_role (user_id,role_id) values (3,3);

insert into `insite`.dam (id,serial_number,description,device_type) values (1, '00:D0:69:41:E0:00','10.10.10.10', 1);
insert into `insite`.dam (id,serial_number,description,device_type) values (2, '00:D0:69:41:E4:39','192.168.1.50', 1);
insert into `insite`.dam (id,serial_number,description,device_type) values (3, '00:d0:69:44:76:e9','192.168.1.50', 1);
insert into `insite`.dam (id,serial_number,description,device_type) values (4, '00:D0:69:41:FD:F922','192.168.1.53', 1);

insert into `insite`.sensor(id,dam_id,sensor_type_id,name,comments) values (1,1,1,'Sensor 1-1','Some Comment');
insert into `insite`.sensor(id,dam_id,sensor_type_id,name) values (2,1,1,'Sensor 2-1');
insert into `insite`.sensor(id,dam_id,sensor_type_id,name,comments) values (3,2,1,'Sensor 3-2',NULL);
insert into `insite`.sensor(id,dam_id,sensor_type_id,name,comments) values (4,2,2,'Sensor 4-2',NULL);
insert into `insite`.sensor(id,dam_id,sensor_type_id,name,comments) values (5,3,1,'Sensor 5-3',NULL);
insert into `insite`.sensor(id,dam_id,sensor_type_id,name,comments) values (6,3,1,'Sensor 6-3','More Comments');
insert into `insite`.sensor(id,dam_id,sensor_type_id,name,comments) values (7,3,2,'Sesnsor 7-3',NULL);
insert into `insite`.sensor(id,dam_id,sensor_type_id,name,comments) values (8,4,1,'Sesnsor 4-1',NULL);

insert into `insite`.channel(id,sensor_id,device_channel_id,channel_type_id,channel_measure_type_id,comments)
values (1,1,1,0,1,'Some comments, channel # 1');

insert into `insite`.channel(id,sensor_id,device_channel_id,channel_type_id,channel_measure_type_id,comments)
values (2,1,2,0,1,'Some comments, channel # 2');
insert into `insite`.channel(id,sensor_id,device_channel_id,channel_type_id,channel_measure_type_id,comments)
values (3,2,1,1,2,'Some comments, channel # 3');
insert into `insite`.channel(id,sensor_id,device_channel_id,channel_type_id,channel_measure_type_id,comments)
values (4,8,1,1,2,'Some comments, channel # 3');

insert into `insite`.band(id,band_coefficient,low_frequency,high_frequency,name) values (1,1,0,1000,'Overall 1');
insert into `insite`.band(id,band_coefficient,low_frequency,high_frequency,name) values (2,1,0,25000,'Overall 2');
insert into `insite`.band(id,band_coefficient,low_frequency,high_frequency,name) values (3,1,0,30000,'Overall 3');
insert into `insite`.band(id,band_coefficient,low_frequency,high_frequency,name) values (4,2,28,31,'1x');

insert into `insite`.channel_band(channel_id,band_id) values (1,1);
insert into `insite`.channel_band(channel_id,band_id) values (1,2);
insert into `insite`.channel_band(channel_id,band_id) values (1,3);
insert into `insite`.channel_band(channel_id,band_id) values (2,3);
insert into `insite`.channel_band(channel_id,band_id) values (2,4);

insert into `insite`.channel_config (id,channel_id,channel_config_type_id,value) values (1,1,2,'2048');
