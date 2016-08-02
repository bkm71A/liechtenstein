select * from insite_existing.config_properties_channels

select property_name,count(*) 
from insite_existing.CONFIG_PROPERTIES group by property_name
order by 1

SELECT c.CHANNEL_ID,cp.PROPERTY_NAME as CHANNEL_KEY,
 cc.CONFIG_VALUE as CHANNEL_VALUE,
 cp.DATA_TYPE, cp.DESCRIPTION,
 cc.DEFAULT_VALUE,
 cp.PROPERTY_ID,
 cg.*,
 u.UNIT_ID,
 ct.CONFIG_TYPE_ID,
 ct.TYPE_NAME as CONFIG_TYPE_NAME,
 ct.DESCRIPTION as CONFIG_TYPE_DESCRIPTION
 FROM insite_existing.CONFIG_PROPERTIES cp, insite_existing.CONFIG_PROPERTIES_CHANNELS cc, 
 insite_existing.CHANNEL c, insite_existing.CONFIG_GROUPS cg, insite_existing.CONFIG_TYPES ct, insite_existing.UNITS u
 WHERE cp.PROPERTY_ID=cc.PROPERTY_ID
 AND c.CHANNEL_ID=CC.CHANNEL_ID
 AND cp.group_id=cg.group_id
 AND ct.config_type_id=cp.config_type_id
 AND u.UNIT_ID=cp.UNIT_ID 
 =================================================================================
 CREATE TABLE `insite`.`channel_type` (
  `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for Channel Type.',
  `name` VARCHAR(100) NOT NULL COMMENT 'Channel type name',
  `description` VARCHAR(200) NOT NULL COMMENT 'Channel type description',
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
COMMENT = 'Channel types';