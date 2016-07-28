package com.epam.bdru2016.team2.mss.integration.hdfs

import com.epam.bdru2016.team2.mss.model.reference._
import com.epam.bdru2016.team2.mss.shared.AppSettingsProvider
import org.apache.spark.SparkContext
import org.apache.spark.sql.types.DataTypes
import org.apache.spark.sql.{DataFrame, Dataset, SQLContext}

/**
  * Created by Aleksander_Khanteev on 5/21/2016.
  */
class DictionaryLoader(dictSettings: DictionarySettings) extends Serializable {

  /**
    * Schema:
    *
    * root
    *   |-- ID: long (nullable = true)
    *   |-- Keyword Value: string (nullable = true)
    *   |-- Keyword Status: string (nullable = true)
    *   |-- Pricing Type: string (nullable = true)
    *   |-- Keyword Match Type: string (nullable = true)
    *   |-- Destination URL: string (nullable = true)
    *
    *
    */
  def loadTagsDF(sqlc: SQLContext): DataFrame = {
    sqlc.read
      .format("com.databricks.spark.csv")
      .option("header", "true") // Use first line of all files as header
      .option("inferSchema", "true") // Automatically infer data types
      .option("delimiter", "\t")
      .load(dictSettings.tagsPath)
  }

  def loadTags(sc:SparkContext): Dataset[DicTags] = {
    val sqlc = SQLContext.getOrCreate(sc)
    import sqlc.implicits._

    loadTagsDF(sqlc)
      .select(
        $"ID".alias("id"),
        $"Keyword Value".alias("keywords"),
        $"Keyword Status".alias("status"),
        $"Pricing Type".alias("pricingType"),
        $"Keyword Match Type".alias("matchType"),
        $"Destination URL".alias("destinationUrl")
      ).map(r => DicTags(r.getLong(0), r.getString(1), r.getString(2), r.getString(3), r.getString(4), r.getString(5)))
      .toDS()
  }

  /**
    * Schema:
    *
    * root
     |-- Id: integer (nullable = true)
     |-- City: string (nullable = true)
     |-- State Id: integer (nullable = true)
     |-- Population: integer (nullable = true)
     |-- Area: double (nullable = true)
     |-- Density: double (nullable = true)
     |-- Latitude: double (nullable = true)
     |-- Longitude: double (nullable = true)
    *
    */
  def loadCitiesDF(sqlc: SQLContext): DataFrame = {
    sqlc.read
      .format("com.databricks.spark.csv")
      .option("header", "true") // Use first line of all files as header
      .option("inferSchema", "true") // Automatically infer data types
      .option("delimiter", "\t")
      .load(dictSettings.citiesPath)
  }

  def loadCities(sc:SparkContext): Dataset[DicCity] = {
    val sqlc = SQLContext.getOrCreate(sc)
    import sqlc.implicits._

    loadCitiesDF(sqlc)
      .select(
        $"Id".alias("id"),
        $"City".alias("name"),
        $"State Id".alias("stateId"),
        $"Population".alias("population"),
        $"Area".alias("area").cast(DataTypes.FloatType),
        $"Density".alias("density").cast(DataTypes.FloatType),
        $"Latitude".alias("latitude").cast(DataTypes.FloatType),
        $"Longitude".alias("longitude").cast(DataTypes.FloatType)
      )
      .as[DicCity]
  }

  /**
    * Schema:
    *
    * root
    * |-- Id: integer (nullable = true)
    * |-- State: string (nullable = true)
    * |-- Population: integer (nullable = true)
    * |-- GSP: integer (nullable = true)
    *
    */
  def loadStatesDF(sqlc: SQLContext): DataFrame = {
    sqlc.read
      .format("com.databricks.spark.csv")
      .option("header", "true") // Use first line of all files as header
      .option("inferSchema", "true") // Automatically infer data types
      .option("delimiter", "\t")
      .load(dictSettings.statesPath)
  }

  def loadStates(sc:SparkContext): Dataset[DicState] = {
    val sqlc = SQLContext.getOrCreate(sc)
    import sqlc.implicits._

    loadStatesDF(sqlc)
      .select(
        $"Id".alias("id"),
        $"State".alias("name"),
        $"Population".alias("population"),
        $"GSP".alias("gsp"))
      .as[DicState]
  }

  /**
    * Schema:
    *
    * root
    * |-- Stream Id: integer (nullable = true)
    * |-- Type: string (nullable = true)
    *
    */
  def loadLogTypesDF(sqlc: SQLContext): DataFrame = {
    sqlc.read
      .format("com.databricks.spark.csv")
      .option("header", "true") // Use first line of all files as header
      .option("inferSchema", "true") // Automatically infer data types
      .option("delimiter", "\t")
      .load(dictSettings.logTypesPath)
  }

  def loadLogTypes(sc:SparkContext): Dataset[DicLogType] = {
    val sqlc = SQLContext.getOrCreate(sc)
    import sqlc.implicits._

    loadLogTypesDF(sqlc)
      .select(
        $"Stream Id".alias("id"),
        $"Type".alias("name"))
      .as[DicLogType]
  }

  /**
    * Schema:
    *
    * root
    *   |-- Id: integer (nullable = true)
    *   |-- Name: string (nullable = true)
    *   |-- Description: string (nullable = true)
    *
    */
  def loadAdExchangesDF(sqlc: SQLContext): DataFrame = {
    sqlc.read
      .format("com.databricks.spark.csv")
      .option("header", "true") // Use first line of all files as header
      .option("inferSchema", "true") // Automatically infer data types
      .option("delimiter", "\t")
      .load(dictSettings.adExchangesPath)
  }

  def loadAdExchanges(sc:SparkContext): Dataset[DicAdExchange] = {
    val sqlc = SQLContext.getOrCreate(sc)
    import sqlc.implicits._

    loadAdExchangesDF(sqlc)
      .select(
        $"Id".alias("id"),
        $"Name".alias("name"),
        $"Description".alias("description"))
      .as[DicAdExchange]
  }

  /**
    * Schema:
    *
    * root
    *   |-- id: long (nullable = true)
    *   |-- categories: array (nullable = true)
    *   |    |-- element: string (containsNull = true)
    */
  def loadTagCategoriesDF(sqlc: SQLContext): DataFrame = {
    sqlc.read.parquet(dictSettings.tagCategoriesPath)
  }

  def loadTagCategories(sc:SparkContext): Dataset[DicTagCategories] = {
    val sqlc = SQLContext.getOrCreate(sc)
    import sqlc.implicits._

    loadTagCategoriesDF(sqlc)
      .as[DicTagCategories]
  }
}

case class DictionarySettings(
                               statesPath:String,
                               citiesPath:String,
                               logTypesPath:String,
                               adExchangesPath:String,
                               tagsPath:String,
                               tagCategoriesPath:String
                             ) {
}
object DictionarySettings {
  def apply(dictionaryDirPath: String) = new DictionarySettings(
    dictionaryDirPath + "/states.us.txt",
    dictionaryDirPath + "/city.us.txt",
    dictionaryDirPath + "/log.type.txt",
    dictionaryDirPath + "/ad.exchange.txt",
    dictionaryDirPath + "/user.profile.tags.us.txt",
    dictionaryDirPath + "/tag_category.parquet"
  )
}

trait DictionarySettingsProvided {
  this:AppSettingsProvider =>

  def dictSettings:DictionarySettings = {

    val cfg = getSectionOrThrow("dict")

    val directory = cfg.getString("directory")

    DictionarySettings(directory)
  }
}


