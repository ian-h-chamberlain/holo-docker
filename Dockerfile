FROM scratch as builder
ADD ./steamos /
ADD ./steamos/usr/share/factory /

COPY ./packagelists/removed-packages.txt /tmp/

ARG REPO=rel
COPY ./packagelists/removed-${REPO}.txt /tmp/

RUN grep --no-filename --invert --extended-regexp '^#' -- /tmp/removed-*.txt \
    | xargs pacman --noconfirm -R

RUN sed -r -i 's/\[(jupiter|core|extra|community|multilib|holo)\]/\[\1-${REPO}\]/g' /etc/pacman.conf \
 && pacman-key --init \
 && pacman-key --populate archlinux \
 && pacman-key --populate holo \
 && pacman -Sy  \
#  && comm -1 -2  <(pacman -Qeq | sort) <(pacman -Qoq /usr/include/ | sort) | pacman -S --noconfirm - \
 && comm -1 -2  <(pacman -Qdq | sort) <(pacman -Qoq /usr/include/ | sort) \
     # Skip filesystem, which owns /etc/hosts: https://github.com/moby/buildkit/issues/1267
    | grep -vE '^filesystem$' \
    # Filter out a bunch of expected warnings for .dockerignore'd package files
    | pacman -S --noconfirm --asdeps - |& grep -vE 'could not get file information|running with faked system time' \
 && pacman -S --noconfirm gcc make autoconf automake bison fakeroot flex m4 tpm2-tss \
 && yes | pacman -Scc

FROM scratch
COPY --from=builder / /
