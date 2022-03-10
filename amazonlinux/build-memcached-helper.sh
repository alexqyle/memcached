#!/bin/bash

set -xe

BUILD_DEPENDENCIES=(\
  git \
  which \
  cyrus-sasl-devel \
  gcc \
  automake \
  libevent-devel \
  make \
  perl \
  perl-IO-Socket-SSL \
  perl-Test-Simple \
)

source /etc/os-release
if [[ ${VERSION} == '2022' ]]; then
  BUILD_DEPENDENCIES+=(openssl openssl-devel)
else
  BUILD_DEPENDENCIES+=(openssl11 openssl11-devel)
fi

function install_build_dependencies() {
  yum install -y ${BUILD_DEPENDENCIES[@]}
}

function clean_build_dependencies() {
  yum remove -y --setopt=clean_requirements_on_remove=1 ${BUILD_DEPENDENCIES[@]} \
  && yum autoremove -y
}

function build_memcached() {
  install_build_dependencies \
  && ./autogen.sh \
  && ./configure \
      -build="$gnuArch" \
      -enable-extstore \
      -enable-sasl \
      -enable-sasl-pwdb \
      -enable-tls \
  && nproc="$(nproc)" \
  && make -j "$nproc"
}
