#!/bin/bash


#export PATH=$PATH:/home/xgzhu/apps/afl
export AFL_NO_UI=1 

# $0: runfuzz.sh itself; $1: path to output directory
# $2: fuzzing seed dir;
# $3: path to target binary;  ${@:4}: parameters running targets
# bash runfuzz.sh ../outputs/becread1 ../target-bins/untracer_bins/binutils/readelf ../target-bins/untracer_bins/binutils/seed_dir/ -a @@

OUTDIR=${1}_aflfast
SEEDS=$2
TARGET=$3
VERSION=$4
FUZZTIME=$5
WITHDICT=$6
TIMEOUT=$7
PARAMS=`echo ${@:8}`



NAME=`echo ${TARGET##*/}`
INSTNAME=${NAME}_inst


mkdir $OUTDIR

if [ "$WITHDICT"x = "nodict"x ]
then
    COMMD="./afl-fuzz -i $SEEDS -o ${OUTDIR}/out -t $TIMEOUT -m 1G -Q -- ${TARGET} $PARAMS"
else
    COMMD="./afl-fuzz -i $SEEDS -o ${OUTDIR}/out -x ${WITHDICT} -t $TIMEOUT -m 1G -Q -- ${TARGET} $PARAMS"
fi


(
    ${COMMD}
)&
sleep $FUZZTIME
# ctrl-c
ps -ef | grep "$COMMD" | grep -v 'grep' | awk '{print $2}' | xargs kill -2

# rm ${OUTDIR}/${INSTNAME}
# chmod 777 -R $OUTDIR
sleep 1