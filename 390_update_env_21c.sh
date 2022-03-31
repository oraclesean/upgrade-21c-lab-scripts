# Steps to add the 21c database to the Docker-specific configuration directory.

# Copy the updated oratab to the config directory:
cp /etc/oratab $ORADATA/dbconfig/$ORACLE_SID/

# Copy the existing pre-19c config directory to the new SID:
cp -rp $ORADATA/dbconfig/$ORACLE_SID $ORADATA/dbconfig/${ORACLE_SID}CDB/

# Remove the SID-specific files:
rm $ORADATA/dbconfig/${ORACLE_SID}CDB/*LAB*

# Set the environment for the 21c database:
. oraenv <<< ${ORACLE_SID}CDB

# Copy database files from the ORACLE_BASE_HOME/dbs to the config directory:
cp $ORACLE_BASE/dbs/orapw${ORACLE_SID}      $ORADATA/dbconfig/$ORACLE_SID/
cp $ORACLE_BASE/dbs/init${ORACLE_SID}.ora   $ORADATA/dbconfig/$ORACLE_SID/
cp $ORACLE_BASE/dbs/spfile${ORACLE_SID}.ora $ORADATA/dbconfig/$ORACLE_SID/

# Update the listener.ora to reflect the new home:
sed -i 's/19c/21c/g' $ORADATA/dbconfig/$ORACLE_SID/listener.ora

# Create links from the Docker configuration directory to their corresponding loctions in ORACLE_BASE_HOME and ORACLE_BASE_CONFIG:
ln -fs $ORADATA/dbconfig/$ORACLE_SID/orapw${ORACLE_SID}      $ORACLE_BASE/dbs/orapw${ORACLE_SID}
ln -fs $ORADATA/dbconfig/$ORACLE_SID/init${ORACLE_SID}.ora   $ORACLE_BASE/dbs/init${ORACLE_SID}.ora
ln -fs $ORADATA/dbconfig/$ORACLE_SID/spfile${ORACLE_SID}.ora $ORACLE_BASE/dbs/spfile${ORACLE_SID}.ora
ln -fs $ORADATA/dbconfig/$ORACLE_SID/listener.ora            $ORACLE_BASE/homes/OraDB21Home1/network/admin/listener.ora
ln -fs $ORADATA/dbconfig/$ORACLE_SID/sqlnet.ora              $ORACLE_BASE/homes/OraDB21Home1/network/admin/sqlnet.ora
ln -fs $ORADATA/dbconfig/$ORACLE_SID/tnsnames.ora            $ORACLE_BASE/homes/OraDB21Home1/network/admin/tnsnames.ora

# Report the database registry:
sqlplus / as sysdba << EOF
col comp_name for a40
select comp_name, version, version_full, status from dba_registry;
EOF
