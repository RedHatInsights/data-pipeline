# AGENTS.md

## Project overview

ccx-data-pipeline contains Clowdapp deployment files for Python services that are based on [ccx-messaging](https://github.com/RedHatInsights/insights-ccx-messaging) module and that are responsible for applying rules to the received data. Rest of deployments for services based on ccx-messaging module is in ccx-messaging repository itself. Reason why these services are in separate repository on Gitlab is that the external Konflux pipeline used for building an image in ccx-messaging repository is unable to access [ccx-rules-ocp](https://gitlab.cee.redhat.com/ccx/ccx-rules-ocp.git) dependency required for these services.

The services deployed are:

- `ccx-data-pipeline` - service used in external data pipeline for receiving Kafka message + corresponding Insights archive. It applies external rules to the data and passes result to a Kafka topic. Originally, this repository contianed this service only.
- `dvo-extractor` - essentially same as `ccx-data-pipeline`, but applying different set of rules to the data.
- `rules-processing` - applies internal rules to the received archives.

Since this repository does not contain the code for these services, refer to [AGENTS.md](https://github.com/RedHatInsights/insights-ccx-messaging/blob/main/AGENTS.md) from `insights-ccx-messaging` repository for most of the information.

## Repository structure

```
dashboards/              - Grafana dashboards for monitoring CCX services
  grafana-dashboard-insights-ccx-cronjobs.yaml
  grafana-dashboard-insights-ccx-data-pipeline.configmap.yaml
  grafana-dashboard-insights-ccx-processing-slo.configmap.yaml
  grafana-dashboard-insights-commit-distance.yaml

demos/                   - Demo applications and benchmark examples
  io-pulling-prometheus/
  notification-service/
  push-pull-model-benchmarks/

deploy/                  - Clowdapp deployment configurations
  clowdapp.yaml          - Deployment file for ccx-data-pipeline service
  dvo-extractor.yaml     - DVO extractor service deployment
  rules-processing.yml   - Rules processing configuration
  benchmark.yaml         - Benchmark testing deployment
  test.yaml              - Test environment configuration

docs/                    - Documentation (hosted on GitLab Pages)
  architecture.md
  clowder.md
  configuration.md
  deploy.md
  implementation.md
  local_setup.md
  logging.md
  prometheus.md
  references.md

research/                - Research and analysis artifacts
  cluster_id_distribution/
  old_results/
  statistic/

test/                    - Test files
  benchmark.py           - Benchmark tests

config.yaml              - Production configuration
config-devel.yaml        - Development configuration
docker-compose.yml       - Docker compose setup for local development
Dockerfile               - Container image definition
requirements.txt         - Python dependencies
Makefile                 - Build and development commands
pr_check.sh              - PR validation script
```

## Development workflow

### Setup

- **Python versions**: 3.11
- **Install dependencies**: `pip install -r requirements.txt`

### Local deployment

- **Run dependencies**: `docker compose up -d`
- **Run service**: `ccx-messaging config-devel.toml`

Service runs with configuration in `config-devel.toml`, which is using same set of classes as `ccx-data-pipeline` service. In case of running another service, the `config-devel.toml` has to be modified according to corresponding Clowdapp configuration or replaced with custom configuration file.

## Other tasks

### Running benchmark

Repository includes a script to run benchmark for Kafka producer. To run it in local environment, you need to define:

- `NO_MESSAGES` - number of messages sent by the producer
- `MESSAGE_SIZE` - size of each message
- `KAFKA_BROKER_URL` - url of the Kafka to be used
- `KAFKA_INGRESS_TOPIC` - topic to be used

After that, you can run the benchmark with `python test/benchmark.py`.
