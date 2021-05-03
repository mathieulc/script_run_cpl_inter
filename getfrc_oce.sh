#!/bin/bash

#
if [ ${interponline} -eq 1 ]; then 

    if [ ${frc_ext} -eq 'ECMWF' ]; then
        vnames='T2M SSTK U10M V10M Q STR STRD SSR TP EWSS NSSS'
    elif [ ${frc_ext} -eq 'AROME' ]; then
        vnames='t2m rh rain swhf lwhf NOPE u10m v10m pmer'
    else
        vnames='Temperature_height_above_ground Specific_humidity Precipitation_rate Downward_Short-Wave_Rad_Flux_surface Upward_Short-Wave_Rad_Flux_surface Downward_Long-Wave_Rad_Flux Upward_Long-Wave_Rad_Flux_surface U-component_of_wind V-component_of_wind'
    fi
#
    for i in `seq 0 $(( ${JOB_DUR_MTH}-1 ))`; do
        mdy=$( valid_date $(( $MONTH_BEGIN_JOB + $i )) $DAY_BEGIN_JOB $YEAR_BEGIN_JOB )
        cur_Y=$( printf "%04d\n"  $( echo $mdy | cut -d " " -f 3) )
        cur_M=$( printf "%02d\n"  $( echo $mdy | cut -d " " -f 1) )
  
        for varname in ${vnames} ; do
        ${io_getfile} ${INPUTDIRO}/${varname}_Y${cur_Y}M${cur_M}.nc ./
        done
    done
#
else 
    for i in `seq 0 $(( ${JOB_DUR_MTH}-1 ))`; do
        if [ ${JOB_DUR_MTH} -eq 1 ]; then
            cur_Y=$( echo $DATE_BEGIN_JOB | cut -c 1-4 )
            cur_M=$( echo $DATE_BEGIN_JOB | cut -c 5-6 )
            ln -sf ${INPUTDIRO}/croco_${frc_ext}_Y${cur_Y}M${cur_M}.nc croco_frc.nc
        else
            printf "\n\nSurface forcing is not yet implemented for job duration longer than a month (need to solve overlapping problem)=>  we stop...\n\n"
            exit 1
        fi
    done
fi
