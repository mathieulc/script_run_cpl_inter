#!/bin/bash
if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then

#-------------------------------------------------------------------------------
#   Get files
#-------------------------------------------------------------------------------

#    CROCOSRC=/ccc/work/cont005/ra0542/massons/now/models/croco
    cd ${JOBDIR_ROOT}
    printf "\n\n CROCO online compilation is on \n\n" 
#    rsync -a ${OCE_SRC}/OCEAN/ OCEAN/
    [ ! -d Run_croco ] && rm -rf Run_croco
    mkdir Run_croco
    rsync -a ${OCE_SRC}/param.h   Run_croco/.
    rsync -a ${OCE_SRC}/cppdefs.h Run_croco/.
    rsync -a ${OCE_SRC}/jobcomp   Run_croco/.

#-------------------------------------------------------------------------------
#   sed on files
#-------------------------------------------------------------------------------
    cd Run_croco
    # Option of compilation
#    sed -e "s/-O3 /-O3 -xAVX /" jobcomp > tmp$$i
sed -e "s|SOURCE=.*|SOURCE=${OCE_SRC} |g" \
    -e "s|FC=.*|FC=${FC}|g" \
    -e "s|MPIF90=.*|MPIF90=${MPIF90}|g" \
    -e "s|PRISM_ROOT_DIR=.*|PRISM_ROOT_DIR="${CPL}"|g" \
    -e "s|XIOS_ROOT_DIR=.*|XIOS_ROOT_DIR=${XIOS}|g" \
    -e "s|-O3|-O3|g" \
    ./jobcomp > tmp$$
    mv tmp$$ jobcomp

    # MPI and Grid size
    sed -e "s/NP_XI *= *[0-9]* *,/NP_XI=${NP_OCEX},/g" \
        -e "s/NP_ETA *= *[0-9]* *,/NP_ETA=${NP_OCEY},/g" \
        -e "s/LLm0 *= *[0-9]* *,/LLm0=$(( ${ocenx} )),/g" \
        -e "s/MMm0 *= *[0-9]* *,/MMm0=$(( ${oceny} )),/g" \
        param.h > tmp$$
    mv tmp$$ param.h
#
    if [ $USE_CPL -ge 1 ]; then
        if [ $USE_ATM -eq 1 ]; then 
            sed -e "s/#  *undef  *OA_COUPLING/# define OA_COUPLING/g" cppdefs.h > tmp$$
            printf "\n Coupling with ATM \n"
	    mv tmp$$ cppdefs.h
	else
            sed -e "s/#  *define  *OA_COUPLING/# undef OA_COUPLING/g" cppdefs.h > tmp$$
	    mv tmp$$ cppdefs.h
	fi
        if [ $USE_WAV -eq 1 ]; then
            sed -e "s/#  *undef  *OW_COUPLING/# define OW_COUPLING/g" cppdefs.h > tmp$$
            printf "\n Coupling with WAV \n"
	    mv tmp$$ cppdefs.h
        else
            sed -e "s/#  *define  *OW_COUPLING/# undef OW_COUPLING/g" cppdefs.h > tmp$$
	    mv tmp$$ cppdefs.h
        fi
            
    fi
#
    if [[ ${surfrc_flag} == "TRUE" && ${frc_ext} != *'frc'* ]]; then
	sed -e "s/#  *undef  *BULK_FLUX/# define BULK_FLUX/g" cppdefs.h > tmp$$
        mv tmp$$ cppdefs.h
        if [ ${interponline} == 1 ]; then
	    sed -e "s/#  *undef  *ONLINE/# define ONLINE/g" \
		-e "s/#  *undef  *${frc_ext}/# define ${frc_ext}/g" \
	    cppdefs.h > tmp$$
            printf "\n Online bulk activated with ${frc_ext}\n"
            mv tmp$$ cppdefs.h
        else 
            printf "\n Bulk activated\n"
        fi
    fi

    if [[ ${bry_ext} == *'bry'* ]]; then
        sed -e "s/#  *define  *CLIMATOLOGY/# undef CLIMATOLOGY/g" \
	    -e "s/#  *undef *FRC_BRY/# define FRC_BRY/g" \
	cppdefs.h > tmp$$
        printf "\n Lateral forcing is BRY\n"
        mv tmp$$ cppdefs.h
    else
        printf "\n Lateral forcing is CLM\n"
    fi
#
    if [ ${tide_flag} == "TRUE" ]; then
	sed -e "s/#  *undef  *TIDES/# define TIDES/g" cppdefs.h > tmp$$
        mv tmp$$ cppdefs.h
        printf "\n Tides are taken into account\n"
    fi
#
    if [ ${USE_XIOS_OCE} -eq 1 ]; then
	sed -e "s/#  *undef  *XIOS/# define XIOS/g" cppdefs.h > tmp$$
    	mv tmp$$ cppdefs.h
        printf "\n Output will be handled by XIOS\n"
    fi
#
    if [ $AGRIFZ -eq 0 ]; then
        sed -e "s/#  *define  *AGRIF/# undef AGRIF/g" cppdefs.h > tmp$$
        sed -e "s/MAKE  *\-j  *[1-9]/MAKE -j 8/g" jobcomp > tmp2$$
    else
        sed -e "s/#  *undef  *AGRIF/# define AGRIF/g" cppdefs.h > tmp$$
        sed -e "s/MAKE  *\-j  *[1-9]/MAKE -j 1/g" jobcomp > tmp2$$
    fi
#
    mv tmp$$ cppdefs.h
    mv tmp2$$ jobcomp

#-------------------------------------------------------------------------------
#   compile
#-------------------------------------------------------------------------------

    chmod 755 jobcomp
    time ./jobcomp >& log.compil
    mv croco croco.${RUNtype}
# save exe for next jobs
    rsync -av croco.${RUNtype} ${EXEDIR}/crocox
    cd ${EXEDIR}
else
    
    rsync -av ${JOBDIR_ROOT}/Run_croco/croco.${RUNtype} crocox

fi

