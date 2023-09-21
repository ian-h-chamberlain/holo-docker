FROM ghcr.io/ian-h-chamberlain/holo-base:latest

RUN pacman -Sy --noconfirm rustup && rustup install stable
