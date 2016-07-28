package com.epam.bdru2016.team2.mss.ingestion.streaming

import java.nio.file.Files

import com.epam.bdru2016.team2.mss.ingestion.streaming.kafka.KafkaStreamer
import com.epam.bdru2016.team2.mss.ingestion.streaming.processors._
import com.epam.bdru2016.team2.mss.integration.cassandra.CassandraFacade
import com.epam.bdru2016.team2.mss.integration.elasticsearch.ESFacade
import com.epam.bdru2016.team2.mss.integration.hdfs.DictionaryLoader
import com.epam.bdru2016.team2.mss.model.KryoRegistrator
import com.epam.bdru2016.team2.mss.model.entities.BiddingSession
import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.{Logging, SparkConf}


/**
  * Created by Aleksander_Khanteev on 5/18/2016.
  */
object StreamingApp extends App with Logging  {

  //set up configuration
  val settings = (if (args.length > 0) args(0) else "cfg/app.dev.conf") match {
    case confPath if confPath != null && !confPath.isEmpty => new StreamingAppSettingsProvider(confPath)
    case _ => throw new IllegalArgumentException("Configuration path must be specified as a first argument!")
  }

  val sparkSettings = settings.getSparkSettings match {
    case Some(x) => x
    case None => SparkStreamingSettings(checkpointDir)
  }

  val conf = new SparkConf()
    //.setMaster("local[4]")
    .setAppName("StreamingApp")
    .set("spark.cassandra.connection.host", settings.cassandraSettings.host)
    .set("es.nodes", settings.esSettings.host)
    .set("es.index.auto.create", "true")
    .set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")

  KryoRegistrator.registerAllModels(conf)

  val ssc = new StreamingContext(conf, Seconds(10))
  ssc.checkpoint(checkpointDir)
  val sc = ssc.sparkContext

  run()

  def run() {

    //configuring pipeline
    val inputStream = KafkaStreamer.getStream(ssc, settings.kafkaSettings)
    val biddingEvents = BiddingEventParsingProcessor.process(inputStream)
    val filteredBiddingEvents = BiddingEventFilteringProcessor.process(biddingEvents)

    val dictionaryLoader = new DictionaryLoader(settings.dictSettings)
    val biddingBundles = BiddingEventEnrichmentProcessor.process(sc, dictionaryLoader)(filteredBiddingEvents)

    val savedBundles = biddingBundles.transform(rdd => {
      ESFacade.saveBiddingBundles(rdd)
      CassandraFacade.saveBiddingBundles(rdd, settings.cassandraSettings)
      rdd
    })

    val sessions = BiddingSessionizationProcessor.process(savedBundles)

    val savedSessions = sessions.transform(rdd => {
      CassandraFacade.saveBiddingSession(rdd.filter(r => r.status == BiddingSession.stateClosed), settings.cassandraSettings)
      ESFacade.savePredictedSessions(BiddingSessionMLProcessor.process(rdd, settings.getMLSettings.modelDir))
      rdd
    })

    savedSessions.foreachRDD(rdd => println(s"Processed ${rdd.count()} events!"))

    // Start the computation
    ssc.start()
    // Wait for the computation to terminate
    ssc.awaitTermination()
  }

  def checkpointDir: String =  settings.getSparkSettings match {
    case Some(x) => x.checkpointDir
    case None => Files.createTempDirectory(this.getClass.getSimpleName).toUri.toString
  }
}







