#!/bin/bash

echo "@0" > $2
xxd -c4 -b "$1" | awk -F " " '{print $5$4$3$2}' >> "$2"


