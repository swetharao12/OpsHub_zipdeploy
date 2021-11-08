#! /bin/sh
################################################################################
#
#  Company:     American Airlines
#  Program:     Horizon
#  Project:     FlightHub
#  Author:      Robert Shrimpton
#  Modified:    Wendy Wyrick
#  Modified:	Nancy Alton
#  Description: Heartbeat Activator/Deactivator
#  Syntax: Heartbeat on|off [CheckFSM.sh]
#
################################################################################

Usage()
{
  printf "Usage: ${0} on|off [CheckFSM.sh]\n"
}

Driver()
{
  # check for valid parameters and if valid, run either onCheckScript function or offCheckScript function
  # depending whether the script passed in is one to on the check script or turn off the check script
  command=`echo $* | awk '\
  {
     if ( $0 ~ /^ *(on|off) *(CheckFSM.sh)*$/ )
     {
        if ( $0 ~ /^ *on*$/ )
           print "on CheckFSM.sh";
        else 
        if ( $0 ~ /^ *off *$/ )
           print "off CheckFSM.sh";
        else
           printf("%s %s\n", $1, $2);
     } 
     else print "Usage";
  }'`
  first_arg=`echo ${command} | awk '{ print $1; }'`;
  if [ "${first_arg}X" = "UsageX" ]
     then
     Usage;
     exit 100;
  fi
  SCRIPT=`echo ${command} | awk '{ print $2; }'`;
  if [ "${first_arg}" = "on" ]
     then
     onCheckScript;
  else
     offCheckScript;
  fi

}

onCheckScript()
{
  if [ -x ${SCRIPT}.not_running ]
      then
      echo "Turning on ${SCRIPT} (rename ${SCRIPT}.not_running to ${SCRIPT})";
      mv ${SCRIPT}.not_running ${SCRIPT}
  else
      if [ -x ${SCRIPT} ]
         then
         echo "${SCRIPT} already exists, and ${SCRIPT}.not_running does not exist, so nothing to do.";
      else
         if [ ! -x ${SCRIPT} ]
            then
            echo "both ${SCRIPT} and ${SCRIPT}.not_running do not exist ... fatal error";
            exit 100;
         fi
      fi
   fi
}

offCheckScript()
{
   if [ -x ${SCRIPT} ]
      then
      echo "Turning Heartbeat Off (rename ${SCRIPT} to ${SCRIPT}.not_running)";
      mv -i ${SCRIPT} ${SCRIPT}.not_running
   else
      if [ ! -x ${SCRIPT}.not_running ]
      then
         echo "${SCRIPT}.not_running does not exist";
         exit 100;
      fi
      if [ -x ${SCRIPT}.not_running ]
      then
         echo "${SCRIPT}.not_running already exists, and ${SCRIPT} does not exist, so nothing to do.";
      fi
   fi
    
}

cd `dirname $0`
Driver $*
