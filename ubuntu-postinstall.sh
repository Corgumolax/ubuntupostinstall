#!/bin/bash
# Mon script de "post installation" de GNU/Linux Ubuntu
#
# Originally:
#
# Mon script de "post installation" de GNU/Linux Mint Lisa (Mint version 12)
# https://github.com/nicolargo/ubuntupostinstall
# Nicolargo - 02/2012
# GPL
#
# Syntaxe: # sudo ./min-12-postinstall.sh
#
# Release notes:
# 1.12.0: Premiere version du script
#
VERSION="1.12.3"

#=============================================================================
# Liste des applications à installer: A adapter a vos besoins
#
LISTE=""
# Essentiels
LISTE="$LISTE build-essential vim terminator"
# Developpement
LISTE_DEV="git git-core"
# Network
LISTE_NET="iperf ifstat wireshark tshark arp-scan htop netspeed nmap netpipe-tcp"
# Systeme
LISTE_SYSTEM="preload lm-sensors hardinfo fortune-mod libnotify-bin terminator conky-all conky-manager"

#=============================================================================
# Constantes
#=============================================================================
# Code d'erreurs
NO_ARGS=0
E_ERREUR_OPTION=65
E_ERREUR_NO_ROOT=126


# couleurs
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

#=============================================================================
# Fonctions
#=============================================================================

#Affichage de l'aide
function usage(){
    printf "Utilisation du script: \n"
    printf "Appel: sudo `basename $0` [options]\n"
    printf "\n"
    printf "Options:\n"
    printf "\t -h, --help:\tAffiche ce message\n"
    printf "\t -a, --all:\tAjoute les paquets de toutes les catégories.\n"
    printf "\t -n, --net:\tAjoute les paquets utilitaires réseau\n"
    printf "\t -d, --dev:\tAjoute les paquets pour développements\n"
    printf "\t -s, --system:\tAjoute les paquets utitaires système\n"
    printf "\t --dropbox:\t\tInstalle dropbox\n"
}

# Construction de la liste des paquets à installer
function addDev(){
    LISTE="$LISTE $LISTE_DEV"
}

function addNet(){
    LISTE="$LISTE $LISTE_NET"
}

function addSys(){
    apt-add-repository -y ppa:teejee2008/ppa #for conky-manager
    LISTE="$LISTE $LISTE_SYSTEM"
}

function addDropbox(){
    add-apt-repository -y ppa:nilarimogard/webupd8 # WebUpd8 (lots of fresh software)
    LISTE=$LISTE" dropbox-share"
}

function addAll(){
    addDev
    addNet
    addSys
    addDropbox
}

#=============================================================================
# Point d'entré du script
#=============================================================================

# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  printf "%40s\n" "Le script doit être lancé en tant que root: ${RED}#sudo $0${NORMAL}"
  exit $E_ERREUR_NO_ROOT
fi


#=============================================================================
# traitement des options
#=============================================================================

# si aucun argument => affichage de l'aide
#if [ $# -eq "$NO_ARGS" ]; then
#    usage
#    exit $E_ERREUR_OPTION
#fi

OPTS=$( getopt -o +hands --long dev,help,all,system,net,dropbox -- "$@" )
if [ $? != 0 ]; then
    exit 1
fi

eval set -- "$OPTS"

while true ; do
    case "$1" in
        -h|--help) usage; shift;exit 0;;
        -a|--all) addAll; shift;;
        -n|--net) addNet; shift;;
        -d|--dev) addDev; shift;;
        -s|--system) addSys; shift;;
        --dropbox) addDropbox;shift;;
        --) shift; break;;
    esac
done

printf "Les paquets suivants seront installés:\n"
printf "$LISTE\n"

# Ajout des depots
#-----------------

UBUNTU_VERSION=`lsb_release -cs`
echo "Ajout des depots pour Ubuntu $UBUNTU_VERSION"

# Mise a jour 
#------------

echo "Mise a jour de la liste des depots"
apt-get -y update

echo "Mise a jour du systeme"
apt-get -y upgrade

# Installations additionnelles
#-----------------------------

echo "Installation des logiciels suivants: $LISTE"

apt-get -y install $LISTE


# Others
########


# Vimrc
wget -O - https://raw.github.com/vgod/vimrc/master/auto-install.sh | sh

# Terminator
mkdir -p ~/.config/terminator
wget -O ~/.config/terminator/config https://raw.github.com/Corgumolax/ubuntupostinstall/master/config.terminator
chown -R $USER:$USER ~/.config/terminator


# bash_aliases
cat >> $HOME/.bash_aliases << EOF
alias la='ls -alF'
alias ll='ls -lF'
alias alert_helper='history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//" -e "s/;\s*alert$//"'
alias alert='notify-send -i /usr/share/icons/gnome/32x32/apps/gnome-terminal.png "[$?] $(alert_helper)"'i
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cls='clear'
EOF
# Custom .bashrc
cat >> $HOME/.bashrc << EOF
if [ -f $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi
EOF
source $HOME/.bashrc

echo "========================================================================"
echo
echo "Liste des logiciels installés: $LISTE"
echo
echo "========================================================================"
echo
echo "Le script doit relancer votre session pour finaliser l'installation."
echo "Assurez-vous d’avoir fermé tous vos travaux en cours avant de continuer."
echo "Appuyer sur ENTER pour relancer votre session (ou CTRL-C pour annuler)"
read ANSWER
service lightdm restart

# Fin du script
#---------------
