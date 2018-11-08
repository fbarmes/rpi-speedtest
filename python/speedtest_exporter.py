#!/usr/bin/env python

import getopt
import os
import re
import subprocess
import sys
import time
import datetime
import tzlocal

#-------------------------------------------------------------------------------
""" Run speedtest and extract the metrics
"""
def run_speedtest():

    #-- collect data
    local_tz = tzlocal.get_localzone()
    now_lima=datetime.datetime.now(tz=local_tz)

    response = subprocess.Popen('speedtest-cli --simple', shell=True, stdout=subprocess.PIPE).stdout.read()

    ping = re.findall('Ping:\s(.*?)\s', response, re.MULTILINE)
    download = re.findall('Download:\s(.*?)\s', response, re.MULTILINE)
    upload = re.findall('Upload:\s(.*?)\s', response, re.MULTILINE)


    #-- get speedtest metrics
    ping[0] = ping[0].replace(',', '.')
    download[0] = download[0].replace(',', '.')
    upload[0] = upload[0].replace(',', '.')

    return {
        'datetime':now_lima.isoformat(),
        'ping':ping[0],
        'download':download[0],
        'upload':upload[0]
        }


#-------------------------------------------------------------------------------
""" Print metrics using prometheus format
"""
def print_prometheus(file, speedtest_data):
    text = data_to_prometheus_text(speedtest_data)

    #-- write data to console
    print text

    #-- write data to file
    fh = open(file, "wt")
    fh.write(text)
    fh.close()

#-------------------------------------------------------------------------------
""" Convert speedtest data to prometheus format text
"""
def data_to_prometheus_text(speedtest_data):
    result = "";
    result += '# HELP speedtest_ping ping time in ms\n'
    result += '# TYPE speedtest_ping gauge\n'
    result += 'speedtest_ping {}\n'.format(speedtest_data['ping'])
    result += '# HELP speedtest_download download speed in Mbit/s\n'
    result += '# TYPE speedtest_download gauge\n'
    result += 'speedtest_download {}\n'.format(speedtest_data['download'])
    result += '# TYPE speedtest_upload gauge\n'
    result += '# HELP speedtest_upload upload speed in Mbit/s\n'
    result += 'speedtest_upload {}\n'.format(speedtest_data['upload'])
    return result

#-------------------------------------------------------------------------------
""" Print metrics using CSV format
"""
def print_csv(file, speedtest_data):
    csv_file_path="/opt/python/speedtest.csv"

    #-- open file
    fh = open(file,"at")

    #-- print first line
    try:
        if os.stat(file).st_size == 0:
            fh.write(get_csv_header())
            print get_csv_header()
    except:
        pass


    #-- write data
    text = data_to_csv_line(speedtest_data)
    print text
    fh.write(text)

    #-- close file
    fh.close()

#-------------------------------------------------------------------------------
""" get csv header line
"""
def get_csv_header():
    return "Date,Ping (ms),Download (Mbit/s),Upload (Mbit/s)\n"


#-------------------------------------------------------------------------------
""" Convert speedtest data to csv line
"""
def data_to_csv_line(speedtest_data):
    sep=','
    result = "";
    result += speedtest_data['datetime'] + sep
    result += speedtest_data['ping'] + sep
    result += speedtest_data['download'] + sep
    result += speedtest_data['upload']
    result += '\n'
    return result

#-------------------------------------------------------------------------------
""" script usage
"""
def usage():
    print "\nThis is the usage function\n"
    print sys.argv[0] + "\n" \
        + "\t"+"-p --prom-file <prometheus-output-file> \n" \
        + "\t"+"-c --csv-file <csv-output-file>\n'"

#-------------------------------------------------------------------------------
""" Main function
"""
def main():
    #-- default values
    prom_file=None
    csv_file=None


    #-- get command line options
    try:
        opts, args = getopt.getopt(sys.argv[1:], "p:c:h", ["help","prom-file=","csv-file="])
    except getopt.GetoptError as err:
        # print help information and exit:
        print str(err)  # will print something like "option -a not recognized"
        usage()
        sys.exit(2)

    #-- handle command line options
    for o, value in opts:
        if o == "-h":
            usage()
            sys.exit()
        elif o in ("-p", "--prom-file"):
            prom_file=value
        elif o in ("-c", "--csv-file"):
            csv_file=value
        else:
            assert False, "unhandled option"

    #-- run speedtest
    speedtest_data = run_speedtest()
    # speedtest_data= {'download': '12.68', 'ping': '25.326', 'upload': '59.17', 'datetime': '2018-11-06 12:45:05'}
    # print(speedtest_data)

    #-- output prometheus
    if(prom_file is not None):
        print_prometheus(prom_file, speedtest_data)

    #-- output csv
    if(csv_file is not None):
        print_csv(csv_file, speedtest_data)


#-------------------------------------------------------------------------------
main()
