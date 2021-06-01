#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------
if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then

    module load $ncomod
    echo 'copy oasis scripts'
    cp -f ${INPUTDIRC}/*.sh ./ #cpfile2
#
    if [ ${USE_ATM} -eq 1 ] ; then
        varlist='WRF_d01_EXT_d01_SURF_NET_SOLAR WRF_d01_EXT_d01_EVAP-PRECIP WRF_d01_EXT_d01_SURF_NET_NON-SOLAR WRF_d01_EXT_d01_TAUX WRF_d01_EXT_d01_TAUY WRF_d01_EXT_d01_TAUMOD WRF_d01_EXT_d01_WND_U_01 WRF_d01_EXT_d01_WND_V_01'
        echo 'create restart file for oasis from calm conditions for variables:'${varlist}
        ./create_oasis_restart_from_calm_conditions.sh wrfinput_d01 atm.nc wrf "${varlist}"
    fi
#
    if [ ${USE_OCE} -eq 1 ] ; then
        varlist='SRMSSTV0 SRMSSHV0 SRMVOCE0 SRMUOCE0'
        echo 'create restart file for oasis from calm conditions for variables:'${varlist}
        ./create_oasis_restart_from_calm_conditions.sh croco_grd.nc oce.nc croco "${varlist}"
    fi
#
    if [ ${USE_WW3} -eq 1 ] ; then
        varlist='WW3_T0M1 WW3__OHS WW3__DIR WW3_ACHA WW3_TAWX WW3_TAWY WW3_TWOX WW3_TWOY'
        echo 'create restart file for oasis from calm conditions for variables:'${varlist}
        ./create_oasis_restart_from_calm_conditions.sh ${ww3file} wav.nc ww3 "${varlist}"
    fi
    module unload $ncomod

else   
    
    [ ${USE_ATM} -eq 1 ] && cpfile ${RESTDIR_IN}/atm_${CEXPER}_${DATE_END_JOBm1}.nc atm.nc
    [ ${USE_OCE} -eq 1 ] && cpfile ${RESTDIR_IN}/oce_${CEXPER}_${DATE_END_JOBm1}.nc oce.nc
    [ ${USE_WW3} -eq 1 ] && cpfile ${RESTDIR_IN}/wav_${CEXPER}_${DATE_END_JOBm1}.nc wav.nc
    [[ ${USE_ATM} -eq 1 && ${USE_OCE} -eq 1 ]] && cp ${RESTDIR_IN}/*atmt_to_ocnt* . && cp ${RESTDIR_IN}/*ocnt_to_atmt* . 
    [[ ${USE_ATM} -eq 1 && ${USE_WW3} -eq 1 ]] && cp ${RESTDIR_IN}/*atmt_to_ww3t* . && cp ${RESTDIR_IN}/*ww3t_to_atmt* .
    [[ ${USE_OCE} -eq 1 && ${USE_WW3} -eq 1 ]] && cp ${RESTDIR_IN}/*ocn*_to_ww3t* . && cp ${RESTDIR_IN}/*ww3t_to_ocnt* .  
    cpfile2 ${RESTDIR_IN}/grids.nc ./ ; cpfile2 ${RESTDIR_IN}/masks.nc  ./ ; cpfile2 ${RESTDIR_IN}/areas.nc ./
    

fi
