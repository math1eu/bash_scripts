#######################################################
#                                                     #
#        Script d installation d applications         #
#                                                     # 
#######################################################

#######################################################
# 19/11/2014 : MJA : Initialisation du script         #
# 18/12/2014 : MJA : Ajout installation Roundcube     #
# 30/12/2014 : MJA : Ajout installation Glpi          #
# 05/01/2015 : MJA : Changement SGBD Owncloud (MySQL) #
# 09/01/2015 : MJA : Prise en compte nouveau disque   #
# 14/01/2015 : MJA : Ajout SI Gold (MySQL distant)	  #
# 21/01/2015 : MJA : Ajout installation OCS			  #
# 22/01/2015 : MJA : Ajout installation Webmin		  #
# 26/01/2015 : MJA : Ajout installation PhpMyAdmin	  #
# 12/02/2015 : MJA : Ajout installation OsTicket	  #
# 13/02/2015 : MJA : Owncloud 8 + Libreoffice Writer  #
# 13/03/2015 : MJA : Ajout installation Wordpress	  #
# 23/03/2015 : MJA : MAJ Owncloud 8.0.2				  #
# 23/03/2015 : MJA : MAJ Joomla 3.4.1				  #
# 02/04/2015 : MJA : Gestion des packages via repo	  #
# 23/04/2015 : MJA : Ajout installation Proftpd		  #
# 04/05/2015 : MJA : Ajout installation Nginx		  #
# 21/05/2015 : MJA : MAJ Owncloud 8.0.3				  #
# 07/07/2015 : MJA : MAJ Owncloud 8.0.4				  #
# 08/07/2015 : MJA : MAJ Owncloud 8.1.0  			  #
# 28/07/2015 : MJA : OC : Redirection HTTP en HTTPS   #
# 28/07/2015 : MJA : OC : Activation du HSTS          #
# 28/07/2015 : MJA : OC : Activation du Memcache APC  # 
# 28/07/2015 : MJA : OC : Activation Sendmail         # 
# 02/09/2015 : MJA : MAJ Owncloud 8.1.1  			  #
# 19/10/2015 : MJA : MAJ Owncloud 8.1.3  			  #
# 12/11/2015 : MJA : Ajout installation OpenVPN		  #
# 30/11/2015 : MJA : MAJ Owncloud 8.2.1     		  #
# 12/01/2016 : MJA : MAJ Owncloud 8.2.2     		  #
# 30/03/2016 : MJA : MAJ Owncloud 9.0.0 + Debian 8	  #
# 01/04/2016 : MJA : Refonte installation Owncloud	  #
# 01/04/2016 : MJA : MAJ OpenVPN 2.3 et EasyRSA 3     #
#######################################################

#######################################################
#                 Structure du script                 #
# - Variables globales                                #
# - Fonction ajout_nouveau_disque                     #
# - Fonction install_lamp                             #
# - Fonction install_owncloud                         #
# - Fonction install_piwik                            #
# - Fonction install_joomla                           #
# - Fonction install_wordpress                        #
# - Fonction install_roundcube                        #
# - Fonction install_nginx	                          #
# - Fonction install_osticket                         #
# - Fonction install_glpi                             #
# - Fonction install_proftpd                          #
# - Fonction install_openvpn                          #
# - Fonction install_ocs                              #
# - Fonction install_webmin                           #
# - Fonction install_phpmyadmin                       #
# - Fonction show_menu      				          #
# - Main                     				          #
#######################################################

# Variables globales 
C_NOIR="\\033[0;39m"				# Couleur noire
C_VERT="\\033[1;32m"				# Couleur verte
C_ROUGE="\\033[1;31m"				# Couleur rouge
C_ROUGE="\\033[1;31m"				# Couleur rouge
C_BLEU="\\033[1;34m"				# Couleur bleue
C_CHOIX="";							# Variable de colorisation du choix du menu
V_DAT=`date +"%Y%m%d-%H%M%S"`;		# Date au format yyyymmdd-hhmmss
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;	# Date au format dd/mm/yyyy-hh:mm:ss
V_DEF_O="O";						# Reponse par defaut aux questions
V_DEF_N="N";						# Reponse par defaut aux questions
V_SCR=`basename $0`;				# Nom du script
V_LOG=${V_SCR}_${V_DAT}.log;		# Fichier de log
V_IP_TRAFIC=$(ifconfig eth1 | grep -o "inet addr:[0-9.]*" | cut -d: -f2;)	# Adresse IP Trafic (eth1)
V_REPO="195.25.97.56/cc/applications" # Adresse du repository Cloud Coach hebergeant les packages d install

# Variables MySQL
V_IP_MYSQL="127.0.0.1";				# Adresse IP serveur MySQL
V_MDP_MYSQL_ROOT=MyS@L123;			# Mot de passe root MySQL

# Variables Lamp
V_APPLI_LAMP=Lamp;					# Nom de l application

# Variables Owncloud
V_APPLI_OWNCLOUD=Owncloud;			# Nom de l application
V_DB_MYSQL_OWNCLOUD=ownclouddb;		# Nom de la base de donnees MySQL
V_USER_MYSQL_OWNCLOUD=owncloud;		# Nom de l utilisateur MySQL
V_MDP_MYSQL_OWNCLOUD=Owncloud_123;	# Mot de passe de l utilisateur MySQL
V_USER_OWNCLOUD=administrateur		# Nom de l utilisateur Owncloud
V_MDP_OWNCLOUD=Owncloud_123			# Mot de passe de l utilisateur Owncloud
V_REP_STOCKAGE_OWNCLOUD=/opt/owncloud_stockage/ # Repertoire de stockage des donnes utilisateurs

# Variables Piwik
V_APPLI_PIWIK=Piwik;				# Nom de l application
V_DB_MYSQL_PIWIK=piwikdb;			# Nom de la base de donnees MySQL
V_USER_MYSQL_PIWIK=piwik;			# Nom de l utilisateur MySQL
V_MDP_MYSQL_PIWIK=Piwik_123;		# Mot de passe de l utilisateur MySQL

# Variables Joomla
V_APPLI_JOOMLA=Joomla;				# Nom de l application
V_DB_MYSQL_JOOMLA=joomladb;			# Nom de la base de donnees MySQL
V_USER_MYSQL_JOOMLA=joomla;			# Nom de l utilisateur MySQL
V_MDP_MYSQL_JOOMLA=Joomla_123;		# Mot de passe de l utilisateur MySQL

# Variables Wordpress
V_APPLI_WORDPRESS=Wordpress			# Nom de l application
V_DB_MYSQL_WORDPRESS=wordpressdb;	# Nom de la base de donnees MySQL
V_USER_MYSQL_WORDPRESS=wordpress;	# Nom de l utilisateur MySQL
V_MDP_MYSQL_WORDPRESS=Wordpress_123;# Mot de passe de l utilisateur MySQL

# Variables Roundcube
V_APPLI_ROUNDCUBE=Roundcube;		# Nom de l application
V_DB_MYSQL_ROUNDCUBE=roundcubedb;	# Nom de la base de donnees MySQL
V_USER_MYSQL_ROUNDCUBE=roundcube;	# Nom de l utilisateur MySQL
V_MDP_MYSQL_ROUNDCUBE=Roundcube_123;# Mot de passe de l utilisateur MySQL

# Variables Nginx
V_APPLI_NGINX=Nginx;	  			# Nom de l application

# Variables OsTicket
V_APPLI_OSTICKET=Osticket;			# Nom de l application
V_DB_MYSQL_OSTICKET=osticketdb;		# Nom de la base de donnees MySQL
V_USER_MYSQL_OSTICKET=osticket;		# Nom de l utilisateur MySQL
V_MDP_MYSQL_OSTICKET=Osticket_123;	# Mot de passe de l utilisateur MySQL

# Variables Glpi
V_APPLI_GLPI=Glpi;					# Nom de l application
V_DB_MYSQL_GLPI=glpidb;				# Nom de la base de donnees MySQL
V_USER_MYSQL_GLPI=glpi;				# Nom de l utilisateur MySQL
V_MDP_MYSQL_GLPI=Glpi_123;			# Mot de passe de l utilisateur MySQL

# Variables Proftpd
V_APPLI_PROFTPD=Proftpd;			# Nom de l application
V_USER_PROFTPD=ftpuser;				# Nom de l utilisateur ftp
V_MDP_PROFTPD=Ftp_123;				# Mot de passe de l utilisateur ftp

# Variables OpenVPN
V_APPLI_OPENVPN=OpenVPN;			# Nom de l application

# Variables OCS
V_APPLI_OCS=Ocs;					# Nom de l application
V_DB_MYSQL_OCS=ocsdb;				# Nom de la base de donnees MySQL
V_USER_MYSQL_OCS=ocs;				# Nom de l utilisateur MySQL
V_MDP_MYSQL_OCS=Ocs_123;			# Mot de passe de l utilisateur MySQL

# Variables Webmin
V_APPLI_WEBMIN=Webmin;				# Nom de l application

# Variables PhpMyAdmin
V_APPLI_PHPMYADMIN=Phpmyadmin;		# Nom de l application

# MySQL : Definition du mot de passe root
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $V_MDP_MYSQL_ROOT"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $V_MDP_MYSQL_ROOT"
#

# Creation du repertoire /var/www
mkdir /var/www

# Fonctions

# Prise en compte du nouveau disque
ajout_nouveau_disque() {

V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Detection du nouveau disque
echo "[${V_NOW}][${V_APPLI}][INFO] : Detection du nouveau disque /dev/sdb" | tee -a ${V_LOG};
echo "- - -" > /sys/class/scsi_host/host0/scan
echo "- - -" > /sys/class/scsi_host/host1/scan
echo "- - -" > /sys/class/scsi_host/host2/scan

# Creation d une nouvelle partition
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation d une nouvelle partition sur /dev/sdb" | tee -a ${V_LOG};
echo "n
p
1

t
8e
w
"|fdisk /dev/sdb > /dev/null 2>&1

fdisk -l /dev/sdb > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : fdisk /dev/sdb" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation et verification du volume physique
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation d un volume physique sur /dev/sdb" | tee -a ${V_LOG};
pvcreate /dev/sdb > /dev/null 2>&1 
pvscan | grep "/dev/sdb" > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : pvcreate /dev/sdb" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation et verification du volume groupe
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du volume groupe vgdata" | tee -a ${V_LOG};
vgcreate vgdata /dev/sdb > /dev/null 2>&1
vgscan | grep "vgdata" > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : vgcreate vgdata /dev/sdb" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation et verification du volume logique
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du volume logique /dev/vgdata/opt" | tee -a ${V_LOG};
lvcreate -n opt -l 100%VG vgdata > /dev/null 2>&1
lvscan | grep /dev/vgdata/opt > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : lvcreate –n opt -l 100%VG vgdata" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Formatage partition
echo "[${V_NOW}][${V_APPLI}][INFO] : Formatage de la partition /dev/vgdata/opt" | tee -a ${V_LOG};
mkfs.ext4 /dev/vgdata/opt > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : mkfs.ext4 /dev/vgdata/opt" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Montage et verification du filesystem
echo "[${V_NOW}][${V_APPLI}][INFO] : Montage du filesystem /opt" | tee -a ${V_LOG};
umount /opt > /dev/null 2>&1
mount /dev/vgdata/opt /opt > /dev/null 2>&1
df -h /opt | grep opt > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : mount /dev/vgdata/opt /opt" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Ajout du montage dans le fichier fstab
echo "[${V_NOW}][${V_APPLI}][INFO] : Ajout du montage /opt dans le fichier fstab" | tee -a ${V_LOG};
echo "/dev/mapper/vgdata-opt /opt                     ext4    defaults        0 2" >> /etc/fstab
cat /etc/fstab | grep opt > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Ajout du montage /opt dans le fichier fstab" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

}

