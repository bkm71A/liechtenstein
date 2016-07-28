package com.epam.bdru2016.team2.mss.processing.fbenrichment

import com.epam.bdru2016.team2.mss.integration.cassandra.CassandraSettingsProvided
import com.epam.bdru2016.team2.mss.processing.fbenrichment.facebook.FacebookSettings
import com.epam.bdru2016.team2.mss.shared.AppSettingsProvider

/**
  * Created by Aleksander_Khanteev on 6/9/2016.
  */
class FbEnrichmentAppSettingsProvider(configPath:String)
  extends AppSettingsProvider(configPath)
  with CassandraSettingsProvided {


  def facebookSettings: Option[FacebookSettings] = {

    val cfg = getSectionOrThrow("facebook")
    Some(FacebookSettings(cfg.getString("token"), Some(cfg.getInt("words-limit"))))
  }

  def getOutputPath: String = {
    if (appCfg.hasPath("output-path")) appCfg.getString("output-path") else "/data/advertising/city_date_event_attendance"
  }


}
