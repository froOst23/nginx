FROM ubuntu:latest

ENV TZ=Europe/Moscow

# установка необходимых пакетов для компиляции nginx
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
&& apt-get update \
&& apt-get install build-essential libpcre++-dev libssl-dev wget zlibc zlib1g zlib1g-dev -y \
&& apt-get clean

RUN cd /tmp/ \
&& wget http://nginx.org/download/nginx-1.17.10.tar.gz \
&& tar -zxvf nginx-1.17.10.tar.gz \
&& rm nginx-1.17.10.tar.gz \
&& cd nginx-1.17.10 \
&& ./configure \
# сконфигурируем наш nginx по умолчанию, указав только префикс
# используемые каталоги nginx описаны тут https://nginx.org/ru/docs/configure.html
--prefix=/usr/local/nginx \
--user=nginx-user \
--group=nginx-user \
--with-http_stub_status_module \
&& make \
&& make install

# создадим непривилегированного пользователя, с правами которого будут выполняться рабочие процессы
RUN useradd -s /usr/sbin/nologin nginx-user \
# чтобы вызывать исполняемый файл nginx сделаем символическую ссылку на него
# исполняемый файл по умолчанию находится '--prefix'/sbin/nginx
&& ln -s /usr/local/nginx/sbin/nginx /bin/nginx \
&& nginx -V

COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# добавление в конфиг nginx 'daemon off'
CMD ["nginx"]
EXPOSE 80