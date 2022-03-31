SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export AU_JOB="$(($(ls $ORADATA/autoupgrade/$ORACLE_SID | egrep "[0-9]{3}" | sort | tail -1)+1))"

echo "The autoupgrade log for this job will be:"
echo "$ORADATA/autoupgrade/$ORACLE_SID/$AU_JOB/autoupgrade_*.log"
echo " "
echo "Starting autoupgrade in 10 seconds..."
sleep 10

$SCRIPT_DIR/910_run_autoupgrade.sh deploy
