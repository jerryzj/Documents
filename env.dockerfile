FROM ubuntu:latest
MAINTAINER jerryzj

RUN apt update
RUN apt upgrade
RUN apt install gcc clang vim wget curl vim git cmake 
