#!/bin/bash

# Check if a YAML configuration file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <config.yaml>"
    exit 1
fi

# Set the command to execute the training script with the provided YAML file
CMD="python3 ./src/train.py --yaml $1"

# Define the path to the AI voice cloning project
CPATH="/home/user/ai-voice-cloning"

# Run the Docker container with the specified settings
docker run --rm --gpus all \
    --mount "type=bind,src=$PWD/models,dst=$CPATH/models" \
    --mount "type=bind,src=$PWD/training,dst=$CPATH/training" \
    --mount "type=bind,src=$PWD/voices,dst=$CPATH/voices" \
    --mount "type=bind,src=$PWD/bin,dst=$CPATH/bin" \
    --mount "type=bind,src=$PWD/src,dst=$CPATH/src" \
    --workdir $CPATH \
    --ipc host \
    --user "$(id -u):$(id -g)" \
    -it ai-voice-cloning $CMD
