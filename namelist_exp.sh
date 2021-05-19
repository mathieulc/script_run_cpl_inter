
############################# from namelist_exp.sh #############################
#===============================================================================
#  Namelist for the experiment
#===============================================================================
export MACHINE="DATARMOR" #DATARMOR / JEANZAY /IRENE
#-------------------------------------------------------------------------------
#  Config : Ocean - Atmosphere - Coupling
#-------------------------------------------------------------------------------
export CONFIG=BEGUELA
export RUN=oa

#
export USE_ATM=1  
export USE_XIOS_ATM=1
#
export USE_OCE=1
export USE_XIOS_OCE=1
#
export USE_WW3=0
#
export USE_XIOS=$(( ${USE_XIOS_ATM} + ${USE_XIOS_OCE} ))
#export USE_ICE=0 # Not setup yet
export USE_CPL=$(( ${USE_ATM} * ${USE_OCE} + ${USE_ATM} * ${USE_WW3} + ${USE_OCE} * ${USE_WW3}))

export AGRIFZ=0
export AGRIF_NAMES=""

# Namelist files and forcing
# ----------------------------
### OASIS namelist ###

export namcouplename=namcouple.base.${RUN}

#### WRF namelist ###

export wrfnamelist=namelist.input.prep.BENGUELA.${RUN}
export NB_dom=1 # Number of coupled domains
export wrfcpldom='d01'

### CROCO ###
export ini_ext='ini_SODA' # ini extension file (ini_SODA,...)
export bry_ext='bry_SODA' # bry extension file (bry_SODA,...)
export surfrc_flag="FALSE" # Flag if surface forcing is needed (FALSE if cpl)
export interponline=0 # switch (1=on, 0=off) for online surface interpolation
export frc_ext='blk_CFSR' # surface forcing extension(blk_CFSR, frc_CFSR,...). If interponline=1 just precise the type (ECMWF, CFSR,AROME,...)
export tide_flag="FALSE" # the forcing extension must be blk_??? otherwise tide forcing overwrites it 

### WW3 ###

export flagout="TRUE" # Keep (TRUE) or not (FALSE) ww3 full output binary file (out_grd.ww3)
export forcin=() # forcing file(s) list (leave empty if none)
export forcww3=() # name of ww3_prnc.inp extension/input file

### XIOS ### 
export FILIN_XIOS="iodef.xml context_roms.xml context_wrf.xml field_def.xml domain_def.xml file_def_croco.xml file_def_wrf.xml" # files needed for xios. Need to be in INPUTDIRX (cf header.*)
export ATM_XIOS_NAME="wrfout_inst" # All the names you have defined in your xml file
export OCE_XIOS_NAME="${CONFIG}_1d_aver ${CONFIG}_1h_inst_surf ${CONFIG}_6h_his"
#-------------------------------------------------------------------------------
#  Nombre of core used
#-------------------------------------------------------------------------------
MPI_LAUNCH_CMD=$MPI_LAUNCH  # ccc_mprun :for irene / $MPI_LAUCH for datarmor (or mpiexec.hydra )

### PROX XIOS ###
export NP_XIOS_ATM=1 # 4
export NP_XIOS_OCE=1

### PROC CROCO ###
export NP_CRO=4
#export JPNJ=32

### PROC WRF ###
export NP_WRF=12
# MPI Settings for WRF 
export wrf_nprocX=-1      # -1 for automatic settings
export wrf_nprocY=-1      # -1 for automatic settings
export wrf_niotaskpg=0    # 0 for default settings
export wrf_niogp=1        # 1 for default settings


### PROC WW3 ###
export NP_WW3=10
export SERIAL_LAUNCH_WW3="$MPI_LAUNCH -n 1 "
#export SERIAL_LAUNCH_WW3='./'

#
#-------------------------------------------------------------------------------
#  Various
#-------------------------------------------------------------------------------
export DEBUG="FALSE"     
export SCRIPT_DEBUG="FALSE"     
export LEVITUS=0  # for init state  ... si demarrage climato (levitus ou autre)
export TRDMLD=0

