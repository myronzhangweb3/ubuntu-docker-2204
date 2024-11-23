FROM ubuntu:22.04

ARG user=duapple

LABEL maintainer="abc" email="1@qq.com"

RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    wget \
    vim \
    git \
    build-essential \
    cmake \
    protobuf-compiler \
    libudev-dev \
    pkg-config \
    clang \
    lsof \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.21.1.linux-amd64.tar.gz \
    && rm go1.21.1.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

RUN go version

RUN useradd --create-home --no-log-init --shell /bin/bash ${user} \
    && adduser ${user} sudo \
    && echo "${user}:123123" | chpasswd

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && /root/.cargo/bin/rustup toolchain install 1.74.0 \
    && /root/.cargo/bin/rustup default 1.74.0

ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /home/${user}

USER ${user}