#!/bin/sh

rsync -av --delete compute-01:/usr/local/share/doc/ Compute-spcm-node-docs
chmod -R a+rX Compute-spcm-node-docs

