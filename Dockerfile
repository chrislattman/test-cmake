FROM ubuntu
WORKDIR $HOME/code
COPY test-project.h .
COPY test-project.c .
COPY CMakeLists.txt .
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && apt install git gnupg2 cmake build-essential -y
CMD ["/bin/bash"]



