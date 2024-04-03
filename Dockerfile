FROM alpine:3.19
WORKDIR /app
COPY . .
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update --no-cache composer dapr-cli php82-xml php82-tokenizer php82-pecl-swoole \
    && composer install --prefer-dist --no-dev --optimize-autoloader \
    && dapr init --slim
ENTRYPOINT [ "composer" ]
CMD [ "start"]
EXPOSE 3500
