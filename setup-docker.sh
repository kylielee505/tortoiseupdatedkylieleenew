#!/bin/bash

# Initialize and update Git submodules
git submodule init
git submodule update --remote

# Build the Docker image with the tag "ai-voice-cloning"
docker build -t ai-voice-cloning .
