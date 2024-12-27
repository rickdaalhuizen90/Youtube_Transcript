.PHONY: download build whisper

build:
	docker build --no-cache -t whisper.cpp:main .
	ollama create yt-transcript-model -f ./Modelfile

clean:
	rm -rf ./audios/*
