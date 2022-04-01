# Steps to update the Docker-specific configuration directory post-migration to 21c.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Set the environment for the 21c database:
. oraenv <<< ${ORACLE_SID}CDB

# Copy database files from the ORACLE_BASE_HOME/dbs to the config directory:
$SCRIPTS_DIR/copy_configurations.sh

# Report the database registry:
$SCRIPT_DIR/dba_registry.sh
