#!/usr/bin/env bash

shopt -s extglob

timed() {
  end=$(date +%s)
  dt=$(("$end" - $1))
  dd=$(("$dt" / 86400))
  dt2=$(("$dt" - 86400 * "$dd"))
  dh=$(("$dt2" / 3600))
  dt3=$(("$dt2" - 3600 * "$dh"))
  dm=$(("$dt3" / 60))
  ds=$(("$dt3" - 60 * "$dm"))

  LC_NUMERIC=C printf "\nTotal runtime: %02d min %02d seconds\n" "$dm" "$ds"
}

start=$(date +%s)
trap 'timed $start' EXIT

for dir in ./modules/*; do
    gradlew_exist="$dir"/gradlew
    if [[ ! -f $gradlew_exist ]]; then
      continue
    fi
      
  printf "\n=== Building module '%s' ===\n" "$(basename "$dir")"
  "$dir"/gradlew clean build -p "$dir"
done