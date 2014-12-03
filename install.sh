#!/bin/bash
#
# Grab the files using this git-clone command:
# git clone https://github.com/mousems/NTUVoteV2_install

if [[ $(id -u) != 0 ]]; then
    echo 'ERROR: This script should run as root.' >&2
    return 1 2>/dev/null || exit 1
fi

# help user: cd to the containing directory of this shell script
cd "$(dirname "${BASH_SOURCE[0]}")"

# help user: make sure all these files exist in the current directory
if ! [[ -f 000-default.conf &&
        -f apache2.conf     &&
        -f config.php       &&
        -f default-ssl.conf &&
        -f ntuvote.sql      &&
        -f Result.sh        ]]; then
    echo 'ERROR: Some required file does not exist.' >&2
    return 1 2>/dev/null || exit 1
fi

# important message goes first
echo
echo
echo '    Please make sure network and OpenSSH server both work already.'
echo '    If you are not ready, press Control-C to stop right now!'
echo
echo
echo 'The installation process will start in 3 seconds...'
echo
sleep 3

# install tasksel and git
apt-get update
apt-get install -y tasksel git

# install LAMP if not done before (need to provide mysql root password twice)
tasksel install lamp-server

# config apache (need to provide csr data for openssl manually)
a2enmod rewrite
a2enmod ssl
mkdir /etc/apache2/ssl
openssl req -x509 -nodes -days 365000 -newkey rsa:2048 \
        -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt
mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
cp ./apache2.conf /etc/apache2/
cp ./default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
cp ./000-default.conf /etc/apache2/sites-enabled/000-default.conf
chown root:root /etc/apache2/sites-enabled/default-ssl.conf
chmod 644 /etc/apache2/sites-enabled/default-ssl.conf
sudo apt-get install -y php5-json
service apache2 restart

# ticket storage
mkdir /var/log/NTUticket
git init /var/log/NTUticket
chmod -R 777 /var/log/NTUticket

# put application files
rm -rf /var/www/
mkdir /var/www/
git clone https://github.com/mousems/ntuvotev2.git
cp -r ./ntuvotev2/* ntuvotev2/.htaccess /var/www/
cp ./config.php /var/www/application/config/
cp ./Result.sh /var/log/NTUticket/



# finally, just a message about next actions
cat <<'END'

install complete
    1.Please connect to MySQL and import SQL file. 'ntuvote.sql'
    2.Edit /var/www/application/config/databases.php for MySQL settings.
    3.Edit /var/www/application/config/config.php for 'URL'.
    4.visit website, administrator account: ntuvote/ntuvote\!@#$%

END
