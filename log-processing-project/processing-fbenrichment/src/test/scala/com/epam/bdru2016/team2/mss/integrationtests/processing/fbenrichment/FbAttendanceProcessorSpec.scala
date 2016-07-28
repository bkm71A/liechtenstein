package com.epam.bdru2016.team2.mss.integrationtests.processing.fbenrichment

import java.util.UUID

import com.epam.bdru2016.team2.mss.integration.elasticsearch.ESSettings
import com.epam.bdru2016.team2.mss.model.entities.BiddingBundle
import com.epam.bdru2016.team2.mss.model.reference._
import com.epam.bdru2016.team2.mss.processing.fbenrichment.processors.{FbAttendanceProcessor, FbBiddingBundle}
import com.epam.bdru2016.team2.mss.testing.fixtures.BiddingFixture
import com.epam.bdru2016.team2.mss.testing.spark.SparkSqlSpec
import org.apache.spark.Logging
import org.scalatest.{FeatureSpec, GivenWhenThen, Matchers}

/**
  * Created by Aleksander_Khanteev on 5/24/2016.
  */
class FbAttendanceProcessorSpec extends FeatureSpec with Matchers with SparkSqlSpec with GivenWhenThen with Logging {

  val settings = ESSettings("mss_test")


  feature("Getting data from facebook") {
    scenario("Process non empty dataset") {

      Given("A bundle with city and categories")
      val city = DicCity(1, "New York", 7, 8491079, 783.8f, 10430, 40.6643f,-73.9385f)
      val categories = Array("cars","chevrolet")
      val bundle = FbBiddingBundle(UUID.randomUUID().toString, 1415463675L, categories, 1, city)
      val dataset = sc.parallelize(Seq(bundle))

      When("I process bundle")
      val result = FbAttendanceProcessor.process(dataset, None).collect()

      Then("I should get a random attendance numbers for city and category")
      result.length should equal(1)
      val cityAttendance = result.head
      cityAttendance.cityId should equal(bundle.city)
      cityAttendance.keywordAttendance.size should equal(2)
      cityAttendance.keywordAttendance should contain key "cars"
      cityAttendance.keywordAttendance should contain key "chevrolet"
    }
  }
}
