#-------------------------------------------------------------------------------
#                                                                      Average
#-------------------------------------------------------------------------------


if [ ${USE_XIOS_ATM} -eq 1 ] ; then
    for file in ${ATM_XIOS_NAME}; do
        mv ${file}* ${OUTPUTDIR}/${file}_${DATE_BEGIN_JOB}_${DATE_END_JOB}.nc
    done
else
    for dom in `seq 1 $NB_dom`; do
        mv wrfout_d0${dom}_${YEAR_BEGIN_JOB}-* ${OUTPUTDIR}/wrfout_d0${dom}_${DATE_BEGIN_JOB}_${DATE_END_JOB}.nc
        mv wrfxtrm_d0${dom}_${YEAR_BEGIN_JOB}-* ${OUTPUTDIR}/wrfxtrm_d0${dom}_${DATE_BEGIN_JOB}_${DATE_END_JOB}.nc
   done
fi

#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------
year=$( printf "%04d"   ${YEAR_BEGIN_JOBp1} )
month=$( printf "%02d"   ${MONTH_BEGIN_JOBp1} )
day=$( printf "%02d"   ${DAY_BEGIN_JOBp1} )

date_rst="${year}-${month}-${day}"

for i in  wrfrst_d0?_${date_rst}_* 
   do
     ${io_putfile} $i ${RESTDIR_OUT}
done

