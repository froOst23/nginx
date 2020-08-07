# Welltory nginx test task

![](https://img.shields.io/docker/stars/froost23/jenkins-with-python-3.7.svg)
![](https://img.shields.io/docker/pulls/froost23/jenkins-with-python-3.7.svg)
![](https://img.shields.io/docker/image-size/froost23/jenkins-with-python-3.7.svg)

## Welltory nginx test task
### v1.0
nginx configurate: add
```
--without-http_autoindex_module
--without-http_ssi_module
--without-http_scgi_module
--without-http_uwsgi_module
--without-http_geo_module
--without-http_split_clients_module
--without-http_memcached_module
--without-http_empty_gif_module
--without-http_browser_module
--with-http_ssl_module
--with-http_v2_module
--with-http_realip_module
--with-http_mp4_module
--with-http_auth_request_module
--with-http_stub_status_module
--with-http_random_index_module
--with-http_gunzip_module
--with-threads
--with-http_stub_status_module 
```

### v1.1
nginx configurate: add
```
--with-http_stub_status_module
```
 ### v1.2
 nginx configurate: default
  
update <code>Dockerfile</code>