# Fonction Installation LAMP
install_lamp(){

V_APPLI=$V_APPLI_LAMP; 				# Nom de l application
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# SI Gold 
if [ $PACK != "Gold" ]
then
	packages="apache2 php5 mysql-server libapache2-mod-php5 php5-mysql"
else
	packages="apache2 php5 libapache2-mod-php5 php5-mysql"
fi

echo -e "\n================================== Installation LAMP ====================================\n" | tee -a ${V_LOG};

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y $packages > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y $packages" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Test d acces 
echo "[${V_NOW}][${V_APPLI}][INFO] : Test de connexion" | tee -a ${V_LOG};
wget -P /tmp http://localhost/ > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://localhost/" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Versions composants
version_linux=$(lsb_release -idrc | grep Description | awk -F ":" '{ $1 = "" ; print $0 }';)
version_apache=$(apache2 -v | grep version | awk -F ":" '{ $1 = "" ; print $0 }';)
version_php=$(php5 -v | grep PHP | grep -v Copyright;)

if [ $PACK = "Gold" ] 
then 
	version_mysql="Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64) using readline 6.2";
else
	version_mysql=$(mysql -V  | awk -F " " '{ $1 = "" ; print $0 }';)
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################### Versions des composants : ###############################

- Linux  : $version_linux
- Apache :    $version_apache
- MySQL  :     $version_mysql
- PHP    :      $version_php

" | tee -a ${V_LOG};

}

# Fonction Activation https Owncloud
activation_https_owncloud(){

V_APPLI=$V_APPLI_OWNCLOUD

# Variables liees au domaine
country=FR
state=Bretagne
locality=Rennes
organization=OBS
organizationalunit=OBS
email=email
password=Owncl@ud123

echo -e "\n=============================== Activation HTTPS Owncloud ===============================\n" | tee -a ${V_LOG};
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Configuration du https 
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du fichier /etc/apache2/sites-available/owncloud.conf" | tee -a ${V_LOG};
echo -e 'NameVirtualHost *:443
<VirtualHost *:443>
DocumentRoot /var/www
# Activation du mode SSL
SSLEngine On 
SSLOptions +FakeBasicAuth +ExportCertData +StrictRequire
SSLCertificateFile /etc/apache2/CertOwncloud/owncloud.crt
SSLCertificateKeyFile /etc/apache2/CertOwncloud/owncloud.key
<IfModule mod_headers.c>
Header always set Strict-Transport-Security "max-age=15768000; includeSubDomains; preload"
</IfModule>
</VirtualHost>' > /etc/apache2/sites-available/owncloud.conf

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation du fichier /etc/apache2/sites-available/owncloud.conf" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Activation du HSTS
#echo "[${V_NOW}][${V_APPLI}][INFO] : Activation du HSTS" | tee -a ${V_LOG};

#sed -i '/<\/VirtualHost>/d' /etc/apache2/sites-available/owncloud.conf
#echo -e 'Header always add Strict-Transport-Security "max-age=15768000; includeSubDomains; preload" \n  </VirtualHost>' >> /etc/apache2/sites-available/owncloud.conf 

#if [ $? -ne 0 ]
#then
#	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Activation du HSTS" | tee -a ${V_LOG};
#	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
#	exit 99;
#fi
#V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Activation du module ssl dans apache et ajouter owncloud comme site actif
echo "[${V_NOW}][${V_APPLI}][INFO] : Activation du module SSL dans apache" | tee -a ${V_LOG};
echo "[${V_NOW}][${V_APPLI}][INFO] : Ajout de Owncloud comme site actif" | tee -a ${V_LOG};
a2enmod ssl > /dev/null 2>&1
a2ensite owncloud.conf > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Activation du module SSL dans apache" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Ajout de Owncloud comme site actif" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation du repertoire de stockage des certificats
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du repertoire de stockage des certificats" | tee -a ${V_LOG};
mkdir -p /etc/apache2/CertOwncloud

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation du repertoire de stockage des certificats" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Generation de la cle
echo "[${V_NOW}][${V_APPLI}][INFO] : Generation de la cle pour le domaine $V_IP_PUBLIQUE" | tee -a ${V_LOG};
openssl genrsa -des3 -passout pass:$password -out owncloud.key 2048 -noout > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Generation de la cle pour le domaine $V_IP_PUBLIQUE" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Suppression de la passphrase dans la cle
echo "[${V_NOW}][${V_APPLI}][INFO] : Suppression de la passphrase dans la cle" | tee -a ${V_LOG};
openssl rsa -in owncloud.key -passin pass:$password -out owncloud.key > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Suppression de la passphrase dans la cle" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation du CSR
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du CSR" | tee -a ${V_LOG};
openssl req -new -key owncloud.key -out owncloud.csr -passin pass:$password \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$V_IP_PUBLIQUE/emailAddress=$email" > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation du CSR" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation CRT
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du CRT" | tee -a ${V_LOG};
openssl x509 -req -days 999 -in owncloud.csr -signkey owncloud.key -out owncloud.crt > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation du CRT" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Copie des certificats dans /etc/ssl
echo "[${V_NOW}][${V_APPLI}][INFO] : Copie des certificats dans /etc/ssl et /etc/apache2/CertOwncloud" | tee -a ${V_LOG};
mv owncloud.key owncloud.csr owncloud.crt /etc/apache2/CertOwncloud

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Copie des certificats dans /etc/ssl et /etc/apache2/CertOwncloud" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Redemarrage apache2
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage apache2" | tee -a ${V_LOG};
service apache2 restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redemarrage apache2" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Nettoyage
rm -Rf /tmp/index.html
}

# Fonction Installation Owncloud
install_owncloud(){

V_APPLI=$V_APPLI_OWNCLOUD			# Nom de l application
V_DB_MYSQL=$V_DB_MYSQL_OWNCLOUD		# Nom de la base de donnees MySQL
V_USER_MYSQL=$V_USER_MYSQL_OWNCLOUD	# Nom de l utilisateur MySQL
V_MDP_MYSQL=$V_MDP_MYSQL_OWNCLOUD	# Mot de passe de l utilisateur MySQL

# SI Gold 
if [ $PACK != "Gold" ]
then
	packages="apache2 php5 mysql-server libapache2-mod-php5 php5-mysql php5-common php5-gd php5-curl curl libcurl3 openssl unzip sendmail php-apc"
else
	packages="apache2 php5 libapache2-mod-php5 php5-mysql php5-common php5-gd php5-curl curl libcurl3 openssl unzip sendmail php-apc"
fi

V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
echo -e "\n================================= Installation Owncloud =================================\n" | tee -a ${V_LOG};

# SI Gold 
#if [ $PACK = "Gold" ]
#then
	# Prise en compte du nouveau disque (si lv /dev/vgdata/opt non present)
#	lvdisplay /dev/vgdata/opt

#	if [ $? -ne 0 ]
#	then
#		ajout_nouveau_disque;
#	fi
#fi

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y $packages > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y $packages" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Recuperation de l installation Owncloud
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression de l archive Owncloud" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.bz2 > /dev/null 2>&1

# Decompression de l installation Owncloud
tar xjf /tmp/latest-version.tar.bz2 -C /tmp > /dev/null 2>&1

# Deplacement du repertoire owncloud sous /var/www
mv /tmp/owncloud /var/www/

if [ $? -ne 0 ]
then			
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.bz2" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : tar xjf /tmp/latest-version.tar.bz2 -C /tmp" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : mv /tmp/owncloud /var/www/" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

if [ $PACK != "Gold" ]
then
	# MySQL : Creation de la base, du user, modifier proprietaire de la base et lui affecter tous les privileges
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "CREATE DATABASE IF NOT EXISTS $V_DB_MYSQL;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "GRANT ALL PRIVILEGES ON $V_DB_MYSQL.* TO $V_USER_MYSQL@localhost IDENTIFIED BY '$V_MDP_MYSQL';" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi
	
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Modification des privileges" | tee -a ${V_LOG}; 
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Modification des privileges" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi
	V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
fi

# Creation du repertoire de stockage des donnees utilisateur (sur le nouveau disque)
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du repertoire de stockage des donnees utilisateur" | tee -a ${V_LOG};
mkdir /opt/owncloud_stockage

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : mkdir /opt/owncloud_stockage" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Modification proprietaire
chown -R www-data:www-data /opt/owncloud_stockage

# Installation Owncloud
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation Owncloud" | tee -a ${V_LOG};
sudo -u www-data php /var/www/owncloud/occ maintenance:install --database "mysql" --database-name "$V_DB_MYSQL"  --database-user "root" --database-pass "$V_MDP_MYSQL_ROOT" --admin-user "$V_USER_OWNCLOUD" --admin-pass "$V_MDP_OWNCLOUD" --data-dir "$V_REP_STOCKAGE_OWNCLOUD" > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Installation Owncloud" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Installation de Libreoffice Writer pour la visualisation de document Word
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation de Libreoffice Writer pour la visualisation de document Word" | tee -a ${V_LOG};
apt-get install -y --no-install-recommends libreoffice-writer > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get install -y --no-install-recommends libreoffice-writer" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Modification du fichier /var/www/owncloud/config/config.php
echo "[${V_NOW}][${V_APPLI}][INFO] : Modification du fichier /var/www/owncloud/config/config.php" | tee -a ${V_LOG};
cp /var/www/owncloud/config/config.php /var/www/owncloud/config/config.php_old
sed -i -e "s/0 => 'localhost'/0 => '$V_IP_TRAFIC', 1 => '$V_IP_PUBLIQUE'/g" /var/www/owncloud/config/config.php
sed -i '/);/d' /var/www/owncloud/config/config.php
echo "  'preview_libreoffice_path' => '/usr/bin/libreoffice',
  'memcache.local' => '\OC\Memcache\APC',
  'logtimezone' => 'Europe/Paris',
  'default_language' => 'fr',
);" >> /var/www/owncloud/config/config.php

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Modification du fichier /var/www/owncloud/config/config.php" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Definition de la taille max d upload de fichiers a 2G
echo "[${V_NOW}][${V_APPLI}][INFO] : Definition de la taille max d upload de fichiers a 2G" | tee -a ${V_LOG};
sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 2G/g" /etc/php5/apache2/php.ini
sed -i -e "s/post_max_size = 8M/post_max_size = 2G/g" /etc/php5/apache2/php.ini

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Definition de la taille max d upload de fichiers a 2G" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Modification du codage en UTF-8
echo "[${V_NOW}][${V_APPLI}][INFO] : Modification du codage en UTF-8" | tee -a ${V_LOG};
sed -i -e 's/;default_charset = "UTF-8"/default_charset = "UTF-8"/g' /etc/php5/apache2/php.ini

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Modification du codage en UTF-8" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Redirection des flux HTTP en HTTPS
echo "[${V_NOW}][${V_APPLI}][INFO] : Redirection des flux HTTP en HTTPS" | tee -a ${V_LOG};
sed -i -e "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\//g" /etc/apache2/sites-available/000-default.conf
sed -i -e "/<\/VirtualHost>/d" /etc/apache2/sites-available/000-default.conf
echo -e "Redirect permanent / https://$V_IP_PUBLIQUE/ \n  </VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redirection des flux HTTP en HTTPS" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Activation du Memcache APC
echo "[${V_NOW}][${V_APPLI}][INFO] : Activation du Memcache APC" | tee -a ${V_LOG};
echo -e "apc.enable_cli=1" >> /etc/php5/mods-available/apc.ini

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Activation du Memcache APC" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Activation des modules apache rewrite et headers
echo "[${V_NOW}][${V_APPLI}][INFO] : Activation des module apache : rewrite et headers" | tee -a ${V_LOG};

a2enmod rewrite > /dev/null 2>&1
a2enmod headers > /dev/null 2>&1

# Redemarrage apache2
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage du service apache2" | tee -a ${V_LOG};
service apache2 restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Utilisateur owncloud proprietaire du repertoire /var/www/owncloud" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Activation des module apache : rewrite et headers" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redemarrage du service apache2" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Modification du proprietaire du repertoire /var/www/owncloud
echo "[${V_NOW}][${V_APPLI}][INFO] : Modification des droits du repertoire /var/www/owncloud" | tee -a ${V_LOG};
chown -R www-data:www-data /var/www/owncloud

# Nettoyage du repertoire /tmp
echo "[${V_NOW}][${V_APPLI}][INFO] : Nettoyage du repertoire /tmp" | tee -a ${V_LOG};
rm -Rf /tmp/latest-version*
rm -Rf /tmp/owncloud

# Appel fonction activation_https_owncloud
activation_https_owncloud;

# Versions composants
version_linux=$(lsb_release -idrc | grep Description | awk -F ":" '{ $1 = "" ; print $0 }';)
version_apache=$(apache2 -v | grep version | awk -F ":" '{ $1 = "" ; print $0 }';)
version_php=$(php5 -v | grep PHP | grep -v Copyright;)

