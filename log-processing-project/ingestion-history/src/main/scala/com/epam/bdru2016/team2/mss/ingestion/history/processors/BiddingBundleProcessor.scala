package com.epam.bdru2016.team2.mss.ingestion.history.processors

import com.epam.bdru2016.team2.mss.ingestion.history.HistoryAppSettingsProvider
import com.epam.bdru2016.team2.mss.integration.hdfs.{DictionaryLoader, DictionaryProvider, LogsLoader}
import com.epam.bdru2016.team2.mss.model.entities.{BiddingBundle, BiddingEvent}
import com.epam.bdru2016.team2.mss.model.reference.{UserAgent, _}
import org.apache.spark.SparkContext
import org.apache.spark.rdd.RDD
import org.apache.spark.sql.SQLContext

object BiddingBundleProcessor {

  def process(sc: SparkContext, sqlc: SQLContext, settingsProvider: HistoryAppSettingsProvider) : RDD[BiddingBundle] = {

    import sqlc.implicits._

    val logsLoader = new LogsLoader(settingsProvider.dwhPath)
    val logs = logsLoader.loadLogsDF(sc).as[BiddingEvent].rdd

    val dictProvider = new DictionaryProvider(new DictionaryLoader(settingsProvider.dictSettings))

    val states = dictProvider.getStates(sc)
    val cities = dictProvider.getCities(sc)
    val logTypes = dictProvider.getLogTypes(sc)
    val adExchanges = dictProvider.getAdExchanges(sc)
    val tags = dictProvider.getTags(sc)
    val tagCategories = dictProvider.getTagCategories(sc)

    logs
      .filter(x => x.hasIpinyouId && x.streamId != 0)
      .map(x => {

      val city = cities.value.getOrElse(x.city, DicCity.empty)
      val state = states.value.getOrElse(city.stateId, DicState.empty)

      val categories = tagCategories.value.get(x.userTags) match {
        case Some(tc) => tc.categories
        case None => Array.empty[String]
      }

      BiddingBundle(
        x,
        state,
        city,
        logTypes.value.getOrElse(x.streamId, DicLogType.empty),
        adExchanges.value.getOrElse(x.adExchange, DicAdExchange.empty),
        tags.value.getOrElse(x.userTags, DicTags.empty),
        UserAgent(x.userAgent),
        categories
      )
    })
  }
}
