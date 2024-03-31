FROM alpine:3.19
WORKDIR /app
COPY . .
RUN apk add --update --no-cache composer php82-xml php82-tokenizer php82-pecl-swoole \
 && composer install --prefer-dist --no-dev --optimize-autoloader
ENTRYPOINT [ "./app" ]
CMD [ "start" ]
