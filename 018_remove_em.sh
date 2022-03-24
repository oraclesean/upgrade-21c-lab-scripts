# Reference: https://mikedietrichde.com/2017/08/05/enterprise-manager-em-clean-up-in-oracle-database-11-2-12-2
emctl stop dbconsole

sqlplus / as sysdba << EOF
@${ORACLE_19C_HOME}/rdbms/admin/emremove.sql
EOF
