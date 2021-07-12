#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------

if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then
    cur_Y=$( echo $DATE_BEGIN_JOB | cut -c 1-4 )
    cur_M=$( echo $DATE_BEGIN_JOB | cut -c 5-6 )
    ${io_getfile} ${OCE_FILES_DIR}/croco_${ini_ext}_Y${cur_Y}M${cur_M}.nc                  croco_ini.nc
else
    for ff in ${RESTDIR_IN}/croco_rst_${DATE_END_JOBm1}.nc #${CEXPER}_????????_rst.*.nc
    do
	${io_getfile} $ff croco_ini.nc # ${ff/*_rst/}
    done
fi
