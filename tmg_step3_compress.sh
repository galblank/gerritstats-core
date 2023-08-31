#!/bin/sh

script_path="$(cd "$(dirname -- "$0")" || exit 1; pwd -P)"
cd "${script_path}"
# source "defaults.inc"

if [ $(uname) == "Darwin" ]; then
  SED_E="${SED_I} -E"
else
  SED_E="${SED_I} sed"
fi

if [ -d "${STAT_REPORT_DIR}" ]; then

LARGE_FILES="$(find "${STAT_REPORT_DIR}" -size +120M)"
for f in ${LARGE_FILES}; do
  # Github won't accept files > 150MB, so compress those by stripping the verbose [commit]message lines
  ls -l "${f}"
  ${SED_E} -e 's/"message": ".*"/"message":""/' -e 's/"commitMessage": ".*"/"commitMessage":""/' "$f"
  ls -l "${f}"
done

if [ -x "${STAT_JS_COMPILE}" ]; then
  JS_FILES="$(find . -name '*.js' -size +50M)"
  for f in ${JS_FILES}; do
    ls -l ${f}
    ${STAT_JS_COMPILE} --js "${f}" --js_output_file "${f}.c.js"
    ls -l "${f}.c.js"
    mv "${f}.c.js" "${f}"
  done
fi

else
  echo "STAT_REPORT_DIR does not exist: ${STAT_REPORT_DIR}" 2>&1
fi

echo "*** Looking for rogue js' files..."
find . -name "*.js'*" -ls

echo ""
echo "Next: step4"
