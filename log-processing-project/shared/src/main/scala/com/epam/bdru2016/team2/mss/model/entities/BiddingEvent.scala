package com.epam.bdru2016.team2.mss.model.entities

import com.epam.bdru2016.team2.mss.model.utils.DateTimeUtils

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
class BiddingEvent(
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
                           val streamId:Int)
  extends Product with Serializable {

                             def canEqual(that: Any) = that.isInstanceOf[BiddingBundle]

                             def productArity = 23 // number of columns

                             def productElement(idx: Int) = idx match {
                             case 0 => bidId
                             case 1 => dt
                             case 2 => ts
                             case 3 => ipinyouId
                             case 4 => userAgent
                             case 5 => ip
                             case 6 => region
                             case 7 => city
                             case 8 => adExchange
                             case 9 => domain
                             case 10 => url
                             case 11 => anonymousUrl
                             case 12 => adSlotId
                             case 13 => adSlotWidth
                             case 14 => adSlotHeight
                             case 15 => adSlotVisibility
                             case 16 => adSlotFormat
                             case 17 => payingPrice
                             case 18 => creativeId
                             case 19 => biddingPrice
                             case 20 => advertiserId
                             case 21 => userTags
                             case 22 => streamId
                           }

  def hasIpinyouId = ipinyouId != null && !ipinyouId.isEmpty && !ipinyouId.equals("null")

}


object BiddingEvent {

  def apply(message:String) : BiddingEvent = {

    val fields = message.split("\t")

    createBiddingEvent(fields)
  }

  def apply(fields: Array[String]) : BiddingEvent = {
    createBiddingEvent(fields)
  }

  def transformTs(tsString:String):Long = {
    tsString match {
      case x if x.startsWith("201") =>
        val date = DateTimeUtils.parseDateTime(x)
        date.getMillis
      case x => x.toLong
    }
  }

  private def createBiddingEvent(fields: Array[String]) : BiddingEvent = {

    val ts = transformTs(fields(1))

    new BiddingEvent(
      fields(0),
      DateTimeUtils.getDatePart(ts),
      ts,
      fields(2),
      fields(3),
      fields(4),
      fields(5).toInt,
      fields(6).toInt,
      fields(7).toByte,
      fields(8),
      fields(9),
      fields(10),
      fields(11),
      fields(12).toInt,
      fields(13).toInt,
      fields(14).toInt,
      fields(15).toInt,
      BigDecimal(fields(16)),
      fields(17),
      BigDecimal(fields(18)),
      fields(19).toInt,
      fields(20).toLong,
      fields(21).toInt
    )
  }

}
