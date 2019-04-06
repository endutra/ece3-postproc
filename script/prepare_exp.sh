#!/usr/bin/env bash

set -eux 

FLOC=/media/Synology04/ecearth3301/
# /media/Synology04/ecearth3301/1850/ifs/

expname=$1
year=$2
yref=$3
clean=${4:-0}
months_per_leg=12

 # load utilities
. ${ECE3_POSTPROC_TOPDIR}/functions.sh
check_environment

# load user and machine specifics
. $ECE3_POSTPROC_TOPDIR/conf/$ECE3_POSTPROC_MACHINE/conf_hiresclim_$ECE3_POSTPROC_MACHINE.sh

eval_dirs 1

if [[ $clean == 1 ]]; then
  rm -rfv $IFSRESULTS
  exit 0
fi

start1=$(date +%s)
echo $IFSRESULTS
if [[ ! -d $IFSRESULTS ]]; then
  mkdir -p $IFSRESULTS
  FRAW=$FLOC/$year/ifs/
  cd $IFSRESULTS
  for ff in $(ls $FRAW/ICMGG*${expname}+*.gz )
  do
    ff1=$(basename $ff)
    gunzip -c $ff > ${ff1%.*}
  done
fi 

end1=$(date +%s)
runtime=$((end1-start1));
hh=$(echo "scale=3; $runtime/3600" | bc)
echo "*II* One year postprocessing gunzip runtime is $runtime sec (or $hh hrs) "