if [ $PACK = "Gold" ] 
then 
	version_mysql="Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64) using readline 6.2";
else
	version_mysql=$(mysql -V  | awk -F " " '{ $1 = "" ; print $0 }';)
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################### Versions des composants : ###############################

- Linux  : $version_linux
- Apache :    $version_apache
- MySQL  :     $version_mysql
- PHP    :      $version_php

################################# Informations MySQL : ##################################

- Serveur MySQL      : $V_IP_MYSQL
- Base MySQL         : $V_DB_MYSQL
- Utilisateur MySQL root  : root
- Mot de passe MySQL root : $V_MDP_MYSQL_ROOT
- Utilisateur MySQL owncloud  : $V_USER_MYSQL
- Mot de passe MySQL owncloud : $V_MDP_MYSQL

############################## Informations de connexion : ##############################

- Merci de vous connecter a l interface graphique : http://ip_serveur/owncloud
- Identifiants : $V_USER_OWNCLOUD / $V_MDP_OWNCLOUD

" | tee -a ${V_LOG};

}

# Fonction Installation Piwik
install_piwik(){

# Suite a l installation, ajouter l adresse ip publique dans /var/www/piwik/config/config.ini.php :
# trusted_hosts[] = "adresse ip publique"

# Variables
V_APPLI=$V_APPLI_PIWIK				# Nom de l application
V_DB_MYSQL=$V_DB_MYSQL_PIWIK		# Nom de la base de donnees MySQL
V_USER_MYSQL=$V_USER_MYSQL_PIWIK	# Nom de l utilisateur MySQL
V_MDP_MYSQL=$V_MDP_MYSQL_PIWIK		# Mot de passe de l utilisateur MySQL

# SI Gold 
if [ $PACK != "Gold" ]
then
	packages="apache2 php5 mysql-server libapache2-mod-php5 php5-mysql php5-common php5-gd php5-curl curl libcurl3 php5-cli php5-geoip openssl"
else
	packages="apache2 php5 libapache2-mod-php5 php5-mysql php5-common php5-gd php5-curl curl libcurl3 php5-cli php5-geoip openssl"
fi

V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
echo -e "\n=================================== Installation Piwik ==================================\n" | tee -a ${V_LOG};

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y $packages > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y $packages" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Recuperation et decompression de l installation Piwik
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression de l archive piwik" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz > /dev/null 2>&1
tar -vxf /tmp/latest-version.tar.gz -C /var/www > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz && tar -vxf /tmp/latest-version.tar.gz -C /var/www" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Changement des droits du repertoire piwik
echo "[${V_NOW}][${V_APPLI}][INFO] : Changement des droits du repertoire /var/www/piwik" | tee -a ${V_LOG};
chown -R www-data:www-data /var/www/piwik
#chmod 775 -R /var/www/piwik/tmp/

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chown -R www-data:www-data /var/www/piwik" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chmod 777 -R /var/www/piwik/tmp/" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

if [ $PACK != "Gold" ]
then
	# MySQL : Creation de la base, du user, modifier proprietaire de la base et lui affecter tous les privileges
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "CREATE DATABASE IF NOT EXISTS $V_DB_MYSQL;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "GRANT ALL PRIVILEGES ON $V_DB_MYSQL.* TO $V_USER_MYSQL@localhost IDENTIFIED BY '$V_MDP_MYSQL';" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Modification des privileges" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Modification des privileges" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi
	V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
fi

# Redemarrage apache2
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage apache2" | tee -a ${V_LOG};
service apache2 restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redemarrage apache2" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Test d acces 
echo "[${V_NOW}][${V_APPLI}][INFO] : Test d acces a la page d accueil" | tee -a ${V_LOG};
wget -P /tmp http://localhost/piwik > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://localhost/piwik" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Nettoyage du repertoire /tmp
echo "[${V_NOW}][${V_APPLI}][INFO] : Nettoyage du repertoire /tmp" | tee -a ${V_LOG};
rm -Rf /tmp/piwik
rm -Rf /tmp/How\ to\ install\ Piwik.html
rm -Rf /var/www/How\ to\ install\ Piwik.html
rm -Rf /tmp/latest-version*

# Versions composants
version_linux=$(lsb_release -idrc | grep Description | awk -F ":" '{ $1 = "" ; print $0 }';)
version_apache=$(apache2 -v | grep version | awk -F ":" '{ $1 = "" ; print $0 }';)
version_php=$(php5 -v | grep PHP | grep -v Copyright;)

if [ $PACK = "Gold" ] 
then 
	version_mysql="Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64) using readline 6.2";
else
	version_mysql=$(mysql -V  | awk -F " " '{ $1 = "" ; print $0 }';)
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################### Versions des composants : ###############################

- Linux  : $version_linux
- Apache :    $version_apache
- MySQL  :     $version_mysql
- PHP    :      $version_php

################################# Informations MySQL : ##################################

- Serveur MySQL      : $V_IP_MYSQL
- Base MySQL         : $V_DB_MYSQL
- Utilisateur MySQL  : $V_USER_MYSQL
- Mot de passe MySQL : $V_MDP_MYSQL
- Prefixe des tables : piwik_
- Adaptateur         : PDO/MYSQL

############################## Informations de connexion : ##############################

- Merci de vous connecter a l interface graphique : http://ip_serveur/piwik 
- Suivre les etapes de configuration
- Suite a l installation, ajouter l adresse ip publique dans /var/www/piwik/config/config.ini.php :
  trusted_hosts[] = 'adresse ip publique'
  
" | tee -a ${V_LOG};

}

# Fonction Installation Joomla
install_joomla(){

# Variables
V_APPLI=$V_APPLI_JOOMLA					# Nom de l application
V_DB_MYSQL=$V_DB_MYSQL_JOOMLA			# Nom de la base de donnees MySQL
V_USER_MYSQL=$V_USER_MYSQL_JOOMLA		# Nom de l utilisateur MySQL
V_MDP_MYSQL=$V_MDP_MYSQL_JOOMLA			# Mot de passe de l utilisateur MySQL

# SI Gold 
if [ $PACK != "Gold" ]
then
	packages="apache2 php5 mysql-server libapache2-mod-php5 php5-mysql"
else
	packages="apache2 php5 libapache2-mod-php5 php5-mysql"
fi

echo -e "\n================================== Installation Joomla ==================================\n" | tee -a ${V_LOG};
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y $packages > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y $packages" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation repertoire Joomla
mkdir /var/www/joomla

# Recuperation et decompression de l installation joomla
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression de l archive joomla" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz > /dev/null 2>&1
tar -vxf /tmp/latest-version.tar.gz -C /var/www/joomla > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz && tar -vxf /tmp/latest-version.tar.gz -C /var/www/joomla" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Changement des droits du repertoire joomla
echo "[${V_NOW}][${V_APPLI}][INFO] : Changement des droits du repertoire /var/www/joomla" | tee -a ${V_LOG};
chown -R www-data:www-data /var/www/joomla
chmod 755 -R /var/www/joomla

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chown -R www-data:www-data /var/www/joomla" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chmod 777 -R /var/www/joomla" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

if [ $PACK != "Gold" ]
then
	# MySQL : Creation de la base, du user, modifier proprietaire de la base et lui affecter tous les privileges
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "CREATE DATABASE IF NOT EXISTS $V_DB_MYSQL;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "GRANT ALL PRIVILEGES ON $V_DB_MYSQL.* TO $V_USER_MYSQL@localhost IDENTIFIED BY '$V_MDP_MYSQL';" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Modification des privileges" | tee -a ${V_LOG}; 
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Modification des privileges" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi
	V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
fi

# Modification du fichier /etc/php5/apache2/php.ini
echo "[${V_NOW}][${V_APPLI}][INFO] : Modification du fichier /etc/php5/apache2/php.ini" | tee -a ${V_LOG};
sed -i -e "s/output_buffering = 4096/;output_buffering = 4096/g" /etc/php5/apache2/php.ini

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Modification du fichier /etc/php5/apache2/php.ini" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Redemarrage apache2
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage apache2" | tee -a ${V_LOG};
service apache2 restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redemarrage apache2" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Test d acces 
echo "[${V_NOW}][${V_APPLI}][INFO] : Test d acces a la page d accueil" | tee -a ${V_LOG};
wget -P /tmp http://localhost/joomla > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://localhost/joomla" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Nettoyage du repertoire /tmp
echo "[${V_NOW}][${V_APPLI}][INFO] : Nettoyage du repertoire /tmp" | tee -a ${V_LOG};
rm -Rf /tmp/index.html*
rm -Rf /tmp/joomla
rm -Rf /tmp/latest-version*

# Versions composants
version_linux=$(lsb_release -idrc | grep Description | awk -F ":" '{ $1 = "" ; print $0 }';)
version_apache=$(apache2 -v | grep version | awk -F ":" '{ $1 = "" ; print $0 }';)
version_php=$(php5 -v | grep PHP | grep -v Copyright;)

if [ $PACK = "Gold" ] 
then 
	version_mysql="Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64) using readline 6.2";
else
	version_mysql=$(mysql -V  | awk -F " " '{ $1 = "" ; print $0 }';)
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################### Versions des composants : ###############################

- Linux  : $version_linux
- Apache :    $version_apache
- MySQL  :     $version_mysql
- PHP    :      $version_php

################################# Informations MySQL : ##################################

- Serveur MySQL      : $V_IP_MYSQL
- Base MySQL         : $V_DB_MYSQL
- Utilisateur MySQL  : $V_USER_MYSQL
- Mot de passe MySQL : $V_MDP_MYSQL

############################## Informations de connexion : ##############################

- Merci de vous connecter a l interface graphique : http://ip_serveur/joomla
- Suivre les etapes de configuration

" | tee -a ${V_LOG};

}

# Fonction Installation Wordpress
install_wordpress(){

# Variables
V_APPLI=$V_APPLI_WORDPRESS				# Nom de l application
V_DB_MYSQL=$V_DB_MYSQL_WORDPRESS		# Nom de la base de donnees MySQL
V_USER_MYSQL=$V_USER_MYSQL_WORDPRESS	# Nom de l utilisateur MySQL
V_MDP_MYSQL=$V_MDP_MYSQL_WORDPRESS		# Mot de passe de l utilisateur MySQL

# SI Gold 
if [ $PACK != "Gold" ]
then
	packages="apache2 php5 mysql-server php5-mysql"
else
	packages="apache2 php5 php5-mysql"
fi

V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
echo -e "\n=================================== Installation Wordpress ==================================\n" | tee -a ${V_LOG};

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y $packages > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y $packages" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Recuperation et decompression de l installation Wordpress
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression de l archive Wordpress" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz > /dev/null 2>&1
tar -vxf /tmp/latest-version.tar.gz -C /var/www > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz && tar -vxf /tmp/latest-version.tar.gz -C /var/www" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

if [ $PACK != "Gold" ]
then
	# MySQL : Creation de la base, du user, modifier proprietaire de la base et lui affecter tous les privileges
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "CREATE DATABASE IF NOT EXISTS $V_DB_MYSQL;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "GRANT ALL PRIVILEGES ON $V_DB_MYSQL.* TO $V_USER_MYSQL@localhost IDENTIFIED BY '$V_MDP_MYSQL';" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Modification des privileges" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Modification des privileges" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi
	V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
fi

# Creation du fichier de configuration wp-config.php
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du fichier de configuration wp-config.php" | tee -a ${V_LOG};
echo "<?php

define('DB_NAME', '$V_DB_MYSQL');
define('DB_USER', '$V_USER_MYSQL');
define('DB_PASSWORD', '$V_MDP_MYSQL');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

\$table_prefix  = 'wp_';

define('WP_DEBUG', false); 

if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');" > /var/www/wordpress/wp-config.php

if [ $? -ne 0 ] 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation du fichier de configuration wp-config.php" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
	
# Redemarrage apache2
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage apache2" | tee -a ${V_LOG};
service apache2 restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redemarrage apache2" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Test d acces 
echo "[${V_NOW}][${V_APPLI}][INFO] : Test d acces a la page d accueil" | tee -a ${V_LOG};
wget -P /tmp http://localhost/wordpress > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://localhost/wordpress" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Nettoyage du repertoire /tmp
echo "[${V_NOW}][${V_APPLI}][INFO] : Nettoyage du repertoire /tmp" | tee -a ${V_LOG};
rm -Rf /tmp/latest-version*

# Versions composants
version_linux=$(lsb_release -idrc | grep Description | awk -F ":" '{ $1 = "" ; print $0 }';)
version_apache=$(apache2 -v | grep version | awk -F ":" '{ $1 = "" ; print $0 }';)
version_php=$(php5 -v | grep PHP | grep -v Copyright;)

if [ $PACK = "Gold" ] 
then 
	version_mysql="Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64) using readline 6.2";
else
	version_mysql=$(mysql -V  | awk -F " " '{ $1 = "" ; print $0 }';)
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################### Versions des composants : ###############################

- Linux  : $version_linux
- Apache :    $version_apache
- MySQL  :     $version_mysql
- PHP    :      $version_php

################################# Informations MySQL : ##################################

- Serveur MySQL      : $V_IP_MYSQL
- Base MySQL         : $V_DB_MYSQL
- Utilisateur MySQL  : $V_USER_MYSQL
- Mot de passe MySQL : $V_MDP_MYSQL

############################## Informations de connexion : ##############################

- Merci de vous connecter a l interface graphique : http://ip_serveur/wordpress 
- Suivre les etapes de configuration
  
" | tee -a ${V_LOG};
}

