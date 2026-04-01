#!/bin/sh
apk add --no-cache curl jq > /dev/null 2>&1

GRAFANA_HOST="${GRAFANA_HOST:-grafana:3000}"
GRAFANA_USER="$1"
GRAFANA_PASSWORD="$2"
DASHBOARD_SLUG="$3"
DASHBOARD_DIR="/project/data/dashboards"

mkdir -p "$DASHBOARD_DIR"

echo ""
echo "Fetching dashboard list from Grafana..."
dashboards=$(curl -sf -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
  "http://${GRAFANA_HOST}/api/search?type=dash-db")

echo "$dashboards" | jq -c '.[]' | while read -r dashboard; do
  uid=$(echo "$dashboard" | jq -r '.uid')
  title=$(echo "$dashboard" | jq -r '.title')
  slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')

  if [ -n "$DASHBOARD_SLUG" ] && [ "$slug" != "$DASHBOARD_SLUG" ]; then
    continue
  fi

  echo "Exporting '${title}'..."
  curl -sf -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
    "http://${GRAFANA_HOST}/api/dashboards/uid/${uid}" \
    | jq '.dashboard' \
    > "${DASHBOARD_DIR}/${slug}.json"
  echo "  -> ${slug}.json"
done

echo "Done."
