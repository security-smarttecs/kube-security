FROM ubuntu:22.04

LABEL description='Dockerfile for Kubernetes security analysis made by SmartTECS Cyber Security GmbH' maintainer='Marko Winkler, SmartTECS Cyber Security GmbH'

# Avoid prompts from apt to hang the build
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies, basic network tools, and Docker
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates net-tools build-essential vim curl xz-utils tmux python3-pip jq nmap netcat tcpdump gdb gnupg2 software-properties-common lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup for Kubernetes apt repository and install kubectl
RUN curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://dl.k8s.io/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and install Peirates
RUN curl -L "https://github.com/inguardians/peirates/releases/download/v1.1.15/peirates-linux-amd64.tar.xz" -o peirates-linux-amd64.tar.xz && \
    tar -xf peirates-linux-amd64.tar.xz -C /tmp/ && \
    mv /tmp/peirates-linux-amd64/peirates /usr/local/bin && \
    rm -rf /tmp/* peirates-linux-amd64.tar.xz

# Install crictl
RUN VERSION="v1.26.0" && \
    curl -L "https://github.com/kubernetes-sigs/cri-tools/releases/download/${VERSION}/crictl-${VERSION}-linux-amd64.tar.gz" --output crictl-${VERSION}-linux-amd64.tar.gz && \
    tar zxvf crictl-${VERSION}-linux-amd64.tar.gz -C /usr/local/bin && \
    rm -f crictl-${VERSION}-linux-amd64.tar.gz

# Install etcd
RUN ETCD_VER="v3.5.12" && \
    GOOGLE_URL="https://storage.googleapis.com/etcd" && \
    DOWNLOAD_URL="${GOOGLE_URL}" && \
    curl -L "${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz" -o "/tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz" && \
    tar xzvf "/tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz" -C /tmp/ --strip-components=1 && \
    mv /tmp/etcdctl /usr/local/bin/etcdctl && \
    rm -rf /tmp/*

# Install Python security tools: kube-hunter
RUN pip3 install kube-hunter

# Download deepce
RUN curl -sL https://github.com/stealthcopter/deepce/raw/main/deepce.sh -o /usr/local/bin/deepce.sh

# Install kubescape
RUN curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash

# Install Metasploit
RUN apt-get update && \
    apt-get install -y gnupg2 software-properties-common && \
    curl https://apt.metasploit.com/metasploit-framework.gpg.key | apt-key add - && \
    echo "deb https://apt.metasploit.com/ jessie main" | tee /etc/apt/sources.list.d/metasploit-framework.list && \
    apt-get update && \
    apt-get install -y metasploit-framework && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the default command for the container
CMD ["/bin/bash"]
