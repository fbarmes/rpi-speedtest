
#===============================================================================
# speedtest image
#===============================================================================
FROM fbarmes/rpi-alpine:latest

#-------------------------------------------------------------------------------
# arguments
#-------------------------------------------------------------------------------

#-- for standard Linux
# ARG NODE_EXPORTER_ARCHIVE=node_exporter-0.17.0-rc.0.linux-amd64.tar.gz

#-- for raspberry pi
ARG NODE_EXPORTER_ARCHIVE=node_exporter-0.17.0-rc.0.linux-armv7.tar.gz

#-------------------------------------------------------------------------------
# update system
#-------------------------------------------------------------------------------
RUN \
  apk update && apk upgrade


#-------------------------------------------------------------------------------
# install speedtest
#-------------------------------------------------------------------------------
RUN \
  apk add python py-pip &&\
  pip install --upgrade pip &&\
  pip install speedtest-cli


#-------------------------------------------------------------------------------
# install node exporter
#-------------------------------------------------------------------------------
COPY bin/${NODE_EXPORTER_ARCHIVE} /tmp/node_exporter.tgz


RUN \
  mkdir /opt &&\
  mkdir /opt/node_exporter &&\
  tar -zxf /tmp/node_exporter.tgz --strip 1 -C /opt/node_exporter


#-------------------------------------------------------------------------------
# node exporter integration
#-------------------------------------------------------------------------------
RUN \
  mkdir /opt/textfile_collector/


#-------------------------------------------------------------------------------
# install python scripts
#-------------------------------------------------------------------------------
RUN \
  mkdir /opt/python

COPY python/speedtest_exporter.py /opt/python
COPY python/run-speedtest.sh /opt/python

#-------------------------------------------------------------------------------
# cron integration
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# wrap up
#-------------------------------------------------------------------------------
EXPOSE 9100
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh 

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
