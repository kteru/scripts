#!/bin/bash
#
# 20121012
# make random natural number
#

MIN=${1:-0}
MAX=${2:-9}

echo $(( ($RANDOM % ($MAX - $MIN + 1) ) + $MIN ))

