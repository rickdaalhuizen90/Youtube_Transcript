# YouTube Transcription Script

This script allows you to transcribe the audio from a YouTube video and save the transcription to a text file.

## Key Features
- Extracts audio from YouTube videos using FFmpeg and yt-dlp
- Transcribes audio using the Whisper.cpp library (port of OpenAI's Whisper model)
- Saves transcription to a specified output file

## Prerequisites

- FFmpeg (for audio extraction)
- Whisper.cpp (for accessing the Speech-to-Text API)
- The following packages:
  - `yt-dlp`

## Getting Started

1. Install whisper.cpp: https://github.com/ggerganov/whisper.cpp
2. Download model and place it in ./models: https://huggingface.co/ggerganov/whisper.cpp/tree/main
3. Make the transcription script executable:

```bash
chmod +x ./transcribe.sh
```

4. Build the Docker image (optional):

```bash
make build
```

## Usage

```bash
./transcribe.sh -u <youtube_video_url> -o <output_file>
```

Example:

```bash
./transcribe.sh -u https://www.youtube.com/watch?v=ke6AVZvDVPg -o transcript.txt
```

## Notes

- The script uses FFmpeg to extract the audio from the YouTube video and `yt-dlp` to download the video.
- Transcriptions may have limitations or inaccuracies depending on audio quality and language.
- Transcription may take some time, depending on the length of the video and the available system resources.

## Todo

- [ ] Implement an option to retrieve transcriptions directly from YouTube using their API, as an alternative to running the Whisper speech recognition model.
- [ ] Implement a web interface to enable users to access this application directly through a web browser.

## License

This project is licensed under the [MIT License](LICENSE).