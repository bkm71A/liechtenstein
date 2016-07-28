package com.epam.bdru2016.team2.mss.integrationtests.ingestion.streaming

import com.epam.bdru2016.team2.mss.ingestion.streaming.processors.BiddingEventEnrichmentProcessor
import com.epam.bdru2016.team2.mss.integration.hdfs.DictionaryLoader
import com.epam.bdru2016.team2.mss.model.entities.{BiddingBundle, BiddingEvent}
import com.epam.bdru2016.team2.mss.model.reference._
import com.epam.bdru2016.team2.mss.testing.fixtures.BiddingFixture
import com.epam.bdru2016.team2.mss.testing.spark.SparkStreamingSpec
import org.apache.spark.SparkContext
import org.apache.spark.rdd.RDD
import org.apache.spark.sql.{Dataset, Encoder, SQLContext}
import org.scalamock.scalatest.MockFactory
import org.scalatest.concurrent.Eventually
import org.scalatest.time.{Millis, Span}
import org.scalatest.{FeatureSpec, GivenWhenThen, Matchers}

import scala.collection.mutable
import scala.reflect.ClassTag

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
class BiddingEventEnrichmentProcessorSpec extends FeatureSpec with Matchers with SparkStreamingSpec with Eventually with GivenWhenThen with MockFactory {

  implicit override val patienceConfig =
    PatienceConfig(timeout = scaled(Span(20000, Millis)))

  feature("Message enrichment") {
    scenario("Creating a bundle with extended information") {

      Given("streaming context is initalized")
      val input = BiddingFixture.createEvent()

      val inputQueue = mutable.Queue[RDD[BiddingEvent]]()
      val results = mutable.ListBuffer.empty[BiddingBundle]

      BiddingEventEnrichmentProcessor
        .process(sc, new MockableDictionaryLoader())(ssc.queueStream(inputQueue, oneAtATime = true))
        .foreachRDD(rdd => results ++= rdd.collect())

      ssc.start()

      When("one message is queued")
      inputQueue.enqueue(sc.parallelize(Seq(input)))

      Then("message count after the first batch")
      advanceClockOneBatch()
      eventually {
        results.length should equal(1)
      }
    }
  }
}

class MockableDictionaryLoader extends DictionaryLoader(null) {

  def makeRDD[A : ClassTag](sc:SparkContext, item:A):RDD[A] = {
    sc.parallelize(Seq(item))
  }
  override def loadStates(sc:SparkContext) = {
    val sqlc = SQLContext.getOrCreate(sc)
    import sqlc.implicits._
    makeRDD(sc, DicState(79, "New York", 19651127, 1350286)).toDS()
  }
  override def loadCities(sc:SparkContext) = {
    val sqlc = SQLContext.getOrCreate(sc)
    import sqlc.implicits._
    makeRDD(sc, DicCity(1, "New York", 79, 8491079, 783.8f, 10430, 40.6643f, -73.9385f)).toDS()
  }
  override def loadLogTypes(sc:SparkContext) = {
    val sqlc = SQLContext.getOrCreate(sc)
    import sqlc.implicits._
    makeRDD(sc, DicLogType(0, "unknown")).toDS()
  }
  override def loadAdExchanges(sc:SparkContext) = {
      val sqlc = SQLContext.getOrCreate(sc)
      import sqlc.implicits._
      makeRDD(sc, DicAdExchange(3, "Baidu", "Baidu")).toDS()
  }
  override def loadTags(sc:SparkContext) = {
        val sqlc = SQLContext.getOrCreate(sc)
        import sqlc.implicits._
        makeRDD(sc, DicTags(282162995497L, "cars,auto", "", "", "", "")).toDS()
  }
  override def loadTagCategories(sc:SparkContext) = {
          val sqlc = SQLContext.getOrCreate(sc)
          import sqlc.implicits._
          makeRDD(sc, DicTagCategories(282162995497L, Array("cars","accessories"))).toDS()
  }
}