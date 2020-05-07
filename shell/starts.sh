#!/bin/bash
set -e

starts_with() {
  INPUT=$1
  REL_SUFFIX=$(echo "$INPUT" | cut -d'-' -f2)
  if [ "$REL_SUFFIX" == "$INPUT" ] || [[ $REL_SUFFIX =~ ^RC ]]; then 
    REL_SUFFIX=""
  else
    REL_SUFFIX="-$REL_SUFFIX"
  fi
  echo "$INPUT is" $(echo "$INPUT" | cut -d'-' -f1 | rev | cut -d'.' -f2- | rev).x$REL_SUFFIX
}

starts_with "v1.10.0-RC1"
starts_with "v1.10.0"
starts_with "v1.10.1-RC1"
starts_with "v1.10.1"
starts_with "v1.10.0-ee-RC1"
starts_with "v1.10.0-ee"
starts_with "v1.10.1-ee-RC1"
starts_with "v1.10.1-ee"
starts_with "v1.10.0-custom-RC1"
starts_with "v1.10.0-custom"
starts_with "v1.10.1-custom-RC1"
starts_with "v1.10.1-custom"
starts_with "v1.10.1-hostfixid"
