# KubeSec Analyzer Docker Image

Dockerfile for analyzing Kubernetes clusters for security misconfigurations.

This Docker image is designed to provide a comprehensive set of tools for analyzing Kubernetes clusters for security misconfigurations. It includes various security analysis tools such as kube-hunter, kubescape, Peirates, crictl, etcdctl, Metasploit, and more.

## Features

- **Kubernetes Security Tools**: Contains essential security tools like kube-hunter, kubescape, Peirates, crictl, etcdctl, Metasploit, etc.
- **Customization**: Easily customizable Dockerfile for adding or removing security tools based on specific requirements.
- **Easy Deployment**: Simplifies the deployment process by providing a pre-configured environment with all necessary tools installed.

## Usage

### Prerequisites

- Docker installed on your system.

### Build Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and run:

```bash
docker build -t kube-sec-analyzer .
```

### Run Docker Container

To run the Docker container interactively, execute the following command:

```bash
docker run -it --rm kube-sec-analyzer
```

This will start the container and drop you into a bash shell with all the security tools available for analysis.

## Maintainer

* Marko Winkler
* SmartTECS Cyber Security GmbH

## License
This project is licensed under the MIT License.
