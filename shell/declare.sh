#!/bin/bash

get_dec_args() {
  declare -n args=$1

  args=(--declared --arguments)
}


get_dec_args dec_args
echo ${dec_args[@]}
