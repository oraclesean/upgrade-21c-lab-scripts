# Steps to add the 21c database to the Docker-specific configuration directory.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Copy the updated oratab to the config directory for the original SID:
cp /etc/oratab $ORADATA/dbconfig/$ORACLE_SID/

# Copy the existing pre-19c config directory to the new SID:
cp -rp $ORADATA/dbconfig/$ORACLE_SID $ORADATA/dbconfig/${ORACLE_SID}CDB/

# Remove the SID-specific files:
rm $ORADATA/dbconfig/${ORACLE_SID}CDB/*LAB*

# Set the environment for the 21c database:
. oraenv <<< ${ORACLE_SID}CDB

# Copy database files from the ORACLE_BASE_HOME/dbs to the config directory:
$SCRIPT_DIR/copy_configurations.sh

# Update the listener.ora to reflect the new home:
sed -i 's/19c/21c/g' $ORADATA/dbconfig/$ORACLE_SID/listener.ora

# Report the database registry:
$SCRIPT_DIR/dba_registry.sh
