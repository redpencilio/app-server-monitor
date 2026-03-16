# app-server-monitor

Application to monitor servers using Prometheus and Grafana 

## Getting started

Clone the repository and start the application using docker compose
```bash
git clone https://github.com/redpencilio/app-server-monitor.git
docker compose up -d
```

The Grafana dashboard can be accessed by setting up an SSH tunnel to port 3000
```bash
ssh my-server -L 3000:127.0.0.1:3000
```
## How-to guides
### How to add a server to be monitored
Setup a metrics stack providing server and container metrics using a [app-metrics](https://github.com/redpencilio/app-metrics). Make the dispatcher service integrate with Letsencrypt such that it's accessible by a DNS name.

Next, add the DNS name to the Prometheus configuration in `./config/prometheus.yml` on your monitor server. Restart the `prometheus` service:

```bash
docker compose restart prometheus
```

## Reference
### Configuration
#### Grafana admin password
The password for the Grafana admin user can be configured by setting the `GF_SECURITY_ADMIN_PASSWORD` environment variable on the `grafana` service.

E.g.

```yaml
services:
  grafana:
    environment:
      GF_SECURITY_ADMIN_PASSWORD: my-secret-password
```

#### Prometheus configuration and rules
Prometheus can be configured in `./config/prometheus.yml` and `./config/alertmanager.yml`. Since these files are environment specific, the config folder is listed in `.gitignore`.

How to configure scrape jobs in Prometheus is explained in [the official documentation](https://prometheus.io/docs/prometheus/latest/getting_started/).
