#!/bin/ash

for templatefile in $(ls -1 /etc/nginx/*.template /etc/nginx/conf.d/*.template 2>/dev/null)
do
  echo "Replacing environmental variables in ${templatefile}"
  destfile="$(echo ${templatefile} | sed -re 's@.template@@g').conf"
  /etc/nginx/script/sub_env_vars_only.sh "${templatefile}" "${destfile}"
done

/usr/sbin/nginx -g 'daemon off;'
