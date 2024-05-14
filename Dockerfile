#
# Tex をコンパイルする環境をDocker上に作成する
#
FROM ubuntu:24.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update
RUN apt -y upgrade
RUN apt -y install sudo make fontconfig
RUN apt -y install texlive-full
RUN apt -y install fonts-firacode fonts-noto

ARG USERNAME=ubuntu
ARG GROUPNAME=ubuntu
USER $USERNAME
WORKDIR /home/$USERNAME/
