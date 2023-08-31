#!/bin/sh

if [ ! -z "${STAT_CMD_COMMIT_REPORT}" -a -x "${STAT_CMD_COMMIT_REPORT}" ]; then
  ${STAT_CMD_COMMIT_REPORT}
else
  echo "No commit-report command set in STAT_CMD_COMMIT_REPORT."
fi
