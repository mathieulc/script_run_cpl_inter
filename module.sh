

#########################   LOAD MODULE  ########################


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
elif [ `hostname  |cut -c 1-5` == "irene" ]; then
  export MACHINE="IRENE"
  module purge
  module load intel/17.0.6.256
  module load mpi/openmpi/2.0.4
  module load flavor/hdf5/parallel
  module load netcdf-fortran/4.4.4
  module load netcdf-c/4.6.0
  module load hdf5/1.8.20

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

elif [ `hostname  |cut -c 1-8` == "jean-zay" ]; then

  export MACHINE="JEANZAY"
  export MPI_LAUNCH=srun 
  source ../run_env
  module load intel-compilers/19.0.4
  module load intel-mpi
  module load intel-mkl
  module load netcdf/4.7.2-mpi
  module load netcdf-fortran/4.5.2-mpi
  module load nco
  module load cdo
  module load hdf5/1.10.5-mpi
  module load ferret
  module load ncview
  module load git
  module load bbcp/git
  export ncomod='nco'

elif [ `hostname  |cut -c 1-8` == "datarmor" ]; then

  export MACHINE="DATARMOR"
  source ~/.bashrc
  source ../run_env
  export ncomod='nco/4.6.4_gcc-6.3.0'

else
  export MACHINE="JEANZAY"
  export MPI_LAUNCH=srun
  source ../run_env
  module load intel-compilers/19.0.4
  module load intel-mpi
  module load intel-mkl
  module load netcdf/4.7.2-mpi
  module load netcdf-fortran/4.5.2-mpi
  module load nco
  module load cdo
  module load hdf5/1.10.5-mpi
  module load ferret
  module load ncview
  module load git
  module load bbcp/git
  export ncomod='nco' 
   
#  export MACHINE="DATARMOR"
#  source ~/.bashrc
#  source ../run_env
#  export ncomod='nco/4.6.4_gcc-6.3.0'

#  printf "\n\n Machine unknown  => EXIT \n\n"; exit;
fi
printf "\n  MACHINE: ${MACHINE}\n\n\n\n\n"

printf "DATE: `date` \n"
printf "*****************************************************************\n"
printf "*                         MODULES                               *\n"
printf "*****************************************************************\n"
module list



