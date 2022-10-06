#!/usr/bin/env bash
#
# Copyright 2021 by Swiss Post, Information Technology Services
#
#

docker exec -u oracle database bash <<EOF

  export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
  export ORACLE_SID=XE
  export TEMPLATE_NAME=XE_Database.dbc
  export PDB_NAME=XEPDB1
  export LISTENER_NAME=LISTENER
  export NUMBER_OF_PDBS=1
  export CREATE_AS_CDB=true
  export PATH=$ORACLE_HOME/bin:$PATH
  export LSNR=$ORACLE_HOME/bin/lsnrctl
  export SQLPLUS=$ORACLE_HOME/bin/sqlplus
  export NETCA=$ORACLE_HOME/bin/netca
  export DBCA=$ORACLE_HOME/bin/dbca
  export ORACLE_OWNER=oracle
  export RETVAL=0
  export CONFIG_NAME="oracle-xe-18c.conf"
  export CONFIGURATION="/etc/sysconfig/$CONFIG_NAME"
  export ORACLE_HOME_NAME="OraHomeXE"
  export MINIMUM_MEMORY=1048576
  export MAXIMUM_MEMORY=2097152
  export MINIMUM_MEMORY_STR="1GB"

  sqlplus -s / as sysdba <<SQLCODE
    create pfile='/opt/oracle/product/18c/dbhomeXE/dbs/initXE.ora' from memory;
    shutdown immediate;
    create spfile from pfile='/opt/oracle/product/18c/dbhomeXE/dbs/initXE.ora';
  SQLCODE
EOF

docker commit database ev/database-snap:${EVOTING_VERSION}
