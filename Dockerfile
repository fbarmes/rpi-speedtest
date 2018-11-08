#===============================================================================
# rpi-speedtest image
#===============================================================================
FROM fbarmes/rpi-alpine:latest

#-------------------------------------------------------------------------------
# setup system
#-------------------------------------------------------------------------------
RUN \
  # update system
  apk update && apk upgrade             &&\
  #
  # create structure
  mkdir -p /opt/speedtest_data/         &&\
  mkdir -p /opt/speedtest_data/prom     &&\
  mkdir -p /opt/python                  &&\
  #
  # install speedtest
  apk add python py-pip                 &&\
  pip install --upgrade pip             &&\
  pip install speedtest-cli

#-------------------------------------------------------------------------------
# install node exporter
#-------------------------------------------------------------------------------
COPY bin/node_exporter.tgz /tmp/node_exporter.tgz
RUN \
  mkdir -p /opt/node_exporter &&\
  tar -zxf /tmp/node_exporter.tgz --strip 1 -C /opt/node_exporter &&\
  rm /tmp/node_exporter.tgz

#-------------------------------------------------------------------------------
# install speedtest_exporter
#-------------------------------------------------------------------------------
COPY python/speedtest_exporter.py /opt/python
COPY python/run-speedtest.sh /opt/python

#-------------------------------------------------------------------------------
# edit crontab
#-------------------------------------------------------------------------------
RUN \
  # run at boot
  echo "@reboot /opt/python/run-speedtest.sh" >> /etc/crontabs/root &&\
  # run hourly
  echo "0    *       *       *       *       /opt/python/run-speedtest.sh" >> /etc/crontabs/root


#-------------------------------------------------------------------------------
# wrap up
#-------------------------------------------------------------------------------
EXPOSE 9100
VOLUME /opt/speedtest_data
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

#-- install entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
