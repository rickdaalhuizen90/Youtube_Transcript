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
    --audio-format wav "$url"

# Ensure the input file exists
input_file="./audios/audio.wav"
if [ ! -f "$input_file" ]; then
    echo "Error: Input file $input_file not found."
    exit 1
fi

# Split the audio into 60-second chunks with 16 kHz sample rate
ffmpeg -i "$input_file" -f segment -segment_time 60 -ar 16000 -ac 1 ./audios/chunk%03d.wav

for chunk in ./audios/chunk*.wav; do
    echo "Transcribing chunk $chunk..."
    docker run -it --rm \
        -v ./models:/app/models \
        -v ./audios:/app/audios \
        whisper.cpp:main "./build/bin/whisper-cli -m ./models/ggml-base.en.bin -f $chunk -otxt"
done

cat $(ls ./audios/chunk*.txt | sort -V)  > "$output"
echo "Transcription saved to $output"

ollama run yt-transcript-model "$(cat $output)"
