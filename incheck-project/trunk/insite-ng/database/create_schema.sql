CREATE TABLE insite.incheck_user (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier,primary key',
  `account_expired` bit(1) NOT NULL,
  `account_locked` bit(1) NOT NULL,
  `credentials_expired` bit(1) NOT NULL,
  `address` varchar(150) DEFAULT NULL COMMENT 'User Address',
  `city` varchar(50) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `postal_code` varchar(15) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `version` int(11) NOT NULL,
  `password` varchar(255) NOT NULL,
  `password_hint` varchar(255) DEFAULT NULL COMMENT 'Password hint',
  `phone_number` varchar(255) DEFAULT NULL COMMENT 'Phone Number',
  `username` varchar(50) NOT NULL,
  `is_enabled` bit(1) DEFAULT b'1' COMMENT 'Users are never deleted, instead is_enabled set to 0',
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when this record was inserted.',
  `created_by` int(11) NOT NULL COMMENT 'Id of the user who inserted this record.',
  `updated_on` timestamp NOT NULL COMMENT 'Timestamp when this record was inserted.',
  `updated_by` int(11) NOT NULL COMMENT 'Id of the user who inserted this record.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_incheck_user_created_by` (`created_by`),
  KEY `fk_incheck_user_updated_by` (`updated_by`),
  CONSTRAINT `fk_incheck_user_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `incheck_user` (`id`),
  CONSTRAINT `fk_incheck_user_created_by` FOREIGN KEY (`created_by`) REFERENCES `incheck_user` (`id`)
) ENGINE=InnoDB COMMENT = 'Users information';

CREATE TABLE insite.`role` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,  
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) 
COMMENT = 'Roles defined for InCheck application.';

insert into insite.role(id,name,description)
values (1,'ROLE_USER','Default role for all Users');

insert into insite.role(id,name,description)
values (2,'ROLE_ADMIN','Administrator role (can edit Users)');

insert into insite.role(id,name,description)
values (3,'ROLE_CONFIG_ADMIN','Configuration administrator role, could configure system');

CREATE TABLE insite.`user_role` (
  `user_id` INTEGER NOT NULL,
  `role_id` INTEGER NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_user_role_role` (`role_id`),
  KEY `fk_user_role_user` (`user_id`),
  CONSTRAINT `fk_user_role_user` FOREIGN KEY (`user_id`) REFERENCES `incheck_user` (`id`),
  CONSTRAINT `fk_user_role_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB;

ALTER TABLE insite.`user_role` ADD UNIQUE INDEX `uq_user_role`(`user_id`, `role_id`);

CREATE TABLE insite.`dam` (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for DAM',
  `serial_number` VARCHAR(100) NOT NULL  COMMENT 'DAM serial number, mac address',
  `description` VARCHAR(100) NOT NULL  COMMENT 'DAM description',
	`device_type` TINYINT(1) NOT NULL COMMENT 'Device Type',
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
COMMENT = 'DAM - Data acquisition modules';
ALTER TABLE insite.`dam` ADD UNIQUE INDEX `uq_serial_number`(`serial_number`);

CREATE TABLE insite.`sensor` (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of Sensor, primary key',
  `dam_id` INTEGER NOT NULL COMMENT 'Id of DAM where this sensor is installed',
  `sensor_type_id` INTEGER NOT NULL DEFAULT 1,  
  `name` VARCHAR(100) NOT NULL  COMMENT 'Sensor Name',  
  `comments` VARCHAR(100) NULL COMMENT 'Sensor comments',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_sensor_dam` FOREIGN KEY `fk_sensor_dam` (`dam_id`)
  REFERENCES `dam` (`id`)
)
ENGINE = InnoDB
COMMENT = 'Sensor information';

