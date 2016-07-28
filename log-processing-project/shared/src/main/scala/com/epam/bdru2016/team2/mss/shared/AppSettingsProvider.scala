package com.epam.bdru2016.team2.mss.shared

import java.io.File

import com.typesafe.config.{Config, ConfigFactory}

/**
  * Created by Aleksander_Khanteev on 5/23/2016.
  */
class AppSettingsProvider(configPath:String) {

  protected val cfgFile = new File(configPath)
  protected val appCfg = cfgFile match  {
    case x if x.exists() => ConfigFactory.parseFile(cfgFile).getConfig("app")
    case _ => throw new IllegalArgumentException(s"Configuration file '$configPath' does not exist")
  }

  protected def get[A](path:String)(getFunc:(Config,String) => A) : Option[A] = {

    if (appCfg.hasPath(path)) {
      Some(getFunc(appCfg,path))
    }
    else {
      None
    }
  }

  protected def getOrThrow[A](path:String)(getFunc:(Config,String) => A):A = {
    if (appCfg.hasPath(path)) {
      getFunc(appCfg,path)
    }
    else {
      throw new IllegalArgumentException(s"Configuration path '$path' does not exist")
    }
  }

  protected def getSectionOrThrow(path:String):Config = getOrThrow(path)((c,p) => c.getConfig(p))
  protected def getStringOrThrow(path:String):String = getOrThrow(path)((c,p) => c.getString(p))

  def isTestRun: Boolean = {
    appCfg.hasPath("is-test-run") && appCfg.getBoolean("is-test-run")
  }


  def getMaster: String = {
    if (appCfg.hasPath("spark-master")) appCfg.getString("spark-master") else "local[4]"
  }

}
