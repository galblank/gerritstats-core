#!/bin/sh

script_path="$(cd "$(dirname -- "$0")" || exit 1; pwd -P)"
cd "${script_path}"

# source "defaults.inc"

if [ -f "${STAT_INC_INCLUDE_DIRS}" ]; then
  source "${STAT_INC_INCLUDE_DIRS}"
fi
if [ -z "${STAT_INCLUDE_DIRS}" ]; then
  echo "STAT_INCLUDE_DIRS not set; falling back to all dirs in STAT_STORAGE: ${STAT_STORAGE}/*/"
  export STAT_INCLUDE_DIRS=$(ls -d ${STAT_STORAGE}/*/ | paste -d, -s -)
fi

IGNORED=(jenkins@myyearbook.com
         jenkins@meetme.com
         jenkins@themeetgroup.com
         jira@myyearbook.com
         ios@themeetgroup.com
         anonymous_coward
         jhansche+stylebot@meetme.com
         milton@myyearbook.com
         ""
        )

# INCLUDE="--include $(IFS=, ; echo "${ANDEVS[*]}")"
EXCLUDE="--exclude $(IFS=, ; echo "${IGNORED[*]}")"

echo ${INCLUDE} ${EXCLUDE}
echo "${STAT_INCLUDE_DIRS}"
./gerrit_stats.sh ${EXCLUDE} ${INCLUDE} -f "${STAT_INCLUDE_DIRS}" -o "${STAT_REPORT_DIR}"

echo "*** Looking for rogue js' files..."
find . -name "*.js'*" -ls

echo ""
echo "Next: step3"
