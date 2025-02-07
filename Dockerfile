# Use an official Ubuntu base image
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and clean up
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    wget \
    curl \
    tar \
    cmake \
    git \
    m4 \
    autoconf \
    automake \
    libtool \
    python3 \
    python3-pip \
    ssh \
    dos2unix \
    flex \
    pkg-config \
    libpmix-dev \
    libevent-dev \
    hwloc \
    libhwloc-dev \
    libxml2-dev \
    xmlto \
    docbook-xsl \
    libxslt-dev \
    zlib1g-dev \
    perl \
    graphviz \
    libeigen3-dev \
    libboost-dev \
    nlohmann-json3-dev \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Clone the SimGrid repository with submodules
RUN git clone --recursive https://github.com/simgrid/simgrid.git /opt/simgrid

# Build and install SimGrid using Ninja
RUN cd /opt/simgrid \
    && mkdir build && cd build \
    && cmake -G Ninja .. \
    && ninja \
    && ninja install \
    && ldconfig

# Set PATH for SimGrid
ENV PATH="/usr/local/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

# Configure SSH for MPI
RUN ssh-keygen -q -N "" -f /root/.ssh/id_rsa \
    && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys \
    && chmod 600 /root/.ssh/authorized_keys

# Set default command
CMD ["bash"]
