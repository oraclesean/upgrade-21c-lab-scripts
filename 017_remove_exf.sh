# Reference: https://mikedietrichde.com/2017/08/04/expression-filter-rules-manager-exf-rul-clean-oracle-database-11-2-12-2

# Skip this step on 12c databases
  if [[ $ORACLE_VERSION =~ ^12 ]]
then exit 0
fi

sqlplus / as sysdba << EOF
@${ORACLE_HOME}/rdbms/admin/catnoexf.sql
EOF
