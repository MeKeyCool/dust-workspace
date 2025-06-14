FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y curl bash tar gzip ca-certificates && \
    apt-get clean

# ---- Install kubectl ----
ENV KUBECTL_VERSION=v1.33.1
RUN curl -L "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# ---- Install helm ----
ENV HELM_VERSION=v3.18.2
RUN curl -L "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar xz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-amd64

WORKDIR /kube

CMD ["bash"]
