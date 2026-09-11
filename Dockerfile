FROM registry.access.redhat.com/ubi9-minimal:latest AS base

RUN microdnf install -y git python3.11 python3.11-pip
RUN python3.11 -m pip install --no-cache-dir "ccx-messaging @ git+https://github.com/joselsegura/insights-ccx-messaging.git@remove_downloader"

FROM quay.io/redhat-services-prod/obsint-processing-tenant/rules-containers/rules-containers-private:2026.09.08

ENV CONFIG_PATH=/ccx-data-pipeline/config.yaml \
    HOME=/ccx-data-pipeline

WORKDIR $HOME

COPY pyproject.toml config.yaml LICENSE $HOME/

RUN pip install --no-cache-dir .

RUN rm -fr /usr/local/lib/python3.11/site-packages/ccx_messaging /usr/local/bin/ccx-messaging

COPY --from=base /usr/local/lib/python3.11/site-packages/ccx_messaging /usr/local/lib/python3.11/site-packages/ccx_messaging
COPY --from=base /usr/local/bin/ccx-messaging /usr/local/bin/ccx-messaging

RUN pip install insights-core-messaging-base>=2.0.0
RUN pip install insights-core-messaging-kafka>=2.0.0
RUN pip install insights-core-messaging-http>=2.0.0
RUN pip install -U boto3>=1.42.0
RUN pip uninstall -y s3fs

ENTRYPOINT []

CMD ["sh", "-c", "ccx-messaging $CONFIG_PATH"]
