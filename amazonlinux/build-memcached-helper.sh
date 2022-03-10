#!/bin/bash

BUILD_DEPENDENCIES=(\
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
  perl-Test-Simple \
)

set -xe

function install_build_dependencies() {
  yum install -y ${BUILD_DEPENDENCIES[@]}
}

function clean_build_dependencies() {
  yum remove -y --setopt=clean_requirements_on_remove=1 ${BUILD_DEPENDENCIES[@]}
  yum autoremove -y
}

function build_memcached() {
  install_build_dependencies

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
}
