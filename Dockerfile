FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y nginx php5-fpm php5-gd curl && \
    rm -rf /var/lib/apt/lists/*

ENV DOKUWIKI_VERSION 2012-10-13
ENV MD5_CHECKSUM a910ebb2fcca13c0337ed672304c4ad4


RUN mkdir -p /var/www \
    && cd /var/www \
    && curl -O "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" \
    && echo "$MD5_CHECKSUM  dokuwiki-$DOKUWIKI_VERSION.tgz" | md5sum -c - \
    && tar xzf "dokuwiki-$DOKUWIKI_VERSION.tgz" --strip 1 \
    && rm "dokuwiki-$DOKUWIKI_VERSION.tgz"

RUN chown -R www-data:www-data /var/www

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/*
ADD dokuwiki.conf /etc/nginx/sites-enabled/

EXPOSE 80

VOLUME [ \
    "/var/www", \
    "/var/share", \
    "/var/log" \
]

CMD /usr/sbin/php5-fpm && /usr/sbin/nginx
