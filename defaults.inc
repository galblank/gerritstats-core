#!/bin/sh
# Import this script, followed by the custom override properties


export STAT_HOST="gerrit.meetmecorp.com:29418"

# The date of today's data pull, used as the output storage directory
export TS_NOW=$(date +%Y-%m-%d)

# The directory where downloaded data will be stored (in subdirectories here)
export STAT_STORAGE="gerrit_out"

# The directory where the report will be generated
export STAT_REPORT_DIR="out-html"

# empty means ALL projects
export STAT_PROJECTS="-p Android/MeetMe -p Android/Skout -p Android/Tagged -p Android/broadcast-video -p Android/mopub-extras -p Android/sns -p Android/utils"

export STAT_JS_COMPILE="${STAT_LIB_PATH}/js-compile"

# Commit stats; Use ${STAT_STORAGE}/${TS_NOW}/ for stats download directory
export STAT_CMD_COMMIT_STATS="echo Not committing downloaded stats!"
# Commit generated reports; Use ${STAT_REPORT_DIR} for output to commit
export STAT_CMD_COMMIT_REPORT="echo Not committing generated reports!"

if [ ! -z "${STAT_SOURCE}" -a -f "${STAT_SOURCE}" ]; then
  source "${STAT_SOURCE}"
else
  echo "Not using local stats properties: ${STAT_SOURCE}. Falling back to defaults."
fi

if [ -z "${SED}" ]; then
  if [ "$(uname)" == "Darwin" ]; then
    SED="sed -i ''"
  else
    SED="sed --in-place"
  fi
fi
