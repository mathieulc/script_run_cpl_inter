#!/bin/bash
#-------------------------------------------------------------------------------
#                                                          Configuration files
#-------------------------------------------------------------------------------

# Get grid file
${io_getfile} ${OCE_FILES_DIR}/croco_grd.nc                croco_grd.nc

# Get boundary foring
. ${SCRIPTDIR}/routines/getbry_oce.sh

# Get surface forcing if needed
[ ${surfrc_flag} == "TRUE" ] && . ${SCRIPTDIR}/routines/getfrc_oce.sh

# Get tide forcing if any
[ ${tide_flag} == "TRUE" ] && ${io_getfile} ${OCE_FILES_DIR}/croco_frc.nc ./ 

          
	       














