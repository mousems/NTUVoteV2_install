installation shell of https://github.com/mousems/NTUvoteV2

## Version

for NTUVoteV2 ver 2.1
https://github.com/mousems/NTUvoteV2/releases/tag/2.1

## Guide
	1. install ubuntu 14.04 LTS server OS (you can create instance on AWS or digitalocean)
	2. run install.sh on server
    3.Please connect to MySQL create database and import SQL file. 'ntuvote.sql'
    	#> mysql -u root -p
    	mysql> create database ntuvote
    	#> mysql ntuvote -u root -p < ntuvote.sql
    4.Edit /var/www/application/config/database_sample.php for MySQL settings.
    5.rename database_sample.php to database.php
    6.Edit /var/www/application/config/config.php for 'URL'.
    7.visit website, administrator account: mousems/ntuvote


All password in system is "ntuvote"

Remote API key for demo is 123456789012345678901234567890 , call by https://{yourdomain}/api

Demo authcode in file "authcodes"