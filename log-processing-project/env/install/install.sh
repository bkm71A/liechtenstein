#!/bin/bash

SCALA_VERSION=2.10
KAFKA_VERSION=0.10.0.0
SPARK_VERSION=1.6

#OS ENV
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export M2_HOME=/usr/local/apache-maven-3.3.3
export KAFKA_HOME=/etc/kafka/kafka_$SCALA_VERSION-$KAFKA_VERSION
export SPARK_HOME=/etc/spark/spark-$SPARK_VERSION.1
export ZEPPELIN_HOME=/etc/incubator-zeppelin
export PATH=$KAFKA_HOME/bin/:$SPARK_HOME/bin/:$PATH

sudo echo "JAVA_HOME=$JAVA_HOME" >> /home/vagrant/.profile
sudo echo "M2_HOME=$M2_HOME" >> /home/vagrant/.profile
sudo echo "KAFKA_HOME=$KAFKA_HOME" >> /home/vagrant/.profile
sudo echo "SPARK_HOME=$SPARK_HOME" >> /home/vagrant/.profile
sudo echo "ZEPPELIN_HOME=$ZEPPELIN_HOME" >> /home/vagrant/.profile
sudo echo "PATH=$KAFKA_HOME/bin/:$SPARK_HOME/bin/:$PATH" >> /home/vagrant/.profile

sudo apt-get update &&
sudo apt-get install software-properties-common python-software-properties

#add all repos
#for java
sudo add-apt-repository ppa:openjdk-r/ppa
#for cassandra
echo "deb http://www.apache.org/dist/cassandra/debian 35x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
echo "deb-src http://www.apache.org/dist/cassandra/debian 35x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
gpg --export --armor F758CE318D77295D | sudo apt-key add -
gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
gpg --export --armor 2B5C1B00 | sudo apt-key add -
gpg --keyserver pgp.mit.edu --recv-keys 0353B12C
gpg --export --armor 0353B12C | sudo apt-key add -
#for elastic
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
#for kibana
#wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - #this added on step istall elastic
echo "deb http://packages.elastic.co/kibana/4.5/debian stable main" | sudo tee -a /etc/apt/sources.list

#other tools
sudo apt-get update &&
sudo apt-get install git wget npm nano ncdu vim curl zip unzip python-pip -y -q 

#java install
sudo apt-get install openjdk-8-jdk -y -q
sudo apt-get install libjansi-native-java libhawtjni-runtime-java libjansi-java

#mvn install
wget http://www.eu.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
sudo tar -zxf apache-maven-3.3.3-bin.tar.gz -C /usr/local/
sudo rm -rf apache-maven-3.3.3-bin.tar.gz
sudo ln -s $M2_HOME/bin/mvn /usr/local/bin/mvn

#install scala
wget http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.4.deb
sudo dpkg -i scala-$SCALA_VERSION.4.deb
sudo apt-get -y update
sudo apt-get -y install scala

# Installation of sbt
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
sudo apt-get update
sudo apt-get install sbt


# install spark
wget http://apache-mirror.rbc.ru/pub/apache/spark/spark-1.6.1/spark-$SPARK_VERSION.1.tgz 
mkdir /etc/spark/
tar -zxf spark-$SPARK_VERSION.1.tgz -C /etc/spark/
# Building spark
#$SPARK_HOME/sbt/sbt assembly || (echo "Fail build spark" && exit -1)
$SPARK_HOME/make-distribution.sh || (echo "Fail build spark" && exit -1)
#sudo cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf
#sudo $SPARK_HOME/sbin/start-master.sh -m 1.5G --host localhost --ip localhost
#sudo $SPARK_HOME/sbin/start-history-server.sh

# Clean-up
rm -rf scala-$SCALA_VERSION.4.deb
rm -rf sbt.deb
rm -rf spark-$SPARK_VERSION.1.tgz

#zeppelin install
cd /etc/
sudo git clone https://github.com/apache/incubator-zeppelin.git
cd $ZEPPELIN_HOME
sudo mvn clean package -DskipTests  -Pspark-$SPARK_VERSION
sudo cp ./conf/zeppelin-env.sh.template ./conf/zeppelin-env.sh && sudo cp ./conf/zeppelin-site.xml.template ./conf/zeppelin-site.xml
sudo sed -i -e 's/<value>8080/<value>9995/g' $ZEPPELIN_HOME/conf/zeppelin-site.xml
sudo $ZEPPELIN_HOME/bin/zeppelin-daemon.sh start
sudo echo "$ZEPPELIN_HOME/bin/zeppelin-daemon.sh start" >> /etc/rc.local

#zookeeper
yes|sudo apt-get install zookeeper || (echo "Fail install zoopkeeper" && exit -1)
#sudo /usr/share/zookeeper/bin/zkServer.sh start

#sudo echo "vagrant soft nofile 80000" >> /etc/security/limits.conf
#sudo echo "vagrant hard nofile 100000" >> /etc/security/limits.conf

#kafka
sudo wget http://apache-mirror.rbc.ru/pub/apache/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz 
sudo mkdir /etc/kafka/
sudo tar -xvzf kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz -C /etc/kafka/
sudo rm -rf kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz
sudo mkdir $KAFKA_HOME/logs/ && sudo touch $KAFKA_HOME/logs/kafka.log
sudo chmod 777 -R $KAFKA_HOME
#sudo nohup /etc/kafka/kafka_2.10-0.10.0.0/bin/zookeeper-server-start.sh /etc/kafka/kafka_2.10-0.10.0.0/config/zookeeper.properties > $KAFKA_HOME/logs/zoo.log 2>&1 &
#sudo nohup $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties > $KAFKA_HOME/logs/kafka.log 2>&1 &


#casandra install
cat > /etc/hosts <<EOF
127.0.0.1       localhost
# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF
yes|sudo apt-get install cassandra || (echo "Fail install cassandra" && exit -1)
#for configure cassandra cluster:https://docs.datastax.com/en/cassandra/2.0/cassandra/initialize/initializeSingleDS.html
#sudo sed -i -e 's/listen_address: localhost/listen_address: IP/g' /etc/cassandra/cassandra.yaml
#sudo sed -i -e 's/- seeds: \"127.0.0.1\"/- seeds: \"IP1,IP2,IP3\"/g' /etc/cassandra/cassandra.yaml
sudo update-rc.d cassandra defaults 95 10

#elastic serach
sudo apt-get install elasticsearch || (echo "Fail install elasticsearch" && exit -1)
sudo update-rc.d elasticsearch defaults 95 10
sudo service elasticsearch start

#install kibana
sudo apt-get install kibana || (echo "Fail install kibana" && exit -1)
sudo update-rc.d kibana defaults 95 10
sudo service kibana start

