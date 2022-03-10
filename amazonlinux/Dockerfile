FROM amazonlinux:2

RUN mkdir /usr/src/memcached

ADD memcached /usr/src/memcached
COPY ./build-memcached-helper.sh /usr/src/memcached/build-memcached-helper.sh

RUN set -x \
  \
  # Create memcache user and group
  && yum install -y shadow-utils \
  && groupadd -g 11211 memcache && useradd -u 11211 -g memcache memcache \
  \
  && cd /usr/src/memcached \
  \
  && source ./build-memcached-helper.sh \
  \
  && build_memcached \
  \
  && make install \
  \
  # Clean build dependencies
  && rm -f /etc/yum/protected.d/* \
  && clean_build_dependencies \
  \
  # Clean source code
  && cd / && rm -rf /usr/src/memcached \
  \
  # Install runtime dependencies
  && yum install -y \
      libevent \
      openssl11-libs \
  && yum clean all \
  && rm -rf /var/cache/yum \
  && memcached -V

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]


USER memcache
EXPOSE 11211
CMD ["memcached"]
