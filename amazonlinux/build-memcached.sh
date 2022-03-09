#!/bin/bash

set -xe

# Install build dependencies
yum install -y \
  git \
  which \
  cyrus-sasl-devel \
  gcc \
  automake \
  libevent-devel \
  make \
  openssl \
  openssl-devel \
  perl \
  perl-IO-Socket-SSL \
  perl-Test-Simple

# Start building
./autogen.sh
./configure \
  -build="$gnuArch" \
  -enable-extstore \
  -enable-sasl \
  -enable-sasl-pwdb \
  -enable-tls
nproc="$(nproc)"
make -j "$nproc"
