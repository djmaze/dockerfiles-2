#!/bin/sh
sed -i -e "s|base_url : False|base_url : ${BASE_URL}|g" \
       -e "s/image_proxy : False/image_proxy : ${IMAGE_PROXY}/g" \
       -e "s/ultrasecretkey/$(openssl rand -hex 16)/g" \
       /usr/local/searx/searx/settings.yml

if [ $HTTP_PROXY_URL ]; then
  cat >/tmp/proxies <<EOF
    proxies:
        http: $HTTP_PROXY_URL
        https: $HTTPS_PROXY_URL
EOF
  sed -i -e "/outgoing:/r /tmp/proxies" /usr/local/searx/searx/settings.yml
  rm /tmp/proxies
fi

exec su-exec $UID:$GID /sbin/tini -- python /usr/local/searx/searx/webapp.py
