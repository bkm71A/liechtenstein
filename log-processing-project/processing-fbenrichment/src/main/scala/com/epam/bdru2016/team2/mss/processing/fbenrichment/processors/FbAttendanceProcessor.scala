package com.epam.bdru2016.team2.mss.processing.fbenrichment.processors

import com.epam.bdru2016.team2.mss.model.reference.DicCity
import com.epam.bdru2016.team2.mss.processing.fbenrichment.facebook.{FacebookSettings, FbFacade}
import org.apache.spark.Logging
import org.apache.spark.rdd.RDD
import org.joda.time.{DateTime, DateTimeZone}

/**
  * Created by Aleksander_Khanteev on 6/6/2016.
  */
object FbAttendanceProcessor extends Logging {

  private val DFAULT_WORDS_LIMIT = 100

  def process(input:RDD[FbBiddingBundle], fbSettings:Option[FacebookSettings]):RDD[CityDateKeywordAttendance] = {

    val wordsLimit = fbSettings match {
      case Some(x) => x.wordsLimit match {
        case Some(y) => y
        case None => DFAULT_WORDS_LIMIT
      }
      case None => DFAULT_WORDS_LIMIT
    }

    val output =
      input
        .map(x => (x.city -> x.getLocalDate.toDate.getTime) -> x)
        .reduceByKey((x,y) =>
            FbBiddingBundle(
              x.bidId,
              x.getLocalDate.toDate.getTime,
              (x.keywordCategories ++ y.keywordCategories).take(wordsLimit),
              x.city,
              x.extCity), 10)
        .groupBy(x => x._1)
        .map(coll => CityAttendanceMapper.mapCityAttendance(coll._2.map(x => x._2).toArray, fbSettings))
        .flatMap(x => x)

    output
  }
}

object CityAttendanceMapper {

  def mapCityAttendance(
                         input:Array[FbBiddingBundle],
                         fbSettings:Option[FacebookSettings]
                       ): Array[CityDateKeywordAttendance] = {


    val dateCategoryMap = input
      .map(x => x.getLocalDate -> x.keywordCategories)
      .toMap
    val uniqueKeywords = dateCategoryMap.flatMap{ case(dt, keywords) => keywords}.toArray.distinct

    val city = input.head.extCity

    val keywordAttendanceMap =
      if (city.id > 0) getAttendance(uniqueKeywords, city, fbSettings) else {
        Map.empty[String,Int]
      }

    input.map(
      x => {
        val keywordAttendance = dateCategoryMap(x.getLocalDate)
          .map(kw => kw -> keywordAttendanceMap.getOrElse(kw, 0))
          .sortBy { case (kw, cnt) => -cnt }
          .toMap
        val totalAttendance = keywordAttendance.values.sum

        CityDateKeywordAttendance(x.city, x.getLocalDate.toDateTimeAtStartOfDay.getMillis, totalAttendance, keywordAttendance)
      })
  }

  def getAttendance(
                     keywords:Array[String],
                     city:DicCity,
                     facebookSettings: Option[FacebookSettings]
                   ): Map[String,Int] = {

    facebookSettings match {
      case Some(settings) =>
        //working with real FB API
        val fbFacade = new FbFacade(facebookSettings.get.token)
        val keywordPlacesMap = fbFacade.getPlaces(keywords, city.latitude -> city.longitude, city.getSearchDistance)
        fbFacade.getEvents(keywordPlacesMap)
      case None =>
        //using fake FB data
        val rnd = scala.util.Random
        keywords.map(kw => kw -> rnd.nextInt(10000)).toMap
    }
  }
}

case class CityDateKeywordAttendance(cityId:Int, date:Long, totalAttendance:Int, keywordAttendance: scala.collection.Map[String,Int])
case class FbBiddingBundle(bidId:String, ts:Long, keywordCategories:Seq[String], city:Int, extCity:DicCity) {
  def getDateTime = new DateTime(ts, DateTimeZone.UTC)
  def getLocalDate = getDateTime.toLocalDate
}
