# Groupe de scholt_k and nouar_a

## 1) Adresse IP

La commande pour obtenir vos adresse ip sur les reseaux est:
```shell
ip a
```
Puis:
```shell
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:18:d0:2e brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.27/24 brd 192.168.1.255 scope global dynamic enp0s3
       valid_lft 34119sec preferred_lft 34119sec
    inet6 2a01:e0a:976:66a0:a00:27ff:fe18:d02e/64 scope global dynamic mngtmpaddr 
       valid_lft 86075sec preferred_lft 86075sec
    inet6 fe80::a00:27ff:fe18:d02e/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:59:03:1d brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.2/16 brd 192.168.255.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe59:31d/64 scope link 
       valid_lft forever preferred_lft forever
```

Signifie que vous étes connecté à 2 réseaux:
* le premier ``enp0s3`` est global c'est un bridge avec laquelle vous pouvez depuis votre machine en ssh avec l'ip ``192.168.1.27``
* le second ``enp0s8`` est local c'est le host-only qui est lié à vos machines du systéme et qui à pour ip ``192.168.0.2``

## 2) Connexion internet

La commande pour savoir si vous étes connecté à internet est:
```shell
ping 8.8.8.8
```
Le retour doit ressemblé à:
```shell
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=119 time=26.4 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=119 time=26.10 ms
```

## 3) DHCP

La commande est:

```shell
service isc-dhcp-server status
```

Le retour dois ressemblé à:
```shell
● isc-dhcp-server.service - LSB: DHCP server
   Loaded: loaded (/etc/init.d/isc-dhcp-server; generated; vendor preset: enabled)
   Active: active (running) ...

     debian isc-dhcp-server[2438]: Launching IPv4 server only.
     debian isc-dhcp-server[2438]: Starting ISC DHCPv4 server: dhcpd.
     debian systemd[1]: Started LSB: DHCP server.
```

## 4) DNS

La commande est:
```shell
dig admin.res1.local
```
Le retour dois ressemblé à:
```shell
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;admin.res1.local.      IN   A

;; ANSWER SECTION:
admin.res1.local.   0   IN   A   192.168.0.5
```

## 5) Intranet

La commande est:
```shell
curl -I web.res1.local
```
Le retour dois ressemblé à:
```shell
HTTP/1.0 200 OK
```
D'autre part:
```shell
curl -I admin.res1.local
````
Renvois:
```shell
HTTP/1.1 401 Unauthorized
Server: nginx
WWW-Authenticate: Basic realm="Administrator's Area"
...
```
Or:
```shell
curl -I -u bob:password admin.res1.local
```
Renvois:
```shell
HTTP/1.1 200 OK
Server: nginx
```

## 6) Fail2ban

La commande est:
```shell
systemctl status fail2ban
```
Le retour dois ressemblé à:
```shell
● fail2ban.service - Fail2Ban Service
    Loaded: loaded (/lib/systemd/system/fail2ban.service; enabled; vendor preset: enabled)
    Active: failed (Result: exit-code) since Mon 2019-03-18 08:07:14 UTC; 6h ago
        Docs: man:fail2ban(1)
      Process: 15284 ExecStart=/usr/bin/fail2ban-client -x start (code=exited, status=255)
```

## Auteurs

Sid-Ahmed NOUAR  [Linkedin](https://www.linkedin.com/in/sid-ahmed-nouar-4347b5159/)

Kevin SCHOLTES  [Linkedin](https://www.linkedin.com/in/kevin-scholtes-etna/)

## Version

* 1.0
    * Première version

## Licence

Ce projet est en open source, lisez le CGG de l'école ETNA Paris.