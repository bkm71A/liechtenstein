#env
export HADOOP_INSTALL=/hadoop-dist
export HADOOP_DATA=/hadoop-store
export PATH=$PATH:$HADOOP_INSTALL/bin
export PATH=$PATH:$HADOOP_INSTALL/sbin
export HADOOP_MAPRED_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_HOME=$HADOOP_INSTALL
export HADOOP_HDFS_HOME=$HADOOP_INSTALL
export YARN_HOME=$HADOOP_INSTALL
export HADOOP_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib -Djava.library.path=$HADOOP_COMMON_LIB_NATIVE_DIR"
export HADOOP_LOG_DIR="$HADOOP_INSTALL/logs"
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"

# Users
useradd hdfs && \
    useradd yarn && \
    useradd hadoop && \
    usermod -aG hadoop hadoop && \
    usermod -aG hadoop hdfs && \
    usermod -aG hadoop yarn && \
    usermod -aG sudo hadoop && \
    usermod -aG sudo hdfs && \
    usermod -aG sudo yarn && \


# Hadoop Folders
mkdir -p $HADOOP_DATA/hdfs/namenode && \
	mkdir $HADOOP_DATA/hdfs/datanode && \
	mkdir $HADOOP_DATA/hdfs/namesecondary && \
	mkdir -p $HADOOP_DATA/yarn/nodemanager &&\
	mkdir $HADOOP_DATA/tmp && \
	chown -R hdfs:hadoop $HADOOP_DATA && chmod -R 770 $HADOOP_DATA

wget http://apache-mirror.rbc.ru/pub/apache/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
tar -xzf hadoop-2.7.2.tar.gz

mv /hadoop-2.7.2 $HADOOP_INSTALL && \
    chown -R hadoop:hadoop $HADOOP_INSTALL && \
    chmod -R 775 $HADOOP_INSTALL && \
    chown hdfs:hadoop $HADOOP_INSTALL/bin/hdfs && \
    chown yarn:hadoop $HADOOP_INSTALL/bin/yarn && \
    chmod 540 $HADOOP_INSTALL/bin/hdfs && \
    chmod 540 $HADOOP_INSTALL/bin/yarn

mkdir $HADOOP_LOG_DIR && \                                
    chown hadoop:hadoop $HADOOP_LOG_DIR && \
    chmod -R 775 $HADOOP_LOG_DIR 

rm -f /hadoop-2.7.2.tar.gz && rm -rf /hadoop-2.7.2


cp $HADOOP_INSTALL/etc/hadoop/core-site.xml $HADOOP_INSTALL/etc/hadoop/core-site.xml_backup
cp /vagrant/install/hadoop/config/core-site.xml $HADOOP_INSTALL/etc/hadoop/core-site.xml

cp $HADOOP_INSTALL/etc/hadoop/hdfs-site.xml $HADOOP_INSTALL/etc/hadoop/hdfs-site.xml_backup
cp /vagrant/install/hadoop/config/hdfs-site.xml $HADOOP_INSTALL/etc/hadoop/hdfs-site.xml

cp /vagrant/install/hadoop/config/mapred-site.xml $HADOOP_INSTALL/etc/hadoop/mapred-site.xml

cp $HADOOP_INSTALL/etc/hadoop/yarn-site.xml $HADOOP_INSTALL/etc/hadoop/yarn-site.xml_backup
cp /vagrant/install/hadoop/config/yarn-site.xml $HADOOP_INSTALL/etc/hadoop/yarn-site.xml

$HADOOP_INSTALL/bin/hdfs namenode -format dev   
#nohup $HADOOP_INSTALL/bin/hdfs namenode >/dev/null 2>&1 & sleep 50 && \
    
sed -i '/<\/configuration>/i\\t<property>\n\t\t<name>fs.defaultFS<\/name>\n\t\t<value>hdfs://localhost:54310<\/value>\n\t</property>' $HADOOP_INSTALL/etc/hadoop/core-site.xml