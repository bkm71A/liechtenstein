package com.epam.bdru2016.team2.mss.model.entities

import com.epam.bdru2016.team2.mss.model.reference._
import com.epam.bdru2016.team2.mss.shared.Clock
import org.apache.spark.mllib.linalg.Vector
import org.apache.spark.mllib.linalg.Vectors
import scala.collection.mutable

/**
  * Created by Aleksander_Khanteev on 5/25/2016.
  */
case class BiddingSession(
                           ipinyouId:String,
                           tsStart:Long,
                           tsEnd:Long,
                           tsCurrent:Long,
                           status:Byte,
                           extState:DicState,
                           extCity:DicCity,
                           extUserAgent: UserAgent,
                           adSlots:Seq[String],
                           adStats:AdStats,
                           bidCounters:Map[String, Long],
                           keywordCounters:Map[String,Long],
                           keywordCategoryCounters:Map[String,Long]) {

  def open(bidBundles:Seq[BiddingBundle]): BiddingSession = {

    val lastBid = bidBundles.last

    BiddingSession(bidBundles, Some(this), Some(Clock.getTime), BiddingSession.stateOpened)
  }

  def open:BiddingSession = {
    BiddingSession(this, tsCurrent, BiddingSession.stateOpened)
  }

  def isExpired:Boolean = {

    val currentTime = Clock.getTime
    currentTime - tsCurrent >= BiddingSession.sessionTimeout
  }

  def close() = {
    BiddingSession(this, this.tsCurrent, BiddingSession.stateClosed)
  }

  def extractFV(): Vector = {
    val siteImpressionCount = this.bidCounters.getOrElse("site-impression", 0L) * 1.0
    val siteClickCount = this.bidCounters.getOrElse("site-click", 0L) * 1.0
    val timeSpan = ((this.tsEnd - this.tsStart) * 1000.0).abs

    return Vectors.dense(0.0, 0.0, 0.0, timeSpan, 0.0, this.adStats.minWidth, 0.0, 0.0, this.adStats.maxHeight, 0.0, 0.0, this.extCity.id * 1.0, this.extCity.stateId * 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, siteImpressionCount, siteClickCount, 0.0, 0.0, 0.0, 0.0, 0.0, this.bidCounters.size, this.adSlots.size, this.keywordCategoryCounters.size, this.keywordCounters.size, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
  }
}

object BiddingSession {

  val sessionTimeout = 30 * 60 * 1000

  val maxBidsPerSession = 100

  val stateNew:Byte = 1
  val stateOpened:Byte = 2
  val stateClosed:Byte = 3

  private def mergeCounters[A](arr:Seq[A], map:Map[A,Long]):Map[A,Long] = {

    val mutableMap = mutable.HashMap(map.toArray:_*)

    arr.foreach(key => mutableMap.get(key) match {
      case Some(cnt) => mutableMap(key) = cnt + 1
      case None => mutableMap(key) = 1
    })

    mutableMap.toMap[A,Long]
  }

  def apply(existing:BiddingSession, currentTime:Long, state:Byte) = {
    new BiddingSession(
      existing.ipinyouId,
      existing.tsStart,
      existing.tsEnd,
      currentTime,
      state,
      existing.extState,
      existing.extCity,
      existing.extUserAgent,
      existing.adSlots,
      existing.adStats,
      existing.bidCounters,
      existing.keywordCounters,
      existing.keywordCategoryCounters
    )
  }


  def apply(bids:Seq[BiddingBundle], existing:Option[BiddingSession] = None, currentTime:Option[Long] = None, state:Byte = BiddingSession.stateNew) = {

    val firstBid = bids.head
    val lastBid = bids.last

    val newAds = bids.map(b => b.adSlotId).toSet
    val adSlots = newAds.union(if (existing.isEmpty) Set.empty[String] else existing.get.adSlots.toSet).toSeq

    val newBids = bids.map(b => b.extLogType.name)
    val bidCounters = mergeCounters(newBids, if (existing.isEmpty)  Map.empty[String, Long] else existing.get.bidCounters)

    val newKeywords = bids.flatMap(b => b.extUserTags.keywords)
    val keywordCounters = mergeCounters(newKeywords, if (existing.isEmpty)  Map.empty[String,Long] else existing.get.keywordCounters)

    val newKeywordCategories = bids.flatMap(b => b.keywordCategories)
    val keywordCategoryCounters = mergeCounters(newKeywordCategories, if (existing.isEmpty)  Map.empty[String, Long] else existing.get.keywordCategoryCounters)

    new BiddingSession(
      firstBid.ipinyouId,
      firstBid.ts,
      lastBid.ts,
      if (currentTime.isEmpty) Clock.getTime else currentTime.get,
      state,
      firstBid.extState,
      firstBid.extCity,
      firstBid.extUserAgent,
      adSlots,
      AdStats(bids, existing match {
        case None => None
        case Some(x) => Some(x.adStats)
      }),
      bidCounters,
      keywordCounters,
      keywordCategoryCounters
    )
  }
}

case class AdStats(
   minWidth:Int,
   maxWidth:Int,
   minHeight:Int,
   maxHeight:Int,
   minVisibility:Int,
   maxVisibility:Int
) {

  def merge(other:AdStats):AdStats = {
    AdStats(
      minWidth = Math.min(minWidth, other.minWidth),
      maxWidth = Math.max(maxWidth, other.maxWidth),
      minHeight = Math.min(minHeight, other.minHeight),
      maxHeight = Math.max(maxHeight, other.maxHeight),
      minVisibility = Math.max(minVisibility, other.minVisibility),
      maxVisibility = Math.min(maxVisibility, other.maxVisibility)
    )
  }
}


object AdStats {

  def apply(bids:Seq[BiddingBundle], existing:Option[AdStats]):AdStats = {

    val current = new AdStats(
      minWidth = bids.map(b => b.adSlotWidth).min,
      maxWidth = bids.map(b => b.adSlotWidth).max,
      minHeight = bids.map(b => b.adSlotHeight).min,
      maxHeight = bids.map(b => b.adSlotHeight).max,
      minVisibility = bids.map(b => b.adSlotVisibility).min,
      maxVisibility = bids.map(b => b.adSlotVisibility).max
    )

    existing match {
      case None => current
      case Some(oldStats) => current.merge(oldStats)
    }
  }
}

case class BiddingSessionWithPrediction(
                           ipinyouId:String,
                           tsStart:Long,
                           tsEnd:Long,
                           tsCurrent:Long,
                           status:Byte,
                           extState:DicState,
                           extCity:DicCity,
                           extUserAgent: UserAgent,
                           adSlots:Seq[String],
                           adStats:AdStats,
                           bidCounters:Map[String, Long],
                           keywordCounters:Map[String,Long],
                           keywordCategoryCounters:Map[String,Long],
                           prediction: Boolean) {
}

object BiddingSessionWithPrediction {

  def apply(parent: BiddingSession, prediction: Boolean):BiddingSessionWithPrediction = {

    new BiddingSessionWithPrediction(parent.ipinyouId,
      parent.tsStart, parent.tsEnd,
      parent.tsCurrent, parent.status,
      parent.extState, parent.extCity, parent.extUserAgent,
      parent.adSlots,
      parent.adStats,
      parent.bidCounters,
      parent.keywordCounters,
      parent.keywordCategoryCounters,
      prediction)
  }
}
