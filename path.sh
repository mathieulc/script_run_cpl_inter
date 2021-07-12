

#-------------------------------------------------------------------------------
# working paths
#-------------------------------------------------------------------------------
CPL_HOME=/home2/datawork/mlecorre/COUPLING/CONFIG
CPL_WORK=/home2/datawork/mlecorre/COUPLING/CONFIG
CONF_NAME=BENGUELA
EXP_NAME=run_dir

export EXEDIR_ROOT="$CPL_WORK/$CONF_NAME/$EXP_NAME/execute"
export OUTPUTDIR_ROOT="$CPL_WORK/$CONF_NAME/$EXP_NAME/outputs"
export RESTDIR_ROOT="$CPL_WORK/$CONF_NAME/$EXP_NAME/restarts"

#-------------------------------------------------------------------------------
# OCE
#-------------------------------------------------------------------------------
export OCE_EXE_DIR="$CPL_HOME/$CONF_NAME/croco_in"
export OCE_NAM_DIR="$CPL_HOME/$CONF_NAME/croco_in"
export OCE_FILES_DIR="$CPL_WORK/$CONF_NAME/croco_files"
export OCE_FILES_ONLINEDIR=""

#-------------------------------------------------------------------------------
# ATM
#-------------------------------------------------------------------------------
export ATM_EXE_DIR="$CPL_HOME/../WRF_xios_LR/exe_coupled"
export ATM_NAM_DIR="$CPL_HOME/$CONF_NAME/wrf_in"
export ATM_FILES_DIR="$CPL_WORK/$CONF_NAME/wrf_files/2005"

#-------------------------------------------------------------------------------
# WAV
#-------------------------------------------------------------------------------
export WAV_EXE_DIR="$CPL_HOME/../WW3/model/exe_owa_BENGUELA"
export WAV_NAM_DIR="$CPL_HOME/$CONF_NAME/ww3_in/inputs_ww3"
export WAV_FILES_DIR="$CPL_WORK/$CONF_NAME/ww3_files"

#-------------------------------------------------------------------------------
# TOY
#-------------------------------------------------------------------------------
export TOY_EXE_DIR="$CPL_HOME/$CONF_NAME/toy_in"
export TOY_NAM_DIR="$CPL_HOME/$CONF_NAME/toy_in"

#-------------------------------------------------------------------------------
# XIOS
#-------------------------------------------------------------------------------
export XIOS_EXE_DIR="$CPL_HOME/xios"
export XIOS_NAM_DIR="$CPL_HOME/$CONF_NAME/XIOS_IN"

#-------------------------------------------------------------------------------
# OASIS
#-------------------------------------------------------------------------------
export CPL_NAM_DIR="$CPL_HOME/$CONF_NAME/oasis_in/inputs_oasis"
export CPL_FILES_DIR="$CPL_HOME/$CONF_NAME/oasis_in"

