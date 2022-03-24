# Reference: https://mikedietrichde.com/2017/07/29/oracle-label-security-ols-clean-oracle-database-11-2-12-2
sqlplus / as sysdba << EOF
@${ORACLE_HOME}/rdbms/admin/catnools.sql
@${ORACLE_HOME}/rdbms/admin/utlrp.sql
EOF

# For version 12, exit after this step.
  if [[ $ORACLE_VERSION =~ ^12 ]]
then exit 0
fi

# For version 11, disable lbac:
sqlplus / as sysdba << EOF
shutdown immediate
EOF

chopt disable lbac

sqlplus / as sysdba << EOF
startup
EOF
