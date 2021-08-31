#!/bin/ksh
set -ue
#set -vx
#
. ${SCRIPTDIR}/routines/caltools.sh
##
##======================================================================
##----------------------------------------------------------------------
##    II. modify namcouple
##----------------------------------------------------------------------
##======================================================================
##
#

echo ' '
echo '-- OASIS inputs --------------'
echo 'fill oasis namcouple'

sed -e "s/<runtime>/$(( ${TOTAL_JOB_DUR} * 86400 ))/g" \
    -e "s/<cpldt>/${CPL_FREQ}/g" \
    ${CPL_NAM_DIR}/${namcouplename} > ./namcouple

### For ATM ###
for dom in $wrfcpldom ; do
    file="wrfinput_${dom}"
    if [ $dom == "d01" ]; then
        searchf=("<atmdt>" "<atmnx>" "<atmny>")
    else 
        searchf=("<atmdt${dom}>" "<atmnx${dom}>" "<atmny${dom}>")
    fi
    
    dimx=$( ncdump -h  $file  | grep "west_east_stag =" | cut -d ' ' -f 3)
    dimy=$( ncdump -h  $file  | grep "south_north_stag =" | cut -d ' ' -f 3)
    
    sed -e "s/${searchf[0]}/${TSP_ATM}/g"   -e "s/${searchf[1]}/${dimx}/g"   -e "s/${searchf[2]}/${dimy}/g" \
    ./namcouple>tmp$$

    mv tmp$$ namcouple
done

### For WAV ###
sed -e "s/<wavdt>/${TSP_WAV}/g"   -e "s/<wavnx>/${wavnx}/g"   -e "s/<wavny>/${wavny}/g"  \

### For OCE ###
for nn in $( seq 0 ${AGRIFZ} ); do
    if [ ${nn} -gt 0 ];    then
        agrif_ext=".${nn}"
        SUBTIME=$( sed -n -e "$(( 2 * ${nn} )) p" AGRIF_FixedGrids.in | awk '{print $7 }' )
        searchf=("<ocedt${nn}>" "<ocenx${nn}>" "<oceny${nn}>" )
        tsp=$(( ${TSP_OCE} / ${SUBTIME} ))
    else
        agrif_ext=""
        searchf=("<ocedt>" "<ocenx>" "<oceny>" )
        tsp=${TSP_OCE}
    fi

    dimx=$( ncdump -h  croco_grd.nc${agrif_ext}  | grep "xi_rho =" | cut -d ' ' -f 3)
    dimy=$( ncdump -h  croco_grd.nc${agrif_ext}  | grep "eta_rho =" | cut -d ' ' -f 3)

    sed -e "s/${searchf[0]}/${tsp}/g"   -e "s/${searchf[1]}/$(( ${dimx} - 2 ))/g"   -e "s/${searchf[2]}/$(( ${dimy} - 2 ))/g" \
    ./namcouple>tmp$$
   
    mv tmp$$ namcouple    
done

