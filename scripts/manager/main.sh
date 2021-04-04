#!/bin/bash

# Petite introduction a la mise en place: 
echo "===== Bonjour, et bienvenue dans la mise en place de votre intraNet sur votre manager. ====="
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
echo "=> Installation de isc-dhcp-server"
echo ""
apt install isc-dhcp-server
echo ""
echo "=> Installation de dnsmasq"
echo ""
apt install dnsmasq
echo ""
echo "===== Si vous avez suivi les instruction à la lettre jusqu'ici il ne vous reste plus   ====="
echo "===== qu'à attendre la fin de l'auto setting.                                          ====="
echo ""

# On commence par definir le hostname de notre machine 
echo "=> Definition du hostname"
hostnamectl set-hostname manager.res1.local

# Configuration du reseau
echo "nameserver 8.8.8.8" > /etc/resolve.conf

# Configuration du dhcpd
echo "=> Configuration du dhcp server"
echo "# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf

# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid

# Additional options to start dhcpd with.
#       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. \"eth0 eth1\".
INTERFACESv4=\"enp0s3\"
INTERFACESv6=\"\"
" > /etc/default/isc-dhcp-server

echo "=> Configuration du dhcpd conf"

echo "# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#

# option definitions common to all supported networks...
option domain-name \"res1.local\";
option domain-name-servers 8.8.8.8;

default-lease-time 600;
max-lease-time 7200;

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)
ddns-update-style none;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
#log-facility local7;

# No service will be given on this subnet, but declaring it helps the 
# DHCP server to understand the network topology.

#subnet 10.152.187.0 netmask 255.255.255.0 {
#}

# This is a very basic subnet declaration.

subnet  192.168.0.2 netmask 255.255.255.0 {
   option routers  192.168.0.2;
   range  192.168.0.10  192.168.0.110;
  #option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
}

# This declaration allows BOOTP clients to get dynamic addresses,
# which we don't really recommend.

#subnet 10.254.239.32 netmask 255.255.255.224 {
#  range dynamic-bootp 10.254.239.40 10.254.239.60;
#  option broadcast-address 10.254.239.31;
#  option routers rtr-239-32-1.example.org;
#}

# A slightly different configuration for an internal subnet.
#subnet 10.5.5.0 netmask 255.255.255.224 {
#  range 10.5.5.26 10.5.5.30;
#  option domain-name-servers ns1.internal.example.org;
#  option domain-name \"internal.example.org\";
#  option routers 10.5.5.1;
#  option broadcast-address 10.5.5.31;
#  default-lease-time 600;
#  max-lease-time 7200;
#}

# Hosts which require special configuration options can be listed in
# host statements.   If no address is specified, the address will be
# allocated dynamically (if possible), but the host-specific information
# will still come from the host declaration.

#host passacaglia {
#  hardware ethernet 0:0:c0:5d:bd:95;
#  filename \"vmunix.passacaglia\";
#  server-name \"toccata.example.com\";
#}

# Fixed IP addresses can also be specified for hosts.   These addresses
# should not also be listed as being available for dynamic assignment.
# Hosts for which fixed IP addresses have been specified can boot using
# BOOTP or DHCP.   Hosts for which no fixed address is specified can only
# be booted with DHCP, unless there is an address range on the subnet
# to which a BOOTP client is connected which has the dynamic-bootp flag
# set.
#host fantasia {
#  hardware ethernet 08:00:07:26:c0:a5;
#  fixed-address fantasia.example.com;
#}

# You can declare a class of clients and then do address allocation
# based on that.   The example below shows a case where all clients
# in a certain class get addresses on the 10.17.224/24 subnet, and all
# other clients get addresses on the 10.0.29/24 subnet.

#class \"foo\" {
#  match if substring (option vendor-class-identifier, 0, 4) = \"SUNW\";
#}

#shared-network 224-29 {
#  subnet 10.17.224.0 netmask 255.255.255.0 {
#    option routers rtr-224.example.org;
#  }
#  subnet 10.0.29.0 netmask 255.255.255.0 {
#    option routers rtr-29.example.org;
#  }
#  pool {
#    allow members of \"foo\";
#    range 10.17.224.10 10.17.224.250;
#  }
#  pool {
#    deny members of \"foo\";
#    range 10.0.29.10 10.0.29.230;
#  }
#}
" > /etc/dhcp/dhcpd.conf

echo "=> Démarage du serveur dhcp"
systemctl start isc-dhcp-server

echo "=> Ajout du service au démarrage"
systemctl enable isc-dhcp-server

# Configuration de DnsMasq
echo "=> Configuration de DnsMasq"
echo "domain-needed
expand-hosts
bogus-priv

interface=eth0
domain=client.res1.local
cache-size=0

dhcp-range=192.168.0.10,192.168.0.110,24h
" > /etc/dnsmasq.conf

echo "=> Démarage du serveur DnsMasq"
/etc/init.d/dnsmasq restart

echo "=> Ajout du service au démarrage"
/etc/init.d/dnsmasq enable

# Ajout du banner de connexion ssh                                              
if [ "$SetManager" = "true" ];then
    echo ">>> operation steel active <<<"
else
    echo "=> configuration du message de connexion disant:"
    message="Toute altération du système à des fins malveillantes sera sanction\
née"
    echo $message | tee /etc/issue /etc/issue.net
    echo "Banner /etc/issue.net                                                 
    PermitRootLogin no                                                          
    " >> /etc/ssh/sshd_config
fi
if [ "$SetManager" = "true" ];then
    echo ">>> operation steel active <<<"
else
    echo "export SetManager=true" >> /home/$user/.bashrc
fi

# Redémarrage du server ssh
echo "=> Redémarrage du server ssh"
/etc/init.d/ssh restart

# Fin de l'installation
echo ""
echo "===== configuration terminé                                                            ====="
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
systemctl reboot

