package com.epam.bdru2016.team2.mss.ingestion.history.processors

import com.epam.bdru2016.team2.mss.model.entities.{BiddingBundle, BiddingSession}
import org.apache.spark.rdd.RDD
import org.apache.spark.{HashPartitioner, Partitioner}

import scala.collection.mutable.ArrayBuffer
import scala.reflect.ClassTag

object BiddingSessionProcessor {

  def process(input: RDD[BiddingBundle]) : RDD[BiddingSession] = {

    val grouped = input.map(x => x.ipinyouId -> x)

    def splitFunc(b1:BiddingBundle, b2:BiddingBundle):Boolean = b2.ts - b1.ts > BiddingSession.sessionTimeout
    def keyFunc(b:BiddingBundle):Long = b.ts
    val splitted = groupByKeyAndSortValues(grouped, keyFunc, splitFunc, 200)

    splitted.map(x => {
      BiddingSession(x._2, state = BiddingSession.stateClosed)
    })
  }

  def groupByKeyAndSortValues[K : Ordering : ClassTag, V : ClassTag, S : Ordering](
                                                                                    rdd: RDD[(K, V)],
                                                                                    secondaryKeyFunc: (V) => S,
                                                                                    splitFunc: (V, V) => Boolean,
                                                                                    numPartitions: Int): RDD[(K, List[V])] = {
    val presess = rdd.map {
      case (lic, trip) => {
        ((lic, secondaryKeyFunc(trip)), trip)
      }
    }
    val partitioner = new FirstKeyPartitioner[K, S](numPartitions)
    presess.repartitionAndSortWithinPartitions(partitioner).mapPartitions(groupSorted(_, splitFunc))
  }

  def groupSorted[K, V, S](
                            it: Iterator[((K, S), V)],
                            splitFunc: (V, V) => Boolean): Iterator[(K, List[V])] = {
    val res = List[(K, ArrayBuffer[V])]()
    it.foldLeft(res)((list, next) => list match {
      case Nil =>
        val ((lic, _), trip) = next
        List((lic, ArrayBuffer(trip)))
      case cur :: rest =>
        val (curLic, items) = cur
        val ((lic, _), trip) = next
        if (!lic.equals(curLic) || splitFunc(items.last, trip)) {
          (lic, ArrayBuffer(trip)) :: list
        } else {
          items.append(trip)
          list
        }
    }).map { case (lic, buf) => (lic, buf.toList) }.iterator
  }
}

class FirstKeyPartitioner[K1, K2](partitions: Int) extends Partitioner {
  val delegate = new HashPartitioner(partitions)
  override def numPartitions = delegate.numPartitions
  override def getPartition(key: Any): Int = {
    val k = key.asInstanceOf[(K1, K2)]
    delegate.getPartition(k._1)
  }
}