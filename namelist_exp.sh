############################# from namelist_exp.sh #############################
#===============================================================================
#  Namelist for the experiment
#===============================================================================
export MACHINE="DATARMOR" #DATARMOR / JEANZAY /IRENE
#-------------------------------------------------------------------------------
#  Config : Ocean - Atmosphere - Coupling
#-------------------------------------------------------------------------------
export CONFIG=BEGUELA
export RUN=owa

#
export USE_ATM=1
export USE_XIOS_ATM=0
#
export USE_OCE=1
export USE_XIOS_OCE=0
#
export USE_WAV=1
#
export USE_TOY=0



#-------------------------------------------------------------------------------
# Namelist files and forcing
# ------------------------------------------------------------------------------
### OASIS namelist ###

export namcouplename=namcouple.base.${RUN}

#### WRF namelist ###

export atmnamelist=namelist.input.prep.BENGUELA.${RUN}
export NB_dom=1 # Number of coupled domains
export wrfcpldom='d01'

### CROCO ###
export ini_ext='ini_SODA' # ini extension file (ini_SODA,...)
export bry_ext='bry_SODA' # bry extension file (bry_SODA,...)
export surfrc_flag="FALSE" # Flag if surface forcing is needed (FALSE if cpl)
export interponline=0 # switch (1=on, 0=off) for online surface interpolation
export frc_ext='blk_CFSR' # surface forcing extension(blk_CFSR, frc_CFSR,...). If interponline=1 just precise the type (ECMWF, CFSR,AROME,...)
export tide_flag="FALSE" # the forcing extension must be blk_??? otherwise tide forcing overwrites it 
export AGRIFZ=0
export AGRIF_NAMES=""
### WW3 ###

export flagout="TRUE" # Keep (TRUE) or not (FALSE) ww3 full output binary file (out_grd.ww3)
export forcin=() # forcing file(s) list (leave empty if none)
export forcww3=() # name of ww3_prnc.inp extension/input file

### TOY ###
export toytype=("wav" "atm") #oce,atm,wav
export toyfile=("/home2/datawork/mlecorre/COUPLING/CONFIG/BENGUELA/outputs_frc_ww3_CFSR/ww3.frc.200501.nc" "/home2/scratch/mlecorre/BEGUELA/outputs/20050101_20050131/wrfout_d01_20050101_20050131.nc")
export timerange=('1,745' '2,125')


### XIOS ### 
export FILIN_XIOS="iodef.xml context_roms.xml context_wrf.xml field_def.xml domain_def.xml file_def_croco.xml file_def_wrf.xml" # files needed for xios. Need to be in INPUTDIRX (cf header.*)
export ATM_XIOS_NAME="wrfout_inst" # All the names you have defined in your xml file
export OCE_XIOS_NAME="${CONFIG}_1d_aver ${CONFIG}_1h_inst_surf ${CONFIG}_6h_his"

#-------------------------------------------------------------------------------
# Number of core used
# ------------------------------------------------------------------------------
MPI_LAUNCH_CMD=$MPI_LAUNCH  # ccc_mprun :for irene / $MPI_LAUCH for datarmor (or mpiexec.hydra )

### PROX XIOS ###
export NP_XIOS_ATM=1
export NP_XIOS_OCE=1

### PROC OCE ###
export NP_OCE=4

### PROC ATM ###
export NP_ATM=12
# MPI Settings for ATM 
export atm_nprocX=-1      # -1 for automatic settings
export atm_nprocY=-1      # -1 for automatic settings
export atm_niotaskpg=0    # 0 for default settings
export atm_niogp=1        # 1 for default settings


### PROC WAV ###
export NP_WAV=10
export SERIAL_LAUNCH_WAV="$MPI_LAUNCH -n 1 " # for ww3 prepro getrst_ww3.sh

### PROC TOY ###
export NP_TOY=2

#-------------------------------------------------------------------------------
#  1 experiment / n jobs
#-------------------------------------------------------------------------------
# The experiment is divided into jobs 

#                                                           Period of Experiment
export YEAR_BEGIN_EXP=2005
export MONTH_BEGIN_EXP=1
export DAY_BEGIN_EXP=1
#                                                     Duration of the Experiment
export EXP_DUR_MTH=$(( 3 * 1 ))
export EXP_DUR_DAY=0
#                                                                  Period of Job
export YEAR_BEGIN_JOB=2005
export MONTH_BEGIN_JOB=1
export DAY_BEGIN_JOB=1
#                                                            Duration of the Job
export JOB_DUR_MTH=1
export JOB_DUR_DAY=0

#-------------------------------------------------------------------------------
#  Time Steps
#-------------------------------------------------------------------------------

### WRF ###
export TSP_ATM=100 #100   # 100 90 75 72 60 45

### CROCO ###
export TSP_OCE=1200
export TSP_OCEF=60

### WW3 ###
export TSP_WAV=3600     # TMAX = 3*TCFL
export TSP_WW_PRO=1200  # TCFL --> ww3.grid to see the definition
export TSP_WW_REF=1800  # TMAX / 2
export TSP_WW_SRC=10

### TOY ###
#!!!! WARNING !!!!
# When using toy, please put the output frequency of "toyfile" in the TSP of the model
# example: ww3.200501.nc output_frequency=3600 -----> TSP_WW3=3600
#!!!!!!!!!!!!!!!!!

### CPL ###
export CPL_FREQ=21600

#-------------------------------------------------------------------------------
# Grids sizes
#-------------------------------------------------------------------------------
export atmnx=56 ; export atmny=50
export wavnx=41 ; export wavny=42
export ocenx=41 ; export oceny=42
export hmin=75; # minimum water depth in CROCO, delimiting coastline in WW3 


