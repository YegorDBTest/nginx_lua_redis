FROM openresty/openresty:latest

COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./get_redis_data.lua /usr/local/src/get_redis_data.lua

EXPOSE 80
