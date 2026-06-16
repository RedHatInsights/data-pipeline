# FIXME(CCXDEV-16469): temporary workaround to restore git, sqlite-libs, krb5-libs removed from base image
# hadolint ignore=DL3007
FROM registry.access.redhat.com/ubi9/ubi:latest AS builder

# hadolint: DL4006 - set pipefail so pipe failures in rpm2cpio | cpio are caught
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint: DL3003 - use WORKDIR instead of cd in RUN for dnf --downloaddir
WORKDIR /tmp/rpms

# hadolint ignore=DL3041
RUN dnf install -y cpio && \
    dnf install -y --downloadonly --downloaddir=/tmp/rpms git-core && \
    dnf reinstall -y --downloadonly --downloaddir=/tmp/rpms sqlite-libs krb5-libs && \
    dnf clean all && \
    mkdir -p /tmp/extracted && \
    for rpm in *.rpm; do rpm2cpio "$rpm" | cpio -idmv -D /tmp/extracted; done

FROM quay.io/redhat-services-prod/obsint-processing-tenant/rules-containers/rules-containers-private:2026.06.16

ENV CONFIG_PATH=/ccx-data-pipeline/config.yaml \
    HOME=/ccx-data-pipeline

WORKDIR $HOME

COPY pyproject.toml config.yaml LICENSE $HOME/

COPY --from=builder /tmp/extracted /

# FIXME(CCXDEV-16469): Clean up unnecessary packages with CVEs as in private rules container Dockerfile
RUN pip install --no-cache-dir . && \
    rm -rf /usr/bin/git* /usr/bin/scalar /usr/libexec/git-core \
           /usr/bin/ssh* /usr/bin/scp /usr/bin/sftp /usr/libexec/openssh \
           /usr/lib64/libsqlite3.so* /usr/lib64/libgssapi_krb5.so* /usr/lib64/libkrb5*.so* /usr/lib64/libk5crypto.so*

ENTRYPOINT []

CMD ["sh", "-c", "ccx-messaging $CONFIG_PATH"]
