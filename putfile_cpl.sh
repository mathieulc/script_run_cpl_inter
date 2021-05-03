
#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------
   [ ${USE_ATM} -eq 1 ] && ${io_putfile} atm.nc ${RESTDIR_OUT}/atm_${CEXPER}_${DATE_END_JOB}.nc
   [ ${USE_OCE} -eq 1 ] && ${io_putfile} oce.nc ${RESTDIR_OUT}/oce_${CEXPER}_${DATE_END_JOB}.nc
   [ ${USE_WW3} -eq 1 ] && ${io_putfile} wav.nc ${RESTDIR_OUT}/wav_${CEXPER}_${DATE_END_JOB}.nc

   [[ ${USE_ATM} -eq 1 && ${USE_OCE} -eq 1 ]] && cp *atmt_to_ocnt* ${RESTDIR_OUT}/. && cp *ocnt_to_atmt* ${RESTDIR_OUT}/. 
   [[ ${USE_ATM} -eq 1 && ${USE_WW3} -eq 1 ]] && cp *atmt_to_ww3t* ${RESTDIR_OUT}/. && cp *ww3t_to_atmt* ${RESTDIR_OUT}/.
   [[ ${USE_OCE} -eq 1 && ${USE_WW3} -eq 1 ]] && cp *ocn*_to_ww3t* ${RESTDIR_OUT}/. && cp *ww3t_to_ocnt* ${RESTDIR_OUT}/. 

   cpfile2 grids.nc ${RESTDIR_OUT}/. && cpfile2 masks.nc ${RESTDIR_OUT}/. && cpfile2 areas.nc ${RESTDIR_OUT}/.



