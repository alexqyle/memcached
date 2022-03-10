#!/bin/bash

scriptDir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -xe

source ${scriptDir}/build-memcached-helper.sh

build_memcached

rm -rf .git*
make test PARALLEL="$nproc"
