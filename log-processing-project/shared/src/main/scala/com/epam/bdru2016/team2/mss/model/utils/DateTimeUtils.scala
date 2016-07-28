package com.epam.bdru2016.team2.mss.model.utils

import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat

/**
  * Created by Aleksander_Khanteev on 6/9/2016.
  */
object DateTimeUtils {

  private val pattern = "yyyyMMddHHmmssSSS"
  private val formatter = DateTimeFormat.forPattern(pattern).withZoneUTC()

  def parseDateTimeWithPadding(tsString:String) : DateTime = {

    val tsCleanString = tsString.replaceAll("[^0-9]","")

    if (tsCleanString.length < 6) {
      throw new IllegalArgumentException(s"Timestamp string must contain at least 6 symbols. Got '$tsCleanString' instead.")
    }

    val tsStringPadded = tsCleanString.padTo(pattern.length, "0").mkString

    parseDateTime(tsStringPadded)
  }

  def parseDateTime(tsString:String) : DateTime = {
    formatter.parseDateTime(tsString)
  }

  def getDatePart(ts:Long):Long = {
    (ts / (86400*1000)) * 86400*1000
  }
}
