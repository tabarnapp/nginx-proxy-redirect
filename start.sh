#!/bin/bash
if [ -z "$REDIRECT_TYPE" ]; then
	REDIRECT_TYPE="permanent"
fi
if [ -z "$REDIRECT_PROTOCOL" ]; then
	REDIRECT_PROTOCOL="HTTPS"
fi
if [ -z "$VIRTUAL_HOST" ]; then
  echo "Virtual host not set, needed for nginx-proxy to create the listen files. [VIRTUAL_HOST]" 
fi

if [ -z "$REDIRECT_TARGET" ]; then
	echo "Redirect target variable not set [REDIRECT_TARGET]"
	exit 1
else
	# Add http if not set
	if ! [[ $REDIRECT_TARGET =~ ^https?:// ]]; then
		REDIRECT_TARGET="http://$REDIRECT_TARGET"
	fi

	# Add trailing slash
	if [[ ${REDIRECT_TARGET:length-1:1} != "/" ]]; then
		REDIRECT_TARGET="$REDIRECT_TARGET/"
	fi
fi


cat <<EOF > ~/${VIRTUAL_HOST}_location
	rewrite ^/(.*)\$ ${REDIRECT_TARGET}\$1 ${REDIRECT_TYPE};
EOF


ln -s ~/${VIRTUAL_HOST}_location /etc/nginx/vhost.d/${VIRTUAL_HOST}_location
echo "Redirecting requests from $VIRTUAL_HOST to ${REDIRECT_TARGET}..."

tail -f /dev/null