#!/bin/bash 

if [[ -z "${CI}" ]]; then
  echo 'Cannot run insall.sh unless in CI'
  exit 0
fi

BRANCH=$1
BASE_BRANCH=$2

cd ../
echo "Cloning pro repo..."
git clone https://$PERSONAL_ACCESS_TOKEN@github.com/Budibase/budibase-pro.git

# Community forks won't be able to clone the pro repo as they can't access secrets
# Skip the rest of the installation and rely on npm version instead
# This should be ok as forks will not rely on pro changes
if [[ -d "budibase-pro" ]]; then
  cd budibase-pro

  # Try to checkout the matching pro branch
  git checkout $BRANCH
  # Try to checkout the matching pro base (master or develop) branch
  git checkout $BASE_BRANCH
  # If neither branch exists continue with default branch 'develop'
  git pull

  echo "Initializing pro repo..."
  yarn setup
fi