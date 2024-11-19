FROM ubuntu:latest

# install required packages
RUN apt-get update && \
  apt-get -y install curl git perl

# download texlive
RUN cd /tmp && \
  curl -L -o install-tl-unx.tar.gz https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
  zcat < install-tl-unx.tar.gz | tar xf - && \
  rm -rf *.tar.gz

# install texlive using profile and perl
COPY basic.profile /tmp
RUN cd /tmp/install-tl-* && \
  perl ./install-tl --no-interaction -profile ../basic.profile

# clean-up installation 
RUN cd /tmp && rm -rf install-tl-*

# attach the installation to the PATH (todo: make this version and platform independent...)
ENV PATH="$PATH:/usr/local/texlive/2024/bin/aarch64-linux"
# NOTE: by default, these are not usable in a minimized version of ubuntu
#ENV MANPATH="$MANPATH:/usr/local/texlive/2024/texmf-dist/doc/man"
#ENV INFOPATH="$INFOPATH:/usr/local/texlive/2024/texmf-dist/doc/info"

# setup latexmkrc
COPY .latexmkrc /root
RUN tlmgr install latexmk

# setup standard gitignores for TeX and attach build directory
RUN curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/TeX.gitignore -o /root/.gitignore && \
  echo "build/**/*.*" >> /root/.gitignore && \
  echo "!build/**/*.pdf" >> /root/.gitignore && \
  git config --global core.excludesFile "/root/.gitignore"
