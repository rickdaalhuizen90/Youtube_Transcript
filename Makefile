.PHONY: download build whisper

MODELS_DIR := ./models
AUDIOS_DIR := ./audios

download:
	echo "Downloading models..."

build:
	docker build -t whisper.cpp:main .

whisper:
	docker run -it --rm \
		-v $(MODELS_DIR):/models \
		-v $(AUDIOS_DIR):/audios \
		whisper.cpp:main "./main -m /models/ggml-base.bin -f /audios/jfk.wav"