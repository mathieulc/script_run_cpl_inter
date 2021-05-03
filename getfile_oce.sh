#!/bin/bash
#-------------------------------------------------------------------------------
#                                                          Configuration files
#-------------------------------------------------------------------------------

# Get grid file
${io_getfile} ${INPUTDIRO}/croco_grd.nc                croco_grd.nc

# Get boundary foring
. ${SCRIPTDIR}/getbry_oce.sh

# Get surface forcing if needed
[ ${surfrc_flag}=="True" ] && . ${SCRIPTDIR}/getfrc_oce.sh

          
	       














