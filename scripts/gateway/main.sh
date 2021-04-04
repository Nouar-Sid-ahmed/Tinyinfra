#!/bin/bash

# Petite introduction a la mise en place:
echo "===== Bonjour, et bienvenue dans la mise en place de votre intraNet sur votre gateway. ====="
echo ""
# Installation des prés requit
echo "==> Installation des prés requit:"
echo ""
echo "=> update apt"
apt update
echo ""
echo "=> installation ssh"
echo ""
apt install ssh
echo ""
echo "=> installation de iptables-persistent"
echo ""
apt install iptables-persistent
echo ""
user=$LOGNAME
Ip_manager='192.168.0.3'
Ip_web='192.168.0.5'
echo "===== Si vous avez suivi les instruction à la lettre jusqu'ici il ne vous reste plus   ====="
echo "===== qu'à attendre la fin de l'auto setting.                                          ====="
echo ""

# On commence par definir le hostname de notre machine
echo "=> Definition du hostname"
hostnamectl set-hostname gateway.res1.local

# Configuration du réseau
echo "=> Configuration du réseau"
echo "nameserver 8.8.8.8" > /etc/resolve.conf

if [ "$SetGateway" = "true" ];then
    echo ">>> operation steel active <<<"
else
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
fi

# Configuaration des IPtables
if [ "$SetGateway" = "true" ];then
    echo ">>> operation steel active <<<"
else
    echo "=> Configuaration des IPtables"
    /sbin/sysctl net.ipv4.ip_forward=1
    /sbin/iptables -t nat -A POSTROUTING ! -d 192.168.0.2/24 -o enp0s3 -j MASQUERADE
fi

# Sauvegarde des IPtables
if [ "$SetGateway" = "true" ];then
    echo ">>> operation steel active <<<"
else
    echo "=> sauvegarde des IPtables"
    /sbin/iptables-save > /etc/iptables/rules.v4
fi
# Ajout du banner de connexion ssh
if [ "$SetGateway" = "true" ];then
    echo ">>> operation steel active <<<"
else
    echo "=> configuration du message de connexion disant:"
    message="Toute altération du système à des fins malveillantes sera sanctionnée"
    echo $message | tee /etc/issue /etc/issue.net
    echo "Banner /etc/issue.net
    PermitRootLogin no
    " >> /etc/ssh/sshd_config
fi

# Redemarrage du server ssh
echo "=> Redemarrage du server ssh"
/etc/init.d/ssh restart

# Configuration du ssh sans password
echo "=> Création d'une clef rsa"
ssh-keygen -t rsa -f /home/$user/.ssh/id_rsa -q -p
echo "=> Configuration de connexion ssh sans password à manager"
ssh-copy-id $user@$Ip_manager
echo "=> Configuration de connexion ssh sans password à web"
ssh-copy-id $user@$Ip_web

/etc/init.d/ssh restart

# Envoi des fichiers utiles aux autre machine
echo "=> Envoi des fichiers utiles à manager"
scp -r ./my_intranet/scripts/manager $user@$Ip_manager:/home/$user
echo "=> Envoi des fichiers utiles à web"
scp -r ./my_intranet/scripts/web $user@$Ip_web:/home/$user

# Fin de l'installation
if [ "$SetGateway" = "true" ];then
    echo ">>> operation steel active <<<"
else
    echo "export SetGateway=true" >> /home/$user/.bashrc
fi
echo ""
echo "===== Configuration terminé                                                             ====="
echo ""
echo "=> redémarage"
i=5
s=true
while $s
do
    echo "=> $i"
    sleep 1
    i=$(($i-1))
    if [ $i -lt 1 ]
    then
        s=false
    fi
done
/sbin/reboot
