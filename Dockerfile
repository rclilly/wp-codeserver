ARG PHP_VERSION=8.2

ARG BASE_IMAGE=ghcr.io/10up/wp-php-fpm-dev
FROM ${BASE_IMAGE}:${PHP_VERSION}-ubuntu

ARG PHP_VERSION=8.2


USER root
RUN apt-get update && \
  apt-get install -y \
  python3-pip \
  zsh \
  glances \
  silversearcher-ag \
  tmux \
  screen \
  jq \
  parallel \
  build-essential && \
  apt clean all && rm -rf /var/lib/apt/lists/*


RUN \
  pip3 --no-cache-dir install \
    python-gitlab \
    mitzasql \
    ranger-fm

RUN \
  curl -fsSL https://code-server.dev/install.sh | sh; \
  rm -rf ~/.cache

RUN chsh -s /bin/bash www-data

COPY code-server-entrypoint.sh /
COPY bash.sh /
RUN \
    chmod +x /code-server-entrypoint.sh && \
    chmod +x /bash.sh

USER www-data
RUN \
  touch ~/.zshrc; \
  mkdir ~/.parallel; \
  touch ~/.parallel/will-cite

WORKDIR /var/www/html

SHELL ["/bin/bash"]
ENTRYPOINT ["/code-server-entrypoint.sh"]
