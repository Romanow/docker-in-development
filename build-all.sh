#!/usr/bin/env bash

set -e
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

services="$*"

for dir in ./modules/*; do
  name="$(basename "$dir")"
  gradlew_exist="$dir"/gradlew
  if [[ ! -f $gradlew_exist ]]; then
    continue
  fi

  if [[ ! "${#services[@]}" -eq 0 && ! "${services[*]}" =~ ${name} ]]; then
    printf "=== Skipping building module %s ===\n" "$name"
    continue
  fi

  printf "\n=== Building module '%s' ===\n" "$(basename "$dir")"
  "$dir"/gradlew clean build -p "$dir"
done
