package com.epam.bdru2016.team2.mss.integrationtests.ingestion.streaming

import com.epam.bdru2016.team2.mss.ingestion.streaming.processors.BiddingSessionizationProcessor
import com.epam.bdru2016.team2.mss.model.entities.{BiddingBundle, BiddingSession}
import com.epam.bdru2016.team2.mss.shared.Clock
import com.epam.bdru2016.team2.mss.testing.fixtures.BiddingFixture
import com.epam.bdru2016.team2.mss.testing.mocks.SparkClockImpl
import com.epam.bdru2016.team2.mss.testing.spark.SparkStreamingSpec
import org.apache.spark.rdd.RDD
import org.scalatest.concurrent.Eventually
import org.scalatest.time.{Millis, Span}
import org.scalatest.{FeatureSpec, GivenWhenThen, Matchers}

import scala.collection.mutable

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
class BiddingSessionizationProcessorSpec extends FeatureSpec with Matchers with SparkStreamingSpec with Eventually with GivenWhenThen {

  implicit override val patienceConfig =
    PatienceConfig(timeout = scaled(Span(5000, Millis)))

  override def beforeAll(): Unit = {
    super.beforeAll()
  }

  override def afterAll(): Unit = {

    super.afterAll()
  }

  feature("Sessionization") {

    scenario("Sessionizing 2 messages from different batches") {

      Given("streaming context is initalized")

      val firstEvent = BiddingFixture.createBundle("user1", 1370476800L)
      val secondEvent = BiddingFixture.createBundle("user1", 1370476800L + 1000)

      val inputQueue = mutable.Queue[RDD[BiddingBundle]]()
      val results = mutable.ListBuffer.empty[BiddingSession]

      BiddingSessionizationProcessor
        .process(ssc.queueStream(inputQueue, oneAtATime = true))
        .foreachRDD(rdd => results ++= rdd.collect())

      Clock.clockImpl = new SparkClockImpl(ssc)
      ssc.start()

      When("first message is queued")
      inputQueue.enqueue(sc.parallelize(Seq(firstEvent)))

      Then("I should see a new session")
      advanceClockOneBatch()
      eventually {
        results.length should equal(1)
        val session = results.head
        session.status should equal(BiddingSession.stateNew)
      }
      results.clear()

      When("second message is queued")
      inputQueue.enqueue(sc.parallelize(Seq(secondEvent)))

      Then("I should see an opened session")
      advanceClockOneBatch()
      eventually {

        results.length should be > 0
        val session = results.head
        session.status should equal(BiddingSession.stateOpened)
      }
      results.clear()
    }
  }

}