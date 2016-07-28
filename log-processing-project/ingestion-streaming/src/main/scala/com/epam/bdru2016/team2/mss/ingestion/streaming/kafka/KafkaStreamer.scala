package com.epam.bdru2016.team2.mss.ingestion.streaming.kafka

import com.epam.bdru2016.team2.mss.shared.AppSettingsProvider
import kafka.serializer.StringDecoder
import org.apache.spark.streaming.StreamingContext
import org.apache.spark.streaming.dstream.DStream
import org.apache.spark.streaming.kafka.KafkaUtils

/**
  * Created by Aleksander_Khanteev on 5/25/2016.
  */
object KafkaStreamer {

  def getStream(ssc: StreamingContext, opts:KafkaSettings):DStream[(String,String)] = {

    //configuring stream
    val kafkaParams = Map("metadata.broker.list" -> opts.broker)

    // Define which topics to read from
    val topics = Set(opts.topic)

    // Create the direct stream with the Kafka parameters and topics
    KafkaUtils.createDirectStream[String, String, StringDecoder, StringDecoder](ssc, kafkaParams, topics)
  }
}

case class KafkaSettings(broker:String, topic:String)

trait KafkaSettingsProvided {
  this:AppSettingsProvider =>

  def kafkaSettings:KafkaSettings = {

    val cfg = this.getSectionOrThrow("kafka")

    val broker = cfg.getString("broker")
    val topic = cfg.getString("topic")

    KafkaSettings(broker, topic)
  }
}