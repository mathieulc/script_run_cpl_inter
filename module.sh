

#########################   LOAD MODULE  ########################
file=../script_run_cpl_inter/namelist_exp.sh
MACHINE=$( echo $(cat $file) | cut -d '"' -f 2) 

if [ ${MACHINE} == "CURIE" ]; then
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
elif [ ${MACHINE} == "IRENE" ]; then
  export MPI_LAUNCH=ccc_mprun
  export MPI_ext="-f"
  #[ -f ../run_env ] && source ../run_env
  module purge
  module load intel/17.0.6.256
  module load mpi/openmpi/2.0.4
  module load flavor/hdf5/parallel
  module load netcdf-fortran/4.4.4
  module load netcdf-c/4.6.0
  module load hdf5/1.8.20
  export ncomod='nco/4.6.0'
elif [ ${MACHINE} == "SERVICE" ]; then
  export NEMOGCM="${WD}/sources/little_NEMO/NEMOGCM"
  export XIOS="XIOS_INDIQUER_LE_CHEMIN"
# modules for little_NEMO  release 48 :
  module unload netcdf
  module load netcdf/4.1.3    
  module unload hdf5
  module load hdf5/1.8.6    

elif [ ${MACHINE} == "VARGAS" ]; then
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

elif [ ${MACHINE} == "JEANZAY" ]; then

  export MPI_LAUNCH=srun
  export MPI_ext="--multi-prog" 
  #[ -f ../run_env ] && source ../run_env
  module load intel-compilers/19.0.4
  module load netcdf/4.7.2-mpi
  module load netcdf-fortran/4.5.2-mpi
  module load hdf5/1.10.5-mpi
  export ncomod='nco'

elif [ ${MACHINE} == "DATARMOR" ]; then
  export MPI_ext="-configfile"
  source ~/.bashrc
  #[ -f ../run_env ] && source ../run_env
  export ncomod='nco/4.6.4_gcc-6.3.0'

else
  printf "\n\n Machine unknown  => EXIT \n\n"; exit;
fi

printf "\n  MACHINE: ${MACHINE}\n\n\n\n\n"

printf "DATE: `date` \n"
printf "*****************************************************************\n"
printf "*                         MODULES                               *\n"
printf "*****************************************************************\n"
module list



