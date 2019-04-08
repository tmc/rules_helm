FROM ubuntu:bionic

RUN apt-get update # Last Modified: 2018-12-08
RUN apt-get install -y build-essential
RUN apt-get install -y curl unzip git
ENV PATH=/root/bin/:$PATH

WORKDIR /app
