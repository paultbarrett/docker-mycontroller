FROM alpine:latest
MAINTAINER pbarrett (at) bitsystems.com.au
# Updated URL to reference FINAL build 
# ENV MYCONTROLLER_URL="https://drive.google.com/uc?export=download&confirm=z6ha&id=0BzuumrtRA7p6S1NKVVVHbmNHRTA"

# pin to /tmp
WORKDIR /tmp
COPY files/mycontroller-dist-standalone-0.0.3.Final-SNAPSHOT-bundle.tar.gz /tmp
# dependencies
RUN apk add --update --no-cache s6 ca-certificates openjdk8-jre-base wget

# install
RUN 	cd /tmp \
	&& tar -x mycontroller-dist-standalone-0.0.3.Final-SNAPSHOT-bundle.tar.gz -C /usr/local \
	&& rm -f /tmp/*

# add files
COPY files/root/ /

# fixes
RUN	chmod +x /service/*/run

# expose mqtt and web
EXPOSE 1883/tcp 8443/tcp

# launch s6
ENTRYPOINT ["/bin/s6-svscan","/service"]
