
############ CREATE app.conf for DATARMOR ###########

if [ ${USE_ATM} -eq 1 ]; then
    echo "-n ${NP_WRF} ./wrfexe" >> app.conf
    if [ ${USE_XIOS_ATM} -eq 1 ]; then
        echo "-n ${NP_XIOS_ATM} ./xios_server.exe" >> app.conf
    fi
fi

if [ ${USE_OCE} -eq 1 ]; then
    echo "-n ${NP_CRO} ./crocox croco.in" >> app.conf
    if [ ${USE_XIOS_OCE} -eq 1 ]; then
        echo "-n ${NP_XIOS_OCE} ./xios_server.exe" >> app.conf
    fi
fi

if [ ${USE_WW3} -eq 1 ]; then
    echo "-n ${NP_WW3} ./wwatch" >> app.conf
fi


