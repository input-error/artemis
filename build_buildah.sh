#!/bin/zsh

buildah from --name artemis openjdk:11-jre-slim
buildah run artemis -- apt update -y && \
buildah run artemis -- apt install wget -y && \
buildah run artemis -- apt-get clean && \
buildah run artemis -- wget --max-redirect 1 -O activemq.tar.gz http://apache.mirrors.hoobly.com/activemq/activemq-artemis/2.9.0/apache-artemis-2.9.0-bin.tar.gz && \
buildah run artemis -- tar -xzvf activemq.tar.gz && \
buildah run artemis -- rm -f activemq.tar.gz && \
buildah run artemis -- mkdir -p /var/lib/artemis-instance && \
buildah run artemis -- groupadd -g 1001 -r artemis && \
buildah run artemis -- useradd -r -u 1001 -g artemis artemis && \
buildah run artemis -- chown -R artemis.artemis /var/lib/artemis-instance

buildah config --env ARTEMIS_USER=artemis \
		--env ARTEMIS_PASSWORD=artemis \
		--env ANONYMOUS_LOGIN=false \
		--env CREATE_ARGUMENTS="--user ${ARTEMIS_USER} --password ${ARTEMIS_PASSWORD} --silent --http-host 0.0.0.0 --relax-jolokia /var/lib/artemis-instance/" \
		artemis

buildah config --port 8161 \
		--port 9404 \
		--port 61616 \
		--port 5445 \
		--port 5672 \
		--port 1883 \
		--port 61613 \
		artemis

buildah copy artemis ./start.sh /start.sh

buildah config --workingdir /var/lib/artemis-instance artemis
buildah config --user artemis artemis
buildah config --volume "/var/lib/artemis-instance" artemis
buildah config --entrypoint '["/start.sh"]' artemis

buildah commit --squash --rm artemis

