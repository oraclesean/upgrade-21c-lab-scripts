# Create an autoupgrade configuration file based on version

mkdir -p $ORADATA/autoupgrade
rm -fr $ORADATA/autoupgrade/*

  if [ -f "$ORADATA/autoupgrade/config.txt" ]
then mv $ORADATA/autoupgrade/config.txt $ORADATA/autoupgrade/config.txt.$(date '+%Y%m%d%H%M')
fi

cat << EOF > $ORADATA/autoupgrade/config.txt
# Global parameters
global.autoupg_log_dir=$ORADATA/autoupgrade
global.raise_compatible=yes
global.drop_grp_after_upgrade=yes
global.remove_underscore_parameters=yes

# Common database parameters
upg.upgrade_node=localhost
upg.source_home=$ORACLE_HOME
upg.sid=$ORACLE_SID
upg.start_time=now
upg.run_utlrp=yes
upg.timezone_upg=yes

EOF

  if [ -d "$ORACLE_19C_HOME" ]
then cat << EOF >> $ORADATA/autoupgrade/config.txt
# Database parameters - 19c upgrade
upg.target_home=$ORACLE_19C_HOME
upg.target_version=19

# Update parameters after upgrade
upg.add_after_upgrade_pfile=$ORADATA/autoupgrade/init${ORACLE_SID}.add.ora
EOF

cat << EOF > $ORADATA/autoupgrade/init${ORACLE_SID}.add.ora
sga_target=600m
sga_max_size=600m
EOF

elif [ -d "$ORACLE_21C_HOME" ]
then cat << EOF >> $ORADATA/autoupgrade/config.txt
# Database parameters - 21c upgrade
upg.target_home=$ORACLE_21C_HOME
upg.target_cdb=${ORACLE_SID}CDB
upg.target_pdb_name=${ORACLE_SID}PDB
upg.target_version=21.5
upg.target_pdb_copy_option=file_name_convert=NONE
EOF
else echo "An upgrade home is not present"
fi
