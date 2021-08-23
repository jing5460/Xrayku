FROM caddy:builder-alpine AS builder

RUN xcaddy build \
        --with github.com/mholt/caddy-l4 \
        --with github.com/mholt/caddy-dynamicdns \
        --with github.com/caddy-dns/openstack-designate \
        --with github.com/caddy-dns/azure \
        --with github.com/caddy-dns/vultr \
        --with github.com/caddy-dns/hetzner \
        --with github.com/caddy-dns/digitalocean \
        --with github.com/caddy-dns/alidns \
        --with github.com/caddy-dns/gandi \
        --with github.com/caddy-dns/duckdns \
        --with github.com/caddy-dns/dnspod \
        --with github.com/caddy-dns/lego-deprecated \
        --with github.com/caddy-dns/route53 \
        --with github.com/caddy-dns/cloudflare
        
FROM caddy:builder-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN apk update && \
    apk add --no-cache --virtual ca-certificates caddy tor curl wget && \
    mkdir /tmp/v2ray && \
    curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray && \
    install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray && \
    install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl && \
    v2ray -version && \
    mkdir -p /usr/share/caddy/$AUUID && wget -O /usr/share/caddy/$AUUID/StoreFiles https://raw.githubusercontent.com/mixool/xrayku/master/etc/StoreFiles && \
    wget -P /usr/share/caddy/$AUUID -i /usr/share/caddy/$AUUID/StoreFiles && \
    rm -rf /tmp/v2ray && \
    rm -rf /var/cache/apk/* 

ENV XDG_CONFIG_HOME /etc/caddy
ENV XDG_DATA_HOME /usr/share/caddy

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
