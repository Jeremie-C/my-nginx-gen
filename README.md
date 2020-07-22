my-nginx-gen
=====

![latest 0.7.5-1](https://img.shields.io/docker/v/jeremiec82/my-nginx-gen?sort=semver)
![docker build](https://img.shields.io/docker/build/jeremiec82/my-nginx-gen)
![docker pull](https://img.shields.io/docker/pulls/jeremiec82/my-nginx-gen)
![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

Based on [nginx-proxy from jwilder](https://github.com/jwilder/nginx-proxy).

### Install

Run two separate containers using the [jeremiec82/my-docker-gen](https://hub.docker.com/repository/docker/jeremiec82/my-nginx-gen) image, together with virtually any other image.

This is how you could run the official [nginx](https://registry.hub.docker.com/_/nginx/) image and have docker-gen generate a reverse proxy config in the same way that `nginx-proxy` works. You may want to do this to prevent having the docker socket bound to a publicly exposed container service.

Start nginx with a shared volume:

```
$ docker run -d -p 80:80 --name nginx-proxy \
   -v /tmp/nginx/conf.d:/etc/nginx/conf.d \
   -v /tmp/nginx/vhost.d:/etc/nginx/vhost.d \
   -t nginx
```

Start the my-nginx-gen container with the shared volume:
```
$ docker run -d --name nginx-gen \
   --volumes-from nginx-proxy \
   -v /var/run/docker.sock:/tmp/docker.sock:ro \
   -t jeremiec82/my-docker-gen -notify-sighup nginx-proxy -watch -only-exposed /etc/docker-gen/templates/nginx.tmpl /etc/nginx/conf.d/default.conf
```
