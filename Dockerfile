FROM ubuntu:latest

# install required packages
RUN apt-get update && \
  apt-get -y install curl perl

# attach profile
COPY basic.profile /tmp

# download texlive
RUN cd /tmp && \
  curl -L -o install-tl-unx.tar.gz https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
  zcat < install-tl-unx.tar.gz | tar xf - && \
  rm -rf *.tar.gz

# install texlive using perl
RUN cd /tmp/install-tl-* && \
  perl ./install-tl --no-interaction -profile ../basic.profile

# clean-up installation 
RUN cd /tmp && rm -rf install-tl-*

# attach the installation to the PATH (todo: make this version and platform independent...)
ENV PATH="$PATH:/usr/local/texlive/2024/bin/aarch64-linux"
ENV MANPATH="$MANPATH:/usr/local/texlive/2024/texmf-dist/doc/man"
ENV INFOPATH="$INFOPATH:/usr/local/texlive/2024/texmf-dist/doc/info"
