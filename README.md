# Speedtest using the raspberry PI

Monitor network bandwidth from raspberry PI.

## Features

This container does two things :
 * runs periodically (hourly) a speedtest analysis
 * exports these data using node_exporter


## Speedtest image

 - [x] install speedtest
 - [x] install node_exporter
 - [x] run speedtest and output data in prometheus format
 - [x] execute speedtest_exporter using cron
 - [x] add speedtest_exporter to node_exporter using textfile_collector
 - [x] expose all metrics using node_exporter


## References

**node_exporter**  
 * releases: https://github.com/prometheus/node_exporter/releases
 *




Notes:

```
./node_exporter/node_exporter --collector.textfile.directory /opt/textfile_collector/
```
