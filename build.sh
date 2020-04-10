#!/bin/sh

#
# build.sh is responsible for initialing the 
# FIPS 140-2 Go build process for the given
# component(s). 
#

set -e 

USAGE='usage: build.sh [component]'

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

# build is responsible for kicking off
# the actual Docker build process for the
# given component.
build() {
    cd "$1"
    component=$(echo "$1" | sed 's/\.\///g')
    ${DOCKER} build -t fips_"${component}":latest .
    cd ..
}

COMPONENT=$1

if [ "${COMPONENT}" = "all" ]; then
    components=$(find . -type d ! -name '.')
    for i in ${components}; do 
        echo "building for ${i}..."
        build "${i}"
    done
elif [ -d "${COMPONENT}" ]; then 
    build "${COMPONENT}"
else
    echo "error: unrecognized component"
    exit 1     
fi

exit 0
