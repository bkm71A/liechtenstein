package com.epam.bdru2016.team2.mss.model.reference

/**
  * Created by Aleksander_Khanteev on 5/21/2016.
  */
case class DicTags(id: Long, keywords:Seq[String], status:String, pricingType:String, matchType:String, destinationUrl:String)
object DicTags {
  val empty = DicTags(0,Seq.empty[String],"","","","")

  def apply(id: Long, keywords:String, status:String, pricingType:String, matchType:String, destinationUrl:String) = {
    new DicTags(id, keywords.split(","), status, pricingType, matchType, destinationUrl)
  }
  def apply(items: Array[String]): DicTags = {
    DicTags(
      items(0).toLong,
      items(1),
      items(2),
      items(3),
      items(4),
      items(5)
    )
  }
}

case class DicCity(id: Int, name: String, stateId: Int, population:Int, area:Float, density:Float, latitude:Float, longitude:Float) {
  def getSearchDistance : Int = {
    Math.sqrt(area).toInt * 1000
  }
}
object DicCity {
  val empty: DicCity = {
    DicCity(0, "", 0,0,0,0,0,0)
  }
  def apply(items: Array[String]) : DicCity = {
    DicCity(
      items(0).toInt,
      items(1),
      items(2).toInt,
      items(3).toInt,
      items(4).toFloat,
      items(5).toFloat,
      items(6).toFloat,
      items(7).toFloat
    )
  }
}

case class DicAdExchange(id:Byte, name:String, description:String)
object DicAdExchange {
  val empty = DicAdExchange(0,"","")
  def apply(items: Array[String]): DicAdExchange = {
    DicAdExchange(
      items(0).toByte,
      items(1),
      items(2)
    )
  }
}

case class DicLogType(id:Int, name:String)
object DicLogType {
  val empty = DicLogType(0,"")
  def apply(items: Array[String]): DicLogType = {
    DicLogType(
      items(0).toInt,
      items(1)
    )
  }
}

case class DicState(id:Int, name:String, population:Int, gsp:Int)
object DicState {
  val empty = DicState(0,"unknown",0,0)
  def apply(items: Array[String]): DicState = {
    DicState(
      items(0).toInt,
      items(1),
      items(2).toInt,
      items(3).toInt
    )
  }
}

case class DicTagCategories(id:Long, categories:Array[String])
