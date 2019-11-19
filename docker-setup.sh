#!/usr/bin/env bash

echo "[>] WordPress setup"
echo "[+] Setting up MySQL..."
ret=`docker run --name wpsql -e MYSQL_ROOT_PASSWORD=wpsql -e MYSQL_DATABASE=wpsql -d mysql:5.7`
if [ -z $ret ]; then
	echo "[!] Error starting MySQL container";
	exit 1;
fi
echo "[+] MySQL running ($ret)"

echo "[+] Setting up WordPress..."
ret=`docker run --name wphack --link wpsql -p 8080:80 -e WORDPRESS_DB_HOST=wpsql:3306 -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=wpsql -e WORDPRESS_DB_NAME=wpsql -e WORDPRESS_TABLE_PREFIX=wp_ -d wordpress`
if [ -z $ret ]; then
	echo "[!] Error starting WordPress container";
	exit 1;
fi
echo "[+] WordPress running ($ret)"

echo "[>] Done. Visit http://localhost:8080"
