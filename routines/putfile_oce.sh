
#-------------------------------------------------------------------------------
#                                                                      Average
#-------------------------------------------------------------------------------

if [ ${USE_XIOS} -eq 1 ]; then 
   mv ${CONFIG}_* ${OUTPUTDIR}/
else

   for ff in croco_his.nc croco_avg.nc ; do
       [ ${ff} == 'croco_his.nc' ] && name=croco_his
       [ ${ff} == 'croco_avg.nc' ] && name=croco_avg
       mv ${ff} ${OUTPUTDIR}/${name}_${DATE_BEGIN_JOB}_${DATE_END_JOB}.nc
   done
fi

#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------

for ff in croco_rst.nc
do
#    fff=${CEXPER}_${DATE_END_JOB}_rst${ff/rst.????/}
    fff=croco_rst_${DATE_END_JOB}.nc
    ${io_putfile} $ff ${RESTDIR_OUT}/$fff
done
