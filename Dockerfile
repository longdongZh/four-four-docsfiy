# 使用国内镜像源加速（如果默认源超时，可以取消下面任一注释）
FROM docker.1panel.live/library/nginx:alpine
# FROM dockerproxy.com/library/nginx:alpine
#FROM nginx:alpine

ARG MAINTAINER=four-four-docsfiy
ARG DESCRIPTION=four-four-docsfiy

LABEL maintainer="${MAINTAINER}"
LABEL description="${DESCRIPTION}"

RUN rm -rf /usr/share/nginx/html/*

COPY . /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
