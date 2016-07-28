package com.epam.bdru2016.team2.mss.processing.esindexer

import com.epam.bdru2016.team2.mss.integration.cassandra.CassandraSettingsProvided
import com.epam.bdru2016.team2.mss.integration.elasticsearch.ESSettingsProvided
import com.epam.bdru2016.team2.mss.model.utils.DateTimeUtils
import com.epam.bdru2016.team2.mss.shared.AppSettingsProvider

/**
  * Created by Aleksander_Khanteev on 6/9/2016.
  */
class ESIndexerSettingsProvider(configPath:String)
  extends AppSettingsProvider(configPath)
  with ESSettingsProvided
  with CassandraSettingsProvided
{

  def getStartTimestamp:Long = {

    val dateTime = getOrThrow("start-time")((c,p)  => c.getString(p))
    DateTimeUtils.parseDateTimeWithPadding(dateTime).getMillis
  }

  def getEndTimestamp:Long = {

    val dateTime = getOrThrow("end-time")((c,p)  => c.getString(p))
    DateTimeUtils.parseDateTimeWithPadding(dateTime).getMillis
  }
}
