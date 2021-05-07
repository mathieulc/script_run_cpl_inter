#!/bin/bash 
set -u
set +x     # pour CURIE

umask 022

#-------------------------------------------------------------------------------
#  Which Computer and modules?
#-------------------------------------------------------------------------------
. ./module.sh # To eddit
#-------------------------------------------------------------------------------
#  namelist of the experiment
#-------------------------------------------------------------------------------
cp namelist_exp.sh namelist_exp.tmp

cat common_definitions.sh >> namelist_exp.tmp

. ./namelist_exp.tmp

[ ! -d ${JOBDIR_ROOT} ] && mkdir -p ${JOBDIR_ROOT}  # for the first submitjob.sh call

cd ${JOBDIR_ROOT} 
ls ${jobname}  > /dev/null  2>&1 
if [ "$?" -eq "0" ] ; then
   if [ ${CHAINED_JOB} == "FALSE" ]; then 
       printf "\n\n\n\n  Un fichier ${jobname} existe deja  dans  ${JOBDIR_ROOT} \n             => exit. \n\n  Nettoyer et relancer\n\n\n\n"; exit
   elif [ ${CHAINED_JOB} == "TRUE" && ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP}]; then
       printf "\n\n\n\n  Un fichier ${jobname} existe deja  dans  ${JOBDIR_ROOT} \n             => exit. \n\n  Nettoyer et relancer\n\n\n\n"; exit
   fi
      
fi
cd -
#-------------------------------------------------------------------------------
# calendar computations (to check dates consistency)
#-------------------------------------------------------------------------------
if [ ${USE_CPL} -ge 1 ]; then
  if [ $(( ${CPL_FREQ} % ${TSP_ATM} )) -ne 0 ] || \
     [ $(( ${CPL_FREQ} % ${TSP_OCE} )) -ne 0 ] || \
     [ $(( ${CPL_FREQ} % ${TSP_WW3} )) -ne 0 ] || \
     [ $(( ${CPL_FREQ} % ${TSP_ICE} )) -ne 0 ] ; then
     printf "\n\n Problem of consistency between Coupling Frequency and Time Step, we stop...\n\n" && exit 1
  fi
fi

. ./caltools.sh

#-------------------------------------------------------------------------------
# create job and submit it
#-------------------------------------------------------------------------------

[ ${USE_OCE}  -eq 1 ] && TOTOCE=$NP_CRO || TOTOCE=0
[ ${USE_ATM}  -eq 1 ] && TOTATM=$NP_WRF || TOTATM=0
[ ${USE_WW3}  -eq 1 ] && TOTWW3=$NP_WW3 || TOTWW3=0
[ ${USE_XIOS} -eq 0 ] && NXIOS=0
totalcore=$(( $TOTOCE + $TOTATM + $TOTWW3 + $NXIOS ))
[ ${COMPUTER}=="DATARMOR" ] && totalcore=$(( $totalcore /29 +1)) 
sed -e "/< insert here variables definitions >/r namelist_exp.tmp" \
    -e "s/<exp>/${ROOT_NAME_1}/g" \
    -e "s/<nmpi>/${totalcore}/g" \
    -e "s/<time_second>/${TIMEsnd}/g" \
    ./header.${COMPUTER} > HEADER_tmp
    cat HEADER_tmp job.base.pbs >  ${JOBDIR_ROOT}/${jobname}
    \rm HEADER_tmp
    \rm ./namelist_exp.tmp


cd ${JOBDIR_ROOT}
chmod 755 ${jobname}

printf "\n  HOSTNAME: `hostname`\n     =>    COMPUTER: ${COMPUTER}\n"  
echo
printf "  CONFIG: ${CONFIG}\n"  
printf "  CEXPER: ${CEXPER}\n"  
echo
printf "  jobname: ${jobname}\n"  
echo
printf "  ROOT_NAME_1: ${ROOT_NAME_1}\n"  
printf "  ROOT_NAME_2: ${ROOT_NAME_2}\n"  
printf "  ROOT_NAME_3: ${ROOT_NAME_3}\n"  
#printf "  EXEDIR: ${EXEDIR}\n"  
#printf "  OUTPUTDIR: ${OUTPUTDIR}\n"  
#printf "  RESTDIR_OUT: ${RESTDIR_OUT}\n"  
#printf "  JOBDIR: ${JOBDIR}\n"  


if [ "${SCRIPT_DEBUG}" == "TRUE" ] ; then
   printf "\n\n\n\n  SCRIPT_DEBUG=${SCRIPT_DEBUG}  Mode script debug => Pas de soumission en queue\n\n\n\n"
else 
    if [ ${CHAINED_JOB} == "TRUE" ]; then
        [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ] && . ${SCRIPTDIR}/chained_job.sh

    else
       ${QSUB} ${jobname}
    fi 
#
    if [ "${MODE_TEST}" != "" ] ; then
        printf "\n\n\n\n  MODE_TEST=${MODE_TEST}  Mode test et non production => Pas d'enchainement de jobs.\n\n\n\n"
    fi
fi

