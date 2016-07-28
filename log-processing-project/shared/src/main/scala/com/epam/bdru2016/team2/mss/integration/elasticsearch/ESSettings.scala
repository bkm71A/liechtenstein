package com.epam.bdru2016.team2.mss.integration.elasticsearch

import com.epam.bdru2016.team2.mss.shared.AppSettingsProvider

/**
  * Created by Aleksander_Khanteev on 6/9/2016.
  */
case class ESSettings(host:String)

trait ESSettingsProvided {

  this: AppSettingsProvider =>

  def esSettings:ESSettings = {

    val cfg = this.getSectionOrThrow("elastic")

    val host = cfg.getString("host")

    ESSettings(host)
  }
}