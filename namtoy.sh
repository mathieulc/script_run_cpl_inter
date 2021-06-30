#!/bin/ksh
set -ue
#set -vx
#
. ./caltools.sh
##

## -------------------------- #
## - Copy TOY input files -   #
## -------------------------- #


#-------
## Number of time step per day
#-------
TOY_NTSP_DAY=$(( 86400 / ${TSP_TOY} ))
TOY_NTIMES=$(( ( ${JDAY_END_JOB} - ${JDAY_BEGIN_JOB} + 1 ) * ${TOY_NTSP_DAY}     ))
#



echo "fill ${toynamelist}"

sed -e "s/<toydt>/${TSP_TOY}/g" -e "s/<toytimes>/${TOY_NTIMES}/g"   \
    ${TOY_NAMEDIR}/${toynamelist} > ./TOYNAMELIST.nam

