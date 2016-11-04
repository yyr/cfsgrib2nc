#!/bin/bash
#
#set -ue
set -vx
#
exp=cfs2_ftpc
#exp=cfs2_ref
#
variables="uwind vwind"
levels="85000"
#variables="vvel"
#levels="50000"
#
yrstr=2019
yrend=2055
#
#yrstr=2014
#yrend=2064
#
yyyystr=$( printf "%04d\n" $yrstr )
yyyyend=$( printf "%04d\n" $yrend )
#
levs=${levels//,/ }
#
dirin=/iitm1/cccr/roxy/cfs2/cfs2_ftpc/out/output
dirout=/iitm2/cccr-res/pascal/cfs2_ftpc
#dirin=/iitm1/cccr/roxy/cfs2/cfs2_ref/out/output
#dirout=/iitm2/cccr-res/pascal/cfs2_ref
#
dirtmp=/iitm2/cccr-res/pascal/tmp
#
[ ! -d $dirout ] && mkdir -p $dirout
[ ! -d $dirtmp ] && mkdir -p $dirtmp

#
for var in $variables
do
#
    cd ${dirin}/${var}
#
    for i in *.grb
    do
        cdo -sellevel,${levels} ${i} ${dirtmp}/tmp_${i}
#
    done
#
    cdo -f nc -r mergetime ${dirtmp}/tmp_*.grb  ${dirout}/${exp}_1d_${yyyystr}_${yyyyend}_${var}.nc
    rm -f  ${dirtmp}/tmp_*.grb
#
    cd ${dirout}
#
    namvar=$( cdo showname ${exp}_1d_${yyyystr}_${yyyyend}_${var}.nc )
#
    for lev in  $levs
    do
#
        level=$(( 10#$lev/100 ))
#
        cdo -r -f nc -sellevel,${lev} ${exp}_1d_${yyyystr}_${yyyyend}_${var}.nc tmp_${exp}_1d_${yyyystr}_${yyyyend}_${var}${level}.nc
        ncwa -O -a lev tmp_${exp}_1d_${yyyystr}_${yyyyend}_${var}${level}.nc ${exp}_1d_${yyyystr}_${yyyyend}_${var}${level}.nc
        rm -f tmp_${exp}_1d_${yyyystr}_${yyyyend}_${var}${level}.nc
#
        ncrename -v ${namvar},${var}${level} ${exp}_1d_${yyyystr}_${yyyyend}_${var}${level}.nc
#
        cdo -r monmean ${exp}_1d_${yyyystr}_${yyyyend}_${var}${level}.nc ${exp}_1m_${yyyystr}_${yyyyend}_${var}${level}.nc
#
    done
#
    rm -f ${exp}_1d_${yyyystr}_${yyyyend}_${var}.nc
#
    echo $var done
#
done
