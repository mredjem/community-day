#!/usr/bin/env bash

git config --global user.name "Travis CI"
git config --global user.email "travis@travis-ci.org"

git checkout -b gh-pages
git add . dist/*
git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"

git remote add origin-pages https://${GITHUB_API_KEY}@github.com/mredjem/community-day.git > /dev/null 2>&1
git subtree push --quiet --set-upstream --prefix dist origin-pages gh-pages
