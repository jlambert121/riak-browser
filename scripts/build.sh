#!/bin/bash

VERSION="0.0.1"
BUILD_DIR="/tmp/riak-browser-build"

PWD=`pwd`

# Clean up old temp build dir
if [ -d ${BUILD_DIR} ]; then
  rm -rf ${BUILD_DIR}
fi

# Create new layout
mkdir -p ${BUILD_DIR}/opt/riak-browser
mkdir -p ${BUILD_DIR}/etc/init.d

# Copy files to layout
cd ..
cp -a * ${BUILD_DIR}/opt/riak-browser
cp scripts/riak-browser.init ${BUILD_DIR}/etc/init.d/riak-browser
chmod a+x ${BUILD_DIR}/etc/init.d/riak-browser
cd ${BUILD_DIR}/opt/riak-browser

# Bundle dependencies
bundle install --path=vendor/bundle --binstubs --standalone

# Create the rpm
fpm \
  -s dir \
  -t rpm \
  -v ${VERSION} \
  --iteration '1' \
  -n riak-browser \
  -a noarch \
  --vendor 'LetsEvenUp.com' \
  --maintainer "Justin Lambert" \
  --config-files /opt/riak-browser/config.ru \
  --rpm-user root \
  --rpm-group root \
  -x opt/riak-browser/.git* \
  -x opt/riak-browser/scripts \
  -d rubygem-bundler \
  -p /tmp \
  -C ${BUILD_DIR} .

# Clean up
cd ${PWD}
rm -rf ${BUILD_DIR}
