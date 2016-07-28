package com.epam.bdru2016.team2.mss.ingestion.streaming.processors

import com.epam.bdru2016.team2.mss.model.entities.BiddingEvent
import org.apache.spark.streaming.dstream.DStream

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
object BiddingEventFilteringProcessor {

  def process(input:DStream[BiddingEvent]): DStream[BiddingEvent] = {

    input.filter(x => x.hasIpinyouId && x.streamId != 0)
  }
}
