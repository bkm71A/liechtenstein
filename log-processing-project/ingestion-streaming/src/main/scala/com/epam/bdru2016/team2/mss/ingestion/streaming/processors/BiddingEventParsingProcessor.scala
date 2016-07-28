package com.epam.bdru2016.team2.mss.ingestion.streaming.processors

import com.epam.bdru2016.team2.mss.model.entities.BiddingEvent
import org.apache.spark.streaming.dstream.DStream

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
object BiddingEventParsingProcessor {

  def process(input:DStream[(String,String)]): DStream[BiddingEvent] = {

    input.map { case(key, message) => BiddingEvent(message)}
  }
}
