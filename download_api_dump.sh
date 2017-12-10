#!/bin/sh
SLEEP_BASE_INTERVAL=2
SLEEP_RANDOM_INTERVAL=5
if [[ -f "wolnelektury.json" ]]; then
  echo "Skipping main books list..."
else
  echo "Downloading main books list..."
  wget "http://wolnelektury.pl/api/books/" -O "wolnelektury.json"
fi
echo "Creating a directory for all the lil' JSONs"
mkdir -p "api_dumps"
pushd "api_dumps"
for api_url in `cat ../wolnelektury.json | jq '.[].href' --raw-output`
do
  api_slug=`basename $api_url`
  api_filename="$api_slug.json"
  if [[ -f "$api_filename" ]]; then
    echo "Skipping $api_filename"
  else
    echo "Downloading $api_filename..."
    wget "$api_url" -O "$api_filename"
    sleep_time=$(( ( RANDOM % SLEEP_RANDOM_INTERVAL ) + SLEEP_BASE_INTERVAL ))
    sleep $sleep_time
  fi
done
