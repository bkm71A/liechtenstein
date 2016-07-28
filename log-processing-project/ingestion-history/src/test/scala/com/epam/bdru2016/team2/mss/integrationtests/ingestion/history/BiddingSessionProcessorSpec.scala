package com.epam.bdru2016.team2.mss.integrationtests.ingestion.history

import java.util.UUID

import com.epam.bdru2016.team2.mss.ingestion.history.processors.BiddingSessionProcessor
import com.epam.bdru2016.team2.mss.integration.elasticsearch.ESSettings
import com.epam.bdru2016.team2.mss.model.entities.BiddingSession
import com.epam.bdru2016.team2.mss.testing.fixtures.BiddingFixture
import com.epam.bdru2016.team2.mss.testing.spark.SparkSqlSpec
import org.apache.spark.Logging
import org.scalatest.{FeatureSpec, GivenWhenThen, Matchers}

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
class BiddingSessionProcessorSpec extends FeatureSpec with Matchers with SparkSqlSpec with GivenWhenThen with Logging {

  val settings = ESSettings("mss_test")


  feature("Grouping bidding bundles into sessions") {
    scenario("Process in separate sessions when time between events is greater than session timeout.") {

      Given("A bundle")
      val bundle1 = BiddingFixture.createBundle(
        ipinyouId = "123",
        ts = 1370721600000L)
      val bundle2 = BiddingFixture.createBundle(
        ipinyouId = "123",
        ts = 1370721600000L + BiddingSession.sessionTimeout + 1000)
      val rdd = sc.parallelize(Seq(bundle1, bundle2))

      When("I process bundles")
      val result = BiddingSessionProcessor.process(rdd).collect()

      Then("I should get 2 closed sessions")
      result.length should equal(2)
    }
  }
}
