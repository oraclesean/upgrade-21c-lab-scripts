SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

$SCRIPT_DIR/910_run_autoupgrade.sh analyze

echo "The preupgrade log from this job is:"
echo "$ORADATA/autoupgrade/$ORACLE_SID/$AU_JOB/prechecks/${ORACLE_SID,,}_preupgrade.log"
