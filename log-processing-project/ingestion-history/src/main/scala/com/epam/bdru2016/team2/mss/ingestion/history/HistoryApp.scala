package com.epam.bdru2016.team2.mss.ingestion.history

import com.epam.bdru2016.team2.mss.ingestion.history.processors.{BiddingBundleProcessor, BiddingSessionProcessor}
import com.epam.bdru2016.team2.mss.integration.cassandra.{CassandraFacade, CassandraSettingsProvided}
import com.epam.bdru2016.team2.mss.integration.hdfs.DictionarySettingsProvided
import com.epam.bdru2016.team2.mss.model.KryoRegistrator
import com.epam.bdru2016.team2.mss.model.entities.BiddingBundle
import com.epam.bdru2016.team2.mss.shared.AppSettingsProvider
import org.apache.spark.rdd.RDD
import org.apache.spark.sql._
import org.apache.spark.storage.StorageLevel
import org.apache.spark.{Logging, SparkConf, SparkContext}

/**
  * Created by Vitaliy_Zinchenko on 6/6/2016.
  */
object HistoryApp extends App with Logging {

  //set up configuration
  val settings = (if (args.length > 0) args(0)
                          else "cfg/history.dev.conf") match {
    case confPath if confPath != null && !confPath.isEmpty =>
      new HistoryAppSettingsProvider(confPath)
    case _ =>
      throw new IllegalArgumentException(
          "Configuration path must be specified as a first argument!")
  }

  val conf =
    new SparkConf()
      .setMaster(settings.getMaster)
      .setAppName("HistoryApp")
      .set("spark.cassandra.connection.host", settings.cassandraSettings.host)
      .set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")

  KryoRegistrator.registerAllModels(conf)

  val sc = new SparkContext(conf)
  val sqlc = new SQLContext(sc)

  run()

  def run(): Unit = {

    val biddingBundles: RDD[BiddingBundle] =
      BiddingBundleProcessor.process(sc, sqlc, settings)

    //Leads to ClassNotFoundException, see https://issues.apache.org/jira/browse/SPARK-10722
    //biddingBundles.persist(StorageLevel.MEMORY_AND_DISK_SER)

    CassandraFacade.saveBiddingBundles(
        biddingBundles, settings.cassandraSettings)

    val biddingSessions =
      BiddingSessionProcessor.process(biddingBundles)

    CassandraFacade.saveBiddingSession(
      biddingSessions, settings.cassandraSettings)

    sc.stop()
  }
}

