# Set the environment to the 21c database:
. oraenv <<< ${ORACLE_SID}CDB

sqlplus / as sysdba << EOF
-- Turn off Replay Upgrade. Replay Upgrade causes the upgrade to fail
-- at 0% while preparing APP\$CDB\$CATALOG. Resuming the upgrade allows
-- it to proceed normally. Turning off upgrade sync allows the upgrade
-- to proceed cleanly.
alter database upgrade sync off;

-- The following turns off alert log messaging for heap allocation
-- in the SGA. It's an informative message but clutters the alert log.
alter system set "_kgl_large_heap_warning_threshold"=0 scope=both;
alter system set "_kgl_large_heap_assert_threshold"=0 scope=both;
EOF
