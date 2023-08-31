#!/bin/sh -xe

script_path="$(cd "$(dirname -- "$0")" || exit 1; pwd -P)"
cd "${script_path}"

# source "defaults.inc"

if [ -z "${STAT_PROJECTS}" ]; then
  echo "STAT_PROJECTS is not set; will download stats for ALL projects..."
  sleep 5
fi

[ -z "${LAST_DATE}" ] && LAST_DATE=$(ls -1 ${STAT_STORAGE} | tail -n1)
[ ! -z "${LAST_DATE}" ] && DOWNLOAD_OPTS="${DOWNLOAD_OPTS} -a ${LAST_DATE}"

if [ "${TS_NOW}" == "${LAST_DATE}" ]; then
  # Running twice on the same date: nothing to do
  echo "Stats have already been reported for today, nothing to do" 2>&1
elif [ -d "${STAT_STORAGE}/${TS_NOW}/" ]; then
  # If you run the script twice in a row on the same day, the first run will include everything from $lastTime..$now;
  # but the second run will only download $midnightToday..$now, and store the results into the same file, overwriting
  # the previous results.
  echo "Stats directory already exists; skipping download!" 2>&1
else
  DOWNLOAD_OPTS="${DOWNLOAD_OPTS} -s ${STAT_HOST} -o ${STAT_STORAGE}/${TS_NOW}/ -b ${TS_NOW}"

  [ ! -z "${STAT_PROJECTS}" ] && DOWNLOAD_OPTS="${DOWNLOAD_OPTS} ${STAT_PROJECTS}"

  ./gerrit_downloader.sh ${DOWNLOAD_OPTS}

  echo "Committing stats storage: ${STAT_STORAGE}/${TS_NOW}/"
  ${STAT_CMD_COMMIT_STATS}

fi

echo "Next: step2"
