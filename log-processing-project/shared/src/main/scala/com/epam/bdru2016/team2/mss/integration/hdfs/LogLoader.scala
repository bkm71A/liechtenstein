package com.epam.bdru2016.team2.mss.integration.hdfs

import com.epam.bdru2016.team2.mss.model.entities.{BiddingBundle, BiddingEvent}
import com.epam.bdru2016.team2.mss.model.utils.DateTimeUtils
import com.epam.bdru2016.team2.mss.shared.AppSettingsProvider
import org.apache.spark.SparkContext
import org.apache.spark.sql.{DataFrame, SQLContext}
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._

class LogsLoader(path:String) extends Serializable {

  def loadLogsDF(sc: SparkContext): DataFrame = {
    val sqlc = SQLContext.getOrCreate(sc)
    import sqlc.implicits._

    val streamSchema = StructType(Array(
      StructField("bidId", DataTypes.StringType, true),
      StructField("ts_string", DataTypes.StringType, true),
      StructField("ipinyouId", DataTypes.StringType, true),
      StructField("userAgent", DataTypes.StringType, true),
      StructField("ip", DataTypes.StringType, true),
      StructField("region", DataTypes.IntegerType, true),
      StructField("city", DataTypes.IntegerType, true),
      StructField("adExchange", DataTypes.ByteType, true),
      StructField("domain", DataTypes.StringType, true),
      StructField("url", DataTypes.StringType, true),
      StructField("anonymousUrl", DataTypes.StringType, true),
      StructField("adSlotId", DataTypes.StringType, true),
      StructField("adSlotWidth", DataTypes.IntegerType, true),
      StructField("adSlotHeight", DataTypes.IntegerType, true),
      StructField("adSlotVisibility", DataTypes.IntegerType, true),
      StructField("adSlotFormat", DataTypes.IntegerType, true),
      StructField("payingPrice", DataTypes.createDecimalType(), true),
      StructField("creativeId", DataTypes.StringType, true),
      StructField("biddingPrice", DataTypes.createDecimalType(), true),
      StructField("advertiserId", DataTypes.IntegerType, true),
      StructField("userTags", DataTypes.LongType, true),
      StructField("streamId", DataTypes.IntegerType, true)))

    val toTS = udf[Long, String]( x => BiddingEvent.transformTs(x))
    val toDT = udf[Long, String]( x => DateTimeUtils.getDatePart(BiddingEvent.transformTs(x)))

    sqlc.read
      .format("com.databricks.spark.csv")
      .option("delimiter", "\t")
      .schema(streamSchema)
      .load(path)
      .withColumn("dt", toDT($"ts_string"))
      .withColumn("ts", toTS($"ts_string"))
  }

}
