FROM amazonlinux:2

RUN mkdir /usr/src/memcached

ADD memcached /usr/src/memcached

RUN set -x \
	\
  # Create memcache user and group
  && yum install -y shadow-utils \
  && groupadd -g 11211 memcache && useradd -u 11211 -g memcache memcache \
  \
  # Install build dependencies
	&& yum install -y \
      git \
      which \
      cyrus-sasl-devel \
      gcc \
      automake \
      libevent-devel \
      make \
      openssl \
      openssl11-devel \
      perl \
      perl-IO-Socket-SSL \
      perl-Test-Simple \
	\
	&& cd /usr/src/memcached \
	\
  # Start building
  && ./autogen.sh \
	&& ./configure \
		--build="$gnuArch" \
		--enable-extstore \
		--enable-sasl \
		--enable-sasl-pwdb \
		--enable-tls \
	&& nproc="$(nproc)" \
	&& make -j "$nproc" \
	\
	&& make install \
	\
  # Clean source code
	&& cd / && rm -rf /usr/src/memcached \
	\
  # Clean build dependencies
  && rm -f /etc/yum/protected.d/* \
  && yum remove -y \
      --setopt=clean_requirements_on_remove=1 \
      libevent-devel \
      openssl11-devel \
      shadow-utils \
      cyrus-sasl-devel \
      openssl \
      git \
      which \
      gcc \
      automake \
      make \
      perl \
      perl-IO-Socket-SSL \
      perl-Test-Simple \
  && yum autoremove -y \
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
