package com.epam.bdru2016.team2.mss.processing.esindexer

import com.epam.bdru2016.team2.mss.integration.elasticsearch.{ESFacade, ESSettings}
import com.epam.bdru2016.team2.mss.model.KryoRegistrator
import com.epam.bdru2016.team2.mss.model.entities.BiddingBundle
import org.apache.spark.{Logging, SparkConf, SparkContext}


/**
  * Created by Aleksander_Khanteev on 4/22/2016.
  */
object ESIndexerApp extends App with Logging {

  val settings = (if (args.length > 0) args(0) else "cfg/esindexer.dev.conf") match {
    case confPath if confPath != null && !confPath.isEmpty => new ESIndexerSettingsProvider(confPath)
    case _ => throw new IllegalArgumentException("Configuration path must be specified as a first argument!")
  }

  val conf = new SparkConf()
    .setMaster(settings.getMaster)
    .setAppName(this.getClass.getSimpleName)
    .set("spark.cassandra.connection.host", settings.cassandraSettings.host)
    .set("es.nodes", settings.esSettings.host)
    .set("es.index.auto.create", "true")
    .set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")

  KryoRegistrator.registerAllModels(conf)

  val sc = new SparkContext(conf)
  import com.datastax.spark.connector._

  run()

  def run() {

    val input =
      sc.cassandraTable[BiddingBundle](settings.cassandraSettings.keyspace, "bidding_bundle")

    //filtering input
    val startTs = settings.getStartTimestamp
    val endTs = settings.getEndTimestamp

    println(s"Indexing events with timestamp between $startTs and $endTs")
    val filteredInput = input.filter(x => x.ts >= startTs && x.ts < endTs)

    ESFacade.saveBiddingBundles(filteredInput)

    sc.stop()
  }

}


