package com.epam.bdru2016.team2.mss.ingestion.streaming.processors

import com.epam.bdru2016.team2.mss.integration.hdfs.{DictionaryLoader, DictionaryProvider}
import com.epam.bdru2016.team2.mss.model.entities.{BiddingBundle, BiddingEvent}
import com.epam.bdru2016.team2.mss.model.reference._
import org.apache.spark.SparkContext
import org.apache.spark.broadcast.Broadcast
import org.apache.spark.sql.Dataset
import org.apache.spark.streaming.Seconds
import org.apache.spark.streaming.dstream.DStream

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
object BiddingEventEnrichmentProcessor {

  def process(sc:SparkContext, dictionaryLoader: DictionaryLoader)(input:DStream[BiddingEvent]) = {

    val dictProvider = new DictionaryProvider(dictionaryLoader)

    input.transform(
      rdd => {

        val sc = rdd.sparkContext
        val states = dictProvider.getStates(sc)
        val cities = dictProvider.getCities(sc)
        val logTypes = dictProvider.getLogTypes(sc)
        val adExchanges = dictProvider.getAdExchanges(sc)
        val tags = dictProvider.getTags(sc)
        val tagCategories = dictProvider.getTagCategories(sc)

        val blacklist = WordBlacklist.getInstance(rdd.sparkContext)

        rdd.map(x => {

          blacklist.value.contains("12")

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
    )
  }
}



object WordBlacklist {

  @volatile private var instance: Broadcast[Seq[String]] = null

  def getInstance(sc: SparkContext): Broadcast[Seq[String]] = {
    if (instance == null) {
      synchronized {
        if (instance == null) {
          val wordBlacklist = Seq("a", "b", "c")
          instance = sc.broadcast(wordBlacklist)
        }
      }
    }
    instance
  }
}

