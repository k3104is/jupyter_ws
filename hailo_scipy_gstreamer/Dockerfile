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

# gstreamer
# tzdataのタイムゾーン入力を求められないようにする
# https://tmyoda.hatenablog.com/entry/20210124/1611416396
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && \
    apt -y install \
    software-properties-common \
    # 必要なパッケージをインストール（必要に応じて取捨選択）
    python3-pip \
    libgl1-mesa-dev \
    libsm6 \
    git \
    wget \
    unzip \
    # OpenCV: Required build dependencies
    cmake \
    python3-dev \
    python3-numpy \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libgtk2.0-dev \
    libgtk-3-dev \
    # OpenCV: Optional Dependencies
    libpng-dev \
    libjpeg-dev \
    libopenexr-dev \
    libtiff-dev \
    libwebp-dev \
    # OpenCV のビルド時に -D WITH_QT=ON を設定するために以下が必要だった
    qtbase5-dev \
    qtdeclarative5-dev \
    # gstreamer のインストール
    # https://gstreamer.freedesktop.org/documentation/installing/on-linux.html
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    # gstreamer1.0-doc \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 \
    gstreamer1.0-pulseaudio && \
    # aptのクリア
    apt clean && rm -rf /var/lib/apt/lists/*

# OpenCV のビルドとインストール
# https://docs.opencv.org/master/d2/de6/tutorial_py_setup_in_ubuntu.html
# https://toriten1024.hatenablog.com/entry/2018/09/29/012205
# https://dlrecord.hatenablog.com/entry/2017/12/15/145356
# https://atmarkit.itmedia.co.jp/ait/articles/1704/10/news134.html
RUN mkdir /opencv && \
    cd /opencv && \
    # OpenCV のダウンロード
    wget https://github.com/opencv/opencv/archive/4.5.3.zip && \
    unzip 4.5.3.zip && \
    # OpenCV の cmake
    cd /opencv/opencv-4.5.3 && \
    mkdir build && \
    cd /opencv/opencv-4.5.3/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D BUILD_DOCS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_TESTS=OFF \
    -D WITH_1394=OFF \
    -D WITH_GSTREAMER=ON \
    -D WITH_FFMPEG=OFF \
    # cv2.waitKey() を使うためには WITH_QT=ON にする必要があった
    -D WITH_QT=ON \
    .. && \
    # OpenCV のビルド ※ $(nproc) はコア数を返す、make を並列処理させて高速化したい場合は指定する
    #make -j${nproc} && \
    #make -j3 && \
    make && \
    make install && \
    # 後始末
    rm -rf /opencv

# 必要なプラグインをインストール（必要に応じて取捨選択）
RUN pip3 install \
    pyyaml \
    pymongo \
    flask \
    pytest \
    mongomock

USER jovyan