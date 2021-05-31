#-------------------------------------------------------------------------------
#                                                          Configuration files
#-------------------------------------------------------------------------------
# link data files necessary for running wrf in a dedicated directory $wrf/data
if [ ! -d ${WRF_EXE_DIR}/../data ] ; then
 mkdir ${WRF_EXE_DIR}/../data
 ln -s ${WRF_EXE_DIR}/../run/* ${WRF_EXE_DIR}/data/.
 # remove executables that could exist and namelist file
 rm -f ${WRF_EXE_DIR}/data/*.exe
 rm -f ${WRF_EXE_DIR}/data/namelist.input*
fi
echo 'link wrf data files'
echo "ln -sf ${WRF_EXE_DIR}/../data/* ."
ln -sf ${WRF_EXE_DIR}/data/* .

ms=$( printf "%02d"  ${MONTH_BEGIN_EXP} )
me=$(printf "%02d"  ${MONTH_END_EXP} )

#-------------------------------------------------------------------------------
#                                                          BDY
#-------------------------------------------------------------------------------
${io_getfile} ${INPUTDIRA}/wrfbdy_d01_${YEAR_BEGIN_EXP}_${ms}_${YEAR_BEGIN_EXP}_${me} wrfbdy_d01  # maybe put month and day of simu istead

#-------------------------------------------------------------------------------
#                                            Forcing fields (interannual case)
#-------------------------------------------------------------------------------
filelist='wrflowinp_d01'
 if [ $NB_dom -ge 2 ] ; then
  filelist="$filelist wrflowinp_d02"
  if [ $NB_dom -eq 3 ] ; then
   filelist="$filelist wrflowinp_d03"
  fi
 fi

for file in ${filelist}
 do
    ${io_getfile} ${INPUTDIRA}/${file}_${YEAR_BEGIN_EXP}_${ms}_${YEAR_END_EXP}_${me} ${file}  # add loop for d02 and d03
 done
