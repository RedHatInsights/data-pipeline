# CCX Data Pipeline

[![Python 3.7](https://img.shields.io/badge/python-3.7-blue.svg)](https://www.python.org/downloads/release/python-370/)

- [CCX Data Pipeline](#ccx-data-pipeline)
  - [Description](#description)
  - [Update dependencies](#update-dependencies)
  - [Benchmark tests](#benchmark-tests)

## Description

CCX Data Pipeline service intends to get Insights gathered archives and analyzes
them using the Insights framework in order to generate a report with the rules
hit by the content of the archive.

This report is published back in order to be consumed by other services.

This service is built on top of [insights-ccx-messaging](https://github.com/RedHatInsights/insights-ccx-messaging)
and [insights-core-messaging framework](https://github.com/RedHatInsights/insights-core-messaging).

Please refer to [insights-ccx-messaging/docs](https://github.com/RedHatInsights/insights-ccx-messaging/tree/main/docs) documentation for more details.

## Update dependencies

Just force a rebuild of the container image with a commit.

## Benchmark tests

In `test/benchmark_test.py` file there are benchmark tests to measure the service
performance. To perform those test the pipeline must be running, either
[locally](https://ccx.pages.redhat.com/ccx-docs/docs/processing/howto/local_edp/) or
in an [ephemeral cluster](https://ccx.pages.redhat.com/ccx-docs/docs/processing/howto/ephemeral_env/).
If you're running tests locally you can tweak the tests configuration by setting the
proper environment variables (a list with description can be found in `deploy/benchmark.yaml`).
To run the test in an ephemeral cluster you need to add the following service to
your `test.yaml` file:

```
- name: ext-pipeline-benchmark
      host: github
      repo: RedHatInsights/data-pipeline
      path: deploy/benchmark.yaml
      ref: main
      parameters:
        IMAGE: quay.io/ccxdev/data-pipeline  # you can push a local image for testing or use the one in prod
        IMAGE_TAG: latest
```

The last step is to launch the test and read the output:

`python test/benchmark_test.py`
