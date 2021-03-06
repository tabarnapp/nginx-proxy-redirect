# tabarnapp/nginx-proxy-redirect # 
![Docker Build Status](https://img.shields.io/docker/cloud/build/tabarnapp/nginx-proxy-redirect.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/tabarnapp/nginx-proxy-redirect.svg) ![Docker Stars](https://img.shields.io/docker/stars/tabarnapp/nginx-proxy-redirect.svg)

This image can be combined with the [jwilder nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/) and it redirects all web traffic to the given target domain/URL.

## Features ##
- Only running process is `tail -f /dev/null`  ~1.25MB RAM used
- Keeps the URL path and GET parameters
- Permanent or temporary redirect

## Usage ##
### Docker run ###
The target domain/URL is set by the `REDIRECT_TARGET` environment variable.  
Possible redirect targets include domains (`mydomain.net`), paths (`mydomain.net/my_page`) or specific protocols (`https://mydomain.net/my_page`).  

**Example:** `$ docker run -d --volumes-from nginx-proxy -e VIRTUAL_HOST=myolddomain.net -e LETSENCRYPT_HOST=myolddomain.net -e REDIRECT_TARGET=https://mydomain.net tabarnapp/nginx-proxy-redirect`

### Paths are retained ###
The URL path and GET parameters are retained. That means that a request to `http://myolddomain.net/index.php?page=2` will be redirected to `http://mydomain.net/index.php?page=2` when `REDIRECT_TARGET=mydomain.net` is set.

### Permanent redirects ###
Redirects are, by default, permanent (HTTP status code 301). That means browsers will cache the redirect and will go directly to the new site on further requests. Also search engines will recognize the new domain and change their URLs. This means this image is not suitable for temporary redirects e.g. for site maintenance.

### Temporary redirects ###
To make redirects temporary (HTTP status code 302) set the environment variable `REDIRECT_TYPE` to `redirect`.

## Docker Compose ##
A sample docker-compose file that redirects `myolddomain.net` to `mydomain.net` could look like this:

## Uninstall ## 
Stopping and removing the container would not delete the created file. You need to go to `/etc/nginx/vhost.d` and delete the redirect conf from there as well. Filename should look like `${VIRTUAL_HOST}_location`.  

Depending on your setup, the location might be mounted on the host or not. `docker exec -it nginx-proxy /bin/sh` should open up the bash console so you can go to the volume and delete it. 

```yaml
version: '3'
services:
  nginx-proxy:
    ... 
    volumes:
     - vhost:/etc/nginx/vhost.d

  redirect:
    restart: always
    image: tabarnapp/nginx-proxy-redirect
    volumes_from:
      - nginx-proxy
    environment:
      - VIRTUAL_HOST=myolddomain.net
      - LETSENCRYPT_HOST=myolddomain.net
      - REDIRECT_TARGET=mydomain.net
volumes:
  vhost:
```


## Changelog ##
- **1.2 [latest]** - added env checking
- **1.1** - added `tail -f /dev/null` command
- **1.0** - initial version