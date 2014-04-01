#!/bin/bash

xxd -c4 -b "$1" | awk -F " " '{print $5$4$3$2}'