# Fonction Installation Roundcube
install_roundcube(){

# Variables
V_APPLI=$V_APPLI_ROUNDCUBE				# Nom de l application
V_DB_MYSQL=$V_DB_MYSQL_ROUNDCUBE		# Nom de la base de donnees MySQL		
V_USER_MYSQL=$V_USER_MYSQL_ROUNDCUBE	# Nom de l utilisateur MySQL
V_MDP_MYSQL=$V_MDP_MYSQL_ROUNDCUBE		# Mot de passe de l utilisateur MySQL
httproot=/var/www;						# Repertoire de decompression de l archive
roundcuberoot="${httproot}"/roundcube;	# Repertoire d installation

# SI Gold 
if [ $PACK != "Gold" ]
then
	packages="apache2 php5 mysql-server libapache2-mod-php5 php5-mysql php5-common php5-mcrypt php5-intl"
else
	packages="apache2 php5 libapache2-mod-php5 php5-mysql php5-common php5-mcrypt php5-intl"
fi

V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
echo -e "\n================================= Installation Roundcube ================================\n" | tee -a ${V_LOG};

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y $packages > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y $packages" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Recuperation et decompression de l installation Roundcube
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression de l archive Roundcube" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz > /dev/null 2>&1
tar -C "${httproot}" -zxpf /tmp/latest-version.tar.gz > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz && tar -C "${httproot}" -zxpf /latest-version.tar.gz" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

rm -Rf /tmp/latest-version* 
mv "${httproot}"/roundcubemail-* "${roundcuberoot}"

# Verification presence fichiers
[ -d "${roundcuberoot}" ] || {
  echo "[${V_NOW}][${V_APPLI}][ERREUR] : Dossier ${roundcuberoot} non present" | tee -a ${V_LOG};
  exit 99
}

[ -e "${roundcuberoot}"/config/config.inc.php.sample ] || {
  echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fichier ${roundcuberoot}/config/config.inc.php.sample non present" | tee -a ${V_LOG};
  exit 99
}

[ -d "${roundcuberoot}"/installer ] || {
  echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fichier ${roundcuberoot}/installer non present" | tee -a ${V_LOG};
  exit 99
}

# Changement des droits du repertoire roundcube
echo "[${V_NOW}][${V_APPLI}][INFO] : Changement des droits du repertoire ${roundcuberoot}" | tee -a ${V_LOG};
chown -R www-data:www-data "${roundcuberoot}"
chmod -R 775 "${roundcuberoot}"/temp
chmod -R 775 "${roundcuberoot}"/logs

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chown -R www-data:www-data ${roundcuberoot}" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chmod -R 775 ${roundcuberoot}/temp" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chmod -R 775 ${roundcuberoot}/logs" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

if [ $PACK != "Gold" ]
then
	# MySQL : Creation de la base, du user, modifier proprietaire de la base et lui affecter tous les privileges
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql --user=root --password=$V_MDP_MYSQL_ROOT -e "CREATE DATABASE IF NOT EXISTS $V_DB_MYSQL;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG}; 
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
	mysql --user=root --password=$V_MDP_MYSQL_ROOT -e "GRANT ALL PRIVILEGES ON $V_DB_MYSQL.* TO $V_USER_MYSQL@localhost IDENTIFIED BY '$V_MDP_MYSQL';" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Modification des privileges" | tee -a ${V_LOG};
	mysql --user=root --password=$V_MDP_MYSQL_ROOT -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Modification des privileges" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Initialisation de la base" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT $V_DB_MYSQL < "${roundcuberoot}"/SQL/mysql.initial.sql > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Initialisation de la base" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi
	V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
fi

# Creation du fichier config.inc.php
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du fichier ${roundcuberoot}/config/config.inc.php" | tee -a ${V_LOG};
cp -a "${roundcuberoot}"/config/config.inc.php.sample "${roundcuberoot}"/config/config.inc.php

deskey=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_#&!*%?' | fold -w 24 | head -n 1)

echo -e "<?php
\$config['db_dsnw'] = 'mysql://$V_USER_MYSQL:$V_MDP_MYSQL@$V_IP_MYSQL/$V_DB_MYSQL';
\$config['debug_level'] = 13;
\$config['default_host'] = '$imapserver';
\$config['default_port'] = $imapport;
\$config['smtp_server'] = '$smtpserver';
\$config['smtp_port'] = $smtpport;
\$config['smtp_user'] = '%u';
\$config['smtp_pass'] = '%p';
\$config['support_url'] = '';
\$config['des_key'] = '$deskey';
\$config['username_domain'] = '$domain';
\$config['product_name'] = '$roundcubeproductname';
\$config['plugins'] = array('archive','zipdownload');
\$config['language'] = '$roundcubelanguage';
\$config['spellcheck_engine'] = 'pspell';
\$config['mail_pagesize'] = 50;
\$config['draft_autosave'] = 300;
\$config['mime_param_folding'] = 0;
\$config['mdn_requests'] = 2;
\$config['skin'] = 'larry';" > "${roundcuberoot}"/config/config.inc.php

if [ $? -ne 0 ] 
then 
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation du fichier ${roundcuberoot}/config/config.inc.php" | tee -a ${V_LOG}; 
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Suppression de l installeur
echo "[${V_NOW}][${V_APPLI}][INFO] : Suppression du fichier ${roundcuberoot}/installer" | tee -a ${V_LOG};
rm -rf "${roundcuberoot}"/installer

if [ $? -ne 0 ] 
then 
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : rm -rf ${roundcuberoot}/installer" | tee -a ${V_LOG}; 
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

if [ $PACK != "Gold" ]
then
	# Creation crontab pour nettoyage quotidien de la base
	echo "[${V_NOW}][${V_APPLI}][INFO] : Mise en place du nettoyage quotidien de la base via crontab" | tee -a ${V_LOG};

	tmp="$(mktemp -t crontab.tmp.XXXXXXXXXX)"
	echo "00 23 * * * ${roundcuberoot}/bin/cleandb.sh > /dev/null" >> "${tmp}"
	crontab -u root "${tmp}"
	rm -f "${tmp}"
	unset tmp

	crontab -l | grep cleandb.sh
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Mise en place du nettoyage quotidien de la base via crontab" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi
	V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
fi

# Activation modules apache
a2enmod deflate > /dev/null 2>&1
a2enmod expires > /dev/null 2>&1
a2enmod headers > /dev/null 2>&1

# Redemarrage apache2
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage apache2" | tee -a ${V_LOG};
service apache2 restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redemarrage apache2" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Test d acces 
echo "[${V_NOW}][${V_APPLI}][INFO] : Test d acces a la page d accueil" | tee -a ${V_LOG};
wget -P /tmp http://localhost/roundcube > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://localhost/roundcube" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi

rm -Rf /tmp/roundcube

# Versions composants
version_linux=$(lsb_release -idrc | grep Description | awk -F ":" '{ $1 = "" ; print $0 }';)
version_apache=$(apache2 -v | grep version | awk -F ":" '{ $1 = "" ; print $0 }';)
version_php=$(php5 -v | grep PHP | grep -v Copyright;)

if [ $PACK = "Gold" ] 
then 
	version_mysql="Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64) using readline 6.2";
else
	version_mysql=$(mysql -V  | awk -F " " '{ $1 = "" ; print $0 }';)
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################### Versions des composants : ###############################

- Linux  : $version_linux
- Apache :    $version_apache
- MySQL  :     $version_mysql
- PHP    :      $version_php

################################# Informations MySQL : ##################################

- Serveur MySQL      : $V_IP_MYSQL
- Base MySQL         : $V_DB_MYSQL
- Utilisateur MySQL  : $V_USER_MYSQL
- Mot de passe MySQL : $V_MDP_MYSQL

############################## Informations de connexion : ##############################

- Merci de vous connecter a l interface graphique : http://ip_serveur/roundcube

" | tee -a ${V_LOG};

}

# Fonction Installation Nginx
install_nginx(){

# Variables
V_APPLI=$V_APPLI_NGINX				# Nom de l application
ip_serveur_web=$V_IP_PROXY 			# IP serveur web vers lequel la redirection sera faite

# Variables certifcat
country=FR
state=France
locality=Locality
organization=OBS
organizationalunit=OBS
commonname=Commonname
email=Email

V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
echo -e "\n=================================== Installation Nginx ==================================\n" | tee -a ${V_LOG};

# Installer les paquets necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des paquets necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y nginx openssl > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update -qq && apt-get install -y nginx openssl" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation du fichier de configuration proxy.conf
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du fichier de configuration proxy.conf" | tee -a ${V_LOG};

echo "proxy_redirect off;
proxy_buffering on;
proxy_read_timeout 300;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto \$scheme;
proxy_set_header Host \$host;
proxy_hide_header X-Powered-By;" > /etc/nginx/conf.d/proxy.conf

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation du fichier de configuration proxy.conf" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Renommage du fichier de configuration default 
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default_old

# Creation du repertoire qui contiendra le certificat SSL
mkdir -p /etc/nginx/cle_ssl/

# Generation d une cle RSA, du certificat generique et du certificat au format x509
echo "[${V_NOW}][${V_APPLI}][INFO] : Generation d une cle RSA, du certificat generique et du certificat au format x509" | tee -a ${V_LOG};
openssl genrsa -out server.key 1024 > /dev/null 2>&1
openssl req -new -key server.key -out server.csr -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" > /dev/null 2>&1
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : openssl genrsa -out server.key 1024" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : openssl req -new -key server.key -out server.csr " | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Copie des certificats dans /etc/nginx/cle_ssl
echo "[${V_NOW}][${V_APPLI}][INFO] : Copie des certificats dans /etc/nginx/cle_ssl" | tee -a ${V_LOG};
mv server.key server.csr server.crt /etc/nginx/cle_ssl

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : mv server.key server.key server.key /etc/nginx/cle_ssl" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Configuration du reverse proxy pour rediriger les flux HTTP et HTTPS
echo "[${V_NOW}][${V_APPLI}][INFO] : Configuration du reverse proxy pour rediriger les flux HTTP et HTTPS" | tee -a ${V_LOG};
echo -e "server {

    listen 80;
    server_name reverse_proxy;

    # Desactivation des access_log pour ne pas faire doublon avec Apache
    access_log off;

    # Requetes arrivant sur le port 80 redirigees vers le serveur web 
    location / {
        proxy_pass http://$ip_serveur_web/;
    }
}

server {

    listen 443;
    server_name reverse_proxy;

    # Desactivation des access_log pour ne pas faire doublon avec Apache
    access_log off;

   # Ajout du certificat auto-signe
    ssl on;
    ssl_certificate /etc/nginx/cle_ssl/server.crt;
    ssl_certificate_key /etc/nginx/cle_ssl/server.key;

    # Requetes arrivant sur le port 80 redirigees vers le serveur web 
    location / {
        proxy_pass https://$ip_serveur_web/;
    }
}" > /etc/nginx/sites-available/default

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Configuration du reverse proxy pour rediriger les flux HTTP et HTTPS" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Redemarrage du service nginx
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage du service nginx" | tee -a ${V_LOG};
service nginx restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : service nginx restart" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes." | tee -a ${V_LOG};
}

