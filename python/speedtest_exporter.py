#!/usr/bin/env python

import re
import subprocess
import time

#-------------------------------------------------------------------------------
#   run speedtest
#-------------------------------------------------------------------------------
response = subprocess.Popen('speedtest-cli --simple', shell=True, stdout=subprocess.PIPE).stdout.read()
timestamp = int(round(time.time() * 1000))



ping = re.findall('Ping:\s(.*?)\s', response, re.MULTILINE)
download = re.findall('Download:\s(.*?)\s', response, re.MULTILINE)
upload = re.findall('Upload:\s(.*?)\s', response, re.MULTILINE)

#-------------------------------------------------------------------------------
# get speedtest metrics
#-------------------------------------------------------------------------------
ping[0] = ping[0].replace(',', '.')
download[0] = download[0].replace(',', '.')
upload[0] = upload[0].replace(',', '.')



#-------------------------------------------------------------------------------
# print data to stdout (prometheus format)
#-------------------------------------------------------------------------------
print '# HELP speedtest_ping ping time in ms'
print '# TYPE speedtest_ping gauge'
print 'speedtest_ping {}'.format(ping[0]);
print '# HELP speedtest_download download speed in MB/s'
print '# TYPE speedtest_download gauge'
print 'speedtest_download {}'.format(download[0]);
print '# TYPE speedtest_upload gauge'
print '# HELP speedtest_upload upload speed in MB/s'
print 'speedtest_upload {}'.format(upload[0]);
