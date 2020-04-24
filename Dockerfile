FROM ubuntu:latest

# installation of necessary components for nginx
RUN apt-get update \
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

# nginx.service setup
RUN echo "" > /lib/systemd/system/nginx.service \
&& echo "[Unit]" >> /lib/systemd/system/nginx.service \
&& echo "Description=A high performance web server and a reverse proxy server" >> /lib/systemd/system/nginx.service \
&& echo "After=network.target" >> /lib/systemd/system/nginx.service \
&& echo "" >> /lib/systemd/system/nginx.service \
&& echo "[Service]" >> /lib/systemd/system/nginx.service \
&& echo "Type=forking" >> /lib/systemd/system/nginx.service \
&& echo "PIDFile=/var/run/nginx.pid" >> /lib/systemd/system/nginx.service \
&& echo "ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'" >> /lib/systemd/system/nginx.service \
&& echo "ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'" >> /lib/systemd/system/nginx.service \
&& echo "ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload" >> /lib/systemd/system/nginx.service \
&& echo "ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /var/run/nginx.pid" >> /lib/systemd/system/nginx.service \
&& echo "TimeoutStopSec=5" >> /lib/systemd/system/nginx.service \
&& echo "KillMode=mixed" >> /lib/systemd/system/nginx.service \
&& echo "" >> /lib/systemd/system/nginx.service \
&& echo "[Install]" >> /lib/systemd/system/nginx.service \
&& echo "WantedBy=multi-user.target" >> /lib/systemd/system/nginx.service \
&& cat /lib/systemd/system/nginx.service

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80
