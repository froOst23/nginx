FROM ubuntu:latest

ENV TZ=Europe/Moscow

# installation of necessary components for nginx
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
&& apt-get update \
&& apt-get install build-essential libpcre++-dev libssl-dev -y \
&& apt-get install wget -y \
&& apt-get install zlibc zlib1g zlib1g-dev -y \
&& apt-get install systemd -y \
&& apt-get clean

# make & install nginx
RUN cd /usr/local/src \
&& wget https://nginx.org/download/nginx-1.17.10.tar.gz \
&& tar -zxvf nginx-1.17.10.tar.gz \
&& cd nginx-1.17.10 \
&& ./configure \
--prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--user=nginx \
--group=nginx \
--without-http_autoindex_module \
--without-http_ssi_module \
--without-http_scgi_module \
--without-http_uwsgi_module \
--without-http_geo_module \
--without-http_split_clients_module \
--without-http_memcached_module \
--without-http_empty_gif_module \
--without-http_browser_module \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_mp4_module \
--with-http_auth_request_module \
--with-http_stub_status_module \
--with-http_random_index_module \
--with-http_gunzip_module \
--with-threads \
--with-http_stub_status_module \
&& make \
&& make install \
&& nginx -V

# creating the necessary directories
RUN useradd -s /usr/sbin/nologin nginx \
&& mkdir /var/cache/nginx \
&& mkdir /etc/nginx/conf/ \
&& mkdir /etc/nginx/sites-enabled/ \
&& mkdir /etc/nginx/sites-available/ \
&& mkdir /etc/nginx/common/ \
&& ln -s /usr/sbin/nginx /bin/nginx

# nginx.service and nginx.conf setup
RUN cd /usr/local/src \
&& wget https://gitlab.com/frost.dat/welltory_nginx_test_task/-/archive/master/welltory_nginx_test_task-master.tar.gz \
&& tar -zxvf welltory_nginx_test_task-master.tar.gz \
&& cd welltory_nginx_test_task-master \
&& cp nginx.service /lib/systemd/system/ \
&& cp nginx.conf /etc/nginx/

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80
