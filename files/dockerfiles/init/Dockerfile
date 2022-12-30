FROM alpine:3.15

RUN apk add --no-cache zsh

COPY init /init
RUN chmod 755 /init

ENTRYPOINT [ "/init", "--debug" ]
