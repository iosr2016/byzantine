#!/bin/bash

pid_file=/var/byzantine/pid

if [ -f "$pid_file" ];
then
   kill -s QUIT `cat $pid_file`
fi