# Fonction Installation OsTicket
install_osticket(){

# Variables
V_APPLI=$V_APPLI_OSTICKET			# Nom de l application
V_DB_MYSQL=$V_DB_MYSQL_OSTICKET		# Nom de la base de donnees MySQL
V_USER_MYSQL=$V_USER_MYSQL_OSTICKET	# Nom de l utilisateur MySQL
V_MDP_MYSQL=$V_MDP_MYSQL_OSTICKET	# Mot de passe de l utilisateur MySQL

# SI Gold 
if [ $PACK != "Gold" ]
then
	packages="php5 mysql-server php5-mysql php5-gd php5-imap sendmail"
else
	packages="php5 php5-mysql php5-gd php5-imap sendmail"
fi

V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
echo -e "\n=================================== Installation OsTicket ==================================\n" | tee -a ${V_LOG};

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y $packages > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y $packages" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Recuperation et decompression de l installation Osticket
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression de l archive osticket" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz > /dev/null 2>&1
tar -vxf /tmp/latest-version.tar.gz -C /tmp > /dev/null 2>&1
mv /tmp/osTicket-* /var/www/osticket

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : get -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz && tar -vxf /tmp/latest-version.tar.gz -C /tmp" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation du fichier de configuration ost-config.php
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du fichier de configuration ost-config.php" | tee -a ${V_LOG};
cp /var/www/osticket/include/ost-sampleconfig.php /var/www/osticket/include/ost-config.php

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : cp /var/www/osticket/include/ost-sampleconfig.php /var/www/osticket/include/ost-config.php" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Changement des droits du fichier de configuration osticket
echo "[${V_NOW}][${V_APPLI}][INFO] : Changement des droits du fichier de configuration ost-config.php" | tee -a ${V_LOG};
chmod 666 /var/www/osticket/include/ost-config.php

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chmod 666 /var/www/osticket/include/ost-config.php" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

if [ $PACK != "Gold" ]
then
	# MySQL : Creation de la base, du user, modifier proprietaire de la base et lui affecter tous les privileges
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "CREATE DATABASE IF NOT EXISTS $V_DB_MYSQL;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "GRANT ALL PRIVILEGES ON $V_DB_MYSQL.* TO $V_USER_MYSQL@localhost IDENTIFIED BY '$V_MDP_MYSQL';" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Modification des privileges" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Modification des privileges" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi
	V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
fi

# Installation du package de langue francaise
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation du package de langue francaise" | tee -a ${V_LOG};
wget -P /var/www/osticket/include/i18n http://$V_REPO/$V_APPLI/fr.phar

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /var/www/osticket/include/i18n http://$V_REPO/$V_APPLI/fr.phar" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Redemarrage apache2
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage apache2" | tee -a ${V_LOG};
service apache2 restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redemarrage apache2" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Test d acces 
echo "[${V_NOW}][${V_APPLI}][INFO] : Test d acces a la page d accueil" | tee -a ${V_LOG};
wget -P /tmp http://localhost/osticket > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://localhost/osticket" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Nettoyage du repertoire /tmp
echo "[${V_NOW}][${V_APPLI}][INFO] : Nettoyage du repertoire /tmp" | tee -a ${V_LOG};
rm -Rf /tmp/latest-version*

# Versions composants
version_linux=$(lsb_release -idrc | grep Description | awk -F ":" '{ $1 = "" ; print $0 }';)
version_apache=$(apache2 -v | grep version | awk -F ":" '{ $1 = "" ; print $0 }';)
version_php=$(php5 -v | grep PHP | grep -v Copyright;)

if [ $PACK = "Gold" ] 
then 
	version_mysql="Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64) using readline 6.2";
else
	version_mysql=$(mysql -V  | awk -F " " '{ $1 = "" ; print $0 }';)
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################### Versions des composants : ###############################

- Linux  : $version_linux
- Apache :    $version_apache
- MySQL  :     $version_mysql
- PHP    :      $version_php

################################# Informations MySQL : ##################################

- Serveur MySQL      : $V_IP_MYSQL
- Base MySQL         : $V_DB_MYSQL
- Utilisateur MySQL  : $V_USER_MYSQL
- Mot de passe MySQL : $V_MDP_MYSQL

############################## Informations de connexion : ##############################

- Merci de vous connecter a l interface graphique : http://ip_serveur/osticket/setup/install.php 
- Suivre les etapes de configuration
- Modifier 2 options depuis le Panneau d admin > Parametres > Acces

	* Inscription requise   :	 Exiger l enregistrement et la connexion pour creer des tickets 
	* Methode d inscription :	 Prive
	
- Pour finir, merci d executer les commandes suivantes sur le serveur :

#chmod 644 /var/www/osticket/include/ost-config.php
#rm -Rf /var/www/osticket/setup/
  
" | tee -a ${V_LOG};

}

# Fonction Installation Glpi
install_glpi(){

# Variables
V_APPLI=$V_APPLI_GLPI			# Nom de l application
V_DB_MYSQL=$V_DB_MYSQL_GLPI		# Nom de la base de donnees MySQL
V_USER_MYSQL=$V_USER_MYSQL_GLPI	# Nom de l utilisateur MySQL
V_MDP_MYSQL=$V_MDP_MYSQL_GLPI	# Mot de passe de l utilisateur MySQL

# SI Gold 
if [ $PACK != "Gold" ]
then
	packages="apache2 php5 libapache2-mod-php5 php5-gd php-pear php5-imap php5-ldap php5-curl php5-mcrypt mysql-server php5-mysql libapache2-mod-perl2"
else
	packages="apache2 php5 libapache2-mod-php5 php5-gd php-pear php5-imap php5-ldap php5-curl php5-mcrypt php5-mysql libapache2-mod-perl2"
fi

echo -e "\n=================================== Installation Glpi ===================================\n" | tee -a ${V_LOG};
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y $packages > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y $packages" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Telechargement et decompression de l archive glpi
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression de l archive glpi" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz > /dev/null 2>&1
tar -vxf /tmp/latest-version.tar.gz -C /var/www > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz && tar -vxf /tmp/latest-version.tar.gz -C /var/www" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Telechargement et decompression du plugin fusion inventory
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression du plugin fusion inventory" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/fusioninventory-for-glpi_0.85+1.0.tar.gz > /dev/null 2>&1
tar -vxf /tmp/fusioninventory-for-glpi_0.85+1.0.tar.gz -C /var/www/glpi/plugins > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://$V_REPO/$V_APPLI/fusioninventory-for-glpi_0.85+1.0.tar.gz && tar -vxf /tmp/fusioninventory-for-glpi_0.85+1.0.tar.gz -C /var/www/glpi/plugins" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Telechargement et decompression du plugin webservices
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression du plugin webservices" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/glpi-webservices-1.4.3.tar.gz > /dev/null 2>&1
tar -vxf /tmp/glpi-webservices-1.4.3.tar.gz -C /var/www/glpi/plugins > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://$V_REPO/$V_APPLI/glpi-webservices-1.4.3.tar.gz && tar -vxf /tmp/glpi-webservices-1.4.3.tar.gz -C /var/www/glpi/plugins" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

if [ $PACK != "Gold" ]
then
	# MySQL : Creation de la base, du user, modifier proprietaire de la base et lui affecter tous les privileges
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "CREATE DATABASE IF NOT EXISTS $V_DB_MYSQL;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "GRANT ALL PRIVILEGES ON $V_DB_MYSQL.* TO $V_USER_MYSQL@localhost IDENTIFIED BY '$V_MDP_MYSQL';" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Modification des privileges" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Modification des privileges" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi
	
	# Initialisation de la base
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Initialisation de la base" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT $V_DB_MYSQL < /var/www/glpi/install/mysql/glpi-0.85-empty.sql > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Initialisation de la base" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi
	
	# Cryptage SHA-1
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Modification du mot de passe pour l utilisateur glpi" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT $V_DB_MYSQL -e "update glpi_users set password='96fc3fa7ba3ab334c8072fc9fbfafc5db60eecd5' where name='glpi';" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Modification du mot de passe pour l utilisateur glpi" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi
	
	# Modification de la langue par defaut
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Modification de la langue par defaut" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT $V_DB_MYSQL -e "update glpi_configs set value='fr_FR' where name='language';" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Modification de la langue par defaut" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi
	
	V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
fi

# Redemarrage apache2
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage apache2" | tee -a ${V_LOG};
service apache2 restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redemarrage apache2" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Suppression de l installeur
echo "[${V_NOW}][${V_APPLI}][INFO] : Suppression de l installeur" | tee -a ${V_LOG};
mv /var/www/glpi/install/install.php /var/www/glpi/install/install.php_old

if [ $? -ne 0 ] 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : mv /var/www/glpi/install/install.php /var/www/glpi/install/install.php_old" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation du fichier de configuration config_db.php
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du fichier de configuration config_db.php" | tee -a ${V_LOG};
echo -e "<?php
 class DB extends DBmysql {
 var \$dbhost = '$V_IP_MYSQL';
 var \$dbuser = '$V_USER_MYSQL';
 var \$dbpassword = '$V_MDP_MYSQL';
 var \$dbdefault = '$V_DB_MYSQL';
 }
?>" > /var/www/glpi/config/config_db.php

if [ $? -ne 0 ] 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation du fichier de configuration config_db.php" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Modification droits du fichier config_db.php
echo "[${V_NOW}][${V_APPLI}][INFO] : Changement des droits du repertoire /var/www/glpi" | tee -a ${V_LOG};
chmod 644 /var/www/glpi/config/config_db.php

# Changement des droits du repertoire glpi
chown -R www-data:www-data /var/www/glpi

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chown -R www-data:www-data /var/www/glpi" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Test d acces 
echo "[${V_NOW}][${V_APPLI}][INFO] : Test d acces a la page d accueil" | tee -a ${V_LOG};
wget -P /tmp http://localhost/glpi > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://localhost/glpi" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Nettoyage du repertoire /tmp
echo "[${V_NOW}][${V_APPLI}][INFO] : Nettoyage du repertoire /tmp" | tee -a ${V_LOG};
rm -Rf /tmp/latest-version*
rm -Rf /tmp/glpi*
rm -Rf /tmp/fusioninventory-for-glpi*.gz

# Versions composants
version_linux=$(lsb_release -idrc | grep Description | awk -F ":" '{ $1 = "" ; print $0 }';)
version_apache=$(apache2 -v | grep version | awk -F ":" '{ $1 = "" ; print $0 }';)
version_php=$(php5 -v | grep PHP | grep -v Copyright;)

if [ $PACK = "Gold" ] 
then 
	version_mysql="Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64) using readline 6.2";
else
	version_mysql=$(mysql -V  | awk -F " " '{ $1 = "" ; print $0 }';)
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################### Versions des composants : ###############################

- Linux  : $version_linux
- Apache :    $version_apache
- MySQL  :     $version_mysql
- PHP    :      $version_php

################################# Informations MySQL : ##################################

- Serveur MySQL      : $V_IP_MYSQL
- Base MySQL         : $V_DB_MYSQL
- Utilisateur MySQL  : $V_USER_MYSQL
- Mot de passe MySQL : $V_MDP_MYSQL

############################## Informations de connexion : ##############################

- Interface graphique : http://ip_serveur/glpi
- Identifiant         : glpi
- Mot de passe        : $V_MDP_MYSQL
  
" | tee -a ${V_LOG};

}

