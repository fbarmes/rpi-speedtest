#===============================================================================
# rpi-speedtest image
#===============================================================================
FROM fbarmes/rpi-alpine:latest

#-------------------------------------------------------------------------------
# arguments
#-------------------------------------------------------------------------------
ARG NODE_EXPORTER_ARCHIVE="node_exporter.tgz"

#-------------------------------------------------------------------------------
# setup system
#-------------------------------------------------------------------------------
RUN \
  # update system
  apk update && apk upgrade           &&\
  #
  # create structure
  mkdir -p /opt/textfile_collector/      &&\
  mkdir -p /opt/python                   &&\
  #
  # install speedtest
  apk add python py-pip               &&\
  pip install --upgrade pip           &&\
  pip install speedtest-cli


#-------------------------------------------------------------------------------
# install node exporter
#-------------------------------------------------------------------------------
COPY bin/${NODE_EXPORTER_ARCHIVE} /tmp/node_exporter.tgz

RUN \
  mkdir -p /opt/node_exporter &&\
  tar -zxf /tmp/node_exporter.tgz --strip 1 -C /opt/node_exporter

#-------------------------------------------------------------------------------
# install speedtest_exporter
#-------------------------------------------------------------------------------
COPY python/speedtest_exporter.py /opt/python
COPY python/run-speedtest.sh /opt/python

#-------------------------------------------------------------------------------
# wrap up
#-------------------------------------------------------------------------------
EXPOSE 9100
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
