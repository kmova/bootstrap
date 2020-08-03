#!/bin/bash

set -e

#sudo zpool create zfspv-pool /dev/nvme0n4
zpool status


sudo zfs create -o recordsize=4k zfspv-pool/ds

sudo zfs create -b 4k -V 64G zfspv-pool/raw_zvol

sudo zfs create -b 4k -V 64G zfspv-pool/mount_zvol
sudo mkfs.xfs /dev/zvol/zfspv-pool/mount_zvol
sudo mkdir -p zvol
sudo mount /dev/zvol/zfspv-pool/mount_zvol zvol

zpool status

echo -e "##################### Running the test on disk #########################\n"
for rw in randwrite
do
	sudo fio --name=fio-nvme --size=10G -group_reporting --time_based --runtime=300 --bs=4k --numjobs=16 --rw=$rw --ioengine=sync --filename=/dev/nvme0n3
	echo -e "--------------\n"
done

echo -e "##################### Running the test on ds #########################\n"
for rw in randwrite
do
	sudo fio --name=fio-nvme --size=10G -group_reporting --time_based --runtime=300 --bs=4k --numjobs=16 --rw=$rw --ioengine=sync --filename=/zfspv-pool/ds/fio.txt
	echo -e "--------------\n"
done

echo -e "##################### Running the test on raw ZVOL #########################\n"
for rw in randwrite
do
	sudo fio --name=fio-raw-zvol --size=10G -group_reporting --time_based --runtime=300 --bs=4k --numjobs=16 --rw=$rw --ioengine=sync --filename=/dev/zvol/zfspv-pool/raw_zvol
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
sudo zfs destroy zfspv-pool/mount_zvol

sudo zfs destroy zfspv-pool/raw_zvol

sudo zfs destroy zfspv-pool/ds
