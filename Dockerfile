#
# Tex をコンパイルする環境をDocker上に作成する
#
FROM ubuntu:24.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#
# 必要なパッケージをインストールします
#
RUN apt update
RUN apt -y upgrade
RUN apt -y install sudo make fontconfig
RUN apt -y install texlive-full
RUN apt -y install fonts-firacode fonts-noto
RUN apt -y install nodejs npm
RUN npm install -g textlint  textlint-plugin-latex2e textlint-rule-preset-japanese

#
# コンパイル環境を作成します
#
# コンパイルテストもします。Texは最初のコンパイル時に
# かなりの時間を要するのを削減するためです
#
ARG USERNAME=ubuntu
ARG GROUPNAME=ubuntu
USER $USERNAME
WORKDIR /home/$USERNAME/
COPY --chown=$USERNAME:$GROUPNAME src /home/$USERNAME/src
COPY --chown=$USERNAME:$GROUPNAME Makefile /home/$USERNAME/
RUN  make localbuild
RUN  make localclean
RUN  rm -r src/*
