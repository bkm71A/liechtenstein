package com.epam.bdru2016.team2.mss.integration.hdfs

import com.epam.bdru2016.team2.mss.model.reference.{DicTagCategories, _}
import org.apache.spark.SparkContext
import org.apache.spark.broadcast.Broadcast
import org.apache.spark.sql.Dataset

/**
  * Created by Aleksander_Khanteev on 6/7/2016.
  */
class DictionaryProvider(dictionaryLoader: DictionaryLoader) extends Serializable {

  @volatile private var states: Broadcast[Map[Int,DicState]] = null
  @volatile private var cities: Broadcast[Map[Int,DicCity]] = null
  @volatile private var tags: Broadcast[Map[Long,DicTags]] = null
  @volatile private var adExchanges: Broadcast[Map[Byte,DicAdExchange]] = null
  @volatile private var logTypes: Broadcast[Map[Int,DicLogType]] = null
  @volatile private var categories: Broadcast[Map[Long, DicTagCategories]] = null

  private def getInstance[A](predicate:() => Boolean)(createFunc: => Unit)(instanceFunc: => Broadcast[A]): Broadcast[A] = {
    if (predicate()) {
      synchronized {
        if (predicate()) {
          createFunc
        }
      }
    }
    instanceFunc
  }

  private def broadcastAsMap[B,A](sc:SparkContext, data:Dataset[A])(getId:A=>B): Broadcast[Map[B,A]] = {

    val map = data.collect().map(x => getId(x) -> x).toMap
    sc.broadcast(map)
  }

  def getStates(sc:SparkContext) = getInstance (() => states == null ) {states = broadcastAsMap(sc, dictionaryLoader.loadStates(sc))(x => x.id) } { states }
  def getCities(sc:SparkContext) = getInstance (() => cities == null ) {cities = broadcastAsMap(sc, dictionaryLoader.loadCities(sc))(x => x.id) } { cities }
  def getLogTypes(sc:SparkContext) = getInstance (() => logTypes == null ) {logTypes = broadcastAsMap(sc, dictionaryLoader.loadLogTypes(sc))(x => x.id) } { logTypes }
  def getAdExchanges(sc:SparkContext) = getInstance (() => adExchanges == null ) {adExchanges = broadcastAsMap(sc, dictionaryLoader.loadAdExchanges(sc))(x => x.id) } { adExchanges }
  def getTags(sc:SparkContext) = getInstance (() => tags == null ) {tags = broadcastAsMap(sc, dictionaryLoader.loadTags(sc))(x => x.id) } { tags }
  def getTagCategories(sc:SparkContext) = getInstance(() => categories == null) { categories = broadcastAsMap(sc, dictionaryLoader.loadTagCategories(sc))(x => x.id) } { categories }
}
