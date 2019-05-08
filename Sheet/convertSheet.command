#!/bin/bash
echo `cd $(dirname $0); pwd`
CURDIR=`cd $(dirname $0); pwd`
python $CURDIR/convert2lua.py $CURDIR $CURDIR/../CoreLogic/Data -cs