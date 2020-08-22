#!/bin/bash -e

CMDSTAND_VERSION=$1
echo "==> Installing cmdstan ${CMDSTAND_VERSION}..."
rm -rf /opt/cmdstan
curl -sOL https://github.com/stan-dev/cmdstan/releases/download/v${CMDSTAND_VERSION}/cmdstan-${CMDSTAND_VERSION}.tar.gz
mkdir -p /opt/cmdstan
tar xfz cmdstan-${CMDSTAND_VERSION}.tar.gz --directory /opt/cmdstan
rm -rf cmdstan-${CMDSTAND_VERSION}.tar.gz
cd /opt/cmdstan/cmdstan-${CMDSTAND_VERSION}
echo "CXXFLAGS += -DSTAN_THREADS" > make/local
echo "CXXFLAGS += -pthread" >> make/local 
make build -j4 > /dev/null 2>&1
