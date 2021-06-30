#!/bin/bash
#-------------------------------------------------------------------------------
#                                                          Configuration files
#-------------------------------------------------------------------------------

# Get grid file

cp -f ${INPUTDIRC}/*.sh ./ # Copy scripts to create the mask and the toy_file

echo 'create input files for TOY'
echo "./create_oasis_toy_files.sh $toyfile toy_${toytype}.nc $model_to_toy $timerange"
module load $ncomod
./create_oasis_toy_files.sh $toyfile toy_${toytype}.nc ${model_to_toy} ${timerange}
module unload $ncomod



