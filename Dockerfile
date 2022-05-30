FROM tensorflow/tensorflow:1.15.2-gpu-py3

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-key del 3bf863cc
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub

RUN apt-get update && apt-get install -y git gpg-agent python3-cairocffi protobuf-compiler python3-pil python3-lxml python3-tk python3-opencv libportaudio2 wget

RUN useradd -ms /bin/bash tensorflow
USER tensorflow
WORKDIR /home/tensorflow

RUN git clone https://github.com/tensorflow/models.git
RUN chown tensorflow .

RUN (cd /home/tensorflow/models/research/ && protoc object_detection/protos/*.proto --python_out=.)
WORKDIR /home/tensorflow/models/research/

RUN cp object_detection/packages/tf1/setup.py ./
ENV PATH="/home/tensorflow/.local/bin:${PATH}"

RUN python -m pip install --user -U pip
RUN python -m pip install --user .

ENV TF_CPP_MIN_LOG_LEVEL 3
