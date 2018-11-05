#!/usr/bin/env sh

#-- setup.
TARGET_DIR="/opt/textfile_collector/"
TMP_FILE="${TARGET_DIR}/speedtest.prom$$"
TARGET_FILE=${TARGET_DIR}/speedtest.prom
PYTHON_SCRIPT=/opt/python/speedtest_exporter.py

#-- run script
${PYTHON_SCRIPT} > ${TMP_FILE}

#-- atomically move temp file
mv ${TMP_FILE} ${TARGET_FILE}
