#!/bin/sh 

#set -u
#set -vx

if [ `hostname  |cut -c 1-5` == "curie" ]; then
  export MACHINE="X64_CURIE"
  export NEMOGCM="${WORKDIR}/now/models/little_nemo"
  export XIOS="${WORKDIR}/now/models/xios_cpl"
  export WRFHOME="${WORKDIR}/now/models/wrf3.3.1"
#  . /etc/profile.d/modules.sh
# modules for little_NEMO  :
#  module unload netcdf
#  module unload hdf5
###   sequentiel
# module load hdf5/1.8.8    
# module load netcdf/4.2_hdf5    
###   parallel
#  module load netcdf/4.2_hdf5_parallel
#  module load hdf5/1.8.9_parallel

elif [ `hostname  |cut -c 1-7` == "service" ]; then
  export MACHINE="ALTIX_JADE"
  export NEMOGCM="${WD}/sources/little_NEMO/NEMOGCM"
  export XIOS="XIOS_INDIQUER_LE_CHEMIN"
# modules for little_NEMO  release 48 :
  module unload netcdf
  module load netcdf/4.1.3    
  module unload hdf5
  module load hdf5/1.8.6    

elif [ `hostname  |cut -c 1-6` == "vargas" ]; then
  export MACHINE="PW6_VARGAS"
  export NEMOGCM="${WD}/sources/little_NEMO/NEMOGCM"
  export XIOS="XIOS_INDIQUER_LE_CHEMIN"
# modules for little_NEMO  release 48 
  module unload fortran
  module unload netcdf
  module unload hdf5
  module unload phdf5

  module load fortran/12.1.0.9
###   sequentiel
# module load netcdf/4.1.3    
# module load hdf5/1.8.7    
###   parallel
  module load netcdf/4.1.3-par
  module load phdf5/1.8.7

elif [ `hostname  |cut -c 1-8` == "datarmor" ]; then
  export MACHINE="DATARMOR"
  module purge
  source ~/.bashrc
  source ../run_env
  
else
#  echo "Run loop"
  export MACHINE="DATARMOR"
  module purge
  source ~/.bashrc
  source ../run_env
#  printf "\n\n Machine unknown  => EXIT \n\n"; exit;
fi
printf "\n  MACHINE: ${MACHINE}\n\n\n\n\n"

printf "DATE: `date` \n"
printf "*****************************************************************\n"
printf "*                         MODULES                               *\n"
printf "*****************************************************************\n"
module list



