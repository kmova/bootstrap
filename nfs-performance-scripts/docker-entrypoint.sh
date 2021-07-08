#!/usr/bin/env bash
set -e

if [ -z "$FBENCH_MOUNTPOINT" ]; then
    FBENCH_MOUNTPOINT=/tmp
fi

if [ -z "$FIO_SIZE" ]; then
    FIO_SIZE=2G
fi

if [ -z "$FIO_OFFSET_INCREMENT" ]; then
    FIO_OFFSET_INCREMENT=500M
fi

if [ -z "$FIO_DIRECT" ]; then
    FIO_DIRECT=1
fi

if [ -z "$RUNTIME" ]; then
    RUNTIME="15s"
fi

echo Working dir: $FBENCH_MOUNTPOINT
echo Fio version: `fio -v`

echo

## get_num_from_match will read fio output and
## convert IOPS & BW into thousands & KiB/s
get_num_from_match() {
    text_line=$1
    match_word=$2
    sum=0

    for word in $text_line; do
        if [[ "$word" == $match_word ]]; then
            val=$(echo "$word" | tr -d -c 0-9.)
            ## Sample: "read: IOPS=10.2k, BW=39.9MiB/s (41.8MB/s)(4786MiB/120012msec)"
            if [[ "$word" == *k, ]]; then
                ## Convert IOPS into thousands
                val=$(echo "$val * 1000" | bc)
            elif [[ "$word" == *MiB/s ]]; then
                ## Convert MiB/s to KiB/s
                val=$(echo "$val * 1024" | bc)
            fi

            sum=$(echo "$sum + $val" | bc)
        fi
    done

    echo "$sum"
}

## get_latency_from_match will convert latency
## values to microsecond
get_latency_from_match() {
    text_line=$1
    match_word=$2
    sum=0
    is_msec=$(echo "$text_line" | grep -c "msec")
    is_nsec=$(echo "$text_line" | grep -c "nsec")

    for word in $text_line; do
        if [[ "$word" == $match_word ]]; then
            val=$(echo "$word" | tr -d -c 0-9.)
            if [ "$is_msec" == "1" ]; then
                val=$(echo "$val * 1000" | bc)
            elif [ "$is_nsec" == "1" ]; then
                val=$(echo "$val / 1000" | bc)
            fi

            sum=$(echo "$sum + $val" | bc)
        fi
    done

    echo "$sum"
}


