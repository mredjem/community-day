#!/usr/bin/env bash
git config --global user.name "Travis CI"
git config --global user.email "travis@travis-ci.org"

git checkout -b gh-pages
git rm -rf .
git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
git push origin gh-pages

git checkout master
git subtree split --prefix dist -b gh-pages
git push -f origin gh-pages:gh-pages
git branch -D gh-pages
