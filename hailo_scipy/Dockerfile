# --- builder ---
FROM ubuntu:22.04 as builder

# --- stage ---
FROM jupyter/scipy-notebook:python-3.10

USER root
# HailoRT control software (GitHub)
RUN --mount=type=cache,target=/var/cache/apt/ \
  apt update && \
  apt install -y git curl wget vim
RUN --mount=type=cache,target=/var/cache/apt/ \
  apt install -y make gcc libelf-dev git cmake build-essential
RUN --mount=type=cache,target=/var/cache/build/ \
  git clone https://github.com/hailo-ai/hailort.git -b v4.17.0 && \
  cd hailort && \
  cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release && \
  cmake --build build --config release --target install
COPY ./bin/hailort-4.17.0-cp310-cp310-linux_aarch64.whl /
RUN pip install /hailort-4.17.0-cp310-cp310-linux_aarch64.whl

USER jovyan