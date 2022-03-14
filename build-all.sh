#!/usr/bin/env bash

shopt -s extglob

for dir in ./modules/*; do
    gradlew_exist="$dir"/gradlew
    if [[ ! -f $gradlew_exist ]]; then
      continue
    fi
      
  printf "\n=== Building module '%s' ===\n" "$(basename "$dir")"
  "$dir"/gradlew clean build -p "$dir"
done