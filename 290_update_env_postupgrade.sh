# Stop the old listener:
$ORACLE_HOME/bin/lsnrctl stop

# Set the environment to use the new SID (updated in oratab by AU)
. oraenv <<< $ORACLE_SID

# Update the Docker-specific configurations.

# Copy the new oratab:
cp /etc/oratab $ORADATA/dbconfig/$ORACLE_SID/

# Copy the password and spfiles from the new 19c ORACLE_HOME:
cp $ORACLE_HOME/dbs/orapw${ORACLE_SID} $ORADATA/dbconfig/$ORACLE_SID/
cp $ORACLE_HOME/dbs/spfile${ORACLE_SID}.ora $ORADATA/dbconfig/$ORACLE_SID/

# Update the listener.ora with the new version:
sed -i 's/11.2.0.4/19c/g' $ORADATA/dbconfig/$ORACLE_SID/listener.ora
sed -i 's/12.1/19c/g' $ORADATA/dbconfig/$ORACLE_SID/listener.ora

# Rebuild links from the config to the corresponding files in the new ORACLE_HOME:
ln -fs $ORADATA/dbconfig/$ORACLE_SID/orapw${ORACLE_SID}      $ORACLE_HOME/dbs/orapw${ORACLE_SID}
ln -fs $ORADATA/dbconfig/$ORACLE_SID/spfile${ORACLE_SID}.ora $ORACLE_HOME/dbs/spfile${ORACLE_SID}.ora
ln -fs $ORADATA/dbconfig/$ORACLE_SID/listener.ora            $ORACLE_HOME/network/admin/listener.ora
ln -fs $ORADATA/dbconfig/$ORACLE_SID/sqlnet.ora              $ORACLE_HOME/network/admin/sqlnet.ora
ln -fs $ORADATA/dbconfig/$ORACLE_SID/tnsnames.ora            $ORACLE_HOME/network/admin/tnsnames.ora

# Start the listener from the new ORACLE_HOME:
$ORACLE_HOME/bin/lsnrctl start

# Report the database registry:
sqlplus / as sysdba << EOF
col comp_name for a40
select comp_name, version, version_full, status from dba_registry;
EOF
