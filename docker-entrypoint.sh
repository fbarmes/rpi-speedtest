#!/bin/sh
set -e

#--
# install cron jb
ln -s /opt/python/run-speedtest.sh /etc/periodic/hourly

#--
# start cron in background
crond -b

#--
# run first speedtest
echo "run first speedtest"
/opt/python/run-speedtest.sh

#--
# start node exporter
echo "start node exporter"
/opt/node_exporter/node_exporter --collector.textfile.directory /opt/speedtest_data/prom
