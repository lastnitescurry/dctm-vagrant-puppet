-- https://github.com/ismaild/vagrant-centos-oracle/blob/master/oracle/set_listener.sql
-- http://www.davidghedini.com/pg/entry/install_oracle_11g_xe_on
--
-- connect sys/manager as sysdba
EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);
alter system set sessions=250 scope=spfile;  
alter system set processes=200 scope=spfile;  
show parameters sessions;  
show parameters processes;  
quit;
/