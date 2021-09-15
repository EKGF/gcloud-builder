FROM gcr.io/cloud-builders/gcloud:latest

ARG HELM_VERSION=v3.2.4
ENV HELM_VERSION=$HELM_VERSION
ENV HELM_HOME=/builder/helm

ARG SOPS_VERSION=3.5.0
ENV SOPS_VERSION=${SOPS_VERSION}
ENV SOPS_DEB_URL="https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb"

ENV YQ_VERSION=v4.2.1

COPY helm.sh /builder/helm.sh

#
# Add some additional utilities that we're relying on
#
RUN chmod u+x /builder/helm.sh && \
    set -ex && \
    uname -a && \
    apt-get -y update && \
    apt-get -y install apt-utils bats ca-certificates curl jq unzip zip gnupg rsync && \
    mkdir -p /builder/helm/plugins /app/keys && \
    curl -SL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz && \
    tar zxvf helm.tar.gz --strip-components=1 -C /builder/helm linux-amd64 && \
    rm helm.tar.gz && \
    curl -SL ${SOPS_DEB_URL} -o sops.deb && \
    dpkg -i sops.deb && \
    apt-get install -y -f && \
    /builder/helm/helm plugin install https://github.com/futuresimple/helm-secrets && \
    curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/bin/yq && \
    chmod +x /usr/bin/yq && \
    yq --version && \
    apt-get install -y pkgdiff && \
    pkgdiff --version && \
    apt-get --purge -y autoremove && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/builder/helm/:$PATH

ENV GCS_PLUGIN_VERSION=0.3.0
ENV GPG_TTY=/dev/console

ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=1
ENV ANSI_ON=0
#
# This image name var can be used in scripts to check whether
# we're running in the context of this builder container
#
ENV IMAGE_NAME=docker.io/ekgf/gcloud-builder

RUN set -x ; which bash ; bash --version
