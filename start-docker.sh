#!/bin/bash

# Command to run the main Python script with any provided arguments
CMD="python3 ./src/main.py $@"

# Set the base path for the container
CPATH="/home/user/ai-voice-cloning"

# Run the Docker container with specified configurations
docker run --rm --gpus all \
    --mount "type=bind,src=$PWD/models,dst=$CPATH/models" \
    --mount "type=bind,src=$PWD/training,dst=$CPATH/training" \
    --mount "type=bind,src=$PWD/voices,dst=$CPATH/voices" \
    --mount "type=bind,src=$PWD/bin,dst=$CPATH/bin" \
    --workdir $CPATH \
    --user "$(id -u):$(id -g)" \
    --net host \
    -it ai-voice-cloning $CMD
