FROM postgres:14.2-alpine

COPY healthcheck.sh /usr/local/bin/
RUN apk add --no-cache bash \
    && chmod +x /usr/local/bin/healthcheck.sh

HEALTHCHECK CMD ["healthcheck.sh"]

