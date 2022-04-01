# Get the target database home:
TARGET_HOME=${ORACLE_21C_HOME:-$ORACLE_19C_HOME}

# Store values for ORACLE_PATH and SQLPATH:
__oracle_path=$ORACLE_PATH
__sqlpath=$SQLPATH

# unset ORACLE_PATH and SQLPATH to prevent errors:
unset ORACLE_PATH
unset SQLPATH

$TARGET_HOME/jdk/bin/java -jar $ORADATA/autoupgrade.jar -config $ORADATA/autoupgrade/config.txt -mode $1

export ORACLE_PATH=$__oracle_path
export SQLPATH=$__sqlpath

export AU_JOB="$(ls $ORADATA/autoupgrade/$ORACLE_SID | egrep "[0-9]{3}" | sort | tail -1)"
