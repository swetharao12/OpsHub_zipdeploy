#!/bin/bash
################################################################################
#
#  Company:     American Airlines
#  Program:     Horizon
#  Project:     FlightHub
#  Author:      Wendy Wyrick
#  Revised:	Nancy Alton
#  Description: CheckFSM - Program for check status of the FSM process.
#
################################################################################
#
# 
#
################################################################################
# Check to make sure the start script is found and can be executed.
# Check to make sure java process is running, if not running, start it.
################################################################################

echo "["$(date)"]" "=== Starting $0 ==="

cd $(dirname $0)

#check for access to start script
if [ ! -x fsm_serverStartStop.sh ]; then
 echo "["$(date)"] start_fsm_server.sh does not exist or is not executable"
 exit 1
fi

ps -e -o args | grep fsm | grep -v grep > /dev/null 2>&1 
# if any error returned from previous command line, start java process
if [[ $? -ne 0 ]]
then 
   echo "FSM process has not started, so attempting to start"
   ./fsm_serverStartStop.sh start
   if [[ $? -ne 0 ]]
      then exit 2
   fi
else
   echo "FSM process already running"
fi

echo "["$(date)"] ""=== Ending $0 ==="

exit 0
