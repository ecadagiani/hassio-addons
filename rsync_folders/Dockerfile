ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk update
RUN apk add --no-cache openssh-client sshpass rsync

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]