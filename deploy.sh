#!/usr/bin/env bash
if [ -z "$1" ]
then
  echo "Choose a folder to deploy"
  exit 1
fi
git subtree push --prefix $1 origin gh-pages
