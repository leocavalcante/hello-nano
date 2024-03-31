FROM alpine:3.19
RUN apk add --update --no-cache composer php82-xml php82-tokenizer php82-pecl-swoole
WORKDIR /app
COPY composer.* .
RUN composer install --prefer-dist --no-dev --optimize-autoloader
COPY . .
ENTRYPOINT [ "./app" ]
CMD [ "start" ]
