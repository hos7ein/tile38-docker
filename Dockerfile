FROM alpine:3.12
LABEL maintainer="https://fedorafans.com <hossein.a97@gmail.com>"

# ---------------- #
#   Installation   #
# ---------------- #

# Install and setup all prerequisites
RUN apk update                                                               &&\
    apk add --no-cache curl                                                  &&\
    rm -rf /var/cache/apk/*                                                  &&\
    addgroup -S tile38                                                       &&\
    adduser -S -G tile38 tile38                                              &&\
    mkdir /data                                                              &&\
    chown tile38:tile38 /data                                                &&\
    TILE38_VER=`curl -s https://api.github.com/repos/tidwall/tile38/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`                    &&\
    curl -Lo /tmp/tile38-${TILE38_VER}-linux-amd64.tar.gz   https://github.com/tidwall/tile38/releases/download/${TILE38_VER}/tile38-${TILE38_VER}-linux-amd64.tar.gz  &&\
    tar -xzvf /tmp/tile38-${TILE38_VER}-linux-amd64.tar.gz  -C /usr/local/bin   --strip-components=1                                                                     \
    tile38-${TILE38_VER}-linux-amd64/tile38-benchmark tile38-${TILE38_VER}-linux-amd64/tile38-server  tile38-${TILE38_VER}-linux-amd64/tile38-cli                      &&\
    chmod +x /usr/local/bin/tile38-benchmark  /usr/local/bin/tile38-server  /usr/local/bin/tile38-cli                                                                  &&\
    rm -rf /tmp/tile38-${TILE38_VER}-linux-amd64.tar.gz                      &&\


VOLUME /data

WORKDIR /data

# ---------------- #
#   Expose Ports   #
# ---------------- #

# Tile38
EXPOSE 9851

# -------- #
#   Run!   #
# -------- #

CMD ["tile38-server", "-d", "/data"]
