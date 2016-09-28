#!/bin/bash
#
#set -ue
set -vx
#
exp=cfs2_ftpc
#exp=cfs2_ref
#
#variables="skintemp t2mt albedo tsfc mslp olr prate dswrf_sfc uswrf_sfc dlwrf_sfc ulwrf_sfc lhtfl senshfl uswrf_toa dswrf_toa"
variables="tsfc mslp prate "
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
#
dirin=/iitm1/cccr/roxy/cfs2/cfs2_ftpc/out/output
dirout=/iitm2/cccr-res/pascal/cfs2_ftpc
#dirin=/iitm1/cccr/roxy/cfs2/cfs2_ref/out/output
#dirout=/iitm2/cccr-res/pascal/cfs2_ref
#
[ ! -d $dirout ] && mkdir -p $dirout
#
cd ${dirout}
#
for var in $variables
do
#
    cdo -f nc -r mergetime ${dirin}/${var}/*.grb  ${exp}_1d_${yyyystr}_${yyyyend}_${var}.nc
    cdo -r monmean ${exp}_1d_${yyyystr}_${yyyyend}_${var}.nc ${exp}_1m_${yyyystr}_${yyyyend}_${var}.nc
#
    namvar=$( cdo showname ${exp}_1d_${yyyystr}_${yyyyend}_${var}.nc )
#
    ncrename -v ${namvar},${var} ${exp}_1d_${yyyystr}_${yyyyend}_${var}.nc
    ncrename -v ${namvar},${var} ${exp}_1m_${yyyystr}_${yyyyend}_${var}.nc
#
    echo $var done
#
done