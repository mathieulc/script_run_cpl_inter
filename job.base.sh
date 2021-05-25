
############################### from job.base.sh ###############################

        DATE1=`date "+%Y%m%d-%H:%M:%S"`
        OLD="old_${DATE1}"
        printf "\n date_chris : ${DATE1}\n"


#===============================================================================
#  Step 1 commands:  get_file step  
#===============================================================================
if [ ${LOADL_STEP_NAME} == "get_file" ] || [ ${LOADL_STEP_NAME} == "XXX" ]; then
        
        #  attention si modif de ces variables, modif dans les 3 steps du job.base.sh
        export JOBDIR="${JOBDIR_ROOT}/${ROOT_NAME_2}"
        export EXEDIR="${EXEDIR_ROOT}/${ROOT_NAME_2}"

# EXEDIR: Execution directory
        [ -d ${EXEDIR} ] && mv ${EXEDIR} ${EXEDIR}_${OLD}
        mkdir -p ${EXEDIR} && mkdir ${EXEDIR}/ls_l

# JOBDIR: job directory
        [ -d ${JOBDIR} ] && mv ${JOBDIR} ${JOBDIR}_${OLD}
        mkdir -p ${JOBDIR}

# some printings
. ${SCRIPTDIR}/common_printing.sh

cd ${EXEDIR} 

        printf "\n ************* SCRIPT files *****************\n"
        for file in ${SCRIPTDIR}/*.sh ; do cpfile ${file} . ; done; chmod 755 *.sh

        printf "\n ************* EXECUTABLE files *****************\n"
	    [ ${USE_OCE}  -eq 1 ] && cpfile ${CROCO_EXE_DIR}/croco.${RUN} crocox
	    [ ${USE_ATM}  -eq 1 ] && cpfile ${WRF_EXE_DIR}/wrf.exe wrfexe
	    [ ${USE_WW3}  -eq 1 ] && cp ${WW3_EXE_DIR}/ww3_* . && mv ww3_shel wwatch
	    [ ${USE_XIOS} -ge 1 ] && cpfile ${XIOS_EXE_DIR}/xios_server.exe .

        printf "\n ************* PARAMETER files *****************\n"
# if xios
        [ ${USE_XIOS} -ge 1 ] && {  for file in ${FILIN_XIOS}; do cpfile ${INPUTDIRX}/${file} . ; done; echo ""; }

# ocean/atmosphere input files (configuration, forcing, obc, levitus/restart...)

        DATE_END_JOBm1=$( makedate $MONTH_BEGIN_JOB $(( $DAY_BEGIN_JOB - 1 )) $YEAR_BEGIN_JOB )
        RESTDIR_IN=${RESTDIR_ROOT}/${DATE_END_JOBm1}

        [ ${USE_OCE} -eq 1 ] && printf "\n ************* get OCEAN CONFIGURATION, OBC, BLK... files *****************\n" 
        [ ${USE_OCE} -eq 1 ] && { . ./getfile_oce.sh ; }

        [ ${USE_OCE} -eq 1 ] && printf "\n ************* get OCEAN RESTART files *****************\n" |tee ls_l/getrst_oce.txt
        [ ${USE_OCE} -eq 1 ] && printf "    see listing in ${EXEDIR}/ls_l/getrst_oce.txt \n"
        [ ${USE_OCE} -eq 1 ] && { . ./getrst_oce.sh ; } >> ls_l/getrst_oce.txt

        [ ${USE_ATM} -eq 1 ] && printf "\n ************* get ATMOSPHERE CONFIGURATION LOWINPUT, BDY... files *****************\n" 
        [ ${USE_ATM} -eq 1 ] && { . ./getfile_atm.sh ; }

	[ ${USE_ATM} -eq 1 ] && printf "\n ************* get ATMOSPHERE RESTART files *****************\n" |tee ls_l/getrst_atm.txt
	[ ${USE_ATM} -eq 1 ] && printf "    see listing in ${EXEDIR}/ls_l/getrst_atm.txt \n"
	[ ${USE_ATM} -eq 1 ] && { . ./getrst_atm.sh ; } >> ls_l/getrst_atm.txt

        [ ${USE_WW3} -eq 1 ] && printf "\n ************* get WAVE CONFIGURATION files *****************\n"
        [ ${USE_WW3} -eq 1 ] && { . ./getfile_ww3.sh ; }

        [ ${USE_WW3} -eq 1 ] && printf "\n ************* get WAVE RESTART files *****************\n" |tee ls_l/getrst_ww3.txt
        [ ${USE_WW3} -eq 1 ] && printf "    see listing in ${EXEDIR}/ls_l/getrst_ww3.txt \n"
        [ ${USE_WW3} -eq 1 ] && { . ./getrst_ww3.sh ; } >> ls_l/getrst_ww3.txt

	[ ${USE_CPL} -ge 1 ] && printf "\n ************* get OA3MCT RESTART files *****************\n"
	[ ${USE_CPL} -ge 1 ] && { . ./getrst_cpl.sh ; }

# make the namelists from the namelist.base files
        printf "\n ************* make namelist files from namelist base files *****************\n"
	[ ${USE_OCE} -eq 1 ] && ./namcroco.sh
	[ ${USE_ATM} -eq 1 ] && ./namwrf.sh
        [ ${USE_WW3} -eq 1 ] && echo "No namelist for WW3"
	[ ${USE_CPL} -ge 1 ] && ./namoa3mct.sh
        printf "\n date_chris : `date "+%Y%m%d-%H:%M:%S"`\n"

fi # Step1
#===============================================================================
#  Step 2 commands:  run_model step (parallel)
#===============================================================================
if [ ${LOADL_STEP_NAME} == "run_model" ] || [ ${LOADL_STEP_NAME} == "XXX" ] ; then
        
        export JOBDIR="${JOBDIR_ROOT}/${ROOT_NAME_2}"
        export EXEDIR="${EXEDIR_ROOT}/${ROOT_NAME_2}"
 
cd ${EXEDIR} 

#       ls -l > ls_l/ls_pre_exe.txt
        printf "\n see ls -l in ${EXEDIR}/ls_l/ls_pre_exe.txt\n"
        printf "\n date_chris : `date "+%Y%m%d-%H:%M:%S"`\n"
        printf "\n---------------  start   ---------------\n"

#       time -p ./nemo.exe > out_run.txt 2>&1
#        echo "${EXEC} > out_run.txt 2>&1" 
#              ${EXEC} > out_run.txt 2>&1

#	run_cmd=""
    [ ${MACHINE} == "JEANZAY" ] && { mystartproc=0 ; }

    if [ ${USE_ATM} -eq 1 ]; then
#
       if [ ${MACHINE} == "JEANZAY" ]; then
           myendproc=$(( ${NP_WRF} - 1 ))
           mod_Str=$mystartproc"-"$myendproc
           echo "$mod_Str ./wrfexe" >> app.conf
           if [ ${USE_XIOS_ATM} -eq 1 ]; then
               mystartproc=$(( ${myendproc} + 1 )) 
               myendproc=$(( ${mystartproc} + ${NP_XIOS_ATM} - 1 ))
               mod_Str=$mystartproc"-"$myendproc
               echo "${NP_XIOS_ATM} ./xios_server.exe" >> app.conf
           fi
#
       else
           echo "${NP_WRF} ./wrfexe" >> app.conf
           if [ ${USE_XIOS_ATM} -eq 1 ]; then
                echo "${NP_XIOS_ATM} ./xios_server.exe" >> app.conf
            fi
       fi
    fi
#
    if [ ${USE_OCE} -eq 1 ]; then
        if [ ${MACHINE} == "JEANZAY" ]; then
            [ ${USE_ATM} -eq 1 ] && { mystartproc=$(( ${myendproc} + 1 )) ; myendproc=$(( ${mystartproc} + ${NP_CRO} - 1 )); } || { myendproc=$(( ${NP_CRO} - 1 )) ; }
            mod_Str=$mystartproc"-"$myendproc
            echo "$mod_Str ./crocox" >> app.conf
            if [ ${USE_XIOS_OCE} -eq 1 ]; then
                mystartproc=$(( ${myendproc} + 1 ))
                myendproc=$(( ${mystartproc} + ${NP_XIOS_OCE} - 1 ))
                mod_Str=$mystartproc"-"$myendproc
                echo "${mod_Str} ./xios_server.exe" >> app.conf
            fi
#
        else
            echo "${NP_CRO} ./crocox croco.in" >> app.conf
     	    if [ ${USE_XIOS_OCE} -eq 1 ]; then
                echo "${NP_XIOS_OCE} ./xios_server.exe" >> app.conf
#                run_cmd="$run_cmd : -n ${NP_XIOS_OCE} xios_server.exe"
            fi
        fi
    fi
#
    if [ ${USE_WW3} -eq 1 ]; then
        if [ ${MACHINE} == "JEANZAY" ]; then
            if [ ${USE_ATM} -eq 1 ] || [ ${USE_OCE} -eq 1 ]; then
                mystartproc=$(( ${myendproc} + 1 ))
                myendproc=$(( ${mystartproc} + ${NP_WW3} - 1 ))
            else
                myendproc=$(( ${NP_WW3} - 1 )) 
            fi
            mod_Str=$mystartproc"-"$myendproc
            echo "${mod_Str} ./wwatch" >> app.conf
        else
           echo "${NP_WW3} wwatch" >> app.conf
        fi
#           run_cmd="$run_cmd : -n $NP_WW3 wwatch"
    fi
#        if [ ${COMPUTER}  == "DATARMOR" ]; then       
	echo "launch run: $MPI_LAUNCH ${MPI_ext} app.conf " #${run_cmd} #$app.conf

##### RUN ######
time $MPI_LAUNCH ${MPI_ext} app.conf > out_run.txt 2>&1
#${run_cmd} #app.conf
################
#        fi
#	time ccc_mprun -f app.conf > out_run.txt 2>&1
#	time ccc_mprun -f app.conf 1>out_run.txt 2>err_run.txt

        printf "\n\n PWD: `pwd`\n"

        [ -f time.step ] && printf "\n  time.step: `cat time.step` \n"
        printf "\n---------------   end    ---------------\n"
        printf "\n date_chris : `date "+%Y%m%d-%H:%M:%S"`\n"
        printf "\n see ls -l in ${EXEDIR}/ls_l/ls_post_exe.txt\n"
        ls -l > ls_l/ls_post_exe.txt
 
fi # Step2
 

#===============================================================================
#  Step 3 commands:  put_file step 
#===============================================================================
if [ ${LOADL_STEP_NAME} == "put_file" ] || [ "${LOADL_STEP_NAME}" == "XXX" ] ; then
     
        export JOBDIR="${JOBDIR_ROOT}/${ROOT_NAME_2}"
        export EXEDIR="${EXEDIR_ROOT}/${ROOT_NAME_2}"
        export OUTPUTDIR="${OUTPUTDIR_ROOT}/${ROOT_NAME_2}"
        export RESTDIR_OUT="${RESTDIR_ROOT}/${ROOT_NAME_3}"
        
# OUTPUTDIR: output directory
        ${MACHINE_STOCKAGE} ls ${OUTPUTDIR}  >  /dev/null  2>&1
        [ "$?" -eq "0" ] && ${MACHINE_STOCKAGE} mv ${OUTPUTDIR} ${OUTPUTDIR}_${OLD}
        ${MACHINE_STOCKAGE} mkdir -p ${OUTPUTDIR}

# RESTDIR_OUT: restart directory
        ${MACHINE_STOCKAGE} ls ${RESTDIR_OUT}  >  /dev/null  2>&1
        [ "$?" -eq "0" ] && ${MACHINE_STOCKAGE} mv ${RESTDIR_OUT} ${RESTDIR_OUT}_${OLD}
        ${MACHINE_STOCKAGE} mkdir -p ${RESTDIR_OUT}

cd ${EXEDIR} 
        printf "\n date_chris : `date "+%Y%m%d-%H:%M:%S"`\n"
        [ ${USE_OCE} -eq 1 ] && printf "\n ************* put OCEAN OUTPUT/RESTART files *****************\n" |tee ls_l/putfile_oce.txt
        [ ${USE_OCE} -eq 1 ] && printf "    see listing in ${EXEDIR}/ls_l/putfile_oce.txt \n" 
        [ ${USE_OCE} -eq 1 ] && { . ${SCRIPTDIR}/putfile_oce.sh ; } >> ls_l/putfile_oce.txt

        [ ${USE_ATM} -eq 1 ] && printf "\n ************* put ATMOSPHERE OUTPUT/RESTART files *****************\n" |tee ls_l/putfile_atm.txt
        [ ${USE_ATM} -eq 1 ] && printf "    see listing in ${EXEDIR}/ls_l/putfile_atm.txt \n"
        [ ${USE_ATM} -eq 1 ] && { . ${SCRIPTDIR}/putfile_atm.sh ; } >> ls_l/putfile_atm.txt
       
        [ ${USE_WW3} -eq 1 ] && printf "\n ************* put WAVE OUTPUT/RESTART files *****************\n" |tee ls_l/putfile_ww3.txt
        [ ${USE_WW3} -eq 1 ] && printf "    see listing in ${EXEDIR}/ls_l/putfile_ww3.txt \n"
        [ ${USE_WW3} -eq 1 ] && { . ${SCRIPTDIR}/putfile_ww3.sh ; } >> ls_l/putfile_ww3.txt

        [ ${USE_CPL} -ge 1 ] && printf "\n ************* put OA3MCT OUTPUT/RESTART files *****************\n" 
        [ ${USE_CPL} -ge 1 ] && { . ${SCRIPTDIR}/putfile_cpl.sh ; }

#-------------------------------------------------------------------------------
#  save output control ascii files in jobs directory
#-------------------------------------------------------------------------------

        printf "\n ************* save ascii job files in ${JOBDIR} *****************\n" 
# if ocean
        FILES_OCE="layout.dat ocean.output* namelist out_run.txt *time.step solver.stat* croco.log"        
        [ ${USE_OCE} -eq 1 ] && {  for file in ${FILES_OCE}; do cpfile2 ${file} ${JOBDIR}; done; echo ""; }
# if atmosphere
        FILES_ATM="namelist.input rsl.error.0000 rsl.out.0000"
        [ ${USE_ATM} -eq 1 ] && {  for file in ${FILES_ATM}; do cpfile2 ${file} ${JOBDIR}; done; echo ""; }
# if wave
        FILES_WW3="log.ww3 strt.out ounf.out prnc.*.out grid.out"
        [ ${USE_WW3} -eq 1 ] && {  for file in ${FILES_WW3}; do cpfile2 ${file} ${JOBDIR}; done; echo ""; }
# if coupler
        FILES_CPL="nout.000000 wrfexe.timers* crocox.timers* wwatch.timers*"
        [ ${USE_CPL} -ge 1 ] && {  for file in ${FILES_CPL}; do cpfile2 ${file} ${JOBDIR}; done; echo ""; }
# if agrif
        FILES_AGRIFZ="AGRIF_FixedGrids.in"
        [ ${AGRIFZ} -eq 1 ] && {  for file in ${FILES_AGRIFZ}; do cpfile2 ${file} ${JOBDIR}; done; echo ""; }
# job
        FILES_JOB="${jobname}"
        if [ ${COMPUTER} == "VARGAS" ] ; then
            FILES_JOB="${FILES_JOB} ${ROOT_NAME_1}.get_file.jobid_*.txt ${ROOT_NAME_1}.run_model.jobid_*.txt ${ROOT_NAME_1}.put_file.jobid_*.txt " 
        elif [ ${COMPUTER} == "IRENE" ]; then
            FILES_JOB="${FILES_JOB} ${ROOT_NAME_1}*.o ${ROOT_NAME_1}*.e"
        elif [ ${COMPUTER} == "JEANZAY" ]; then
            FILES_JOB="${FILES_JOB} ${ROOT_NAME_1}.out"
        else
            FILES_JOB="${FILES_JOB} ${ROOT_NAME_1}.jobid_*.txt ${ROOT_NAME_1}.o*"
        fi
        cd ${JOBDIR_ROOT}; for file in ${FILES_JOB}; do mvfile2 ${file} ${JOBDIR}; done;  cd -; echo "";
#
#  mv output files in output directory 
#
#        mkdir output
#        mv ${CEXPER}* output

        printf "\n date_chris : `date "+%Y%m%d-%H:%M:%S"`\n"

#-------------------------------------------------------------------------------
#  NEXT job!
#-------------------------------------------------------------------------------
        printf "\n *************  run the next job  *****************\n"

if [ "${MODE_TEST}" == "" ] ; then      #  en production  
        sed -e "s/YEAR_BEGIN_JOB=.*/YEAR_BEGIN_JOB=${YEAR_BEGIN_JOBp1}/" \
            -e "s/MONTH_BEGIN_JOB=.*/MONTH_BEGIN_JOB=${MONTH_BEGIN_JOBp1}/" \
            -e "s/DAY_BEGIN_JOB=.*/DAY_BEGIN_JOB=${DAY_BEGIN_JOBp1}/" \
                ${SCRIPTDIR}/namelist_exp.sh > tata.sh
        mvfile2 ${SCRIPTDIR}/namelist_exp.sh ${JOBDIR}
        mvfile tata.sh ${SCRIPTDIR}/namelist_exp.sh
        chmod 755   ${SCRIPTDIR}/namelist_exp.sh

	if [ ${DATE_END_JOB} -ne ${DATE_END_EXP} ]
	then
        cd ${SCRIPTDIR}
        chmod 755 submitjob.sh
        ./submitjob.sh
    else
	    printf "\n     run finished at date : ${DATE_END_EXP} \n\n\n\n"
	    exit 0
	fi

else # en test
        printf "\n\n\n\n  MODE_TEST=${MODE_TEST}  Mode test et non production => Pas d'enchainement de jobs.\n\n\n\n"
fi

fi # Step3

