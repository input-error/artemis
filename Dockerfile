# Lots of useful help can be found at https://github.com/apache/activemq-artemis/tree/master/artemis-docker
FROM openjdk:11-jre-slim

RUN apt update -y && \
    apt install wget -y && \
    apt-get clean && \
    wget --max-redirect 1 -O activemq.tar.gz http://apache.mirrors.hoobly.com/activemq/activemq-artemis/2.9.0/apache-artemis-2.9.0-bin.tar.gz && \
    tar -xzvf activemq.tar.gz && \
    rm -f activemq.tar.gz  && \
    mkdir -p /var/lib/artemis-instance && \
    groupadd -g 1001 -r artemis && \
    useradd -r -u 1001 -g artemis artemis && \
    chown -R artemis.artemis /var/lib/artemis-instance

ENV BROKER_HOME /var/lib/
ENV CONFIG_PATH /var/lib/etc
ENV ARTEMIS_USER artemis
ENV ARTEMIS_PASSWORD artemis
ENV ANONYMOUS_LOGIN false
ENV CREATE_ARGUMENTS --user ${ARTEMIS_USER} --password ${ARTEMIS_PASSWORD} --silent --http-host 0.0.0.0 --relax-jolokia /var/lib/artemis-instance/

# Web Server
EXPOSE 8161 \
# JMX Exporter
    9404 \
# Port for CORE,MQTT,AMQP,HORNETQ,STOMP,OPENWIRE
    61616 \
# Port for HORNETQ,STOMP
    5445 \
# Port for AMQP
    5672 \
# Port for MQTT
    1883 \
#Port for STOMP
    61613


COPY start.sh /start.sh
USER artemis
VOLUME ["/var/lib/artemis-instance"]
WORKDIR /var/lib/artemis-instance
CMD ["/start.sh"]
