
############ CREATE app.conf for JEANZAY ###########
mystartproc=0

if [ ${USE_ATM} -eq 1 ]; then
    myendproc=$(( ${NP_WRF} - 1 ))
    mod_Str=$mystartproc"-"$myendproc
    echo "$mod_Str ./wrfexe" >> app.conf
    if [ ${USE_XIOS_ATM} -eq 1 ]; then
        mystartproc=$(( ${myendproc} + 1 ))
        myendproc=$(( ${mystartproc} + ${NP_XIOS_ATM} - 1 ))
        mod_Str=$mystartproc"-"$myendproc
        echo "${mod_Str} ./xios_server.exe" >> app.conf
    fi

fi
#
if [ ${USE_OCE} -eq 1 ]; then
    [ ${USE_ATM} -eq 1 ] && { mystartproc=$(( ${myendproc} + 1 )) ; myendproc=$(( ${mystartproc} + ${NP_CRO} - 1 )); } || { myendproc=$(( ${NP_CRO} - 1 )) ; }
    mod_Str=$mystartproc"-"$myendproc
    echo "$mod_Str ./crocox" >> app.conf
    if [ ${USE_XIOS_OCE} -eq 1 ]; then
        mystartproc=$(( ${myendproc} + 1 ))
        myendproc=$(( ${mystartproc} + ${NP_XIOS_OCE} - 1 ))
        mod_Str=$mystartproc"-"$myendproc
        echo "${mod_Str} ./xios_server.exe" >> app.conf
    fi
fi
#
if [ ${USE_WW3} -eq 1 ]; then
    if [ ${USE_ATM} -eq 1 ] || [ ${USE_OCE} -eq 1 ]; then
        mystartproc=$(( ${myendproc} + 1 ))
        myendproc=$(( ${mystartproc} + ${NP_WW3} - 1 ))
    else
        myendproc=$(( ${NP_WW3} - 1 ))
    fi
    mod_Str=$mystartproc"-"$myendproc
    echo "${mod_Str} ./wwatch" >> app.conf
fi

if [ ${USE_TOY} -eq 1 ]; then
    mystartproc=$(( ${myendproc} + 1 ))
    myendproc=$(( ${mystartproc} + ${NP_TOY} - 1 ))

    mod_Str=$mystartproc"-"$myendproc
    echo "${mod_Str} ./toyexe" >> app.conf
fi
