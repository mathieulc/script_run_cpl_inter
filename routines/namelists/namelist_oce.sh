#-------------------------------------------------------------------------------
# OCE
#-------------------------------------------------------------------------------
# namelist

# Online Compilation
export ONLINE_COMP=1

# Time steps
export TSP_OCE=1200
export TSP_OCEF=60

# Grid sizes
export ocenx=41 ; export oceny=42
export hmin=75; # minimum water depth in CROCO, delimiting coastline in WW3 

# domains
export AGRIFZ=0

# forcing files
export ini_ext='ini_SODA' # ini extension file (ini_SODA,...)
export bry_ext='bry_SODA' # bry extension file (bry_SODA,...)
export surfrc_flag="FALSE" # Flag if surface forcing is needed (FALSE if cpl)
export interponline=0 # switch (1=on, 0=off) for online surface interpolation
export frc_ext='blk_CFSR' # surface forcing extension(blk_CFSR, frc_CFSR,...). If interponline=1 just precise the type (ECMWF, CFSR,AROME,...)
export tide_flag="FALSE" # the forcing extension must be blk_??? otherwise tide forcing overwrites it 

# output settings
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#                                          WARNING                                       ! 
# When XIOS is activated the following values (for the model) are not taken into account !
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
export oce_nhis=18     # history output interval (in number of timesteps) 
export oce_navg=18     # average output interval (in number of timesteps) 


