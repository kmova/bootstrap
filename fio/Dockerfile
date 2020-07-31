# VERSION 0.1
FROM alpine

#Credit Dmitry Monakhov dmonakhov@openvz.org
#https://github.com/dmonakhov/docker-image--alpine-fio/blob/master/Dockerfile

# Install build deps + permanent dep: libaio
RUN apk --no-cache add \
    	make \
	alpine-sdk \
	zlib-dev \
	libaio-dev \
	linux-headers \
	coreutils \
	libaio && \
    git clone https://github.com/axboe/fio && \
    cd fio && \
    ./configure && \
    make -j`nproc` && \
    make install && \
    cd .. && \
    rm -rf fio && \
    apk --no-cache del \
    	make \
	alpine-sdk \
	zlib-dev \
	libaio-dev \
	linux-headers \
	coreutils

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["fio"]
