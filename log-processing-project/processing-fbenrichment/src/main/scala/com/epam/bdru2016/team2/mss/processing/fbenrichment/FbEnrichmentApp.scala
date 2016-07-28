package com.epam.bdru2016.team2.mss.processing.fbenrichment

import com.epam.bdru2016.team2.mss.integration.cassandra.{CassandraSettings, CassandraSettingsProvided}
import com.epam.bdru2016.team2.mss.processing.fbenrichment.processors.{CityDateKeywordAttendance, FbAttendanceProcessor, FbBiddingBundle}
import com.epam.bdru2016.team2.mss.shared.AppSettingsProvider
import org.apache.spark.sql.SQLContext
import org.apache.spark.{Logging, SparkConf, SparkContext}


/**
  * Created by Aleksander_Khanteev on 4/22/2016.
  */
object FbEnrichmentApp extends App with Logging {

  val settings = (if (args.length > 0) args(0) else "cfg/fbenrichment.dev.conf") match {
    case confPath if confPath != null && !confPath.isEmpty => new FbEnrichmentAppSettingsProvider(confPath)
    case _ => throw new IllegalArgumentException("Configuration path must be specified as a first argument!")
  }

  val conf = new SparkConf().setMaster(settings.getMaster).setAppName("StreamingApp")
    .set("spark.cassandra.connection.host", settings.cassandraSettings.host)
    .set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
    .registerKryoClasses(Array(classOf[FbBiddingBundle], classOf[CityDateKeywordAttendance]))

  val sc = new SparkContext(conf)
  val sqlc = SQLContext.getOrCreate(sc)
  import sqlc.implicits._

  import com.datastax.spark.connector._

  run()

  def run() {

    val input =
      sc.cassandraTable[FbBiddingBundle](settings.cassandraSettings.keyspace, "bidding_bundle")

    val result = FbAttendanceProcessor.process(input, settings.facebookSettings)

    result
      .toDF()
      .write
      .format("parquet")
      .save(settings.getOutputPath)
  }

  sc.stop()
}


