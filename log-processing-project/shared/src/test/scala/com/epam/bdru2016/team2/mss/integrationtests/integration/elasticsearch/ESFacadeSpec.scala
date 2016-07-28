package com.epam.bdru2016.team2.mss.integrationtests.integration.elasticsearch

import java.util.UUID

import com.epam.bdru2016.team2.mss.integration.elasticsearch.{ESFacade, ESSettings}
import com.epam.bdru2016.team2.mss.integrationtests.ElasticsearchTest
import com.epam.bdru2016.team2.mss.testing.fixtures.BiddingFixture
import com.epam.bdru2016.team2.mss.testing.spark.SparkSpec
import org.apache.spark.Logging
import org.scalatest.{FeatureSpec, GivenWhenThen, Matchers}

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
class ESFacadeSpec extends FeatureSpec with Matchers with SparkSpec with GivenWhenThen with Logging {

  feature("Saving bidding bundle") {
    scenario("Save new bidding bundle", ElasticsearchTest) {

      Given("A bundle")
      val bundle = BiddingFixture.createBundle(ipinyouId = UUID.randomUUID().toString)
      val rdd = sc.parallelize(Seq(bundle))

      When("I save bundle to ElasticSearch")
      ESFacade.saveBiddingBundles(rdd, "mss-event-test")
    }
  }
}
