sqlplus / as sysdba << EOF
exec dbms_stats.gather_dictionary_stats;
exec dbms_stats.gather_fixed_objects_stats;
EOF
