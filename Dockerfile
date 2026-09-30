# syntax=docker/dockerfile:1.7

ARG BASE_IMAGE=ubuntu:22.04

# ============================================================
# Stage 1: host-tools 构建阶段
# 执行 ./build.sh host-tools，生成通用软件包组
# ============================================================
FROM ${BASE_IMAGE} AS host-tools-builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        locales \
        gettext-base \
        autoconf \
	gawk \
        git \
        curl \
        wget \
        python3 \
        pkg-config \
        && locale-gen zh_CN.UTF-8 \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

RUN chmod +x ./main/build.sh \
    && cd ./main \
    && ./build.sh -l host-tools

# host-tools 产物统一收集到 /output/host-tools
RUN mkdir -p /output/host-tools /output/status/{host-tools,bootstrap} \
    && cp -a ./workbase/host-tools/. /output/host-tools/ \
    && cp -a ./workbase/status/host-tools/. /output/status/host-tools/ \
    && cp -a ./workbase/status/bootstrap/. /output/status/bootstrap/