# Fonction Installation Proftpd
install_proftpd(){

# Variables
V_APPLI=$V_APPLI_PROFTPD			# Nom de l application
V_USER=$V_USER_PROFTPD				# Nom de l utilisateur ftp
V_MDP=$V_MDP_PROFTPD				# Mot de passe de l utilisateur ftp

# Cryptage du mot de passe de l utilisateur ftpuser
echo "[${V_NOW}][${V_APPLI}][INFO] : Cryptage du mot de passe de l utilisateur $V_USER" | tee -a ${V_LOG};
V_MDP_CRYPTE=$(mkpasswd $V_MDP)

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : mkpasswd $V_MDP" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation de l utilisateur ftpuser
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation de l utilisateur $V_USER" | tee -a ${V_LOG};
useradd -G root,www-data -d /var/www/ -p $V_MDP_CRYPTE $V_USER

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : useradd -G root,www-data -d /var/www/ -p $V_MDP_CRYPTE $V_USER" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Modification des droits du repertoire /var/www/
echo "[${V_NOW}][${V_APPLI}][INFO] : Modification des droits du repertoire /var/www/" | tee -a ${V_LOG};
chmod -R 775 /var/www/

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chmod -R 775 /var/www/" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Mise a jour systeme et installation de proftpd
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation de proftpd" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y proftpd > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update -qq && apt-get -y install proftpd" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Modification du repertoire racine proftpd
echo "[${V_NOW}][${V_APPLI}][INFO] : Modification du repertoire racine proftpd" | tee -a ${V_LOG};
sed -i -e "s/Debian/Serveur FTP/g" /etc/proftpd/proftpd.conf
sed -i -e "s/# DefaultRoot/DefaultRoot/g" /etc/proftpd/proftpd.conf

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Modification du repertoire racine proftpd" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Autorisation pour l utilisateur ftpuser a acceder au repertoire racine proftpd
echo "[${V_NOW}][${V_APPLI}][INFO] : Autorisation pour l utilisateur a acceder au repertoire racine proftpd" | tee -a ${V_LOG};
echo -e "<Limit LOGIN>
AllowUser $V_USER
DenyAll
</Limit>" >> /etc/proftpd/proftpd.conf

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Autorisation pour l utilisateur a acceder au repertoire racine proftpd" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Redemarrage du service proftpd
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage du service proftpd" | tee -a ${V_LOG};
service proftpd restart > /dev/null 2>&1
if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : service proftpd restart" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################## Informations de connexion : ##############################

- Identifiant         : $V_USER
- Mot de passe        : $V_MDP
  
" | tee -a ${V_LOG};

}

