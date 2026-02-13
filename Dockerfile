FROM quay.io/redhat-services-prod/obsint-processing-tenant/rules-containers/rules-containers-private:2026.02.13

ENV CONFIG_PATH=/ccx-data-pipeline/config.yaml \
    HOME=/ccx-data-pipeline

WORKDIR $HOME

COPY pyproject.toml requirements.txt config.yaml LICENSE $HOME

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT []

CMD ["sh", "-c", "ccx-messaging $CONFIG_PATH"]
