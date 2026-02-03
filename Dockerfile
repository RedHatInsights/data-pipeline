FROM localhost/ccx-rules-ocp-private:new

ENV CONFIG_PATH=/ccx-data-pipeline/config.yaml \
    HOME=/ccx-data-pipeline

WORKDIR $HOME

COPY pyproject.toml requirements.txt config.yaml LICENSE $HOME

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT []

CMD ["sh", "-c", "ccx-messaging $CONFIG_PATH"]
