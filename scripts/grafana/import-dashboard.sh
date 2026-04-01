#!/bin/sh
apk add --no-cache curl jq > /dev/null 2>&1

GRAFANA_HOST="${GRAFANA_HOST:-grafana:3000}"
GRAFANA_USER="$1"
GRAFANA_PASSWORD="$2"
DASHBOARD_SLUG="$3"
DASHBOARD_DIR="/project/data/dashboards"

if [ ! -d "$DASHBOARD_DIR" ]; then
  echo "No dashboards directory found at ${DASHBOARD_DIR}"
  exit 1
fi

if [ -n "$DASHBOARD_SLUG" ]; then
  pattern="${DASHBOARD_DIR}/${DASHBOARD_SLUG}.json"
else
  pattern="${DASHBOARD_DIR}/*.json"
fi

echo ""
echo "Importing dashboards from ${DASHBOARD_DIR}..."
for file in $pattern; do
  [ -f "$file" ] || continue

  echo "Importing $(basename "$file")..."
  payload=$(jq -n --slurpfile dashboard "$file" '{
    dashboard: ($dashboard[0] | .id = null),
    overwrite: true,
    folderId: 0
  }')

  status=$(curl -sf -X POST \
    -H "Content-Type: application/json" \
    -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
    -d "$payload" \
    "http://${GRAFANA_HOST}/api/dashboards/db" \
    | jq -r '.status')

  echo "  -> ${status}"
done

echo "Done."
