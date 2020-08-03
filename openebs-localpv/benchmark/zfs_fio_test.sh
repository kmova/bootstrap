#!/bin/bash

set -e

#This script needs two identical block devices to perform benchmarking
# One is used to benchmark raw performance
# Other is used to benchmark ZFS performance

RAW_DEVICE=/dev/nvme0n3
POOL_DEVICE=/dev/nvme0n4

#Install ZFSonLinux and fio tools used in this script
#sudo apt-get install zfsutils-linux
#sudo apt-get install fio

POOL_NAME=zfspv-pool
#Create the pool if not already present.
#sudo zpool create ${POOL_NAME} ${POOL_DEVICE}
zpool status


sudo zfs create -o recordsize=4k ${POOL_NAME}/ds

sudo zfs create -b 4k -V 64G ${POOL_NAME}/raw_zvol

sudo zfs create -b 4k -V 64G ${POOL_NAME}/mount_zvol
sudo mkfs.xfs /dev/zvol/${POOL_NAME}/mount_zvol
sudo mkdir -p zvol
sudo mount /dev/zvol/${POOL_NAME}/mount_zvol zvol

zfs list

echo -e "##################### Running the test on disk #########################\n"
for rw in randwrite
do
	sudo fio --name=fio-nvme --size=10G -group_reporting --time_based --runtime=300 --bs=4k --numjobs=16 --rw=$rw --ioengine=sync --filename=${RAW_DEVICE}
	echo -e "--------------\n"
done

echo -e "##################### Running the test on ds #########################\n"
for rw in randwrite
do
	sudo fio --name=fio-ds --size=10G -group_reporting --time_based --fallocate=0 --runtime=300 --bs=4k --numjobs=16 --rw=$rw --ioengine=sync --filename=/${POOL_NAME}/ds/fio.txt
	echo -e "--------------\n"
done

echo -e "##################### Running the test on raw ZVOL #########################\n"
for rw in randwrite
do
	sudo fio --name=fio-raw-zvol --size=10G -group_reporting --time_based --runtime=300 --bs=4k --numjobs=16 --rw=$rw --ioengine=sync --filename=/dev/zvol/${POOL_NAME}/raw_zvol
	echo -e "--------------\n"
done


echo -e "##################### Running the test on mounted ZVOL #########################\n"
for rw in randwrite
do
	sudo fio --name=fio-mount-zvol --size=10G -group_reporting --time_based --runtime=300 --bs=4k --numjobs=16 --rw=$rw --ioengine=sync --filename=zvol/fio-$rw.txt
	echo -e "--------------\n"
done


sudo umount zvol
sudo rm -r zvol
sudo zfs destroy ${POOL_NAME}/mount_zvol

sudo zfs destroy ${POOL_NAME}/raw_zvol

sudo zfs destroy ${POOL_NAME}/ds

