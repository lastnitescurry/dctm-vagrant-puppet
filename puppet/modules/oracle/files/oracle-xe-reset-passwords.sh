#!/bin/bash
#
#
# chkconfig: 2345 80 05
# description: This is a program that is responsible for taking care of
# configuring the Oracle Database 11g Express Edition and its associated 
# services. 
#
# processname: oracle-xe 
# Red Hat or SuSE config: /etc/sysconfig/oracle-xe
# Debian or Ubuntu config: /etc/default/oracle-xe
#
# change log:
#	svaggu 02/19/11 -  /etc/oratab permissions are updated to 664
#	svaggu 12/20/10 -  apex updates.
#	svaggu 07/28/10 -  Creation
#
# Brian July 2015 - repurpose to reset oracle passwords

# Source fuction library
if [ -f /lib/lsb/init-functions ]
then
	. /lib/lsb/init-functions
elif [ -f /etc/init.d/functions ]
then
	. /etc/init.d/functions
fi

# Set path if path not set (if called from /etc/rc)
case $PATH in
    "") PATH=/bin:/usr/bin:/sbin:/etc
        export PATH ;;
esac

# Save LD_LIBRARY_PATH
SAVE_LLP=$LD_LIBRARY_PATH
RETVAL=0
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export ORACLE_SID=XE
export ORACLE_BASE=/u01/app/oracle
export PATH=$ORACLE_HOME/bin:$PATH
LSNR=$ORACLE_HOME/bin/lsnrctl
SQLPLUS=$ORACLE_HOME/bin/sqlplus
ORACLE_OWNER=oracle
LOG="$ORACLE_HOME_LISTNER/listener.log"

if [ -z "$CHOWN" ]; then CHOWN=/bin/chown; fi
if [ -z "$CHMOD" ]; then CHMOD=/bin/chmod; fi
if [ -z "$HOSTNAME" ]; then HOSTNAME=/bin/hostname; fi
if [ -z "$NSLOOKUP" ]; then NSLOOKUP=/usr/bin/nslookup; fi
if [ -z "$GREP" ]; then GREP=/usr/bin/grep; fi
if [ ! -f "$GREP" ]; then GREP=/bin/grep; fi
if [ -z "$SED" ]; then SED=/bin/sed; fi
if [ -z "$AWK" ]; then AWK=/bin/awk; fi
if [ -z "$SU" ];then SU=/bin/su; fi

export LC_ALL=C

if [ $(id -u) != "0" ]
then
    echo "You must be root user to run the configure script."
    exit 1
fi

echo  alter user sys identified by vagrant\; | $SU -s /bin/bash $ORACLE_OWNER -c "$SQLPLUS -s / as sysdba" > /dev/null 2>&1
echo  alter user system identified by vagrant\; | $SU -s /bin/bash $ORACLE_OWNER -c "$SQLPLUS -s / as sysdba" > /dev/null 2>&1

# Enabling Remote HTTP Connection to the Database
# http://docs.oracle.com/cd/E17781_01/server.112/e18804/network.htm#ADMQS171

#echo  EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE)\; | $SU -s /bin/bash $ORACLE_OWNER -c "$SQLPLUS -s / as sysdba" > /dev/null 2>&1

exit 0
