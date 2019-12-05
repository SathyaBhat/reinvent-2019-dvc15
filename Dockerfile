FROM alpine:3.8
RUN apk update && apk add groff mysql-client bash python py-pip && pip install awscli
COPY mysql-export.sh /app/
CMD ["/bin/bash", "/app/mysql-export.sh"]
