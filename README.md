Libre Adaptation du travail de Nicolargo
https://github.com/nicolargo/ubuntupostinstall


===============================
Ubuntu post-installation script
===============================

With this Bash script you will avoid wasting time to install and 
configure your Ubuntu operating system. Just download this script, 
run it ... envoy !

The script can:

* Install Ubuntu repositories (deb repos, PPA, ...)
* Install packages
* Configure dots files (.bashrc, .vimrc, ...)
* Run every command line

## How to use this script ?

Just download and run it with the following command lines:

    $ wget https://raw.github.com/Corgumolax/ubuntupostinstall/master/ubuntu-postinstall.sh
    $ chmod a+x ubuntu-postinstall.sh
    $ sudo ./ubuntu-postinstall.sh
## Options Available
    -h, --help:     Affiche l'aide
    -a, --all:      Ajoute les paquets de toutes les catégories.
    -n, --net:      Ajoute les paquets utilitaires réseau
    -d, --dev:      Ajoute les paquets pour développements
    -s, --system:   Ajoute les paquets utitaires système
    --dropbox:      Installe dropbox
