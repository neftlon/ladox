FROM ubuntu:latest

# install required packages
RUN apt-get update && apt-get install -y \
  curl git locales perl \
  && rm -rf /var/lib/apt/lists/*

# setup locale such that perl is happy
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# setup standard gitignores for TeX and attach build directory
RUN curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/TeX.gitignore -o /root/.gitignore && \
  echo "build/**/*.*" >> /root/.gitignore && \
  echo "!build/**/*.pdf" >> /root/.gitignore && \
  git config --global core.excludesFile "/root/.gitignore"

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
RUN tlmgr install latexmk
COPY .latexmkrc /root
