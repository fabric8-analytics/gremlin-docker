#!/bin/bash

set -ex

. cico_setup.sh
docker pull prod.registry.devshift.net/osio-prod/base/jboss-jdk-8:latest
docker images

build_image

push_image
