#!/bin/bash

scriptDir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -xe

${scriptDir}/build-memcached.sh

rm -rf .git*
make test PARALLEL="$nproc"
