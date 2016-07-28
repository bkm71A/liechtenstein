package com.epam.bdru2016.team2.mss.ingestion.streaming.processors

import com.epam.bdru2016.team2.mss.model.entities.{BiddingSession, BiddingSessionWithPrediction}
import org.apache.spark.rdd.RDD
import org.apache.spark.mllib.classification.LogisticRegressionModel
import org.apache.spark.SparkContext

/**
  * Created by Svyatoslav Kovalenko on 6/06/2016.
  */
object BiddingSessionMLProcessor {
  @volatile
  var model: LogisticRegressionModel = null

  def process(input: RDD[BiddingSession], modelDirectory: String): RDD[BiddingSessionWithPrediction] = {

    val model = getModel(input.context, modelDirectory)
    val predictions = model.predict(input.map(x => x.extractFV()))

    input.zip(predictions).map {case (bs, prediction) => BiddingSessionWithPrediction(bs, prediction > 0.0) }
  }

  private def getModel(sc: SparkContext, modelDirectory: String): LogisticRegressionModel = {
    //double-check lock pattern impl.
    if (model == null) {
      synchronized {
        if (model == null) {
          model = LogisticRegressionModel.load(sc, modelDirectory)
        }
      }
    }
    model
  }
}
