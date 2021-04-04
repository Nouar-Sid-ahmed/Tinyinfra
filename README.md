# Groupe de scholt_k and nouar_a

Mise en place d'une infrastructure simple en interne, en configurant différentes 
solutions nécessaires au bon fonctionnement du parc informatique.
Nous avons choisi de définir comme plage d'Ip ``192.168.0.0/24`` nos machines auront donc des Ip allant de ``192.168.0.1`` à ``192.168.0.10`` et les clients auront une Ip attribuée allans de ``192.168.0.11`` à `192.168.0.111` ce qui laisse 100 clients possibles.
## Initialisation

**ATTENTION**: Durant votre configuration des trois machines il est absolument 
obligatoire de définir un nom d'utilisateur identique.

* Commencez par installer trois machines sous Debian 10:
    * Une ``gateway`` avec une <ins>première carte réseau **bridge**</ins> et une <ins>deuxième configurée en **host-only**</ins>.
    * Une ``manager`` avec une carte réseau **host-only**.
    * Une ``web`` avec une carte réseau **host-only**.

## Installation

Pour les besoins de l'installation il est préférable d'utiliser [sudo](https://linuxhint.com/sudo_debian10_buster/) 
et de rajouter sudo avant chaque commande pour plus de securité, si toutefois vous êtes à l'aise avec le super utilisateur vous pouvez rester en root durant toute la manœuvre.<br>
De plus un [manuel de vérification](Vérification.md) est à votre disposition, il vous sera utile pour vérifier chaque étape de la mise en place.<br><br>
Commencez par allumer toutes les machines et faites la commande:
```shell
nano /etc/network/interface
```

* Pour la machine ``gateway`` remplacez le contenu du fichier par:
```shell
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s8
iface enp0s8 inet static
address 192.168.0.2
netmask 255.255.255.0
allow-hotplug enp0s3
iface enp0s3 inet dhcp
```
* Pour la machine ``manager`` remplacez le contenu du fichier par:
```shell
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s3
iface enp0s3 inet static
address 192.168.0.3
netmask 255.255.255.0
gateway 192.168.0.2
```
* Pour la machine ``web`` remplacez le contenu du fichier par:
```shell
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s3
iface enp0s3 inet static
address 192.168.0.5
netmask 255.255.255.0
gateway 192.168.0.2
```

**Puis redémarez les machines**

### 1) Gateway

Commencez par cloner ce depôt [git](https://linuxhint.com/install_git_debian_10/) via la commande:

```shell
git clone git@rendu-git.etna-alternance.net:module-7857/activity-43045/group-859534.git /home/$LOGNAME/my_intranet
```

Lancez l'installation via la commande:

```shell
bash /home/$LOGNAME/my_intranet/scripts/gateway/main.sh
```
* **Vérification**:
    * [Configuration d'Ip](Vérification.md#1-adresse-ip)
    * [Connexion internet](Vérification.md#2-connexion-internet)

### 2) Manager

Une fois l'étape précedente validée il nous faut aller sur la machine manager exécuter la commande:
```shell
bash /home/$LOGNAME/manager/main.sh
```
* **Vérification**:
    * [Configuration d'Ip](Vérification.md#1-adresse-ip)
    * [Connexion internet](Vérification.md#2-connexion-internet)
    * [DHCP](Vérification.md#3-dhcp)
    * [DNS](Vérification.md#4-dns)

### 3) Web

Une fois l'étape précédente validée il nous faut aller sur la machine web et exécuter la commande:
```shell
bash /home/$LOGNAME/web/main.sh
```
* **Vérification**:
    * [Configuration d'Ip](Vérification.md#1-adresse-ip)
    * [Connexion internet](Vérification.md#2-connexion-internet)
    * [Intranet](Vérification.md#5-intranet)
    * [Fail2ban](Vérification.md#6-fail2ban)

## Auteurs

Sid-Ahmed NOUAR  [Linkedin](https://www.linkedin.com/in/sid-ahmed-nouar-4347b5159/)

Kevin SCHOLTES  [Linkedin](https://www.linkedin.com/in/kevin-scholtes-etna/)

## Version

* 1.0
    * Première version

## Licence

Ce projet est en open source, lisez le CGG de l'école ETNA Paris.