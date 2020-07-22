ARG BASE_IMAGE_PREFIX
FROM ${BASE_IMAGE_PREFIX}alpine:latest

ARG QEMU_ARCH
COPY qemu-${QEMU_ARCH}-static* /usr/bin/

RUN apk -U upgrade

ARG DG_ARCH
ARG DG_VERS=0.7.5

RUN wget https://github.com/Jeremie-C/my-docker-gen/releases/download/$DG_VERS/docker-gen-alpine-linux-$DG_ARCH-$DG_VERS.tar.gz -q \
    && tar -C /usr/local/bin -xvzf docker-gen-alpine-linux-$DG_ARCH-$DG_VERS.tar.gz \
    && rm docker-gen-alpine-linux-$DG_ARCH-$DG_VERS.tar.gz

WORKDIR /etc/docker-gen/templates
COPY nginx.tmpl nginx.tmpl
RUN sed -i 's|/etc/nginx/dhparam/dhparam.pem|/etc/nginx/certs/dhparam.pem|' nginx.tmpl

ENV DOCKER_HOST unix:///var/run/docker.sock

ENTRYPOINT ["/usr/local/bin/docker-gen"]
CMD ["-notify-sighup", "nginx-proxy", "-watch", "-wait", "5s:30s", "/etc/docker-gen/templates/nginx.tmpl", "/etc/nginx/conf.d/default.conf"]

ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

LABEL maintainer="Jeremie-C <Jeremie-C@users.noreply.github.com>" \
  ForkedFrom="Jason Wilder <mail@jasonwilder.com>" \
  Description="nginx-gen image based on my-docker-gen" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.name="my-nginx-gen" \
  org.label-schema.description="nginx-gen image based on my-docker-gen" \
  org.label-schema.url="https://github.com/Jeremie-C/my-nginx-gen/" \
  org.label-schema.usage="https://github.com/Jeremie-C/my-nginx-gen/tree/master/README.md" \
  org.label-schema.vcs-url="https://github.com/Jeremie-C/my-nginx-gen" \
  org.label-schema.vcs-ref="${BUILD_REF}" \
  org.label-schema.version="${BUILD_VERSION}"
