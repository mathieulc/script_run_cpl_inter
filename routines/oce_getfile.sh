#!/bin/bash
#-------------------------------------------------------------------------------
#                                                          Configuration files
#-------------------------------------------------------------------------------

# Get grid file
${io_getfile} ${OCE_FILES_DIR}/croco_grd.nc                croco_grd.nc

# Get boundary foring
. ${SCRIPTDIR}/routines/oce_getbry.sh

# Get surface forcing if needed
[ ${surfrc_flag} == "TRUE" ] && . ${SCRIPTDIR}/routines/oce_getfrc.sh

# Get tide forcing if any
[ ${tide_flag} == "TRUE" ] && ${io_getfile} ${OCE_FILES_DIR}/croco_frc.nc ./ 

          
	       














