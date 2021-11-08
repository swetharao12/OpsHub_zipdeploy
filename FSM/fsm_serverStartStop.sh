#!/bin/bash
#"Usage: $0 { start | stop }"
#####################################################################
# Metron Aviation, Inc
# FSM Server Startup Script For UNIX/Linux
#
# FSM_ROOT      Path to FSM Root Directory
# J2SE_HOME     Path to Java JRE
# CLASSPATH     Java Class File Search Path
# PATH          Standard Search Path
#
# $Id: start_fsm_server 3 2005-07-20 18:21:29Z huynhdo $
#
#####################################################################

case "$1" in
'start')

echo "Starting FSM Server"
echo "-------------------------"

#. /etms/fsm/jfsm.env
. ./jfsm.env
cd $FSM_ROOT

CLASSPATH=$FSM_ROOT/fsm_server.jar:$FSM_ROOT/fsm_lib.jar:$FSM_ROOT/genlib.jar:$FSM_ROOT/xml-apis.jar:$FSM_ROOT/xercesimpl.jar:$J2SE_HOME/lib/rt.jar
PATH=$J2SE_HOME/bin/:$PATH:.:/bin:/usr/bin:/sbin:/usr/sbin
export CLASSPATH PATH

echo "J2SE_HOME is set to " $J2SE_HOME
echo " FSM_ROOT is set to " $FSM_ROOT
echo "CLASSPATH is set to " $CLASSPATH

nohup $J2SE_HOME/bin/java -Xms128m -Xmx512m -agentpath:/opt/DT/dynatrace-7.1/agent/lib64/libdtagent.so=name=FSM_App_CDC_187227,server=hztulldtp400.horizon.cherokee.aa.com:9998 -Djava.security.manager -Djava.security.policy=$FSM_ROOT/config/policy.fsm com.metronaviation.fsm.server.Controller $FSM_ROOT/config/fsm_server.ini > $FSM_ROOT/trace/fsm_server_startup_error.log 2>&1 &

#nohup $J2SE_HOME/bin/java -Xms128m -Xmx512m -Djava.security.manager -Djava.security.policy=$FSM_ROOT/config/policy.fsm com.metronaviation.fsm.server.Controller $FSM_ROOT/config/fsm_server.ini > $FSM_ROOT/trace/fsm_server_startup_error.log 2>&1 &

#nohup /usr/lib/jvm/jre-1.6.0-openjdk.x86_64/bin/java -Xmx128m -Djava.security.manager -Djava.security.policy=$FSM_ROOT/config/policy.fsm com.metronaviation.fsm.server.Controller $FSM_ROOT/config/fsm_server.ini > $FSM_ROOT/trace/fsm_server_startup_error.log 2>&1 &
echo $?
echo "-------------------------"
#echo "FSM Server started"

   ;;
'stop')
   ##############################################################################
   # Stop the J2SE application
   ##############################################################################

   ps -ef | grep -i fsm | grep -v grep | awk '{print $2}' | xargs kill -9
   ;;
*)
   echo "Usage: $0 { start | stop }"
   exit 1
   ;;
esac
exit 0

