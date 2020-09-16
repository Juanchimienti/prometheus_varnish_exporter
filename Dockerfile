FROM alpine:3.12

ENV EXPORTER_VERSION=1.5.2
ENV VARNISH_VERSION=6.4

# To avoid not found error
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

RUN apk update; apk add varnish varnish~${VARNISH_VERSION}

RUN mkdir /exporter; chown varnish /exporter

USER varnish

ADD --chown=varnish https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/${EXPORTER_VERSION}/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz /tmp

RUN cd /exporter; tar -xzf /tmp/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz; ln -sf /exporter/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64/prometheus_varnish_exporter prometheus_varnish_exporter

CMD [ "/exporter/prometheus_varnish_exporter" ,"-no-exit"]

EXPOSE 9131
