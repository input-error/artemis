# artemis
Apache Artemis docker container.

## Building:
Execute build.sh

## Running
docker run -it inputerror/artemis:2.9.0 --rm -v /path/to/persistent/store:/var/lib/artemis-instance -p 61616:61616 -p 8161
