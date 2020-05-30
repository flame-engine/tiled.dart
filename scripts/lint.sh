#!/bin/bash -e

if [[ $(flutter format --line-length=120 -n .) ]]; then
    echo "flutter format issue"
    exit 1
fi

result=`dartanalyzer lib/`
if ! echo "$result" | grep -q "No issues found!"; then
  echo "$result"
  echo "dartanalyzer issue: lib"
  exit 1
fi

result=`dartanalyzer test/`
if ! echo "$result" | grep -q "No issues found!"; then
  echo "$result"
  echo "dartanalyzer issue: test"
  exit 1
fi

echo "success"
exit 0
