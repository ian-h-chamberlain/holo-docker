FROM ghcr.io/ian-h-chamberlain/holo-base:latest

RUN pacman -Sy --noconfirm go go-tools
