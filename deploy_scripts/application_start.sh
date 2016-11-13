#!/bin/bash

cd /var/byzantine/current
nohup ./bin/byzantine start --config-file /var/byzantine/config.yml &>/dev/null &
