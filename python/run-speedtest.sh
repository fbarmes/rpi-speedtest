#!/usr/bin/env sh

#-- setup.
PYTHON_SCRIPT=/opt/python/speedtest_exporter.py
PROM_TARGET_DIR="/opt/speedtest_data/prom"
CSV_TARGET_DIR="/opt/speedtest_data/csv"

PROM_FILE_TMP='/tmp/speedtest.prom$$'
PROM_FILE="${PROM_TARGET_DIR}/speedtest.prom"
CSV_FILE="${CSV_TARGET_DIR}/speedtest.csv"

#-- make sure paths exist
mkdir -pv ${PROM_TARGET_DIR}
mkdir -pv ${CSV_TARGET_DIR}

#-- run script
${PYTHON_SCRIPT} --prom-file ${PROM_FILE_TMP} --csv-file ${CSV_FILE}

#-- atomically move temp file
mv ${PROM_FILE_TMP} ${PROM_FILE}
