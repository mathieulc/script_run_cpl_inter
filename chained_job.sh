#!/bin/bash

if [ ${MACHINE} == "DATARMOR" ] ; then

    ${QSUB} -h -N ${ROOT_NAME_1} ${jobname}
    sub_ext=".pbs"
    launchcmd="-W depend=afterany:$( echo $( qselect -N ${ROOT_NAME_1}) | cut -c 1-7 )"
elif [ ${MACHINE} == "IRENE" ]; then
    ${QSUB} ${jobname}
    sub_ext=".sh"
    prejobname=${ROOT_NAME_1}
else
    printf "\n\n Chained job for your machine is not set up yet, we stop...\n\n" && exit 1

fi


cd ${SCRIPTDIR}

newsdate=$( makedate $MONTH_BEGIN_JOBp1 $DAY_BEGIN_JOBp1 $YEAR_BEGIN_JOBp1 )
newedate=${newsdate}
months=$MONTH_BEGIN_JOBp1
days=$DAY_BEGIN_JOBp1
years=$YEAR_BEGIN_JOBp1

while [ ${newedate} -lt ${DATE_END_EXP} ] ; do
    #
    mdy=$( valid_date $(( $months + $JOB_DUR_MTH )) $(( $days + $JOB_DUR_DAY - 1 )) $years )
    monthe=$( echo $mdy | cut -d " " -f 1 )
    daye=$( echo $mdy | cut -d " " -f 2 )
    yeare=$( echo $mdy | cut -d " " -f 3 )
    newedate=$( makedate $monthe $daye $yeare )   
    #
    future_date="${CEXPER}_${newsdate}_${newedate}${MODE_TEST}"   
    future_job="job_${future_date}${sub_ext}"
    cd ${JOBDIR_ROOT} 
    #
    sed -e "s/YEAR_BEGIN_JOB=${YEAR_BEGIN_JOB}/YEAR_BEGIN_JOB=${years}/" \
        -e "s/MONTH_BEGIN_JOB=${MONTH_BEGIN_JOB}/MONTH_BEGIN_JOB=${months}/" \
        -e "s/DAY_BEGIN_JOB=${DAY_BEGIN_JOB}/DAY_BEGIN_JOB=${days}/" \
        ${jobname} > ${future_job}

    chmod 755 ${future_job}
    #
    if [ ${MACHINE} == "DATARMOR" ] ; then 
#
        newjobname="${CEXPER}_${newsdate}_${newedate}${MODE_TEST}"
        ${QSUB} -N ${newjobname} ${launchcmd} ${future_job} 
        launchcmd="-W depend=afterany:$( echo $( qselect -N ${newjobname}) | cut -c 1-7 )"
        cd ${SCRIPTDIR}
#
    elif [ ${MACHINE} == "IRENE" ] ; then 

         ${QSUB} -a ${prejobname} ${future_job} 
         prejobname="${CEXPER}_${newsdate}_${newedate}${MODE_TEST}"
         cd ${SCRIPTDIR} 
    fi
#    
    mdy=$( valid_date $(( $monthe )) $(( $daye + 1 )) $yeare )
    months=$( echo $mdy | cut -d " " -f 1 )
    days=$( echo $mdy | cut -d " " -f 2 )
    years=$( echo $mdy | cut -d " " -f 3 )
    newsdate=$( makedate $months $days $years )
    
done
#
cd ${JOBDIR_ROOT}

[ ${MACHINE} == "DATARMOR" ] && { jobid=$( echo $( qselect -N ${ROOT_NAME_1}) | cut -c 1-7 ) ; qrls ${jobid} ; }