if [ "$1" = 'fio' ]; then

    if [ -z "$IODEPTH" ]; then
        IODEPTH="64k"
    fi

    echo "========================= Testing Random Read...  ==========================="

    ## Here we are running multiple times to get some average value with multiple runs
    counter=0
    READ_IOPS_AVAL=0
    READ_BW_AVAL=0
    READ_LATENCY_AVAL=0
    while [ $counter -lt 3 ]; do
        READ_IOPS=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --name=read_iops --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=$IODEPTH --size=$FIO_SIZE --readwrite=randread --time_based --ramp_time=2s --runtime="$RUNTIME")
        echo "Test run $counter"
        echo "$READ_IOPS"

        ## Calculating READ_IOPS_AVG
        READ_IOPS_NUM_VAL=$(get_num_from_match "$(echo "$READ_IOPS" | grep "read:")" "IOPS*")
        READ_IOPS_AVAL=$(echo "$READ_IOPS_AVAL + $READ_IOPS_NUM_VAL" | bc)

        ## Calculating READ_BW_AVG
        READ_BW_NUM_VAL=$(get_num_from_match "$(echo "$READ_IOPS" | grep "read:")" "BW*")
        READ_BW_AVAL=$(echo "$READ_BW_AVAL + $READ_BW_NUM_VAL" | bc)

        ## Calculating READ_LATENCY_AVG
        READ_LATENCY_NUM_VAL=$(get_latency_from_match "$(echo "$READ_IOPS" | grep " lat.*avg")" "avg*")
        READ_LATENCY_AVAL=$(echo "$READ_LATENCY_AVAL + $READ_LATENCY_NUM_VAL" | bc)

        # READ_IOPS_VAL=$(echo "$READ_IOPS"|grep -E 'read ?:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
        counter=$((counter + 1))
    done
    echo
    echo
    echo "========================= Testing Random Read Completed...  ==========================="

    echo "========================= Testing Random Write... ==================================="
    counter=0
    WRITE_IOPS_AVAL=0
    WRITE_BW_AVAL=0
    WRITE_LATENCY_AVAL=0
    while [ $counter -lt 3 ]; do
        WRITE_IOPS=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --name=write_iops --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=$IODEPTH --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime="$RUNTIME")
        echo "Test run $counter"
        echo "$WRITE_IOPS"

        ## Calculating Write IOPS AVG
        WRITE_IOPS_NUM_VAL=$(get_num_from_match "$(echo "$WRITE_IOPS" | grep "write:")" "IOPS*")
        WRITE_IOPS_AVAL=$(echo "$WRITE_IOPS_AVAL + $WRITE_IOPS_NUM_VAL" | bc)

        WRITE_BW_NUM_VAL=$(get_num_from_match "$(echo "$WRITE_IOPS" | grep "write:")" "BW*")
        WRITE_BW_AVAL=$(echo "$WRITE_BW_AVAL + $WRITE_BW_NUM_VAL" | bc)

        WRITE_LATENCY_NUM_VAL=$(get_latency_from_match "$(echo "$WRITE_IOPS" | grep " lat.*avg")" "avg*")
        WRITE_LATENCY_AVAL=$(echo "$WRITE_LATENCY_AVAL + $WRITE_LATENCY_NUM_VAL" | bc)

        rm $FBENCH_MOUNTPOINT/fiotest
        cd $FBENCH_MOUNTPOINT && sync && cd ..
        counter=$((counter + 1))
    done
    echo
    echo
    echo "========================= Testing Random Write Completed...  ==========================="

    if [ "$FBENCH_QUICK" == "" ] || [ "$FBENCH_QUICK" == "no" ]; then
        echo "======================================= Testing Read Sequential... ============================"

        READ_SEQ_IOPS_AVAL=0
        READ_SEQ_BW_AVAL=0
        READ_SEQ_LATENCY_AVAL=0
        counter=0
        while [ $counter -lt 3 ]; do
            READ_SEQ=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --name=read_seq --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4k --iodepth=$IODEPTH --size=$FIO_SIZE --readwrite=read --time_based --ramp_time=2s --runtime="$RUNTIME" --offset_increment=$FIO_OFFSET_INCREMENT)
            echo "Test run $counter"
            echo "$READ_SEQ"

            ## Calculating READ IOPS AVG
            READ_SEQ_IOPS_NUM_VAL=$(get_num_from_match "$(echo "$READ_SEQ" | grep "read:")" "IOPS*")
            READ_SEQ_IOPS_AVAL=$(echo "$READ_SEQ_IOPS_AVAL + $READ_SEQ_IOPS_NUM_VAL" | bc)

            READ_SEQ_BW_NUM_VAL=$(get_num_from_match "$(echo "$READ_SEQ" | grep "read:")" "BW*")
            READ_SEQ_BW_AVAL=$(echo "$READ_SEQ_BW_AVAL + $READ_SEQ_BW_NUM_VAL" | bc)


            READ_SEQ_LATENCY_NUM_VAL=$(get_latency_from_match "$(echo "$READ_SEQ" | grep " lat.*avg")" "avg*")
            READ_SEQ_LATENCY_AVAL=$(echo "$READ_SEQ_LATENCY_AVAL + $READ_SEQ_LATENCY_NUM_VAL" | bc)

            counter=$((counter + 1))
        done
        echo
        echo
        echo "======================================= Testing Read Sequential Completed... ============================"

        echo "====================================== Testing Write Sequential Speed... ================================"
        WRITE_SEQ_IOPS_AVAL=0
        WRITE_SEQ_BW_AVAL=0
        WRITE_SEQ_LATENCY_AVAL=0
        counter=0
        while [ $counter -lt 3 ]; do
            WRITE_SEQ=$(fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --name=write_seq --filename=$FBENCH_MOUNTPOINT/fiotest --bs=4k --iodepth=$IODEPTH --size=$FIO_SIZE --readwrite=write --time_based --ramp_time=2s --runtime="$RUNTIME" --offset_increment=$FIO_OFFSET_INCREMENT)
            echo "Test run $counter"
            echo "$WRITE_SEQ"

            WRITE_SEQ_IOPS_NUM_VAL=$(get_num_from_match "$(echo "$WRITE_SEQ" | grep "write:")" "IOPS*")
            WRITE_SEQ_IOPS_AVAL=$(echo "$WRITE_SEQ_IOPS_AVAL + $WRITE_SEQ_IOPS_NUM_VAL" | bc)

            WRITE_SEQ_BW_NUM_VAL=$(get_num_from_match "$(echo "$WRITE_SEQ" | grep "write:")" "BW*")
            WRITE_SEQ_BW_AVAL=$(echo "$WRITE_SEQ_BW_AVAL + $WRITE_SEQ_BW_NUM_VAL" | bc)


            WRITE_SEQ_LATENCY_NUM_VAL=$(get_latency_from_match "$(echo "$WRITE_SEQ" | grep " lat.*avg")" "avg*")
            WRITE_SEQ_LATENCY_AVAL=$(echo "$WRITE_SEQ_LATENCY_AVAL + $WRITE_SEQ_LATENCY_NUM_VAL" | bc)

            rm $FBENCH_MOUNTPOINT/fiotest
            cd $FBENCH_MOUNTPOINT && sync && cd ..
            counter=$((counter + 1))
        done
        echo
        echo
        echo "====================================== Testing Write Sequential Speed Completed... ================================"
    fi

    READ_IOPS_AVAL=$(echo "$READ_IOPS_AVAL / 3" | bc)
    WRITE_IOPS_AVAL=$(echo "$WRITE_IOPS_AVAL / 3" | bc)
    READ_BW_AVAL=$(echo "$READ_BW_AVAL / 3" | bc)
    WRITE_BW_AVAL=$(echo "$WRITE_BW_AVAL / 3" | bc)
    READ_LATENCY_AVAL=$(echo "$READ_LATENCY_AVAL / 3" | bc)
    WRITE_LATENCY_AVAL=$(echo "$WRITE_LATENCY_AVAL / 3" | bc)

    READ_SEQ_IOPS_AVAL=$(echo "$READ_SEQ_IOPS_AVAL / 3" | bc)
    WRITE_SEQ_IOPS_AVAL=$(echo "$WRITE_SEQ_IOPS_AVAL / 3" | bc)
    READ_SEQ_BW_AVAL=$(echo "$READ_SEQ_BW_AVAL / 3" | bc)
    WRITE_SEQ_BW_AVAL=$(echo "$WRITE_SEQ_BW_AVAL / 3" | bc)
    READ_SEQ_LATENCY_AVAL=$(echo "$READ_SEQ_LATENCY_AVAL / 3" | bc)
    WRITE_SEQ_LATENCY_AVAL=$(echo "$WRITE_SEQ_LATENCY_AVAL / 3" | bc)


    echo All tests complete.
    echo
    echo ==================
    echo "= FIO bench Summary ="
    echo ==================
    echo "Random Read/Write IOPS: $READ_IOPS_AVAL / $WRITE_IOPS_AVAL. BW(KiB/s): $READ_BW_AVAL / $WRITE_BW_AVAL.  lat(usec) $READ_LATENCY_AVAL / $WRITE_LATENCY_AVAL"
    if [ -z "$FBENCH_QUICK" ] || [ "$FBENCH_QUICK" == "no" ]; then
        echo "Sequential Read/Write IOPS: $READ_SEQ_IOPS_AVAL / $WRITE_SEQ_IOPS_AVAL. BW(KiB/s) $READ_SEQ_BW_AVAL / $WRITE_SEQ_BW_AVAL. lat(usec) $READ_SEQ_LATENCY_AVAL / $WRITE_SEQ_LATENCY_AVAL"
    fi

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
