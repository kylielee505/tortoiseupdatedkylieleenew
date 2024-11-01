# Use NVIDIA CUDA base image for GPU support
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set environment variables for non-interactive installs and timezone
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=UTC
ARG MINICONDA_VERSION=23.1.0-1
ARG PYTHON_VERSION=3.9.13

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install essential packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl wget git ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN adduser --disabled-password --gecos '' --shell /bin/bash user

# Switch to the new user
USER user
ENV HOME=/home/user
WORKDIR $HOME

# Create necessary directories
RUN mkdir -p $HOME/.cache $HOME/.config && chmod -R 777 $HOME

# Download and install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py39_$MINICONDA_VERSION-Linux-x86_64.sh && \
    chmod +x Miniconda3-py39_$MINICONDA_VERSION-Linux-x86_64.sh && \
    ./Miniconda3-py39_$MINICONDA_VERSION-Linux-x86_64.sh -b -p $HOME/miniconda && \
    rm Miniconda3-py39_$MINICONDA_VERSION-Linux-x86_64.sh

# Update PATH and initialize conda
ENV PATH="$HOME/miniconda/bin:$PATH"
RUN conda init bash && \
    conda install python=$PYTHON_VERSION -y && \
    conda clean --all -y

# Upgrade pip and install PyTorch with CUDA support
RUN python3 -m pip install --upgrade pip && \
    pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118

# Set up the application directory
RUN mkdir $HOME/ai-voice-cloning
WORKDIR $HOME/ai-voice-cloning

# Copy modules and install dependencies
COPY --chown=user:user modules modules
RUN python3 -m pip install -r ./modules/tortoise-tts/requirements.txt && \
    python3 -m pip install -e ./modules/tortoise-tts/ && \
    python3 -m pip install -r ./modules/dlas/requirements.txt && \
    python3 -m pip install -e ./modules/dlas/

# Add additional requirements and install them
COPY --chown=user:user requirements.txt requirements.txt
RUN python3 -m pip install -r ./requirements.txt

# Copy the rest of the application code
COPY --chown=user:user . $HOME/ai-voice-cloning

# Define the command to run the application
CMD ["python", "./src/main.py", "--listen", "0.0.0.0:7680"]