# Fonction Installation OpenVPN
install_openvpn() {

# Variables
V_APPLI=$V_APPLI_OPENVPN			# Nom de l application
ip_publique_openvpn=$V_IP_PUBLIQUE  # Adresse IP publique du serveur OpenVPN
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y openvpn zip git > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y openvpn zip git" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Copie des fichiers de configuration
echo "[${V_NOW}][${V_APPLI}][INFO] : Copie des fichiers de configuration" | tee -a ${V_LOG};
mkdir -p /etc/openvpn/easy-rsa/
git clone https://github.com/OpenVPN/easy-rsa.git /etc/openvpn/easy-rsa/ > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Copie des fichiers de configuration" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

chown -R $USER /etc/openvpn/easy-rsa/

# Modification du fichier /etc/openvpn/easy-rsa/easyrsa3/vars
echo "[${V_NOW}][${V_APPLI}][INFO] : Modification du fichier /etc/openvpn/easy-rsa/easyrsa3/vars" | tee -a ${V_LOG};
cp /etc/openvpn/easy-rsa/easyrsa3/vars.example /etc/openvpn/easy-rsa/easyrsa3/vars
sed -i -e 's/#set_var EASYRSA_REQ_COUNTRY/set_var EASYRSA_REQ_COUNTRY/g' /etc/openvpn/easy-rsa/easyrsa3/vars
sed -i -e 's/#set_var EASYRSA_REQ_PROVINCE/set_var EASYRSA_REQ_PROVINCE/g' /etc/openvpn/easy-rsa/easyrsa3/vars
sed -i -e 's/#set_var EASYRSA_REQ_CITY/set_var EASYRSA_REQ_CITY/g' /etc/openvpn/easy-rsa/easyrsa3/vars
sed -i -e 's/#set_var EASYRSA_REQ_ORG/set_var EASYRSA_REQ_ORG/g' /etc/openvpn/easy-rsa/easyrsa3/vars
sed -i -e 's/#set_var EASYRSA_REQ_EMAIL/set_var EASYRSA_REQ_EMAIL/g' /etc/openvpn/easy-rsa/easyrsa3/vars
sed -i -e 's/#set_var EASYRSA_REQ_OU/set_var EASYRSA_REQ_OU/g' /etc/openvpn/easy-rsa/easyrsa3/vars

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Modification du fichier /etc/openvpn/easy-rsa/easyrsa3/vars" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Generation des cles et certificats serveur
echo "[${V_NOW}][${V_APPLI}][INFO] : Generation des cles et certificats serveur et client" | tee -a ${V_LOG};
cd /etc/openvpn/easy-rsa/easyrsa3/
./easyrsa init-pki > /dev/null 2>&1
./easyrsa --batch build-ca nopass > /dev/null 2>&1
./easyrsa build-server-full server nopass > /dev/null 2>&1
./easyrsa build-client-full client nopass > /dev/null 2>&1
./easyrsa gen-dh > /dev/null 2>&1
./easyrsa gen-crl > /dev/null 2>&1
cd - > /dev/null 2>&1
openvpn --genkey --secret /etc/openvpn/ta.key > /dev/null 2>&1

# Verification de la presence des certificats
if [ ! -e /etc/openvpn/easy-rsa/easyrsa3/pki/ca.crt ]; 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fichier ca.crt non present" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
if [ ! -e /etc/openvpn/easy-rsa/easyrsa3/pki/private/server.key ]; 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fichier server.key non present" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
if [ ! -e /etc/openvpn/easy-rsa/easyrsa3/pki/issued/server.crt ]; 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fichier server.crt non present" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
if [ ! -e /etc/openvpn/easy-rsa/easyrsa3/pki/dh.pem ]; 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fichier dh.pem non present" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
if [ ! -e /etc/openvpn/easy-rsa/easyrsa3/pki/crl.pem ]; 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fichier crl.pem non present" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
if [ ! -e /etc/openvpn/easy-rsa/easyrsa3/pki/issued/client.crt ]; 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fichier client.crt non present" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
if [ ! -e /etc/openvpn/easy-rsa/easyrsa3/pki/private/client.key ]; 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fichier client.key non present" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
if [ ! -e /etc/openvpn/ta.key ]; 
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fichier ta.key non present" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Copie des cles et certificats serveur dans /etc/openvpn/
echo "[${V_NOW}][${V_APPLI}][INFO] : Copie des cles et certificats serveur dans /etc/openvpn/" | tee -a ${V_LOG};
mv /etc/openvpn/easy-rsa/easyrsa3/pki/ca.crt /etc/openvpn/easy-rsa/easyrsa3/pki/private/server.key /etc/openvpn/easy-rsa/easyrsa3/pki/issued/server.crt /etc/openvpn/easy-rsa/easyrsa3/pki/dh.pem /etc/openvpn/easy-rsa/easyrsa3/pki/crl.pem /etc/openvpn/
if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Copie des cles et certificats serveur dans /etc/openvpn/" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Copie des cles et certificats client dans /etc/openvpn/
echo "[${V_NOW}][${V_APPLI}][INFO] : Copie des cles et certificats client dans /etc/openvpn/client" | tee -a ${V_LOG};
mkdir -p /etc/openvpn/client
cp /etc/openvpn/ca.crt /etc/openvpn/ta.key /etc/openvpn/client
mv /etc/openvpn/easy-rsa/easyrsa3/pki/issued/client.crt /etc/openvpn/easy-rsa/easyrsa3/pki/private/client.key /etc/openvpn/client

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Copie des cles et certificats client dans /etc/openvpn/client" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation du fichier de configuration /etc/openvpn/server.conf
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du fichier de configuration /etc/openvpn/server.conf" | tee -a ${V_LOG};
echo -e "# Serveur TCP/443
mode server
proto tcp
port 443
dev tun
# Cles et certificats
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh.pem
tls-auth ta.key 1
key-direction 0
cipher AES-256-CBC
# Reseau
server 10.8.0.0 255.255.255.0
# Rediriger tout le trafic
push 'redirect-gateway def1 bypass-dhcp'
push 'dhcp-option DNS 208.67.222.222'
push 'dhcp-option DNS 208.67.220.220'
# Rediriger le trafic uniquement vers un sous-reseau
# push 'route 213.56.106.0 255.255.255.0'
keepalive 10 120
# Securite
user nobody
group nogroup
persist-key
persist-tun
comp-lzo
# Log
verb 3
mute 20
status openvpn-status.log
log-append /var/log/openvpn.log
# Autoriser plusieurs clients avec le meme certificat
duplicate-cn" > /etc/openvpn/server.conf

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation du fichier de configuration /etc/openvpn/server.conf" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation du fichier de configuration /etc/openvpn/client/client.conf
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du fichier de configuration client.conf" | tee -a ${V_LOG};
echo -e "# Client
client
dev tun
proto tcp-client
remote $ip_publique_openvpn 443
resolv-retry infinite
cipher AES-256-CBC
; client-config-dir ccd
# Cles
ca ca.crt
cert client.crt
key client.key
tls-auth ta.key 1
key-direction 1
# Securite
nobind
persist-key
persist-tun
comp-lzo
verb 3
route-method exe
route-delay 2" > /etc/openvpn/client/client.conf

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation du fichier de configuration client.conf" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation du fichier de configuration client.ovpn
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du fichier de configuration client.ovpn" | tee -a ${V_LOG};
cp /etc/openvpn/client/client.conf /etc/openvpn/client/client.ovpn

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : cp client.conf client.ovpn" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation de l archive client.zip
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation de l archive client.zip" | tee -a ${V_LOG};
zip -j /etc/openvpn/client.zip  /etc/openvpn/client/* > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Creation de l archive client.zip" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Demarrage du service openvpn
echo "[${V_NOW}][${V_APPLI}][INFO] : Demarrage du service openvpn" | tee -a ${V_LOG};
systemctl start openvpn@server.service

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : /etc/init.d/openvpn start" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Activation du forwarding IP
echo "[${V_NOW}][${V_APPLI}][INFO] : Activation du forwarding IP" | tee -a ${V_LOG};
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i -e 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Activation du forwarding IP" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Ajout de regles iptables
echo "[${V_NOW}][${V_APPLI}][INFO] : Ajout de regles iptables" | tee -a ${V_LOG};
# règles obligatoires pour ouvrir déverrouiller l’accès 
iptables -I FORWARD -i tun0 -j ACCEPT
iptables -I FORWARD -o tun0 -j ACCEPT
iptables -I OUTPUT -o tun0 -j ACCEPT
# autres règles : Translation d'adresses
iptables -A FORWARD -i tun0 -o eth1 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth1 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.2/24 -o eth1 -j MASQUERADE
sh -c "iptables-save > /etc/iptables.rules"
echo "pre-up iptables-restore < /etc/iptables.rules" >> /etc/network/interfaces

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Ajout de regles iptables" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################## Actions poste client : ##############################

- Telecharger le client VPN : http://openvpn.net/index.php/open-source/downloads.html
- Recuperer l archive /etc/openvpn/client.zip
- Copier le contenu de l archive sous C:\Programs Files\Openvpn\conf\
- Lancer le client OpenVPN en tant qu administrateur

" | tee -a ${V_LOG};
}

# Fonction Installation Ocs
install_ocs(){

# Variables
V_APPLI=$V_APPLI_OCS				# Nom de l application
V_DB_MYSQL=$V_DB_MYSQL_OCS			# Nom de la base de donnees MySQL
V_USER_MYSQL=$V_USER_MYSQL_OCS		# Nom de l utilisateur MySQL
V_MDP_MYSQL=$V_MDP_MYSQL_OCS		# Mot de passe de l utilisateur MySQL

# SI Gold 
if [ $PACK != "Gold" ]
then
	packages="apache2 php5 libapache2-mod-php5 php5-imap php5-ldap php5-curl mysql-server-5.5 php5-mysql libapache2-mod-php5 libapache2-mod-perl2 libxml-simple-perl libio-compress-perl libdbi-perl libdbd-mysql-perl libnet-ip-perl libphp-pclzip make libapache-dbi-perl nmap snmp libsoap-lite-perl php5-gd"
else
	packages="apache2 php5 libapache2-mod-php5 php5-imap php5-ldap php5-curl php5-mysql libapache2-mod-php5 libapache2-mod-perl2 libxml-simple-perl libio-compress-perl libdbi-perl libdbd-mysql-perl libnet-ip-perl libphp-pclzip make libapache-dbi-perl nmap snmp libsoap-lite-perl php5-gd"
fi

V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
echo -e "\n=================================== Installation OCS ====================================\n" | tee -a ${V_LOG};

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y $packages > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y $packages" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Mise a jour CPAN et installation des modules PERL non packages
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour CPAN et installation des modules PERL non packages" | tee -a ${V_LOG};   
perl -MCPAN -e 'install XML::Entities' <<< "yes" > /dev/null 2>&1
perl -MCPAN -e 'install SOAP::Lite' > /dev/null 2>&1
perl -MCPAN -e 'Apache2::SOAP' > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Mise a jour CPAN et installation des modules PERL non packages" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Recuperation et decompression de l installation OCS
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression de l archive OCS" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz > /dev/null 2>&1
tar -vxf /tmp/latest-version.tar.gz -C /var/www > /dev/null 2>&1
mv /var/www/OCS* /var/www/ocs

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz && tar -vxf /tmp/latest-version.tar.gz -C /var/www" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

if [ $PACK != "Gold" ]
then
	# MySQL : Creation de la base, du user, modifier proprietaire de la base et lui affecter tous les privileges
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "CREATE DATABASE IF NOT EXISTS $V_DB_MYSQL;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "GRANT ALL PRIVILEGES ON $V_DB_MYSQL.* TO $V_USER_MYSQL@localhost IDENTIFIED BY '$V_MDP_MYSQL';" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Creation de l utilisateur $V_USER_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Affectation de tous les privileges pour l utilisateur $V_USER_MYSQL sur la base $V_DB_MYSQL" | tee -a ${V_LOG}; 
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi

	echo "[${V_NOW}][${V_APPLI}][INFO] : MySQL : Modification des privileges" | tee -a ${V_LOG};
	mysql -u root -p$V_MDP_MYSQL_ROOT -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
	if [ $? -ne 0 ] 
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL : Modification des privileges" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};	
		exit 99;
	fi

	V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
fi

# Lancement de l installation OCS (KO si lancement de l install en chemin absolu)
echo "[${V_NOW}][${V_APPLI}][INFO] : Lancement de l installation OCS" | tee -a ${V_LOG};
cd /var/www/ocs/
./setup.sh <<< "y" > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Lancement de l installation OCS";
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin";
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Modification de la langue
echo "[${V_NOW}][${V_APPLI}][INFO] : Modification de la langue" | tee -a ${V_LOG};
sed -i -e "s/english/french/g" /var/www/ocs/ocsreports/var.php

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Modification de la langue";
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin";
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Suppression du repertoire d installation
# echo "[${V_NOW}][${V_APPLI}][INFO] : Suppression du repertoire d installation" | tee -a ${V_LOG};
# rm /var/www/ocs/ocsreports/install.php

# if [ $? -ne 0 ]
# then
# 	echo "[${V_NOW}][${V_APPLI}][ERREUR] : rm /var/www/ocs/ocsreports/install.php" | tee -a ${V_LOG};
# 	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
# 	exit 99;
# fi
# V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Modification des parametres de connexions a la base de donnees
echo "[${V_NOW}][${V_APPLI}][INFO] : Modification des parametres de connexions a la base de donnees" | tee -a ${V_LOG};
sed -i "s/PerlSetEnv OCS_DB_HOST localhost/PerlSetEnv OCS_DB_HOST $V_IP_MYSQL/g" /etc/apache2/conf.d/z-ocsinventory-server.conf
sed -i "s/PerlSetEnv OCS_DB_NAME ocsweb/PerlSetEnv OCS_DB_NAME $V_DB_MYSQL/g" /etc/apache2/conf.d/z-ocsinventory-server.conf
sed -i "s/PerlSetEnv OCS_DB_LOCAL ocsweb/PerlSetEnv OCS_DB_LOCAL $V_DB_MYSQL/g" /etc/apache2/conf.d/z-ocsinventory-server.conf
sed -i "s/PerlSetEnv OCS_DB_USER ocs/PerlSetEnv OCS_DB_USER $V_USER_MYSQL/g" /etc/apache2/conf.d/z-ocsinventory-server.conf
sed -i "s/PerlSetVar OCS_DB_PWD ocs/PerlSetVar OCS_DB_PWD $V_MDP_MYSQL/g" /etc/apache2/conf.d/z-ocsinventory-server.conf

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Modification des parametres de connexions a la base de donnees" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Changement des droits du repertoire ocs
echo "[${V_NOW}][${V_APPLI}][INFO] : Changement des droits du repertoire /var/www/ocs" | tee -a ${V_LOG};
cd -
chown -R www-data:www-data /var/www/ocs
chmod 775 -R /var/www/ocs

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chown -R www-data:www-data /var/www/ocs" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chmod 777 -R /var/www/ocs" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Redemarrage apache2
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage apache2" | tee -a ${V_LOG};
service apache2 restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redemarrage apache2" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Redemarrage mysql
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage mysql" | tee -a ${V_LOG};
service mysql restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Redemarrage mysql" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Test d acces 
echo "[${V_NOW}][${V_APPLI}][INFO] : Test d acces a la page d accueil" | tee -a ${V_LOG};
wget -P /tmp http://localhost/ocs > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://localhost/ocs/ocsreports" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Nettoyage du repertoire /tmp
echo "[${V_NOW}][${V_APPLI}][INFO] : Nettoyage du repertoire /tmp" | tee -a ${V_LOG};
rm -Rf /tmp/ocsreports
rm -Rf /tmp/latest-version*

# Versions composants
version_linux=$(lsb_release -idrc | grep Description | awk -F ":" '{ $1 = "" ; print $0 }';)
version_apache=$(apache2 -v | grep version | awk -F ":" '{ $1 = "" ; print $0 }';)
version_php=$(php5 -v | grep PHP | grep -v Copyright;)

if [ $PACK = "Gold" ] 
then 
	version_mysql="Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64) using readline 6.2";
else
	version_mysql=$(mysql -V  | awk -F " " '{ $1 = "" ; print $0 }';)
fi

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################### Versions des composants : ###############################

- Linux  : $version_linux
- Apache :    $version_apache
- MySQL  :     $version_mysql
- PHP    :      $version_php

################################# Informations MySQL : ##################################

- Serveur MySQL      : $V_IP_MYSQL
- Base MySQL         : $V_DB_MYSQL
- Utilisateur MySQL  : $V_USER_MYSQL
- Mot de passe MySQL : $V_MDP_MYSQL

############################## Informations de connexion : ##############################

- Merci de vous connecter a l interface graphique : http://ip_serveur/ocs/ocsreports
- Identifiant : admin
- Mot de passe : admin
  
" | tee -a ${V_LOG};

}

# Fonction Installation Webmin
install_webmin(){

# Variables
V_APPLI=$V_APPLI_WEBMIN			# Nom de l application
V_PORT_WEBMIN=10735				# Port Webmin

V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
echo -e "\n=================================== Installation Webmin =================================\n" | tee -a ${V_LOG};

# Mise a jour systeme et installation des packages necessaires
echo "[${V_NOW}][${V_APPLI}][INFO] : Mise a jour systeme et installation des packages necessaires" | tee -a ${V_LOG};
apt-get update -qq && apt-get install -y libnet-ssleay-perl libauthen-pam-perl libio-pty-perl apt-show-versions libapt-pkg-perl > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : apt-get update && apt-get install -y libnet-ssleay-perl libauthen-pam-perl libio-pty-perl apt-show-versions libapt-pkg-perl" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Recuperation et installation Webmin
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et installation de Webmin" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.deb > /dev/null 2>&1
dpkg --install /tmp/latest-version.deb > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.deb && dpkg --install /tmp/latest-version.deb" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Modification du port Webmin
echo "[${V_NOW}][${V_APPLI}][INFO] : Modification du port Webmin" | tee -a ${V_LOG};
sed -i -e "s/port=10000/port=10735/g" /etc/webmin/miniserv.conf

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : sed -i -e 's/port=10000/port=10735/g' /etc/webmin/miniserv.conf" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Redemarrage du service Webmin
echo "[${V_NOW}][${V_APPLI}][INFO] : Redemarrage du service Webmin" | tee -a ${V_LOG};
/etc/init.d/webmin restart > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : /etc/init.d/webmin restart" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Test d acces 
echo "[${V_NOW}][${V_APPLI}][INFO] : Test d acces a la page d accueil" | tee -a ${V_LOG};
wget -P /tmp http://localhost:$V_PORT_WEBMIN > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://localhost/$V_PORT_WEBMIN" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Nettoyage du repertoire /tmp
echo "[${V_NOW}][${V_APPLI}][INFO] : Nettoyage du repertoire /tmp" | tee -a ${V_LOG};
rm -Rf /tmp/index*
rm -Rf /tmp/latest-version*

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################## Informations de connexion : ##############################

- Merci de vous connecter a l interface graphique : https://ip_serveur:$V_PORT_WEBMIN
- Identifiant : root
- Mot de passe : mot de passe root du serveur

" | tee -a ${V_LOG};

}

# Fonction Installation PhpMyAdmin
install_phpmyadmin(){

# Variables
V_APPLI=$V_APPLI_PHPMYADMIN				# Nom de l application

V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
echo -e "\n=================================== Installation PhpMyAdmin ==================================\n" | tee -a ${V_LOG};

# Verification que mysql est installe pour installer phpmyadmin
if [ $PACK != "Gold" ]
then
	mysql -V > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : MySQL n est pas installe sur ce serveur" | tee -a ${V_LOG};
		exit 99;
	fi	
fi

# Recuperation et decompression de l installation PhpMyAdmin
echo "[${V_NOW}][${V_APPLI}][INFO] : Telechargement et decompression de l archive phpmyadmin" | tee -a ${V_LOG};
wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz > /dev/null 2>&1
tar -xzvf /tmp/latest-version.tar.gz -C /var/www/ > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://$V_REPO/$V_APPLI/latest-version.tar.gz && tar -xzvf /tmp/latest-version.tar.gz -C /var/www/" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Creation du fichier de configuration config.inc.php 
echo "[${V_NOW}][${V_APPLI}][INFO] : Creation du fichier de configuration config.inc.php" | tee -a ${V_LOG};
mv /var/www/phpMyAdmin* /var/www/fce_phpmyadmin
cp /var/www/fce_phpmyadmin/config.sample.inc.php /var/www/fce_phpmyadmin/config.inc.php

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : cp /var/www/fce_phpmyadmin/config.sample.inc.php /var/www/fce_phpmyadmin/config.inc.php" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Configuration PhpMyAdmin avec base de donnees distante
if [ $PACK = "Gold" ]
then
	echo "[${V_NOW}][${V_APPLI}][INFO] : Configuration PhpMyAdmin avec base de donnees distante" | tee -a ${V_LOG};
	sed -i -e "s/\['host'\] = 'localhost'/\['host'\] = '$V_IP_MYSQL'/g" /var/www/fce_phpmyadmin/config.inc.php
	
	if [ $? -ne 0 ]
	then
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Modification du fichier /var/www/fce_phpmyadmin/config.inc.php" | tee -a ${V_LOG};
		echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
		exit 99;
	fi
	V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
fi

# Configuration du mode d'authentification
echo "[${V_NOW}][${V_APPLI}][INFO] : Configuration du mode d'authentification" | tee -a ${V_LOG};
sed -i -e "s/\['blowfish_secret'\] = ''/\['blowfish_secret'\] = 'Ma phrase de passe PhpMyAdmin'/g" /var/www/fce_phpmyadmin/config.inc.php
	
if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Modification du fichier /var/www/fce_phpmyadmin/config.inc.php" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Changement des droits du repertoire phpmyadmin
echo "[${V_NOW}][${V_APPLI}][INFO] : Changement des droits du repertoire /var/www/fce_phpmyadmin" | tee -a ${V_LOG};
chown -R www-data:www-data /var/www/fce_phpmyadmin/

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : chown -R www-data:www-data /var/www/fce_phpmyadmin" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Suppression du repertoire d installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Suppression du repertoire d installation" | tee -a ${V_LOG};
rm -Rf /var/www/fce_phpmyadmin/setup/

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : rm -Rf /var/www/fce_phpmyadmin/setup/" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Test d acces 
echo "[${V_NOW}][${V_APPLI}][INFO] : Test d acces a la page d accueil" | tee -a ${V_LOG};
wget -P /tmp http://localhost/fce_phpmyadmin > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : wget -P /tmp http://localhost/fce_phpmyadmin" | tee -a ${V_LOG};
	echo "[${V_NOW}][${V_APPLI}][ERREUR] : Fin" | tee -a ${V_LOG};
	exit 99;
fi
V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;

# Nettoyage du repertoire /tmp
echo "[${V_NOW}][${V_APPLI}][INFO] : Nettoyage du repertoire /tmp" | tee -a ${V_LOG};
rm -Rf /tmp/phpmyadmin
rm -Rf /tmp/latest-version*

# Fin Installation
echo "[${V_NOW}][${V_APPLI}][INFO] : Installation terminee avec succes. 

############################## Informations de connexion : ##############################

- Merci de vous connecter a l interface graphique : http://ip_serveur/fce_phpmyadmin 
- Identifiant : root
- Mot de passe : $V_MDP_MYSQL_ROOT
  
" | tee -a ${V_LOG};

}

# Fonction affichage du menu
show_menu() {

echo -e "\n======================================== MENU ===========================================";
echo -e "${C_CHOIX[1]}""1)  LAMP""$C_NOIR";
echo -e "${C_CHOIX[2]}""2)  Owncloud""$C_NOIR";
echo -e "${C_CHOIX[3]}""3)  Piwik""$C_NOIR";
echo -e "${C_CHOIX[4]}""4)  Joomla""$C_NOIR";
echo -e "${C_CHOIX[5]}""5)  Wordpress""$C_NOIR";
echo -e "${C_CHOIX[6]}""6)  Roundcube""$C_NOIR";
echo -e "${C_CHOIX[7]}""7)  Nginx""$C_NOIR";
echo -e "${C_CHOIX[8]}""8)  OsTicket""$C_NOIR";
echo -e "${C_CHOIX[9]}""9)  Glpi""$C_NOIR";
echo -e "${C_CHOIX[10]}""10) Proftpd""$C_NOIR";
echo -e "${C_CHOIX[11]}""11) OpenVPN""$C_NOIR";
echo -e "${C_CHOIX[12]}""12) Ocs""$C_NOIR";
echo -e "${C_CHOIX[13]}""13) Webmin""$C_NOIR";
echo -e "${C_CHOIX[14]}""14) PhpMyAdmin""$C_NOIR";
echo -e "$C_VERT""i) Installation des applications selectionnees";
echo -e "$C_ROUGE""q) Quitter sans installer";
echo -e "$C_ROUGE""e) Effacer le script et ses logs""$C_NOIR";

read choix
}

#========================== Main ======================

# Nettoyage du screen
clear

# Initialisation tableau des reponses
TAB_ID_REP="";
TAB_NOM_REP="";
i=0;

echo -e "\n================================= Demarrage du script ===================================" | tee -a ${V_LOG};

# Verification que l adresse IP Trafic est configuree sur eth1 
echo $V_IP_TRAFIC | grep 213.56 > /dev/null 2>&1
if [ $? -ne 0 ]
then
	echo "[ERREUR] : L interface reseau eth1 n est pas configuree avec une adresse IP Trafic de type 213.56.x.x" | tee -a ${V_LOG}=
	exit 99;
fi

# Prompt
PS3=$(echo -e "\n>>> Choix : ")	  
			  
# Installation SI Gold ?

read -p "Voulez-vous installer un SI Gold [o/$V_DEF_N] ? : " confirmation
confirmation="${confirmation:-${V_DEF_N}}"

case "$confirmation" in
	o|O)	
	
	echo "[${V_NOW}][INFO] : Voulez-vous installer un SI Gold [o/$V_DEF_N] ? : o" >> ${V_LOG};
	
	# Definition variable Pack
	PACK="Gold"
	
	# IP trafic du serveur de base de donnees
	if [ -z "${V_IP_TRAFIC_BDD}" ]; then
	  tmp="213.56.x.x"
	  read -p "Adresse IP trafic du serveur de base de donnees [${tmp}]: " V_IP_TRAFIC_BDD
	  V_IP_TRAFIC_BDD="${V_IP_TRAFIC_BDD:-${tmp}}"
	  unset tmp
	fi
	
	# Verification validite @IP
	if [[ ! $V_IP_TRAFIC_BDD =~ ^213\.56\.[0-9]{1,3}\.[0-9]{1,3}$ ]];
	then
		V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
		echo "[${V_NOW}][ERREUR] : Adresse IP trafic du serveur de base de donnees non valide" | tee -a ${V_LOG};
		exit 99;
	fi	
	
	# Changement de l adresse IP serveur MySQL
	V_IP_MYSQL=$V_IP_TRAFIC_BDD;
	
	;;

	n|N)
	
	echo "[${V_NOW}][INFO] : Voulez-vous installer un SI Gold [$V_DEF_O/n] ? : N" >> ${V_LOG};
	
	# Definition variable Pack
	PACK="NonGold"
	;;
esac

clear
show_menu

while [ choix != '' ]
    do
	case $choix in

    1) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;
	   
    2) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;

    3) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;

    4) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;

    5) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;

    6) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;

    7) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;

    8) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;

    9) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;

    10) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;

	11) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;
	
	12) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;

	13) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;
	
	14) TAB_ID_REP[$i]=$choix
    i=$((i+1));
	C_CHOIX[choix]=$C_BLEU
    clear
	show_menu
	;;
	
    i|I) if [[ ${TAB_ID_REP[*]} == "" ]]
	then 
		echo "Merci de selectionner au moins une application.";
		sleep 2
		clear
		show_menu
	else break;
	fi;;
	
	q|Q) exit 0;;
	
    e|E) read -p "Confirmez-vous la suppression du script, des logs et de l historique [$V_DEF_O/n] ? : " confirmation
		confirmation="${confirmation:-${V_DEF_O}}"
		case "$confirmation" in
			o|O)
			
			# Suppression du script, des logs et de l historique
			rm -Rf $V_SCR 
			rm -Rf "$V_SCR"_*
			history -c
			cat /dev/null > ~/.bash_history
			exit 0
			;;
	   
			n|N)
			clear
			show_menu
			;;
	esac
	;;
	   
    *) echo "Choix invalide.";
	sleep 2
	clear
	show_menu
	;;
esac
done

# Confirmation choix
echo -e "\nLes applications selectionnees en "$C_BLEU"bleu"$C_NOIR" vont etre installees.";
read -p "Confirmez-vous l installation [$V_DEF_O/n] ? : " confirmation
confirmation="${confirmation:-${V_DEF_O}}"

case "$confirmation" in
	o|O)
	
	for index in "${!TAB_ID_REP[@]}";            					
	do

		# Owncloud : Demande des parametres specifiques 
		if [[ ${TAB_ID_REP[$index]} -eq 2 ]]
		then
			# Adresse IP publique
			if [ -z "${V_IP_PUBLIQUE}" ]; then
			  read -p "Installation Owncloud : Adresse IP publique : " V_IP_PUBLIQUE
			fi
			
			# Verification validite @IP
			if [[ ! $V_IP_PUBLIQUE = "" ]];
			then
				if [[ ! $V_IP_PUBLIQUE =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];
				then
					V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
					echo "[${V_NOW}][Owncloud][ERREUR] : Adresse IP publique non valide" | tee -a ${V_LOG};
					exit 99;
				fi
			fi
		fi
		
		# Roundcube : Demande des parametres specifiques
		if [ ${TAB_ID_REP[$index]} -eq 6 ]
		then
			# Nom du Webmail
			if [ -z "${roundcubeproductname}" ]; then
			  tmp="Roundcube Webmail"
			  read -p "Installation Roundcube : Nom du Webmail [${tmp}]: " roundcubeproductname
			  roundcubeproductname="${roundcubeproductname:-${tmp}}"
			  unset tmp
			fi

			# Language
			if [ -z "${roundcubelanguage}" ]; then
			  tmp="fr_FR"
			  read -p "Installation Roundcube : Language [${tmp}]: " roundcubelanguage
			  roundcubelanguage="${roundcubelanguage:-${tmp}}"
			  unset tmp
			fi

			# Domaine
			if [ -z "${domain}" ]; then
			  tmp="yourdomain.com"
			  read -p "Installation Roundcube : Domaine [${tmp}]: " domain
			  domain="${domain:-${tmp}}"
			  unset tmp
			fi

			# Serveur IMAP
			if [ -z "${imapserver}" ]; then
			  tmp="ssl://imapserver.domain.com"
			  read -p "Installation Roundcube : Serveur IMAP [${tmp}]: " imapserver
			  imapserver="${imapserver:-${tmp}}"
			  unset tmp
			fi

			# Port IMAP
			if [ -z "${imapport}" ]; then
			  tmp="993"
			  read -p "Installation Roundcube : Port IMAP [${tmp}]: " imapport
			  imapport="${imapport:-${tmp}}"
			  unset tmp
			fi

			# Serveur SMTP
			if [ -z "${smtpserver}" ]; then
			  tmp="ssl://smtpserver.domain.com"
			  read -p "Installation Roundcube : Serveur SMTP [${tmp}]: " smtpserver
			  smtpserver="${smtpserver:-${tmp}}"
			  unset tmp
			fi

			# Port SMTP
			if [ -z "${smtpport}" ]; then
			  tmp="465"
			  read -p "Installation Roundcube : Port SMTP [${tmp}]: " smtpport
			  smtpport="${smtpport:-${tmp}}"
			  unset tmp
			fi
		fi	
		
		# Nginx : Demande des parametres specifiques 
		if [[ ${TAB_ID_REP[$index]} -eq 7 ]]
		then
			# Adresse IP Serveur Web
			if [ -z "${V_IP_PROXY}" ]; then
			  read -p "Installation Nginx : Adresse IP Serveur Web : " V_IP_PROXY
			fi
			
			# Verification validite @IP
			if [[ ! $V_IP_PROXY = "" ]];
			then
				if [[ ! $V_IP_PROXY =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];
				then
					V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
					echo "[${V_NOW}][Nginx][ERREUR] : Adresse IP non valide" | tee -a ${V_LOG};
					exit 99;
				fi
			fi
		fi
		
		# OpenVpn : Demande des parametres specifiques 
		if [[ ${TAB_ID_REP[$index]} -eq 11 ]]
		then
			# Adresse IP publique
			if [ -z "${V_IP_PUBLIQUE}" ]; then
			  read -p "Installation OpenVPN : Adresse IP publique : " V_IP_PUBLIQUE
			fi
			
			# Verification validite @IP
			if [[ ! $V_IP_PUBLIQUE = "" ]];
			then
				if [[ ! $V_IP_PUBLIQUE =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];
				then
					V_NOW=`date +"%d/%m/%Y-%H:%M:%S"`;
					echo "[${V_NOW}][OpenVPN][ERREUR] : Adresse IP publique non valide" | tee -a ${V_LOG};
					exit 99;
				fi
			fi
		fi
		
	done
	
	# Appel fonctions installation
	for index in "${!TAB_ID_REP[@]}";            					
	do
		
		if [ ${TAB_ID_REP[$index]} -eq 1 ]
		then install_lamp; fi

		if [ ${TAB_ID_REP[$index]} -eq 2 ]
		then install_owncloud; fi
		
		if [ ${TAB_ID_REP[$index]} -eq 3 ]
		then install_piwik; fi
		
		if [ ${TAB_ID_REP[$index]} -eq 4 ]
		then install_joomla; fi

		if [ ${TAB_ID_REP[$index]} -eq 5 ]
		then install_wordpress; fi
		
		if [ ${TAB_ID_REP[$index]} -eq 6 ]
		then install_roundcube; fi

		if [ ${TAB_ID_REP[$index]} -eq 7 ]
		then install_nginx; fi
		
		if [ ${TAB_ID_REP[$index]} -eq 8 ]
		then install_osticket; fi
		
		if [ ${TAB_ID_REP[$index]} -eq 9 ]
		then install_glpi; fi
		
		if [ ${TAB_ID_REP[$index]} -eq 10 ]
		then install_proftpd; fi
		
		if [ ${TAB_ID_REP[$index]} -eq 11 ]
		then install_openvpn; fi
		
		if [ ${TAB_ID_REP[$index]} -eq 12 ]
		then install_ocs; fi

		if [ ${TAB_ID_REP[$index]} -eq 13 ]
		then install_webmin; fi
		
		if [ ${TAB_ID_REP[$index]} -eq 14 ]
		then install_phpmyadmin; fi
		
	done;
	;;
	
	n|N)
	exit 1
	;;
	
esac

# Fichier de log
echo -e "\n==================================== Fin du script ======================================\n" | tee -a ${V_LOG};
echo "Logs du script :  $V_LOG" | tee -a ${V_LOG};