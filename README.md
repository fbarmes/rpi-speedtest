# Speedtest using the raspberry PI

Monitor network bandwidth from raspberry PI and expose the metric on HTTP using
prometheus format.

## Features

This container does two things :
 * runs periodically (hourly) a speedtest analysis
 * exports these data using node_exporter

## Building this image

This project uses `make` to build the image :

**Get the dependencies**  
```
mkdir -p bin
cd bin
wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0-rc.0/node_exporter-0.17.0-rc.0.linux-armv7.tar.gz
```

**Build the image**
```
make
```

## Running this image

```
docker run fbarmes/rpi-speedtest -p 9100:9100
```

## Viewing the data

Point your browser to **<http://[YOUR-RASPBERRY-IP]:9100/>**
The relevant data looks like :
```
# HELP speedtest_download download speed in Mb/s
# TYPE speedtest_download gauge
speedtest_download 9.15
# HELP speedtest_ping ping time in ms
# TYPE speedtest_ping gauge
speedtest_ping 46.982
# HELP speedtest_upload upload speed in Mb/s
# TYPE speedtest_upload gauge
speedtest_upload 60.24
```


## Speedtest image TODO

 - [x] install speedtest
 - [x] install node_exporter
 - [x] run speedtest and output data in prometheus format
 - [x] execute speedtest_exporter using cron
 - [x] add speedtest_exporter to node_exporter using textfile_collector
 - [x] expose all metrics using node_exporter


## References

**node_exporter**  
 * releases: https://github.com/prometheus/node_exporter/releases
