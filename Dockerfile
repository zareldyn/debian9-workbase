FROM debian:9.0


LABEL maintainer="zareldyn" \
      description="A customized minimal Debian 9 image with one regular user, one text editor and a nicer prompt."


ARG MAIN_USER_ID
ARG MAIN_USER_LOGIN
#                    openSSL hash for 'password'
ARG main_user_passwd='$1$3zQH3LzF$btPwP2cM/fbEDxGFTJBIq/'

ARG PARENT_HOSTNAME
ARG SYSTEM_TIMEZONE
ARG default_locale=en_US.UTF-8


ENV MAIN_USER_ID=${MAIN_USER_ID:-1000} \
    MAIN_USER_LOGIN=${MAIN_USER_LOGIN:-mainuser} \
    PARENT_HOSTNAME=${PARENT_HOSTNAME:-host} \
    SYSTEM_TIMEZONE=${SYSTEM_TIMEZONE:-Etc/UTC}\
    WORKBASE_VERSION="1.0.2"


# Creates the main user and installs some packages
RUN ["/bin/bash", "-c", " \
    echo $SYSTEM_TIMEZONE > /etc/timezone && ln -fs /usr/share/zoneinfo/$SYSTEM_TIMEZONE /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && \
    adduser --uid $MAIN_USER_ID --disabled-password --gecos '' $MAIN_USER_LOGIN && \
    usermod --password \"$main_user_passwd\" $MAIN_USER_LOGIN && \
    echo 'deb http://ftp.debian.org/debian stretch-backports main' >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
        bash-completion \
        less \
        locales \
        nano \
        tree && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/^# *\\('$default_locale'\\)/\\1/' /etc/locale.gen && locale-gen && update-locale LANG=$default_locale \
"]


# Redefines some shell behaviors
COPY root/* /root/
COPY user/* /home/$MAIN_USER_LOGIN/
RUN chown -R $MAIN_USER_ID:$MAIN_USER_ID /home/$MAIN_USER_LOGIN


# For a default environment with the locale applied
CMD su
