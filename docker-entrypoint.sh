#!/bin/sh
set -e

#--
# start cron in background
# this will also launch speedtest upon boot via cron
crond -b -l 1

#--
# start node exporter
/opt/node_exporter/node_exporter --collector.textfile.directory /opt/speedtest_data/prom