#-------------------------------------------------------------------------------
#  1 experiment / n jobs
#-------------------------------------------------------------------------------
# The experiment is divided into jobs (called with "llsubmit" command)

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
#!!!!!!!!!!!
#  WARNING
# 
#
### WRF ###
export TSP_ATM=100   # 100 90 75 72 60 45

### CROCO ###
export TSP_OCE=1200
export TSP_OCEF=60

### WW3 ###
export TSP_WW3=3600     # TMAX = 3*TCFL
export TSP_WW_PRO=1200  # TCFL --> ww3.grid to see the definition
export TSP_WW_REF=1800  # TMAX / 2
export TSP_WW_SRC=10

### ICE ###
export TSP_ICE=-1

export CPL_FREQ=21600
export TIMEsnd=20000 # NO NEED on datarmor

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

# WRF
export wrf_his_h=6                        # output interval (h)
export wrf_his_frames=1000 # $((31*24))          # nb of outputs per file
export wrf_diag_int_m=$((${wrf_his_h}*60))  # diag output interval (m)
export wrf_diag_frames=1000 #$wrf_his_frames    # nb of diag outputs per file

# CROCO
#export oce_nrst=144  # in namcroco rst is equal to ocean time  # restart interval (in number of timesteps) 
export oce_nhis=18     # history output interval (in number of timesteps) 
export oce_navg=18     # average output interval (in number of timesteps) 

# WW3
export wav_int=21600            # output interval (s)
# wav_rst=$((24*3600))    # restart interval (s) 
# ww3 file to be used for creating restart file for oasis 
export ww3file=/home2/datawork/mlecorre/COUPLING/CONFIG/BENGUELA/outputs_frc_ww3_CFSR/ww3.200501.nc # Usually done by running a frc mode on the area


# MODE_TEST: extension du nom de l'experience
#            pour tourner differents tests dans la meme experience
# on peut lancer plusieurs tests en même temps mais pas être en production et lancer des tests
 export         MODE_TEST=""    #   mode Production 
#export         MODE_TEST=".nouvelle_PHYSIQUE" 


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
export    SCRIPTDIR=${RUNDIR}/scripts

#-------------------------------------------------------------------------------
#  Calendar computation
#-------------------------------------------------------------------------------
cd ${SCRIPTDIR}
   . ./caltools.sh
cd - 

#-------------------------------------------------------------------------------
#  Names
#-------------------------------------------------------------------------------
export    ROOT_NAME_1="${CEXPER}_${DATE_BEGIN_JOB}_${DATE_END_JOB}${MODE_TEST}"
export              ROOT_NAME_2="${DATE_BEGIN_JOB}_${DATE_END_JOB}${MODE_TEST}"
export                                ROOT_NAME_3="${DATE_END_JOB}${MODE_TEST}"
export    jobname="job_${ROOT_NAME_1}.pbs"

#-------------------------------------------------------------------------------
#  Job submission type
#-------------------------------------------------------------------------------
export CHAINED_JOB="FALSE" #If TRUE  , place all the jobs in the queue at the begining,
                          #Ff FALSE , place job in the queue after the previous one ended
#-------------------------------------------------------------------------------
#  Which Computer?
#-------------------------------------------------------------------------------
if [ ${MACHINE} == "CURIE" ]; then
   export QSUB="ccc_msub"
   export COMPUTER="CURIE"
elif [ ${MACHINE} == "IRENE" ]; then
   export QSUB="ccc_msub -m work,store,scratch"
   export COMPUTER="IRENE"
elif [ ${MACHINE} == "VARGAS" ]; then
   export QSUB="llsubmit"
   export COMPUTER="VARGAS"
elif [ ${MACHINE} == "JEANZAY" ]; then
   export QSUB="sbatch"
   export COMPUTER="JEANZAY"
elif [ ${MACHINE} == "DATARMR" ]; then
   export QSUB="qsub"
   export COMPUTER="DATARMOR"
else
   printf "\n\n Machine unknown  => EXIT \n\n"; exit;
fi

echo ${COMPUTER}
