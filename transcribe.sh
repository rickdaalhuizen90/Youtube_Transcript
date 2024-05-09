#!/bin/bash

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null
then
    echo "yt-dlp could not be found. Please install yt-dlp."
    exit 1
fi

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    echo "ffmpeg could not be found. Please install ffmpeg."
    exit 1
fi

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -u|--url) url="$2"; shift ;;
        -o|--output) output="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if required arguments are provided
if [ -z "$url" ] || [ -z "$output" ]; then
    echo "Usage: $0 -u <url> -o <output>"
    exit 1
fi

# Download audio from YouTube
yt-dlp -x \
    --abort-on-error \
    --extract-audio \
    --audio-quality 7 \
    --no-keep-video \
    --no-update \
    --ffmpeg-location $(which ffmpeg) \
    --output "./audios/audio.%(ext)s" -k \
    --audio-format flac "$url"

# Split the audio into 60-second chunks
ffmpeg -i audio.flac -f segment -segment_time 60 -c copy ./audios/chunk%03d.flac

for chunk in ./audios/chunk*.flac; do
    make whsiper ./audios/$chunk >> "$output"
done

# TODO: Pipe the transcription to ollama and summarize the results using the Modelfile.