#!/bin/bash -e

echo "####################################################################"
echo "#################### Installing mesosphere $INSTALLER_TYPE #########"
echo "####################################################################"

export INSTALLER_TYPE="$1"
export MASTER_IP="$2"
export MY_ADDRESS="$3"
export ATTRIBUTES="$4"

setup-master() {
  mkdir -p /etc/zookeeper/conf
  mkdir -p /etc/mesos
  mkdir -p /etc/mesos-master
  mkdir -p /etc/marathon/conf
  echo "1" > /etc/zookeeper/conf/myid
  echo "server.1=$MASTER_IP:2888:3888" >> /etc/zookeeper/conf/zoo.cfg
  echo "zk://$MASTER_IP:2181/mesos" > /etc/mesos/zk
  cp /etc/mesos/zk /etc/marathon/conf/master
  echo "zk://$MASTER_IP:2181/marathon" > /etc/marathon/conf/zk
  #echo "1" > /etc/mesos-master/quorum
  echo "$MY_ADDRESS" > /etc/mesos-master/hostname
  echo "$MY_ADDRESS" > /etc/mesos-master/ip
  echo "$MY_ADDRESS" > /etc/marathon/conf/hostname
  
  rm /etc/init/zookeeper.override
  rm /etc/init/mesos-master.override
  rm /etc/init/marathon.override
  sudo service zookeeper start
  sudo service mesos-master start
  sudo service marathon start
}

setup-slave() {
  mkdir -p /etc/mesos
  mkdir -p /etc/mesos-slave
  mkdir -p /etc/marathon/conf
  echo 'docker,mesos' > /etc/mesos-slave/containerizers
  echo "$ATTRIBUTES" > /etc/mesos-slave/attributes
  echo '5mins' > /etc/mesos-slave/executor_registration_timeout
  echo "zk://$MASTER_IP:2181/mesos" > /etc/mesos/zk
  echo "ports:[7000-9000]" > /etc/mesos-slave/resources
  echo "$MY_ADDRESS" > /etc/mesos-slave/hostname
  echo "$MY_ADDRESS" > /etc/mesos-slave/ip
  echo "$MY_ADDRESS" > /etc/marathon/conf/hostname
  rm /etc/init/mesos-slave.override

  sleep 10
  sudo service mesos-slave start
}

if [[ "$INSTALLER_TYPE" == "master" ]]; then
  setup-master
else
  setup-slave
fi