#-------------------------------------------------------------------------------
#  Output Settings
#-------------------------------------------------------------------------------

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#                                          WARNING                                       ! 
# When XIOS is activated the following values (for the model) are not taken into account !
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# ATM
export atm_his_h=6                        # output interval (h)
export atm_his_frames=1000 # $((31*24))          # nb of outputs per file
export atm_diag_int_m=$((${atm_his_h}*60))  # diag output interval (m)
export atm_diag_frames=1000     # nb of diag outputs per file

# oce

export oce_nhis=18     # history output interval (in number of timesteps) 
export oce_navg=18     # average output interval (in number of timesteps) 

# WW3
export wav_int=21600            # output interval (s)
# ww3 file to be used for creating restart file for oasis 
export wavfile=/home2/datawork/mlecorre/COUPLING/CONFIG/BENGUELA/outputs_frc_ww3_CFSR/ww3.200501.nc # Usually done by running a frc mode on the area

#-------------------------------------------------------------------------------
#  Job submission type
#-------------------------------------------------------------------------------
export CHAINED_JOB="FALSE" #If TRUE  , place all the jobs in the queue at the begining,
                          #Ff FALSE , place job in the queue after the previous one ended

# MODE_TEST: extension du nom de l'experience
#            pour tourner differents tests dans la meme experience
# on peut lancer plusieurs tests en même temps mais pas être en production et lancer des tests
export         MODE_TEST=""    #   mode Production 

#-------------------------------------------------------------------------------
#  Multi-Step
#-------------------------------------------------------------------------------
LOADL_STEP_NAME="XXX" # to access directly to "get_file"/"run_model"/"put_file" in job_base.sh 

# DEBUG for test
export SCRIPT_DEBUG="FALSE"

################################################################################
############################ END USER CHANGE ###################################
################################################################################

# KEY for XIOS and TOY #
export USE_XIOS=$(( ${USE_XIOS_ATM} + ${USE_XIOS_OCE} ))
[ ${USE_TOY} -eq 1 ] && export USE_CPL=1 || export USE_CPL=$(( ${USE_ATM} * ${USE_OCE} + ${USE_ATM} * ${USE_WAV} + ${USE_OCE} * ${USE_WAV} ))

### TOY ###
export nbtoy=${#toytype[@]}
export model_to_toy=()
export toynamelist=()
export TSP_TOY=()
for k in `seq 0 $(( ${nbtoy} - 1))` ; do
    [ ${toytype[$k]} == "oce" ] && model_to_toy+=("croco")
    [ ${toytype[$k]} == "atm" ] && model_to_toy+=("wrf")
    [ ${toytype[$k]} == "wav" ] && model_to_toy+=("ww3")
    if [ ${nbtoy} -eq 1 ]; then
        toynamelist+=("TOYNAMELIST.nam.${toytype[$k]}.${RUN}")
    elif [ ${nbtoy} -eq 2 ]; then
        toynamelist+=("TWOTOYNAMELIST.nam.${toytype[$k]}.${RUN}")
    else
        printf "\n No namelist available for three namelist toy\n" ; exit 0
    fi
    [ ${toytype[$k]} == "oce" ] && TSP_TOY+=("${TSP_OCE}")
    [ ${toytype[$k]} == "atm" ] && TSP_TOY+=("${TSP_ATM}")
    [ ${toytype[$k]} == "wav" ] && TSP_TOY+=("${TSP_WAV}")
done
######

#-------------------------------------------------------------------------------
#  Name and directory of the experiment (from the path of the experiment)
#-------------------------------------------------------------------------------
export CEXPER=`pwd | awk -F"/" '{print $(NF-1)}'`
PWD1=$(pwd)
export    RUNDIR=${PWD1%/*}

#-------------------------------------------------------------------------------
#  Directories
#-------------------------------------------------------------------------------
export  JOBDIR_ROOT=${RUNDIR}/jobs_${CONFIG}
export    SCRIPTDIR=${RUNDIR}/script_run_cpl_inter

#-------------------------------------------------------------------------------
#  Calendar computation
#-------------------------------------------------------------------------------
cd ${SCRIPTDIR}
   . ./routines/caltools.sh
cd -

#-------------------------------------------------------------------------------
#  Names
#-------------------------------------------------------------------------------
export    ROOT_NAME_1="${CEXPER}_${DATE_BEGIN_JOB}_${DATE_END_JOB}${MODE_TEST}"
export              ROOT_NAME_2="${DATE_BEGIN_JOB}_${DATE_END_JOB}${MODE_TEST}"
export                                ROOT_NAME_3="${DATE_END_JOB}${MODE_TEST}"
export    jobname="job_${ROOT_NAME_1}.sh"  # File submitted. For DATRAMOR the extension is changed by .pbs

#-------------------------------------------------------------------------------
#  define the function to get/put files
#-------------------------------------------------------------------------------
export io_getfile="lnfile"
export io_putfile="mvfile"

#-------------------------------------------------------------------------------
#  Which Computer?
#-------------------------------------------------------------------------------
if [ ${MACHINE} == "IRENE" ]; then
   export QSUB="ccc_msub -m work,store,scratch"
   export COMPUTER="IRENE"
elif [ ${MACHINE} == "JEANZAY" ]; then
   export QSUB="sbatch"
   export COMPUTER="JEANZAY"
elif [ ${MACHINE} == "DATARMOR" ]; then
   export QSUB="qsub"
   export COMPUTER="DATARMOR"
   export jobname="job_${ROOT_NAME_1}.pbs"
else
   printf "\n\n Machine unknown  => EXIT \n\n"; exit;
fi

echo ${COMPUTER}
