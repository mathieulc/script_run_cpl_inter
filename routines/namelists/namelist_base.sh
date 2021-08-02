############################# from mynamelist.sh ###############################

################################################################################
############################ USER CHANGES ######################################
################################################################################
#
export CEXPER=BENGUELA
export RUNtype=owa
#
export USE_ATM=1
export USE_TOYATM=0
export USE_XIOS_ATM=0
#
export USE_OCE=1
export USE_TOYOCE=0
export USE_XIOS_OCE=0
#
export USE_WAV=1
export USE_TOYWAV=0
#
[ ${USE_TOYATM}  -eq 1 ] && istoy=.toyatm  || istoy=''
[ ${USE_TOYWAV}  -eq 1 ] && istoy=.toywav  || istoy=''
[ ${USE_TOYOCE}  -eq 1 ] && istoy=.toyoce  || istoy=''
#
#-------------------------------------------------------------------------------
# RUN_DIR
#-------------------------------------------------------------------------------
export EXEDIR_ROOT="$CWORK/rundir/${CEXPER}_execute"
export OUTPUTDIR_ROOT="$CWORK/rundir/${CEXPER}_outputs"
export RESTDIR_ROOT="$CWORK/rundir/${CEXPER}_restarts"

export  JOBDIR_ROOT=${CHOME}/jobs_${CEXPER}
#-------------------------------------------------------------------------------
# Exe paths
# ------------------------------------------------------------------------------
export ATM_EXE_DIR=$ATM/exe_coupled
export OCE_EXE_DIR=$CHOME/croco_in
export WAV_EXE_DIR=$WAV/exe_${RUNtype}_${CEXPER}
export TOY_EXE_DIR=$CHOME/toy_in
export XIOS_EXE_DIR=$XIOS

#-------------------------------------------------------------------------------
# Model settings
# ------------------------------------------------------------------------------

################################################################################
############################ END USER CHANGE ###################################
################################################################################

if [ ${USE_ATM} == 0 ]; then
    export TSP_ATM=0
    export atmnx=56 ; export atmny=50
fi

if [ ${USE_OCE} == 0 ]; then
    export TSP_OCE=0
    export ocenx=41 ; export oceny=42
fi

if [ ${USE_WAV} == 0 ]; then
    export TSP_WAV=0
    export wavnx=41 ; export wavny=42
fi

# KEY for XIOS and TOY #
export USE_XIOS=$(( ${USE_XIOS_ATM} + ${USE_XIOS_OCE} ))
export USE_TOY=$(( ${USE_TOYATM} + ${USE_TOYOCE} + ${USE_TOYWAV} ))
[ ${USE_TOY} -ge 1 ] && export USE_CPL=1 || export USE_CPL=$(( ${USE_ATM} * ${USE_OCE} + ${USE_ATM} * ${USE_WAV} + ${USE_OCE} * ${USE_WAV} ))

### TOY ###
[ -z ${toytype+x} ] && export toytype=()

export nbtoy=${#toytype[@]}
export model_to_toy=()
export toynamelist=()
export TSP_TOY=()
for k in `seq 0 $(( ${nbtoy} - 1))` ; do
    [ ${toytype[$k]} == "oce" ] && model_to_toy+=("croco")
    [ ${toytype[$k]} == "atm" ] && model_to_toy+=("wrf")
    [ ${toytype[$k]} == "wav" ] && model_to_toy+=("ww3")
    if [ ${nbtoy} -eq 1 ]; then
        toynamelist+=("TOYNAMELIST.nam.${toytype[$k]}.${RUNtype}")
    elif [ ${nbtoy} -eq 2 ]; then
        toynamelist+=("TWOTOYNAMELIST.nam.${toytype[$k]}.${RUNtype}")
    else
        printf "\n No namelist available for three namelist toy\n" ; exit 0
    fi
    [ ${toytype[$k]} == "oce" ] && TSP_TOY+=("${TSP_OCE}")
    [ ${toytype[$k]} == "atm" ] && TSP_TOY+=("${TSP_ATM}")
    [ ${toytype[$k]} == "wav" ] && TSP_TOY+=("${TSP_WAV}")
done
######
