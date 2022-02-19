#!/bin/bash

## create build dir
mkdir -p build/

## package
helm package -u -d build/ src/*

## create new index with only the new modified charts
helm repo index --merge docs/index.yaml build/

## copy new index ot the final repo location
cp -f build/index.yaml docs/
cp -f build/*.tgz docs/

## clean up
rm -Rf build/