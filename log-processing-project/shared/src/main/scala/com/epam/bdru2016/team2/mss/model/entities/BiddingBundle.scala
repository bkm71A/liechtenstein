package com.epam.bdru2016.team2.mss.model.entities

import com.epam.bdru2016.team2.mss.model.reference._
import org.apache.spark.sql.types.Decimal
import org.joda.time.{DateTime, DateTimeZone}

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
class BiddingBundle(
                    val bidId:String,
                    val dt:Long,
                    val ts:Long,
                    val ipinyouId:String,
                    val userAgent:String,
                    val ip:String,
                    val region:Int,
                    val city:Int,
                    val adExchange:Byte,
                    val domain:String,
                    val url:String,
                    val anonymousUrl:String,
                    val adSlotId:String,
                    val adSlotWidth:Int,
                    val adSlotHeight:Int,
                    val adSlotVisibility:Int,
                    val adSlotFormat:Int,
                    val payingPrice:BigDecimal,
                    val creativeId:String,
                    val biddingPrice:BigDecimal,
                    val advertiserId:Int,
                    val userTags:Long,
                    val streamId:Int,

                    val extState:DicState,
                    val extCity:DicCity,
                    val extLogType: DicLogType,
                    val extAdExchange: DicAdExchange,
                    val extUserTags:DicTags,
                    val extUserAgent:UserAgent,
                    val keywordCategories:Seq[String]
) extends Product
  //For Spark it has to be Serializable
  with Serializable {

  private def getDateTime = new DateTime(ts, DateTimeZone.UTC)
  private def getLocalDate = getDateTime.toLocalDate

  def canEqual(that: Any) = that.isInstanceOf[BiddingBundle]

  def productArity = 29 // number of columns

  def productElement(idx: Int) = idx match {
    case 0 => bidId
    case 1 => ts
    case 2 => ipinyouId
    case 3 => userAgent
    case 4 => ip
    case 5 => region
    case 6 => city
    case 7 => adExchange
    case 8 => domain
    case 9 => url
    case 10 => anonymousUrl
    case 11 => adSlotId
    case 12 => adSlotWidth
    case 13 => adSlotHeight
    case 14 => adSlotVisibility
    case 15 => adSlotFormat
    case 16 => payingPrice
    case 17 => creativeId
    case 18 => biddingPrice
    case 19 => advertiserId
    case 20 => userTags
    case 21 => streamId

    case 22 => extState
    case 23 => extCity
    case 24 => extLogType
    case 25 => extAdExchange
    case 26 => extUserTags
    case 27 => extUserAgent
    case 28 => keywordCategories
  }
}

object BiddingBundle {

  def apply(biddingEvent:BiddingEvent,
            extState:DicState,
            extCity:DicCity,
            extLogType: DicLogType,
            extAdExchange: DicAdExchange,
            extUserTags:DicTags,
            extUserAgent:UserAgent,
            keywordCategories: Seq[String]
           ): BiddingBundle ={

    new BiddingBundle(
      biddingEvent.bidId,
      biddingEvent.dt,
      biddingEvent.ts,
      biddingEvent.ipinyouId,
      biddingEvent.userAgent,
      biddingEvent.ip,
      biddingEvent.region,
      biddingEvent.city,
      biddingEvent.adExchange,
      biddingEvent.domain,
      biddingEvent.url,
      biddingEvent.anonymousUrl,
      biddingEvent.adSlotId,
      biddingEvent.adSlotWidth,
      biddingEvent.adSlotHeight,
      biddingEvent.adSlotVisibility,
      biddingEvent.adSlotFormat,
      biddingEvent.payingPrice,
      biddingEvent.creativeId,
      biddingEvent.biddingPrice,
      biddingEvent.advertiserId,
      biddingEvent.userTags,
      biddingEvent.streamId,

      extState,
      extCity,
      extLogType,
      extAdExchange,
      extUserTags,
      extUserAgent,
      keywordCategories
    )
  }
}

