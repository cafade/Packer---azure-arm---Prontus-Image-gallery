echo "******************************Actualizando repositorios"
apt-get update
# utilidades generales
echo "******************************Instalando utlidades de software"
apt-get -y install curl wget mc nano net-tools
# librerias de perl y otros
echo "******************************Instalando software requerido"
apt-get -y install libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libauthen-sasl-perl libcgi-fast-perl libcgi-pm-perl libcpanel-json-xs-perl libcrypt-eksblowfish-perl libcrypt-eksblowfish-perl libmojo-jwt-perl libdbd-mysql-perl libdbi-perl libdigest-sha-perl libdpkg-perl libemail-mime-perl libemail-sender-perl libemail-sender-perl libemail-simple-perl libencode-locale-perl liberror-perl libfcgi-perl libfile-fcntllock-perl libfile-libmagic-perl libfile-listing-perl libfont-afm-perl libhtml-form-perl libhtml-format-perl libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libimage-exiftool-perl libio-all-perl libio-html-perl libio-socket-ssl-perl libjson-perl liblocale-gettext-perl liblwp-mediatypes-perl liblwp-online-perl liblwp-protocol-https-perl libmailtools-perl libnet-amazon-s3-perl libnet-http-perl libnet-smtp-ssl-perl libnet-ssleay-perl libterm-readkey-perl libtext-charwidth-perl libtext-iconv-perl libtext-unidecode-perl libtext-wrapi18n-perl libtimedate-perl liburi-perl libwww-perl libwww-robotrules-perl perl-openssl-defaults libgd-perl libnet-dns-perl liblockfile-simple-perl ffmpeg libx264-dev

echo "******************************Instalando PHP 7.3"
apt-get -y install php7.3-cli php7.3-common php7.3-fpm php7.3-json #php7.3-opcache php7.3-readline php7.3-curl php7.3-xml php7.3-mysql php7.3-gd
apt-get -y install aspell aspell-en enchant hunspell-en-us libaspell15 libenchant1c2a libhunspell-1.7-0 php7.3-enchant

echo "******************************Instalando MariaDB"
apt-get -y install mariadb-server
echo "******************************Instalando Apache 2"
apt-get -y install apache2 libapache2-mod-perl2

echo "******************************Configurando Apache 2"
mkdir -p /var/www/prontus
mkdir -p /var/wlog/prontus

mv /etc/apache2/mods-available/mpm_event.conf /etc/apache2/mods-available/mpm_event.conf.bkp
cp config/apache/mods-available/mpm_event.conf /etc/apache2/mods-available/mpm_event.conf

ln -s ../mods-available/proxy.load  /etc/apache2/mods-enabled/proxy.load
ln -s ../mods-available/proxy.conf  /etc/apache2/mods-enabled/proxy.conf
ln -s ../mods-available/proxy_fcgi.load  /etc/apache2/mods-enabled/proxy_fcgi.load
ln -s ../mods-available/cgi.load  /etc/apache2/mods-enabled/cgi.load
ln -s ../mods-available/rewrite.load  /etc/apache2/mods-enabled/rewrite.load
ln -s ../mods-available/expires.load  /etc/apache2/mods-enabled/expires.load
mv /etc/apache2/sites-enabled /etc/apache2/sites-enabled.bkp
cp -R config/apache/sites-enabled /etc/apache2
cp -R config/apache/global /etc/apache2

echo "******************************Copiando Prontus a /var/www/prontus"
cp -R web /var/www/prontus
chown -R www-data:www-data /var/www/prontus/

echo "******************************Reiniciando Apache 2"
systemctl restart apache2

echo "******************************Creando base de datos y usuario para Prontus"
# creacion base de datos y usuario
# se generan dinamicamente
password=`openssl rand -hex 6`
user=`openssl rand -hex 2`

mysql -e "create database prontus_cms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci";
mysql -e "CREATE USER 'prontus$user'@'localhost' IDENTIFIED BY '$password'"
mysql -e "GRANT ALL ON *.* TO 'prontus$user'@'localhost'";
echo "******************************  Use los siguientes datos en el wizard prontus para realizar la instalacion"
echo "******************************  Base de datos: prontus_cms"
echo "******************************  usuario:  prontus$user"
echo "******************************  password: $password"

echo "Prontus instalado en /var/www/prontus/web"
echo "Visite el wizard Prontus en http://<ip>/wizard_prontus/"
