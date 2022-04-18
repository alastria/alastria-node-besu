FROM adoptopenjdk/openjdk11:alpine-jre

ARG NODE_TYPE
ARG NODE_BRANCH
ENV VERSION_BESU="22.1.0"

RUN apk add --no-cache tar jq

WORKDIR /data/alastria-node-besu

RUN wget https://hyperledger.jfrog.io/artifactory/besu-binaries/besu/$VERSION_BESU/besu-$VERSION_BESU.tar.gz -O - | tar -xz

RUN ln -s /data/alastria-node-besu/besu-$VERSION_BESU/bin bin
RUN ln -s /data/alastria-node-besu/besu-$VERSION_BESU/lib lib

RUN bin/besu --data-path=. public-key export --to=key.pub && \
    bin/besu --data-path=. public-key export-address --to=nodeAddress && \
    mkdir -p keys && \
    mv key key.pub nodeAddress keys/
    
COPY configure.node.sh ./
RUN chmod +x ./configure.node.sh && ./configure.node.sh
