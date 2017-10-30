#!/bin/bash -e

NAME=qqvcp
IMAGE=zultron/${NAME}
TOPDIR="$(readlink -f "$(dirname $0)"/..)"

usage() {
    ERRMSG="$1"
    {
	test -z "$ERRMSG" || echo "ERROR:  $ERRMSG"
	echo "Usage:"
	echo "    $0 build             Build the Docker container image"
	echo "    $0 anddemo-build     Build the AND demo"
	echo "    $0                   Run interactive shell in container"
	echo "    $0 CMD [ ARGS ... ]  Run CMD in container"
    } >&2
    if test -z "$ERRMSG"; then
	exit
    else
	exit 1
    fi
}

run() {
    UID_GID=`id -u`:`id -g`
    set -x
    exec docker run --rm \
	 -it --privileged \
	 -u $UID_GID \
	 -v /tmp/.X11-unix:/tmp/.X11-unix \
	 -v /dev/dri:/dev/dri \
	 -v $HOME:$HOME -e HOME \
	 -v $PWD:$PWD \
	 -p 3000:3000 \
	 -w $PWD \
	 -e DISPLAY \
	 -e DEBUG \
	 -e MSGD_OPTS \
	 -h ${NAME} --name ${NAME} \
	 ${IMAGE} "$@"
}

if test "$1" = build; then
    shift
    cd "$TOPDIR/docker"
    exec docker build -t qqvcp "$@" .
fi

if test "$1" = anddemo-build; then
    run bash -xec "
	mkdir -p $TOPDIR/node
	cd $TOPDIR/node
	# - AND demo:  clone
	test -d anddemo || \
	    git clone https://github.com/machinekoder/anddemo.git
	# - qmlweb:  clone and install
	test -d qmlweb || \
	    git clone -b webvcp https://github.com/machinekoder/qmlweb.git
	( cd qmlweb && npm install && npm run build )
	# - webvcp:  clone and install
	test -d webvcp || \
	    git clone -b pr-svc-disc https://github.com/zultron/webvcp.git
	    # FIXME https://github.com/qtquickvcp/webvcp/pull/1
	    #git clone https://github.com/machinekoder/webvcp.git
	( cd webvcp && npm install )
    "
fi

if test "$1" = anddemo; then
    run bash -xec "
	# - Start system services
	for s in rsyslog dbus avahi-daemon; do sudo /etc/init.d/\$s start; done
	# - Start AND demo
	( cd node/anddemo && exec ./run.py ) &
	sleep 2
	# - Start web service
	( cd node/webvcp && exec node index.js ) &
	sleep 2
	exec bash -i
    "
fi

# Check for existing containers
EXISTING="$(docker ps -aq --filter=name=${NAME})"
if test -n "${EXISTING}"; then
    # Container exists; is it running?
    RUNNING=$(docker inspect ${EXISTING} | awk '/"Running":/ { print $2 }')
    if test "${RUNNING}" = "false,"; then
	# Remove stopped container
	echo docker rm ${EXISTING}
    elif test "${RUNNING}" = "true,"; then
	# Container already running; error
	echo "Error:  container '${NAME}' already running" >&2
	exit 1
    else
	# Something went wrong
	echo "Error:  unable to determine status of " \
	    "existing container '${EXISTING}'" >&2
	exit 1
    fi
fi

run "$@"
