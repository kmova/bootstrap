#!/bin/bash
set -e


test_if()
{
  if [ $SRC != $DST ] && [ -f "diff.txt" ];
  then
    echo "Copying diff.txt to $SRC"
  else
    echo "Not copying diff.txt to $SRC"
  fi
}

SRC="test1"
DST="test1"
test_if

SRC="test1"
DST="test2"
test_if

SRC="test1"
DST="test2"
touch diff.txt
test_if
rm diff.txt
