# Server monitoring using Prometheus and Grafana

## Grafana password

The password for Grafana should be set using an environment variable.

Add a `docker-compose.override.yml` like:

```yaml
version: "3"
services:
  grafana:
    environment:
      GF_SECURITY_ADMIN_PASSWORD: something
```

## Prometheus configs

The configs for Prometheus go in `./config` and are gitignored.