CREATE TABLE insite.channel_measure_type (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `code` VARCHAR(10) NOT NULL COMMENT 'Measure code',
  `description` VARCHAR(100) NOT NULL COMMENT 'Description',
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
COMMENT = 'Channel measure types';

insert into insite.channel_measure_type(id,code,description)
values (1,'VIB','Vibration');
insert into insite.channel_measure_type(id,code,description)
values (2,'TEM','Temperature');

CREATE TABLE insite.channel_type (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for Channel Type.',
  `name` VARCHAR(100) NOT NULL COMMENT 'Channel type name',
  `description` VARCHAR(200) NOT NULL COMMENT 'Channel type description',
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
COMMENT = 'Channel types';

SET SESSION sql_mode='NO_AUTO_VALUE_ON_ZERO';

insert into insite.channel_type(id,name,description)
values (0,'Dynamic','Dynamic channel');
insert into insite.channel_type(id,name,description)
values (1,'Static','Static channel');

SET SESSION sql_mode='';

CREATE TABLE insite.`chanel_config_type` (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of configuration value, primary key',
  `name` VARCHAR(50) NOT NULL COMMENT 'Name of configuration Vlaue',
  `description` VARCHAR(200) NOT NULL COMMENT 'Description of configuration value',
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
COMMENT = 'Configuration Values Types for channel';
ALTER TABLE insite.`chanel_config_type` ADD UNIQUE INDEX `uq_chanel_config_type`(`name`);

insert into insite.chanel_config_type(id,name,description) values (1,'bandwidth','Bandwidth');
insert into insite.chanel_config_type(id,name,description) values (2,'block-size','Channel block size');
insert into insite.chanel_config_type(id,name,description) values (3,'max-volts','Max Volts');
insert into insite.chanel_config_type(id,name,description) values (4,'number-of-lines','Number of lines');
insert into insite.chanel_config_type(id,name,description) values (5,'sampling-interval','Sampling interval');
insert into insite.chanel_config_type(id,name,description) values (6,'sampling-rate','Channel Sampling Rate');
insert into insite.chanel_config_type(id,name,description) values (7,'sensor-bias-voltage','Sensor bias voltage');
insert into insite.chanel_config_type(id,name,description) values (8,'sensor-offset','Sensor offset');
insert into insite.chanel_config_type(id,name,description) values (9,'sensor-sensitivity','Sensor sensitivity (mv/eu)');
insert into insite.chanel_config_type(id,name,description) values (10,'sample-size','Sample size');
insert into insite.chanel_config_type(id,name,description) values (11,'frequency-adjustment-factor','Frequency Adjustment Factor');
insert into insite.chanel_config_type(id,name,description) values (12,'gain-adjustment-factor','Gain Adjustment Factor');
insert into insite.chanel_config_type(id,name,description) values (13,'primary-channel-engineering-units','Primary channel engineering units');
insert into insite.chanel_config_type(id,name,description) values (14,'overall-type-to-calculate','Overall type to calculate');
insert into insite.chanel_config_type(id,name,description) values (15,'ticks-per-revolution','How many ticks are recorded by a sensor per a single revolution');
insert into insite.chanel_config_type(id,name,description) values (16,'dcfilter-smoothing-factor','DCFilter Smoothing Factor');
insert into insite.chanel_config_type(id,name,description) values (17,'converter-bit-resolution','Bit resolution used by a unit converter to convert from Intergers to Volts');
insert into insite.chanel_config_type(id,name,description) values (18,'converter-max-volts','Maximum voltage generated by the DAM hardware module');
insert into insite.chanel_config_type(id,name,description) values (19,'converter-sensor-bias-voltage','Sensor Bias Voltage Adjustment');
insert into insite.chanel_config_type(id,name,description) values (20,'converter-sensor-gain','Sensor Gain (should be close to 1: 0.98798).  Do not set to 0 (zero)');
insert into insite.chanel_config_type(id,name,description) values (21,'converter-sensor-offset','Sensor Offset');
insert into insite.chanel_config_type(id,name,description) values (22,'converter-sensor-sensitivity','Sensor sensitivity in mv/EU (where EU - engineering unit such as G etc.)');
insert into insite.chanel_config_type(id,name,description) values (23,'no-of-data-bins-to-average','Number of data points to use for cacluating the average of a static measurment');
insert into insite.chanel_config_type(id,name,description) values (24,'sim-sleeprate','Simulator Sleep Rate');
insert into insite.chanel_config_type(id,name,description) values (25,'sim-tickmod','TBD');
insert into insite.chanel_config_type(id,name,description) values (26,'sim-random','Defines if simulator adds random noise to the simulated signal: 1 - true, 0 - false');
insert into insite.chanel_config_type(id,name,description) values (27,'recent-trend-buffer-size','Defines how many mesaurements DSP should keep in the buffer for a recent trend plot');

CREATE TABLE insite.channel_default_config (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of channel config values,primary key',
  `channel_type_id` INTEGER NOT NULL COMMENT 'Channel Type',
  `channel_config_type_id` INTEGER NOT NULL COMMENT 'Configuration value type',
  `value` VARCHAR(50) NOT NULL COMMENT 'Default value',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_channel_default_channel_type` FOREIGN KEY `fk_channel_default_channel_type` (`channel_type_id`)
    REFERENCES `channel_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_channel_default_config_type` FOREIGN KEY `fk_channel_default_config_type` (`channel_config_type_id`)
    REFERENCES `chanel_config_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);

ALTER TABLE insite.`channel_default_config` ADD UNIQUE INDEX uq_channel_default_config(channel_type_id, channel_config_type_id);

CREATE TABLE insite.channel (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of channel, primary key',
  `sensor_id` INTEGER NOT NULL COMMENT 'Id of sensor to which this channel belongs',
  `device_channel_id` INTEGER NOT NULL  COMMENT 'Channel id for particular DAM',
  `channel_type_id` INTEGER NOT NULL DEFAULT 1,
  `channel_measure_type_id` INTEGER NOT NULL DEFAULT 1 COMMENT 'Channel measure type',
  `comments` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_channel_sensor` FOREIGN KEY `fk_channel_sensor` (`sensor_id`)
    REFERENCES `sensor` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
)
ENGINE = InnoDB
COMMENT = 'Data acquisition channel';

ALTER TABLE insite.`channel` ADD CONSTRAINT `fk_channel_measure_type` FOREIGN KEY `fk_channel_measure_type` (`channel_measure_type_id`)
    REFERENCES `channel_measure_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

ALTER TABLE insite.`channel` ADD CONSTRAINT `fk_channel_type` FOREIGN KEY `fk_channel_type` (`channel_type_id`)
    REFERENCES `channel_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

CREATE TABLE insite.`channel_config` (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of channel config value, primary key',
  `channel_id` INTEGER NOT NULL COMMENT 'Channel Id',
  `channel_config_type_id` INTEGER NOT NULL COMMENT 'Configuration type',
  `value` VARCHAR(50) NOT NULL COMMENT 'Value of configuration parameter',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_channel_config_channel` FOREIGN KEY `fk_channel_config_channel` (`channel_id`)
    REFERENCES `channel` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_channel_config_type` FOREIGN KEY `fk_channel_config_type` (`channel_config_type_id`)
    REFERENCES `chanel_config_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
)
ENGINE = InnoDB
COMMENT = 'Channel configuration values';

ALTER TABLE insite.`channel_config` ADD UNIQUE INDEX `uq_channel_config`(`channel_id`, `channel_config_type_id`);

CREATE TABLE insite.overall_type (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier, primary key',
  `name` varchar(32) NOT NULL,
  `description` varchar(100) NOT NULL,
  `is_enabled` bit(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
COMMENT = 'Overall Types';

insert into insite.overall_type(id,name,description,is_enabled) values (1,'RMS', 'RMS', 1);
insert into insite.overall_type(id,name,description,is_enabled) values (2,'True Peak', 'True Peak', 1);
insert into insite.overall_type(id,name,description,is_enabled) values (3,'Derived Peak', 'Derived Peak', 0);
insert into insite.overall_type(id,name,description,is_enabled) values (4,'Derived Peak To Peak', 'Derived Peak to Peak', 0);
insert into insite.overall_type(id,name,description,is_enabled) values (5,'True Peak To Peak', 'True peak to peak', 0);
insert into insite.overall_type(id,name,description,is_enabled) values (6,'Kurtosis', 'Kurtosis', 0);
insert into insite.overall_type(id,name,description,is_enabled) values (7,'Std Deviation', 'Std Deviation', 0);
insert into insite.overall_type(id,name,description,is_enabled) values (8,'Crest Factor', 'Crest Factor', 0);
insert into insite.overall_type(id,name,description,is_enabled) values (9,'Accel_Rms', 'ACC  RMS', 1);

CREATE TABLE insite.`config_property_type` (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier if configuration property type',
  `type` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
COMMENT = 'Type of configuration preperty';

CREATE TABLE insite.`config_property` (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of configuration property, primary key',
  `name` VARCHAR(100) NOT NULL COMMENT 'Name of property',
  `value` VARCHAR(200) NOT NULL COMMENT 'Property Value',
  `description` VARCHAR(100) NOT NULL COMMENT 'Human readable property description',
  `property_type_id` INTEGER NOT NULL COMMENT 'Type of the property',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_property_type` FOREIGN KEY `fk_property_type` (`id`)
    REFERENCES `config_property_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
)
ENGINE = InnoDB
COMMENT = 'System-wide configuration properties';

CREATE TABLE insite.`alarm` (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of alarm',
  `channel_id` INTEGER NOT NULL COMMENT 'Channel to which this alarm belongs',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_channel` FOREIGN KEY `fk_channel` (`id`)
    REFERENCES `channel` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
)
ENGINE = InnoDB
COMMENT = 'Channel alarm settings';

CREATE TABLE insite.`sample` (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique id of acquired data, primary key',
  `channel_id` INTEGER NOT NULL COMMENT 'Id of the channel where this data was taken',
  `data` BLOB NOT NULL COMMENT 'Raw data, array packed as blob',
  `run_time` DATETIME NOT NULL COMMENT 'Local Time when this was acquired',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_sample_channel` FOREIGN KEY `fk_sample_channel` (`id`)
    REFERENCES `channel` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
)
ENGINE = InnoDB
COMMENT = 'Measurement  sample';

CREATE TABLE insite.`sample_overall` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `sample_id` INTEGER NOT NULL,
  `overall_type_id` INTEGER NOT NULL,
  `value` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_sample_overall_sample` FOREIGN KEY `fk_sample_overall_sample` (`sample_id`)
    REFERENCES `sample` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_sample_overall_overall_type` FOREIGN KEY `fk_sample_overall_overall_type` (`overall_type_id`)
    REFERENCES `overall_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
)
ENGINE = InnoDB
COMMENT = 'Samples overalls, one sample could have multiple overalls';

CREATE TABLE insite.`band` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `band_coefficient` decimal(10,0) NOT NULL COMMENT 'Band coefficient',
  `low_frequency`  INT(11) NOT NULL COMMENT 'Band Low(start) frequency',
  `high_frequency` INT(11) NOT NULL COMMENT 'Band High(end) frequency',
  `name` varchar(100) NOT NULL DEFAULT 'All' COMMENT 'Band Name',
  PRIMARY KEY (`id`),
  CHECK (low_frequency < high_frequency)
) ENGINE=InnoDB 
COMMENT = 'Cahnnel bands';

ALTER TABLE insite.`band` ADD UNIQUE INDEX `uq_band_name`(`name`);

CREATE TABLE insite.`channel_band` (
  `channel_id` INTEGER NOT NULL COMMENT 'Id of channel',
  `band_id` INTEGER NOT NULL COMMENT 'Id of band',
  PRIMARY KEY (`channel_id`, `band_id`),
  CONSTRAINT `fk_channel_band_channel_id` FOREIGN KEY `fk_channel_band_channel_id` (`channel_id`)
    REFERENCES `channel` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_channel_band_band_id` FOREIGN KEY `fk_channel_band_band_id` (`band_id`)
    REFERENCES `band` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
)
ENGINE = InnoDB
COMMENT = 'Table that links Channels and Bands';

create view insite.v_channel_config AS 
select t1.id as channel_id,t3.name,ifnull(t4.value,t2.value) as value
from insite.channel t1 inner join insite.channel_default_config t2
on t1.channel_type_id = t2.channel_type_id
inner join insite.chanel_config_type t3
on t2.channel_config_type_id = t3.id
left outer join insite.channel_config t4
on t1.id = t4.channel_id
and t2.channel_config_type_id = t4.channel_config_type_id
order by 1,2;

insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (1,0,6,'5120');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (2,0,2,'4096');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (3,0,5,'10');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (4,0,3,'10');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (5,0,1,'1000');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (6,0,4,'800');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (7,0,7,'2.5');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (8,0,9,'100');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (9,0,8,'0');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (10,1,6,'256');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (11,1,2,'128');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (12,1,5,'10');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (13,1,3,'10');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (14,1,7,'0');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (15,1,9,'42.5');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (16,1,8,'24.5');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (17,0,11,'1.0');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (18,0,12,'1.0');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (19,0,13,'T');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (20,0,14,'RMS');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (21,0,15,'1');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (22,0,16,'500');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (23,0,17,'16');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (24,0,18,'5');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (25,0,19,'2.5');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (26,0,20,'1');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (27,0,21,'0');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (28,0,22,'100');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (29,1,17,'16');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (30,1,18,'5');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (31,1,19,'2.5');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (32,1,20,'1');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (33,1,21,'0');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (34,1,22,'100');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (35,1,23,'50');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (36,1,13,'T');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (37,0,24,'10');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (38,0,25,'20');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (39,0,26,'true');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (40,0,27,'200');
insert into `insite`.channel_default_config(id,channel_type_id,channel_config_type_id,value) values (41,1,27,'200');

/*
channel
	device_channel_id -> channel_config ?

Sensor
	sensor_type

DAM
	serial number
	device_type
	description
	last_time_connected ???
	
Simple audit for 4 tables
*/