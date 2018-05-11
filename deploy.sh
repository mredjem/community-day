#!/usr/bin/env bash
git config --global user.name "Travis CI"
git config --global user.email "travis@travis-ci.org"

git checkout -b gh-pages
git add . dist/*
git commit -am "Travis build: $TRAVIS_BUILD_NUMBER"
git push origin gh-pages

git checkout master
git push origin `git subtree split --prefix dist gh-pages`:gh-pages --force
