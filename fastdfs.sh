#!/bin/bash
if [ -n "$FASTDFS_IPADDR" ] ; then  
new_val=$FASTDFS_IPADDR
old="com.ikingtech.ch116221"

sed -i "s/$old/$new_val/g" /etc/fdfs/client.conf
sed -i "s/$old/$new_val/g" /etc/fdfs/storage.conf
sed -i "s/$old/$new_val/g" /etc/fdfs/mod_fastdfs.conf

fi

cat  /etc/fdfs/client.conf > /etc/fdfs/client.txt
cat  /etc/fdfs/storage.conf >  /etc/fdfs/storage.txt
cat  /etc/fdfs/mod_fastdfs.conf > /etc/fdfs/mod_fastdfs.txt

mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.t
cp /etc/fdfs/nginx.conf /usr/local/nginx/conf

if [ "$1" = "tracker" ] ; then

echo "start trackerd"
/etc/init.d/fdfs_trackerd start

elif [ "$1" = "storage" ] ; then

echo "start storage"
/etc/init.d/fdfs_storaged start

elif [ "$1" = "nginx" ] ; then

echo "start nginx"
/usr/local/nginx/sbin/nginx 

else 

echo "start trackerd"
/etc/init.d/fdfs_trackerd start

echo "start storage"
/etc/init.d/fdfs_storaged start

echo "start nginx"
/usr/local/nginx/sbin/nginx 

fi

tail -f  /dev/null