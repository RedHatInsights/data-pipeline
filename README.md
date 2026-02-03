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
This tutorial assumes installed `uv` dependency manager.

1. Update versions of `ccx-messaging`, `ccx-rules-processing`, `ccx-rules-ocp` in `pyproject.toml`. If you are updating other package, you can add the restriction there and then remove it. For examp if you are updating `urllib3`, you can add the restriction `urllib3==2.6.3` and then clean the pyproject. If there are any dependencies broken by this change, just look in Pypi for the compatible version and add/update the restrictions.
2. Update the `uv.lock` and its dependencies:
```
uv --native-tls lock --upgrade
uv --native-tls sync
```
3. Export dependencies into `requirements.txt`
```
uv export --format requirements-txt --no-hashes > requirements.txt
```
4. Remove the `ccx-ocp-core` from the dependency list. The latest version is always pulled in automatically.

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
