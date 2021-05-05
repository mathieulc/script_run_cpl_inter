
#-------------------------------------------------------------------------------
#                                                                      Average
#-------------------------------------------------------------------------------

for ff in croco_his.nc croco_avg.nc
do
#    mv $ff ${CEXPER}_1d_${DATE_BEGIN_JOB}_${DATE_END_JOB}_$ff
     [ ${ff} == 'croco_his.nc' ] && name=croco_his
     [ ${ff} == 'croco_avg.nc' ] && name=croco_avg
     mv ${ff} ${OUTPUTDIR}/${name}_${DATE_BEGIN_JOB}_${DATE_END_JOB}.nc
done

#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------

for ff in croco_rst.nc
do
#    fff=${CEXPER}_${DATE_END_JOB}_rst${ff/rst.????/}
    fff=croco_rst_${DATE_END_JOB}.nc
    ${io_putfile} $ff ${RESTDIR_OUT}/$fff
done
