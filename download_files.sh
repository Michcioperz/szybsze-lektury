#!/bin/sh
SLEEP_BASE_INTERVAL=1
SLEEP_RANDOM_INTERVAL=2
if [[ -d "api_dumps" ]]; then
  echo "Creating a directory for all the lil' files"
  mkdir -p "file_dumps"
  pushd "file_dumps"
  for api_dump in ../api_dumps/*.json
  do
    for file_url in `cat $api_dump | jq '.pdf, .txt, .epub, .xml, .fb2, .mobi, .cover' --raw-output | grep -v '^$'`
    do
      file_name=`basename $file_url`
      if [[ -f "$file_name" ]]; then
        echo "Skipping $file_name"
      else
        echo "Downloading $file_name..."
        wget "$file_url" -O "$file_name"
        sleep_time=$(( ( RANDOM % SLEEP_RANDOM_INTERVAL ) + SLEEP_BASE_INTERVAL ))
        sleep $sleep_time
      fi
    done
  done  
else
  echo "api_dumps directory does not exist"
  return 1
fi
