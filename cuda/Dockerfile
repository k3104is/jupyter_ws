# --- builder ---
FROM ubuntu:22.04 as builder

# --- stage ---
FROM nvidia/cuda:12.5.0-devel-ubuntu22.04

ARG CUDA_VER='12.5'
ARG CUDA_ARCH='8.9'
ARG CV_VER='4.10.0'

# tzdataのタイムゾーン入力を求められないようにする
# https://tmyoda.hatenablog.com/entry/20210124/1611416396
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# https://qiita.com/orphiria/items/3b8ba0c3e23144d3f4df
RUN --mount=type=cache,target=/var/cache/apt \
  apt update && \
  apt -y install \
  build-essential cmake git pkg-config \
  python3-dev python3-numpy python3-pip libtbb2 \
  qtbase5-dev \
  qtdeclarative5-dev \
  freeglut3 freeglut3-dev libtbb-dev \
  libjpeg8-dev libpng-dev libtiff5-dev libdc1394-25 \
  libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
  libxvidcore-dev libx264-dev \
  libgtk-3-dev \
  libatlas-base-dev gfortran
  
RUN pip3 install jupyterlab

RUN git clone https://github.com/itseez/opencv.git -b ${CV_VER} && \
  git clone https://github.com/itseez/opencv_contrib.git -b ${CV_VER} && \
  cd opencv && mkdir build && cd build && \
  # --- CUDA対応有りビルド用 ---
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_TESTS=ON \
    -D WITH_PYTHON=ON \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=ON \
    -D PYTHON_DEFAULT_EXECUTABLE=python3 \
    -D WITH_MKL=ON \
    -D WITH_CUDA=ON \
    -D CUDA_FAST_MATH=ON \
    -D WITH_CUBLAS=ON \
    -D WITH_CUDNN=ON \
    -D WITH_NVCUVID=OFF \
    -D OPENCV_DNN_CUDA=OFF \
    -D BUILD_opencv_cudaimgproc=OFF \
    -D BUILD_EXAMPLES=ON \
    -D WITH_TBB=ON \
    -D WITH_V4L=ON \
    -D WITH_QT=ON \
    -D WITH_OPENGL=ON .. && \
  # --- CUDA対応無しビルド用 ---
  # cmake -D CMAKE_BUILD_TYPE=RELEASE \
  #   -D CMAKE_INSTALL_PREFIX=/usr/local \
  #   -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
  #   -D INSTALL_C_EXAMPLES=ON \
  #   -D INSTALL_PYTHON_EXAMPLES=ON \
  #   -D INSTALL_TESTS=ON \
  #   -D WITH_PYTHON=ON \
  #   -D BUILD_opencv_python2=OFF \
  #   -D BUILD_opencv_python3=ON \
  #   -D PYTHON_DEFAULT_EXECUTABLE=python3 \
  #   -D BUILD_EXAMPLES=ON \
  #   -D WITH_TBB=ON \
  #   -D WITH_V4L=ON \
  #   -D WITH_QT=ON \
  #   -D WITH_OPENGL=ON ..
  make -j$(nproc) && \
  make install && \
  /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' && \
  ldconfig

COPY ./cfg/export.sh /
RUN echo "source /export.sh" >> /root/.bashrc