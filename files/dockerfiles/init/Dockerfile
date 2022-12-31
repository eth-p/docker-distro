FROM alpine:3.15

RUN apk add --no-cache zsh

COPY init /init
RUN chmod 755 /init

COPY extra/decapx /extra/decapx
RUN chmod -R 755 /extra/decapx/scripts

ENTRYPOINT [ "/init", "--debug" ]
