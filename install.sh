echo -e "before install , please make sure network and open-ssh server already setup.\n" 

# git and tasksel
apt-get install -y git 
apt-get install -y tasksel 
apt-get update 
#clone
git clone https://github.com/mousems/ntuvotev2.git 

# checkout tag 2.1
cd ntuvotev2
git checkout 2.1
cd ..

#install LAMP
tasksel install lamp-server 
apt-get update 


#config apache
a2enmod rewrite 
a2enmod ssl 
mkdir /etc/apache2/ssl 
openssl req -x509 -nodes -days 365000 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt 
mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak 
cp apache2.conf /etc/apache2/ 
cp default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf 
cp 000-default.conf /etc/apache2/sites-enabled/000-default.conf 
chown root:root /etc/apache2/sites-enabled/default-ssl.conf 
chmod 644 /etc/apache2/sites-enabled/default-ssl.conf 
sudo apt-get install -y php5-json
service apache2 restart 

# app file
rm -rf /var/www/* 
mv ntuvotev2/* /var/www 
cp ./ntuvotev2/.htaccess /var/www
mv config.php /var/www/application/config 
mv Result.sh /var/log/NTUticket 

#ticket storage
mkdir /var/log/NTUticket 
cd /var/log/NTUticket 
git init 
chmod 777 ./ 
chmod -R 777 .git


echo -e "\n\n\ninstall complete \n    1.Please connect to MySQL and import SQL file. 'ntuvote.sql'\n    2.Edit /var/www/application/config/databases.php for MySQL settings.\n    3.Edit /var/www/application/config/config.php for 'URL'.\n    4.visit website , administrator account: ntuvote/ntuvote\!@#$%\n\n\n\n\n"