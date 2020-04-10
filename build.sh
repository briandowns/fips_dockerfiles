#!/bin/sh

#
# build.sh is responsible for initialing the 
# FIPS 140-2 Go build process for the given
# component(s). 

set -e 

USAGE='build.sh [component]
examples:
    build.sh all
    build.sh kubernetes
'

DOCKER=$(which docker)

# check if debug specified and set it on.
if [ "${DEBUG}" = 1 ]; then
    set -x
fi

# error if we have no arguments.
if [ $# -eq 0 ]; then
    echo "${USAGE}"
    exit 1
fi

# build is a responsible for kicking off
# the actual Docker build process for the
# given component.
build() {
    component=$1
    ${DOCKER} build -t fips_"${component}":latest .
}

COMPONENT=$1

case ${COMPONENT} in 
    all)
        components=$(find . -type d ! -name '.')
        for i in ${components}; do 
            build "${i}"
        done
        ;;
    kubernetes)
        cd "${COMPONENT}"
        build "${i}"
        ;;
    *)
        echo "error: unrecognized component"
        exit 1
        ;;
esac

exit 0
