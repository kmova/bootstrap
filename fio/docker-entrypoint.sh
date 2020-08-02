#!/usr/bin/env sh
set -e

if [ -z $FBENCH_MOUNTPOINT ]; then
    FBENCH_MOUNTPOINT=/tmp
fi

if [ -z $FIO_SIZE ]; then
    FIO_SIZE=2G
fi

if [ -z $FIO_OFFSET_INCREMENT ]; then
    FIO_OFFSET_INCREMENT=500M
fi

if [ -z $FIO_DIRECT ]; then
    FIO_DIRECT=1
fi

echo Working dir: $FBENCH_MOUNTPOINT
echo Fio version: `fio -v`

echo

if [ "$1" = 'fio' ]; then

    echo Testing Read IOPS...
    READ_IOPS=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=read_iops --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=64 --size=$FIO_SIZE --readwrite=randread --time_based --ramp_time=2s --runtime=15s)
    echo "$READ_IOPS"
    READ_IOPS_VAL=$(echo "$READ_IOPS"|grep -E 'read ?:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
    echo
    echo

    echo Testing Write IOPS...
    WRITE_IOPS=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=write_iops --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=64 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=15s)
    echo "$WRITE_IOPS"
    WRITE_IOPS_VAL=$(echo "$WRITE_IOPS"|grep -E 'write:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
    echo
    echo

    echo Testing Read Bandwidth...
    READ_BW=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=read_bw --filename=$FBENCH_MOUNTPOINT/fiotest --bs=128K --iodepth=64 --size=$FIO_SIZE --readwrite=randread --time_based --ramp_time=2s --runtime=15s)
    echo "$READ_BW"
    READ_BW_VAL=$(echo "$READ_BW"|grep -E 'read ?:'|grep -Eoi 'BW=[0-9GMKiBs/.]+'|cut -d'=' -f2)
    echo
    echo

    echo Testing Write Bandwidth...
    WRITE_BW=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=write_bw --filename=$FBENCH_MOUNTPOINT/fiotest --bs=128K --iodepth=64 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=15s)
    echo "$WRITE_BW"
    WRITE_BW_VAL=$(echo "$WRITE_BW"|grep -E 'write:'|grep -Eoi 'BW=[0-9GMKiBs/.]+'|cut -d'=' -f2)
    echo
    echo

    if [ "$FBENCH_QUICK" == "" ] || [ "$FBENCH_QUICK" == "no" ]; then
        echo Testing Read Latency...
        READ_LATENCY=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --name=read_latency --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=4 --size=$FIO_SIZE --readwrite=randread --time_based --ramp_time=2s --runtime=15s)
        echo "$READ_LATENCY"
        READ_LATENCY_VAL=$(echo "$READ_LATENCY"|grep ' lat.*avg'|grep -Eoi 'avg=[0-9.]+'|cut -d'=' -f2)
        echo
        echo

        echo Testing Write Latency...
        WRITE_LATENCY=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --name=write_latency --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=4 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=15s)
        echo "$WRITE_LATENCY"
        WRITE_LATENCY_VAL=$(echo "$WRITE_LATENCY"|grep ' lat.*avg'|grep -Eoi 'avg=[0-9.]+'|cut -d'=' -f2)
        echo
        echo

        echo Testing Read Sequential Speed...
        READ_SEQ=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=read_seq --filename=$FBENCH_MOUNTPOINT/fiotest --bs=1M --iodepth=16 --size=$FIO_SIZE --readwrite=read --time_based --ramp_time=2s --runtime=15s --thread --numjobs=4 --offset_increment=$FIO_OFFSET_INCREMENT)
        echo "$READ_SEQ"
        READ_SEQ_VAL=$(echo "$READ_SEQ"|grep -E 'READ:'|grep -Eoi '(aggrb|bw)=[0-9GMKiBs/.]+'|cut -d'=' -f2)
        echo
        echo

        echo Testing Write Sequential Speed...
        WRITE_SEQ=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=write_seq --filename=$FBENCH_MOUNTPOINT/fiotest --bs=1M --iodepth=16 --size=$FIO_SIZE --readwrite=write --time_based --ramp_time=2s --runtime=15s --thread --numjobs=4 --offset_increment=$FIO_OFFSET_INCREMENT)
        echo "$WRITE_SEQ"
        WRITE_SEQ_VAL=$(echo "$WRITE_SEQ"|grep -E 'WRITE:'|grep -Eoi '(aggrb|bw)=[0-9GMKiBs/.]+'|cut -d'=' -f2)
        echo
        echo

        echo Testing Read/Write Mixed...
        RW_MIX=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=rw_mix --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4k --iodepth=64 --size=$FIO_SIZE --readwrite=randrw --rwmixread=75 --time_based --ramp_time=2s --runtime=15s)
        echo "$RW_MIX"
        RW_MIX_R_IOPS=$(echo "$RW_MIX"|grep -E 'read ?:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
        RW_MIX_W_IOPS=$(echo "$RW_MIX"|grep -E 'write:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
        echo
        echo
    fi

    echo All tests complete.
    echo
    echo ==================
    echo = FIO bench Summary =
    echo ==================
    echo "Random Read/Write IOPS: $READ_IOPS_VAL/$WRITE_IOPS_VAL. BW: $READ_BW_VAL / $WRITE_BW_VAL"
    if [ -z $FBENCH_QUICK ] || [ "$FBENCH_QUICK" == "no" ]; then
        echo "Average Latency (usec) Read/Write: $READ_LATENCY_VAL/$WRITE_LATENCY_VAL"
        echo "Sequential Read/Write: $READ_SEQ_VAL / $WRITE_SEQ_VAL"
        echo "Mixed Random Read/Write IOPS: $RW_MIX_R_IOPS/$RW_MIX_W_IOPS"
    fi

    rm $FBENCH_MOUNTPOINT/fiotest
    exit 0

elif [ "$1" = 'ext-fio' ]; then

    echo Testing Extended Write Bandwidth 4 jobs...
    EXT_WRITE_BW_04=$(fio -group_reporting -numjobs=4 --randrepeat=0 --verify=0 --ioengine=sync --direct=$FIO_DIRECT --gtod_reduce=1 --name=ext_write_bw --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=64 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=300s)
    echo "$EXT_WRITE_BW_04"
    EXT_WRITE_BW_04_VAL=$(echo "$EXT_WRITE_BW_04"|grep -E 'write:'|grep -Eoi 'BW=[0-9GMKiBs/.]+'|cut -d'=' -f2)
    EXT_WRITE_IOPS_04_VAL=$(echo "$EXT_WRITE_BW_04"|grep -E 'write:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
    echo
    echo

    echo Testing Extended Write Bandwidth 8 jobs...
    EXT_WRITE_BW_08=$(fio -group_reporting -numjobs=8 --randrepeat=0 --verify=0 --ioengine=sync --direct=$FIO_DIRECT --gtod_reduce=1 --name=ext_write_bw --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=64 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=300s)
    echo "$EXT_WRITE_BW_08"
    EXT_WRITE_BW_08_VAL=$(echo "$EXT_WRITE_BW_08"|grep -E 'write:'|grep -Eoi 'BW=[0-9GMKiBs/.]+'|cut -d'=' -f2)
    EXT_WRITE_IOPS_08_VAL=$(echo "$EXT_WRITE_BW_08"|grep -E 'write:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
    echo
    echo

    echo Testing Extended Write Bandwidth 16 jobs...
    EXT_WRITE_BW_16=$(fio -group_reporting -numjobs=16 --randrepeat=0 --verify=0 --ioengine=sync --direct=$FIO_DIRECT --gtod_reduce=1 --name=ext_write_bw --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=64 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=300s)
    echo "$EXT_WRITE_BW_16"
    EXT_WRITE_BW_16_VAL=$(echo "$EXT_WRITE_BW_16"|grep -E 'write:'|grep -Eoi 'BW=[0-9GMKiBs/.]+'|cut -d'=' -f2)
    EXT_WRITE_IOPS_16_VAL=$(echo "$EXT_WRITE_BW_16"|grep -E 'write:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
    echo
    echo

    echo Testing Extended Write Bandwidth AIO 4 jobs...
    EXT_WRITE_BW_AIO_04=$(fio -group_reporting -numjobs=4 --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=ext_write_bw --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=64 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=300s)
    echo "$EXT_WRITE_BW_AIO_04"
    EXT_WRITE_BW_AIO_04_VAL=$(echo "$EXT_WRITE_BW_AIO_04"|grep -E 'write:'|grep -Eoi 'BW=[0-9GMKiBs/.]+'|cut -d'=' -f2)
    EXT_WRITE_IOPS_AIO_04_VAL=$(echo "$EXT_WRITE_BW_AIO_04"|grep -E 'write:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
    echo
    echo

    echo Testing Extended Write Bandwidth AIO 8 jobs...
    EXT_WRITE_BW_AIO_08=$(fio -group_reporting -numjobs=8 --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=ext_write_bw --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=64 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=300s)
    echo "$EXT_WRITE_BW_AIO_08"
    EXT_WRITE_BW_AIO_08_VAL=$(echo "$EXT_WRITE_BW_AIO_08"|grep -E 'write:'|grep -Eoi 'BW=[0-9GMKiBs/.]+'|cut -d'=' -f2)
    EXT_WRITE_IOPS_AIO_08_VAL=$(echo "$EXT_WRITE_BW_AIO_08"|grep -E 'write:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
    echo
    echo

    echo Testing Extended Write Bandwidth AIO 16 jobs...
    EXT_WRITE_BW_AIO_16=$(fio -group_reporting -numjobs=16 --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=ext_write_bw --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=64 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=300s)
    echo "$EXT_WRITE_BW_AIO_16"
    EXT_WRITE_BW_AIO_16_VAL=$(echo "$EXT_WRITE_BW_AIO_16"|grep -E 'write:'|grep -Eoi 'BW=[0-9GMKiBs/.]+'|cut -d'=' -f2)
    EXT_WRITE_IOPS_AIO_16_VAL=$(echo "$EXT_WRITE_BW_AIO_16"|grep -E 'write:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
    echo
    echo

    echo All tests complete.
    echo
    echo =====================
    echo = FIO bench Summary =
    echo = ioengine=sync     =
    echo =====================
    echo "Random Write (4 jobs): IOPS: $EXT_WRITE_IOPS_04_VAL / BW: $EXT_WRITE_BW_04_VAL"
    echo "Random Write (8 jobs): IOPS: $EXT_WRITE_IOPS_08_VAL / BW: $EXT_WRITE_BW_08_VAL"
    echo "Random Write (16 jobs): IOPS: $EXT_WRITE_IOPS_16_VAL / BW: $EXT_WRITE_BW_16_VAL"
    echo
    echo =====================
    echo = FIO bench Summary =
    echo = ioengine=libaio     =
    echo =====================
    echo "Random Write (4 jobs): IOPS: $EXT_WRITE_IOPS_AIO_04_VAL / BW: $EXT_WRITE_BW_AIO_04_VAL"
    echo "Random Write (8 jobs): IOPS: $EXT_WRITE_IOPS_AIO_08_VAL / BW: $EXT_WRITE_BW_AIO_08_VAL"
    echo "Random Write (16 jobs): IOPS: $EXT_WRITE_IOPS_AIO_16_VAL / BW: $EXT_WRITE_BW_AIO_16_VAL"


    rm $FBENCH_MOUNTPOINT/fiotest
    exit 0

fi

exec "$@"
