# Leaflet Telegraf Buildpack

This Leaflet Sidecar Buildpack 

1. Installs  `Telegraf v1.27.2`-binaries, see https://w2.influxdata.com/time-series-platform/telegraf/
2. Updates the telegraf config from env variables
3. Starts the agent

## Configuration

Currently supported env variables

| Name                     | Description                                                             |
| ------------------------ |-------------------------------------------------------------------------|
| PROM_REMOTE_WRITE_URL    | Prometheus endpoint to push data to (prometheusremotewrite data format) |
| PROM_REMOTE_WRITE_USER   | Basic Auth user of push endpoint                                        |
| PROM_REMOTE_WRITE_PASSWD | Basic Auth password of push endpoint                                    |






