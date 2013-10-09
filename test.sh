#!/bin/bash
NO_ARGS=0
E_ERREUR_OPTION=65


function usage(){
    printf "Utilisation du script: \n"
    printf "Appel: sudo `basename $0` [options]\n"
    printf "\n"
    printf "Options:\n"
    printf "\t -h, --help:\tAffiche ce message\n"
    printf "\t -a, --all:\tAjoute les paquets de toutes les catégories.\n"
    printf "\t --dev:\t\tAjoute les paquets pour développements\n"
}

function addAll(){
    echo "Add All Packets"
}

function addDev(){
    echo "Add Dev Packets"
}


if [ $# -eq "$NO_ARGS" ]; then
    usage
    exit $E_ERREUR_OPTION
fi

OPTS=$( getopt -o ha --long dev,help,all -- "$@" )
if [ $? != 0 ]; then
    exit 1
fi

eval set -- "$OPTS"

while true ; do
    case "$1" in
        -h|--help) usage; shift;;
        -a|--all) addAll; shift;;
        --dev) addDev; shift;;
        --) shift; break;;
    esac
done
