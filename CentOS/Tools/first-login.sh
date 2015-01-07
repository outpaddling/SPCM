#!/bin/sh -e

while [ ! -e $HOME/.pwchanged ]; do
    if cluster-passwd; then
	touch $HOME/.pwchanged
    fi
done

