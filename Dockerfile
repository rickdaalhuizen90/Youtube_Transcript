FROM ghcr.io/ggerganov/whisper.cpp:main AS base

FROM --platform=linux/arm64 base

WORKDIR /app

COPY models /models
COPY audios /audios

CMD ["./main", "-m", "/models/ggml-base.en.bin", "-f", "/audios/audio.flac"]