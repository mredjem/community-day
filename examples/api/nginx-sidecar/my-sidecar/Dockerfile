FROM nginx:1.13

ARG CERTS_DIR="/etc/certs"

RUN apt-get update \
 && apt-get install -y openssl \
 && mkdir -p ${CERTS_DIR} \
 && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/ST=Roubaix/L=Roubaix/O=Nextoo/OU=Nextoo/CN=nextoo.fr" -keyout ${CERTS_DIR}/nginx.key -out ${CERTS_DIR}/nginx.crt

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

WORKDIR /etc/nginx
