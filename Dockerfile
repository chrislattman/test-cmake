FROM ubuntu
WORKDIR $HOME/code
COPY test-project.h .
COPY test-project.c .
COPY CMakeLists.txt .
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && \
    apt install -y git gnupg2 cmake build-essential && apt clean
CMD ["/bin/bash"]
