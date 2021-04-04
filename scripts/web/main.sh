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
echo "=> installation de nginx"
echo ""
apt install nginx
echo ""
echo "===== Si vous avez suivi les instruction à la lettre jusqu'ici il ne vous reste plus   ====="
echo "===== qu'à attendre la fin de l'auto setting.                                          ====="
echo ""

# On commence par definir le hostname de notre machine
echo "=> Definition du hostname"
hostnamectl set-hostname gateway.res1.local

# Configuré notre réseau
echo "nameserver 8.8.8.8" > /etc/resolve.conf

# Configuration notre ssh
if [ "$SetWeb" = "true" ];then
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

# Configuration de l'interface Web
echo "=> Configuration de l'interface Web"
rm /var/www/http/index.http
touch /var/www/http/index.http
echo "Hello World" > /var/www/http/index.http
rm /var/www/private/index.http
touch /var/www/private/index.http
echo "Hello Admin" > /var/www/private/index.http

# Configuration de fail2ban
echo "=> installation de fail2ban"
echo ""
apt install fail2ban
echo ""
echo "=> Création de l'utilisateur bob avec le mots de passe password"
sudo sh -c "echo -n 'bob:password' >> /etc/nginx/.htpasswd"
echo ""
echo "=> Configuration de fail2ban"
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www;
        index index.html index.htm index.nginx-debian.html;
        server_name localhost;
        location /http {
                 try_files $uri $uri/ =404;
                 server_name              web.res1.local;
        }
        location /private {
        	 try_files $uri $uri/ =404;
                 server_name              admin.res1.local;
                 auth_basic               \"Administrator's Area\";
                 auth_basic_user_file     /etc/nginx/conf.d/.htpasswd;	
        }
        location /*.php {
		 deny all;
        }
}" > /etc/nginx/sites-available/default

echo "[Definition]
action = iptables-multiport[name=banbadrequests, port=\"http,https\", protocol=tcp]

[banbadrequest]
enabled = true
port = http,https
filter = banbadrequest
logpath = /var/log/nginx/error.log
logpath = /var/log/nginx/access.log
maxretry = 3

[apache-noscript]

enabled  = true" >> /etc/fail2ban/jail.conf

if [ "$SetWeb" = "true" ];then
    echo ">>> operation steel active <<<"
else
    echo "=> Demarage de fail2ban"
    systemctl start fail2ban
    systemctl enable fail2ban
fi

# Fin de l'installation
if [ "$SetWeb" = "true" ];then
    echo ">>> operation steel active <<<"
else
    echo "export SetWeb=true" >> /home/$user/.bashrc
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
