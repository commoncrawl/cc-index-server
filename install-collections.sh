#!/usr/bin/bash

if [ ! -d "collections" ]; then
    mkdir collections
fi

aws s3 sync s3://commoncrawl/cc-index/collections/ collections/ --exclude "*" --include "*/cluster.idx" --include "*/metadata.yaml"

if [ $? -ne 0 ]; then
    echo "Error installing collections"
    exit 1
fi
echo "Collections installed"
