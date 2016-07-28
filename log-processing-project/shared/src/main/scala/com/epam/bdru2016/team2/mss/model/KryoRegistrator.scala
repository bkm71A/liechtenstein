package com.epam.bdru2016.team2.mss.model

import com.epam.bdru2016.team2.mss.model.entities.{BiddingBundle, BiddingEvent, BiddingSession}
import com.epam.bdru2016.team2.mss.model.reference._
import org.apache.spark.SparkConf

/**
  * Created by Aleksander_Khanteev on 6/2/2016.
  */
object KryoRegistrator {

  def registerReferences(conf:SparkConf):Unit = {
    conf.registerKryoClasses(Array(
      classOf[DicAdExchange],
      classOf[DicCity],
      classOf[DicLogType],
      classOf[DicState],
      classOf[DicTagCategories],
      classOf[DicTags]
    ))
  }

  def registerEntities(conf:SparkConf):Unit = {

    conf.registerKryoClasses(Array(
      classOf[BiddingEvent],
      classOf[BiddingBundle],
      classOf[BiddingSession]
    ))
  }

  def registerAllModels(conf:SparkConf):Unit = {
    registerReferences(conf)
    registerEntities(conf)
  }
}
