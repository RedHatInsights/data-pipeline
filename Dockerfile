FROM quay.io/redhat-services-prod/obsint-processing-tenant/rules-containers/rules-containers-private:2026.08.11

ENV CONFIG_PATH=/ccx-data-pipeline/config.yaml \
    HOME=/ccx-data-pipeline

WORKDIR $HOME

COPY pyproject.toml config.yaml LICENSE $HOME/

RUN pip install --no-cache-dir .

ENTRYPOINT []

CMD ["sh", "-c", "ccx-messaging $CONFIG_PATH"]
