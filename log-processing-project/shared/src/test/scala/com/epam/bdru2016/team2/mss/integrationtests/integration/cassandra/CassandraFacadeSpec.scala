package com.epam.bdru2016.team2.mss.integrationtests.integration.cassandra

import java.util.UUID

import com.epam.bdru2016.team2.mss.integration.cassandra.{CassandraFacade, CassandraSettings}
import com.epam.bdru2016.team2.mss.integrationtests.CassandraTest
import com.epam.bdru2016.team2.mss.testing.fixtures.BiddingFixture
import com.epam.bdru2016.team2.mss.testing.spark.SparkSpec
import org.apache.spark.Logging
import org.scalatest.{FeatureSpec, GivenWhenThen, Matchers}

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
class CassandraFacadeSpec extends FeatureSpec with Matchers with SparkSpec with GivenWhenThen with Logging {

  val settings = CassandraSettings("127.0.0.1","mss_test")

  feature("Saving to Cassandra") {
    scenario("Save new bidding bundle", CassandraTest) {

      Given("A bundle")
      val bundle = BiddingFixture.createBundle(ipinyouId = UUID.randomUUID().toString)
      val rdd = sc.parallelize(Seq(bundle))

      When("I save bundle to Cassandra")
      CassandraFacade.saveBiddingBundles(rdd, settings)
    }

    scenario("Save new bidding session", CassandraTest) {

      Given("A session")
      val bundle = BiddingFixture.createSession(ipinyouId = UUID.randomUUID().toString)
      val rdd = sc.parallelize(Seq(bundle))

      When("I save session to Cassandra")
      CassandraFacade.saveBiddingSession(rdd, settings)
    }
  }

}
