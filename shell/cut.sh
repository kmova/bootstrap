#!/bin/bash
set -e

cut_first_matching_char() {
  echo "$1 is" $(echo "${1#v}")
}

cut_first_matching_char "v1.10.0-RC1"
cut_first_matching_char "v1.10.0"
cut_first_matching_char "v1.10.1-RC1"
cut_first_matching_char "v1.10.1"
cut_first_matching_char "v1.10.0-ee-RC1"
cut_first_matching_char "v1.10.0-ee"
cut_first_matching_char "v1.10.1-ee-RC1"
cut_first_matching_char "v1.10.1-ee"
cut_first_matching_char "v1.10.0-custom-RC1"
cut_first_matching_char "v1.10.0-custom"
cut_first_matching_char "v1.10.1-custom-RC1"
cut_first_matching_char "v1.10.1-custom"
cut_first_matching_char "v1.10.1-hostfixid"
