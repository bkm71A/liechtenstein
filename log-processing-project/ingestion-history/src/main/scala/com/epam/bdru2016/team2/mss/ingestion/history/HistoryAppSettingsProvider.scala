package com.epam.bdru2016.team2.mss.ingestion.history

import com.epam.bdru2016.team2.mss.integration.cassandra.CassandraSettingsProvided
import com.epam.bdru2016.team2.mss.integration.hdfs.DictionarySettingsProvided
import com.epam.bdru2016.team2.mss.shared.AppSettingsProvider

/**
  * Created by Aleksander_Khanteev on 6/9/2016.
  */
class HistoryAppSettingsProvider(configPath:String)
  extends AppSettingsProvider(configPath)
  with CassandraSettingsProvided
  with DictionarySettingsProvided {

  def dwhPath:String = getStringOrThrow("dwh-path")
}
