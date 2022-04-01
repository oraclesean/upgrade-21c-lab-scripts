SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Stop the old listener:
$ORACLE_HOME/bin/lsnrctl stop

# Set the environment to use the new SID (updated in oratab by AU)
. oraenv <<< $ORACLE_SID

# Update the Docker-specific configurations.
$SCRIPT_DIR/copy_configurations.sh

# Update the listener.ora with the new version:
sed -i 's/11.2.0.4/19c/g' $ORADATA/dbconfig/$ORACLE_SID/listener.ora
sed -i 's/12.1/19c/g' $ORADATA/dbconfig/$ORACLE_SID/listener.ora

# Start the listener from the new ORACLE_HOME:
$ORACLE_HOME/bin/lsnrctl start

# Report the database registry:
$SCRIPT_DIR/dba_registry.sh
