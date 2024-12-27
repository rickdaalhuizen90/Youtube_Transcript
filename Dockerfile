FROM ghcr.io/ggerganov/whisper.cpp:main AS base

#FROM --platform=linux/arm64 base

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    g++ \
    clang \
    libstdc++-10-dev \
    && rm -rf /var/lib/apt/lists/*

COPY models /models
COPY audios /audios

RUN cmake -S . -B build
RUN cmake --build build --config Release
