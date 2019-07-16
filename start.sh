#!/bin/sh

set -e

echo CREATE_ARGUMENTS=${CREATE_ARGUMENTS}

if ! [ -f ./etc/broker.xml ]; then
	/apache-artemis-2.9.0/bin/artemis create ${CREATE_ARGUMENTS}
else
	echo "broker already created, ignoring creation"
fi

exec /var/lib/artemis-instance/bin/artemis run $@
