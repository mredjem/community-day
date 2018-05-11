#!/usr/bin/env bash
git checkout master
git subtree split --prefix dist -b gh-pages
git push -f "https://${GITHUB_API_KEY}@github.com/mredjem/community-day.git" gh-pages:gh-pages
git branch -D gh-pages
