sqlplus / as sysdba << EOF
REM Set the passwords:
alter user sys identified by oracle;
alter user system identified by oracle;

REM Remove any control files that are not in the /opt/oracle/oradata path (11g Docker only):
/*
  declare
          v_cf varchar2(2000);
    begin
            select listagg('''' || name || '''', ',') within group (order by name asc)
              into v_cf
              from v\$controlfile
             where name like '$ORADATA/%';
          execute immediate 'alter system set control_files=' || v_cf || ' scope=spfile';
      end;
/
*/

alter system set db_recovery_file_dest='$ORADATA' scope=both;

REM Meet autoupgrade prerequisites:
alter system set db_recovery_file_dest_size=10g scope=both;
alter system set sga_target=1002438656 scope=spfile;
alter system set processes=300 scope=spfile;
alter system reset local_listener;

REM Avoid UPG-1316 error during autoupgrade time zone upgrade
REM (ERROR Dispatcher failed: AutoUpgException [UPG-1316]):
alter system set parallel_max_servers=16 scope=both;


REM Add larger logfile groups:
alter database add logfile group 11 size 200m;
alter database add logfile group 12 size 200m;
alter database add logfile group 13 size 200m;
alter database add logfile group 14 size 200m;
alter database add logfile group 15 size 200m;

REM Drop original logfile groups:
    begin
      for i in (select group#, status from v\$log where group# in (1,2,3) order by status desc)
     loop
             if i.status = 'INACTIVE'
           then execute immediate 'alter database drop logfile group ' || i.group#;
           else execute immediate 'alter system checkpoint';
                execute immediate 'alter system switch logfile';
                execute immediate 'alter system switch logfile';
                execute immediate 'alter database drop logfile group ' || i.group#;
         end if;
 end loop;
      end;
/
!rm $ORADATA/$ORACLE_SID/redo*.log

REM Resize datafiles to avoid waiting on autoextend:
alter database datafile 1 resize 1100m;
alter database tempfile 1 resize 250m;
alter database datafile 3 resize 950m;
alter database datafile 4 resize 410m;
EOF
