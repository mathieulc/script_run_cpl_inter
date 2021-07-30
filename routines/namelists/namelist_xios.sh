#-------------------------------------------------------------------------------
# XIOS
#-------------------------------------------------------------------------------
# namelist
export FILIN_XIOS="iodef.xml context_roms.xml context_wrf.xml field_def.xml domain_def.xml file_def_croco.xml file_def_wrf.xml" # files needed for xios. Need to be in INPUTDIRX (cf header.*)

# files
export ATM_XIOS_NAME="wrfout_inst" # All the names you have defined in your xml file
export OCE_XIOS_NAME="${CEXPER}_1d_aver ${CEXPER}_1h_inst_surf ${CEXPER}_6h_his"

