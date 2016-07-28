package com.epam.bdru2016.team2.mss.ingestion.streaming

import com.epam.bdru2016.team2.mss.ingestion.streaming.kafka.KafkaSettingsProvided
import com.epam.bdru2016.team2.mss.integration.cassandra.CassandraSettingsProvided
import com.epam.bdru2016.team2.mss.integration.elasticsearch.ESSettingsProvided
import com.epam.bdru2016.team2.mss.integration.hdfs.DictionarySettingsProvided
import com.epam.bdru2016.team2.mss.shared.AppSettingsProvider

/**
  * Created by Aleksander_Khanteev on 6/9/2016.
  */
class StreamingAppSettingsProvider(configPath:String)
  extends AppSettingsProvider(configPath)
  with ESSettingsProvided
  with CassandraSettingsProvided
  with KafkaSettingsProvided
  with DictionarySettingsProvided
{

  def getMLSettings:MLSettings = {
    MLSettings(if (appCfg.hasPath("ml")) appCfg.getConfig("ml").getString("model-directory") else "/data/mss/ml/model/logistic-regression/")
  }

  def getSparkSettings:Option[SparkStreamingSettings] = {

    val cfg = getSectionOrThrow("spark-streaming")
    Some(SparkStreamingSettings(cfg.getString("checkpoint-directory")))
  }
}

case class SparkStreamingSettings(checkpointDir:String)
case class MLSettings(modelDir:String)
