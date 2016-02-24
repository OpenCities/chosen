#!/bin/sh

set -e

CURRENT_BRANCH=`git name-rev --name-only HEAD`

if [ $CURRENT_BRANCH != 'master' ] ; then
  echo "Build not on master. Skipped chosen-package release"
  exit 0
fi

CHOSEN_VERSION=`git tag --sort=v:refname | tail -1`

git clone https://pfiller:${GH_TOKEN}@github.com/harvesthq/bower-chosen.git
rm -rf bower-chosen/*
cp README.md public/*.json public/*.png public/chosen.jquery.js public/chosen.css bower-chosen/
cd bower-chosen

git config user.email "chosen@harvesthq.com"
git config user.name "chosen-package"

LATEST_VERSION=`git tag --sort=v:refname | tail -1`

if [ "$LATEST_VERSION" = "$CHOSEN_VERSION" ] ; then
  echo "No Chosen version change. Skipped tagging"
else
  echo "Chosen version changed. Tagging version ${CHOSEN_VERSION}\n"
  git tag -a "${CHOSEN_VERSION}" -m "Version ${CHOSEN_VERSION}"
fi

git remote set-url origin https://pfiller:${GH_TOKEN}@github.com/harvesthq/bower-chosen.git

git add -A
git commit -m "Chosen build to bower-chosen"
git push origin master
git push origin --tags

echo "Chosen published to harvesthq/bower-chosen"
