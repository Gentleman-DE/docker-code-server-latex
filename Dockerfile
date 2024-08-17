FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CODE_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config"

RUN \
  echo "**** install runtime dependencies ****" && \
  apt-get update && \
  apt-get install -y \
    git \
    jq \
    libatomic1 \
    nano \
    net-tools \
    netcat \
    sudo && \
  echo "**** install code-server ****" && \
  if [ -z ${CODE_RELEASE+x} ]; then \
    CODE_RELEASE=$(curl -sX GET https://api.github.com/repos/coder/code-server/releases/latest \
      | awk '/tag_name/{print $4;exit}' FS='[""]' | sed 's|^v||'); \
  fi && \
  mkdir -p /app/code-server && \
  curl -o \
    /tmp/code-server.tar.gz -L \
    "https://github.com/coder/code-server/releases/download/v${CODE_RELEASE}/code-server-${CODE_RELEASE}-linux-amd64.tar.gz" && \
  tar xf /tmp/code-server.tar.gz -C \
    /app/code-server --strip-components=1 && \
  echo "**** clean up ****" && \
  apt-get clean && \
  rm -rf \
    /config/* \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*


    RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y texlive-lang-all asymptote biber chktex \
    cm-super context dvidvi dvipng feynmf fragmaster lacheck latex-cjk-all \
    latexmk lcdf-typetools prerex psutils purifyeps t1utils tex-gyre latexdiff \
    texlive-base texlive-bibtex-extra texlive-binaries texlive-extra-utils \
    texlive-font-utils texlive-fonts-extra texlive-fonts-extra-links \
    texlive-fonts-recommended texlive-formats-extra texlive-games \
    texlive-humanities texlive-latex-base texlive-latex-extra \
    texlive-latex-recommended texlive-luatex texlive-metapost \
    texlive-music texlive-pictures texlive-plain-generic \
    texlive-pstricks texlive-publishers texlive-science \
    texlive-xetex tipa vprerex && apt-get autoclean


# add local files
COPY /root /

# ports and volumes
EXPOSE 8443
