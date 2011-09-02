package Term::Menus;

#    Menus.pm
#
#    Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005
#                  2006, 2007, 2008, 2010, 2011
#
#    by Brian M. Kelly. <Brian.Kelly@fullautosoftware.net>
#
#    You may distribute under the terms of the GNU General
#    Public License, as specified in the LICENSE file.
#    (http://www.opensource.org/licenses/gpl-license.php).
#
#    http://www.fullautosoftware.net/

## See user documentation at the end of this file.  Search for =head


our $VERSION = '1.94';


use 5.006;

use strict;
use warnings;
## Module export.
require Exporter;
our @ISA = qw(Exporter);
use vars qw(@EXPORT @EXPORT_OK %term_input %test %Dump %tosspass %b
            %blanklines %maps_config_module_file %parent_menu %Hosts
            %custom_code_module_file %canload %setsid %EXPORT %log
            %VERSION %SetTerminalSize %SetControlChars %find_Selected
            %clearpath %noclear %ReadKey %local_hostname %BEGIN %ISA
            %editor %__ANON__  %data_dump_streamer %Maps %ReadMode
            %configuration_module_file %transform_pmsi %termwidth %a
            %DumpVars %DumpLex %fullauto %delete_Selected %timeout
            %pick %termheight %EXPORT_OK %ReadLine %fa_login %Menu
            %menu_config_module_file %hosts_config_module_file %FH
            %get_all_hosts %hostname %GetSpeed %get_subs_from_menu
            %passwd_file_loc %run_sub %GetTerminalSize %escape_quotes
            %GetControlChars %numerically %rawInput %transform_sicm
            %return_result $MenuMap %get_Menu_map_count %MenuMap
            %get_Menu_map %check_for_dupe_menus %EXPORT_FAIL
            %import %DB_LOCK_PUT %DB_ENV_DSYNC_LOG %DB_ENV_STANDALONE
            %DB_ST_IS_RECNO %DB_JOINENV &DB_JOINENV %DB_LOCK_INHERIT
            %DB_VERB_REP_SYSTEM %DB_MUTEX_PROCESS_ONLY %DB_VERSION_MISMATCH
            %DB_LOG_VERIFY_ERR %DB_EVENT_REG_ALIVE %DB_XA_CREATE
            %DB_VERB_REP_ELECT %DB_REP_JOIN_FAILURE %DB_DELIMITER
            %DB_ENV_TXN %DB_ENV_RPCCLIENT %DB_MPOOL_CLEAN %DB_BTREEOLDVER
            %DB_TEMPORARY %DB_REPMGR_ACKS_ONE %DB_OLD_VERSION
            %DB_TEST_POSTLOGMETA %DB_SET_RECNO %DB_SA_UNKNOWNKEY
            %DB_MAX_RECORDS %DB_LOCK_CONFLICT %DB_REP_NEWMASTER
            %DB_LOCK_FREE_LOCKER %DB_POSITIONI %DB_VERB_FILEOPS
            %DB_LOCK_DEFAULT %DB_REP_ANYWHERE %DB_REPMGR_CONF_2SITE_STRICT
            %DB_AUTO_COMMIT %DB_TXN_NOWAIT %DB_STAT_LOCK_PARAMS
            %DB_REP_CONF_NOWAIT %DB_OK_RECNO %DB_SEQ_WRAPPED
            %DB_MUTEX_LOCKED %DB_BEFORE %DB_EVENT_REP_MASTER_FAILURE
            %DB_QUEUE %DB_TXN_LOCK_OPTIMISTIC %DB_REP_UNAVAIL
            %DB_FOREIGN_CASCADE %DB_NOOVERWRITE %DB_REP_CONF_AUTOINIT
            %LOGREC_OP %DB_RUNRECOVERY %DB_UNREF %DB_REPMGR_ISPEER
            %DB_VERIFY_BAD %DB_STAT_NOERROR %DB_ENV_LOG_AUTOREMOVE
            %DB_REP_PAGELOCKED %DB_ST_RECNUM %DB_ORDERCHKONLY
            %DB_PRIORITY_VERY_LOW %DB_BTREEMAGIC %DB_LOCK_NOTHELD
            %DB_QAMOLDVER %DB_TEST_POSTSYNC %DB_LOG_AUTO_REMOVE
            %DB_BTREEVERSION %DB_GET_BOTHC %DB_ENV_RPCCLIENT_GIVEN
            %DB_CREATE %DB_ARCH_DATA %DB_VERB_WAITSFOR %DB_INIT_REP
            %DB_ENV_RECOVER_FATAL %DB_LOCK_GET_TIMEOUT %DB_STAT_CLEAR
            %DB_REP_FULL_ELECTION %DB_VERB_REP_LEASE %DB_REGISTERED
            %DB_APPLY_LOGREG %DB_REP_HANDLE_DEAD %DB_NOORDERCHK
            %DB_HEAP_RID_SZ %DB_VERIFY_PARTITION %DB_THREADID_STRLEN
            %DB_FIRST %DB_REPMGR_CONF_ELECTIONS %DB_SEQ_DEC
            %DB_REP_CONF_INMEM %DB_MUTEX_ALLOCATED %DB_JOIN_ITEM
            %DB_REP_CONF_NOAUTOINIT %DB_REPMGR_DISCONNECTED
            %DB_DUPSORT %DB_TXN_POPENFILES %DB_LOCK_RW_N
            %DB_TXN_NOT_DURABLE %DB_LOCK_NORUN %DB_REP_CONF_BULK
            %DB_STAT_SUBSYSTEM %DB_USERCOPY_GETDATA %DB_LOCK_TRADE
            %DB_COMMIT %DB_LOG_AUTOREMOVE %DB_MPOOL_TRY %DB_WRITEOPEN
            %DB_STAT_LOCK_CONF %DB_CLIENT %DB_ENV_TIME_NOTGRANTED
            %DB_REPFLAGS_MASK %DB_ENV_NOPANIC %DB_DUPCURSOR
            %DB_ENV_APPINIT %DB_LOGFILEID_INVALID %DB_LOCKMAGIC
            %DB_STAT_MEMP_HASH %DB_REP_FULL_ELECTION_TIMEOUT
            %DB_TXN_CKP %DB_QAMVERSION %DB_EVENT_REP_CLIENT
            %DB_NOCOPY %DB_TXNVERSION %LOGREC_PGLIST %DB_RENAMEMAGIC
            %DB_REP_DUPMASTER %DB_OPEN_CALLED %DB_PAGE_NOTFOUND
            %DB_VERB_DEADLOCK %DB_TXN_FORWARD_ROLL %DB_MULTIVERSION
            %DB_LOCK_TIMEOUT %DB_JOIN_NOSORT %DB_NEEDSPLIT
            %DB_SET_TXN_NOW %DB_TXN_OPENFILES %DB_TEST_POSTOPEN
            %DB_RECORD_LOCK %DB_TEST_PREOPEN %DB_RPC_SERVERVERS
            %DB_PRINTABLE %DB_VERB_REPLICATION %DB_MULTIPLE
            %DB_COMPACT_FLAGS %DB_KEYEXIST %DB_PRIORITY_VERY_HIGH
            %DB_NOERROR %DB_VERSION_RELEASE %DB_USE_ENVIRON
            %DB_LOG_VERIFY_DBFILE %DB_TEST_ELECTSEND %DB_TXN_REDO
            %DB_DURABLE_UNKNOWN %DB_ARCH_LOG %DB_QAMMAGIC
            %DB_TIMEOUT %DB_VERB_REPMGR_MISC %DB_REP_PAGEDONE
            %DB_LOCK_PUT_OBJ %DB_VERSION_FAMILY %DB_OK_BTREE
            %DB_MAX_PAGES %DB_RDONLY %DB_CACHED_COUNTS
            %DB_CKP_INTERNAL %DB_LOG_IN_MEMORY %DB_LOCK_GET
            %DB_AGGRESSIVE %DB_STAT_LOCK_LOCKERS %DB_LOCKVERSION
            %DB_PRIORITY_DEFAULT %DB_ENV_REP_MASTER %DB_FAILCHK
            %DB_ENV_LOG_INMEMORY %DB_LOG_VERIFY_FORWARD
            %DB_LOG_VERIFY_WARNING %DB_IGNORE_LEASE
            %DB_ENV_DBLOCAL %DB_GET_BOTH_RANGE %DB_FOREIGN_ABORT
            %DB_REP_PERMANENT %DB_MPOOL_NOFILE %DB_LOG_BUFFER_FULL
            %DB_ENV_MULTIVERSION %DB_RPC_SERVERPROG %DB_MPOOL_DIRTY
            %DB_REP_NOBUFFER %DB_USE_ENVIRON_ROOT %DB_LOCK_CHECK
            %DB_PREV_NODUP %DB_ST_TOPLEVEL %DB_PAGEYIELD %DB_EXCL
            %DB_UPGRADE %DB_INORDER %DB_YIELDCPU %DB_ENV_DSYNC_DB
            %DB_REP_ELECTION %DB_LOCK_RIW_N %DB_PAGE_LOCK
            %DB_TXN_SYNC %DB_ST_DUPSORT %DB_LOG_SILENT_ERR
            %DB_MPOOL_UNLINK %LOGREC_PGDBT %DB_DIRECT %DB_CHKSUM
            %DB_ENV_OVERWRITE %DB_TXN_LOG_UNDO %DB_INIT_TXN
            %DB_REP_CHECKPOINT_DELAY %DB_TEST_ELECTVOTE2
            %DB_TEST_ELECTINIT %DB_EID_BROADCAST %DB_DELETED
            %DB_REPMGR_ACKS_QUORUM %DB_ENV_LOCKDOWN
            %DB_MUTEXDEBUG %DB_FREE_SPACE %DB_VERB_REGISTER
            %DB_MPOOL_EDIT %DB_NORECURSE %DB_TEST_ELECTVOTE1
            %DB_PRIORITY_LOW %DB_EVENT_REP_PERM_FAILED
            %DB_SET_RANGE %DB_FORCE %LOGREC_LOCKS %DB_RENUMBER
            %DB_REP_CONNECTION_RETRY %DB_MPOOL_PRIVATE
            %DB_SEQUENCE_OLDVER %DB_LOG_CHKPNT %DB_FREELIST_ONLY
            %DB_VERB_REP_MISC %DB_ENV_REGION_INIT %DB_RENUMBER
            %DB_TXN_BACKWARD_ROLL %DB_LOCK_ABORT %DB_LOG_RESEND
            %DB_ENV_REF_COUNTED %DB_DONOTINDEX %DB_NOMMAP
            %DB_LOCK_UPGRADE %DB_REP_STARTUPDONE %DB_NEXT_DUP
            %DB_ENV_OPEN_CALLED %DB_LOGVERSION_LATCHING
            %DB_REP_ELECTION_RETRY %DB_VERB_REP_TEST
            %DB_VERB_REP_MSGS %DB_debug_FLAG %DB_LOG_DSYNC
            %DB_DSYNC_LOG %DB_GET_BOTH_LTE %DB_TXN_LOG_VERIFY
            %DB_LOCK_RANDOM %DB_KEYEMPTY %DB_DIRECT_LOG
            %DB_LOG_ZERO %DB_ENV_REP_LOGSONLY %DB_NOSYNC
            %DB_LOG_VERIFY_INTERR %DB_SHALLOW_DUP %DB_SET
            %DB_LOCK_SET_TIMEOUT %DB_UPDATE_SECONDARY
            %DB_THREAD %DB_USERCOPY_SETDATA %DB_ASSOC_CREATE
            %DB_MUTEXLOCKS %DB_LOGOLDVER %DB_TXN_LOCK_MASK
            %DB_REGION_NAME %DB_NOLOCKING %DB_MPOOL_CREATE
            %DB_INIT_MPOOL %DB_CURLSN %DB_LOG_PERM %DB_WRITELOCK
            %DB_ENV_FAILCHK %DB_EVENT_REP_NEWMASTER
            %DB_JAVA_CALLBACK %DB_OVERWRITE_DUP %DB_RPCCLIENT
            %DB_ENV_CREATE %DB_ENV_THREAD %DB_PR_HEADERS
            %DB_TXN_APPLY %DB_WRITELOCK %DB_VRFY_FLAGMASK
            %DB_REP_LOCKOUT %DB_EVENT_NOT_HANDLED %DB_NEXT
            %DB_TIME_NOTGRANTED %DB_LOG_INMEMORY %LOGREC_Done
            %DB_LOG_DIRECT %DB_ALREADY_ABORTED %DB_INCOMPLETE
            %DB_MUTEX_LOGICAL_LOCK %DB_TXN_LOG_MASK %DB_PREV
            %DB_STAT_MEMP_NOERROR %DB_CL_WRITER %DB_DSYNC_DB
            %DB_ENV_TXN_NOWAIT %DB_REGISTER %DB_ODDFILESIZE
            %DB_FAST_STAT %DB_LOG_NOT_DURABLE %DB_CDB_ALLDB
            %DB_LOG_NOCOPY %DB_INIT_CDB %DB_RECORDCOUNT
            %LOGREC_DATA %DB_NEXT_DUP %DB_SET_LOCK_TIMEOUT
            %DB_PERMANENT %DB_TXN_LOG_REDO %DB_CHECKPOINT
            %DB_ENV_CDB_ALLDB %DB_EVENT_REP_JOIN_FAILURE
            %DB_LOG_VERIFY_VERBOSE %DB_LOGCHKSUM %DB_BTREE
            %DB_LOG_VERIFY_PARTIAL %DB_KEYFIRST %DB_EXTENT
            %DB_TXN_SNAPSHOT %DB_REP_ISPERM %DB_NOPANIC
            %DB_LOCK_UPGRADE_WRITE %DB_FOREIGN_CONFLICT
            %DB_MPOOL_NEW %DB_TXN_UNDO %DB_REGION_MAGIC
            %DB_PRIORITY_HIGH %DB_ENV_DIRECT_DB %LOGREC_HDR 
            %DB_RECOVER_FATAL %DB_LOCK_REMOVE %DB_LOGVERSION
            %DB_GID_SIZE %DB_PRIORITY_UNCHANGED %LOGREC_HDR
            %DB_LOGC_BUF_SIZE %DB_REVSPLITOFF %DB_LOCK_NOWAIT
            %DB_SEQUENTIAL %DB_REGION_ANON %DB_ENV_NOMMAP
            %DB_SEQUENCE_VERSION %DB_SYSTEM_MEM %DB_AFTER
            %DB_REP_ELECTION_TIMEOUT %DB_STAT_ALL %DB_APPEND
            %DB_HASHVERSION %DB_LOCK_OLDEST %DB_XIDDATASIZE
            %DB_VERIFY_FATAL %DB_ASSOC_IMMUTABLE_KEY
            %DB_SEQ_RANGE_SET %DB_REGION_INIT %DB_RECOVER
            %DB_LOCK_MAXLOCKS %DB_REP_CONF_DELAYCLIENT
            %DB_EVENT_REP_ELECTION_FAILED %DB_ENV_YIELDCPU
            %DB_OK_QUEUE %DB_MULTIPLE_KEY %DB_DIRECT_DB
            %DB_LOCK_DUMP %DB_TEST_PREDESTROY %DB_ENCRYPT 
            %DB_EID_INVALID %DB_LOCK_MINLOCKS %LOGREC_TIME
            %LOGREC_DBOP %DB_ENV_REP_CLIENT %DB_SPARE_FLAG
            %DB_TXNMAGIC %DB_LOCK_NOTEXIST %DB_REP_REREQUEST
            %DB_VERB_REP_SYNC %DB_NO_AUTO_COMMIT %DB_PR_PAGE
            %DB_EVENT_REP_DUPMASTER %DB_GET_BOTH %DB_HASH 
            %DB_TXN_BULK %DB_TEST_POSTLOG %DB_REP_LOGSONLY
            %DB_ENV_TXN_NOT_DURABLE %DB_POSITION %DB_RECNUM
            %DB_LOCKDOWN %DB_LOG_NO_DATA %DB_ST_DUPSET
            %DB_REP_HEARTBEAT_SEND %DB_SET_TXN_TIMEOUT
            %DB_REPMGR_ACKS_ALL_PEERS %DB_TEST_ELECTWAIT2
            %DB_ENV_DATABASE_LOCKING %DB_GET_RECNO
            %DB_ARCH_REMOVE %DB_LOCK_RECORD %DB_EVENT_PANIC
            %DB_LOG_LOCKED %DB_LOCK_NOTGRANTED %DB_RMW
            %DB_ENV_AUTO_COMMIT %DB_NEXT_NODUP %DB_SEQ_WRAP
            %DB_LOCK_PUT_READ %DB_REP_ACK_TIMEOUT
            %DB_VERB_CHKPOINT %DB_LOG_DISK %DB_HASHMAGIC
            %DB_HASHOLDVER %DB_OK_HASH %DB_REP_NEWSITE
            %DB_TEST_POSTRENAME %DB_ST_RELEN %DB_TXN_LOCK
            %DB_NOSERVER_ID %DB_UNKNOWN %DB_ENV_LOGGING
            %DB_EVENT_NO_SUCH_EVENT %DB_NODUPDATA
            %DB_BUFFER_SMALL %DB_APP_INIT %DB_TXN_FAMILY
            %DB_ENV_SYSTEM_MEM %DB_READ_UNCOMMITTED
            %DB_MPOOL_DISCARD %DB_SNAPSHOT %DB_NOSERVER
            %DB_REPMGR_CONNECTED %DB_VERSION_FULL_STRING
            %DB_SWAPBYTES %DB_REP_MASTER %DB_SECONDARY_BAD
            %DB_TXN_LOCK_2PL %DB_TXN_LOG_UNDOREDO
            %DB_LOG_WRNOSYNC %DB_ENV_FATAL %DB_TRUNCATE
            %DB_LOCK_PUT_ALL %DB_MUTEX_SELF_BLOCK
            %DB_CURSOR_BULK %DB_VERSION_PATCH %DB_ENV_CDB
            %DB_DATABASE_LOCK %DB_HANDLE_LOCK %DB_SET_LTE
            %DB_LOG_VERIFY_BAD %DB_OPFLAGS_MASK %DB_PAD
            %DB_SET_REG_TIMEOUT %DB_REP_BULKOVF
            %DB_REP_CONF_LEASE %DB_INIT_LOCK %DB_NOTFOUND
            %DB_TXN_PRINT %DB_INIT_LOG %DB_TEST_SUBDB_LOCKS
            %DB_ARCH_ABS %DB_ST_DUPOK %DB_REP_IGNORE
            %DB_REPMGR_PEER %DB_REPMGR_ACKS_NONE %LOGREC_DBT
            %DB_WRNOSYNC %DB_VERSION_STRING %DB_ST_OVFL_LEAF
            %DB_ENV_TXN_NOSYNC %DB_SA_SKIPFIRSTKEY %DB_FLUSH
            %DB_REP_EGENCHG %DB_MPOOL_NEW_GROUP %DB_LOGMAGIC
            %LOGREC_PGDDBT %DB_MPOOL_FREE %DB_READ_COMMITTED
            %DB_ENV_NOLOCKING %DB_EVENT_REG_PANIC
            %DB_TXN_NOSYNC %DB_CONSUME_WAIT %DB_CURRENT
            %DB_REPMGR_ACKS_ALL %DB_REP_NOTPERM %DB_DEGREE_2
            %LOGREC_POINTER %DB_REP_OUTDATED %DB_RDWRMASTER
            %DB_ENV_USER_ALLOC %DB_CURSOR_TRANSIENT
            %DB_FOREIGN_NULLIFY %DB_LOCK_SWITCH %DB_VERIFY
            %DB_EVENT_REP_MASTER %DB_DIRTY_READ %LOGREC_DB
            %DB_MPOOL_LAST %DB_CONSUME %DB_KEYLAST
            %DB_LOCK_MINWRITE %DB_REP_HEARTBEAT_MONITOR
            %DB_LOG_COMMIT %DB_VERB_RECOVERY %DB_TXN_WAIT
            %DB_EVENT_REP_ELECTED %DB_FILE_ID_LEN
            %DB_TEST_ELECTWAIT1 %DB_LOCK_EXPIRE %DB_LAST
            %DB_DATABASE_LOCKING %DB_FCNTL_LOCKING
            %DB_TXN_WRITE_NOSYNC %DB_ENV_NO_OUTPUT_SET
            %DB_user_BEGIN %DB_EVENT_WRITE_FAILED
            %DB_MPOOL_NOLOCK %DB_VERSION_MINOR
            %DB_REP_CREATE %DB_REP_DEFAULT_PRIORITY
            %DB_REP_LEASE_TIMEOUT %DB_REP_CLIENT
            %DB_TXN_LOCK_OPTIMIST %DB_LOCK_DEADLOCK
            %DB_ENCRYPT_AES %DB_LOCK_MAXWRITE %DB_GETREC
            %DB_MUTEX_THREAD %DB_ENV_PRIVATE %DB_PREV_DUP
            %DB_TEST_PRERENAME %DB_PR_RECOVERYTEST
            %DB_MPOOL_EXTENT %DB_FILEOPEN %DB_SALVAGE
            %DB_CXX_NO_EXCEPTIONS %DB_LOCK_YOUNGEST
            %DB_VERB_REPMGR_CONNFAIL %DB_REP_LOGREADY
            %DB_ENV_TXN_WRITE_NOSYNC %DB_ENV_LOCKING
            %DB_IMMUTABLE_KEY %DB_MUTEX_SHARED %DB_HEAP
            %DB_CHKSUM_SHA1 %DB_ENV_TXN_SNAPSHOT
            %DB_VERSION_MAJOR %DB_ENV_HOTBACKUP
            %DB_TEST_POSTDESTROY %DB_FORCESYNC %DB_DUP
            %DB_NOSERVER_HOME %DB_SEQ_INC %DB_FIXEDLEN
            %DB_LOG_VERIFY_CAF %DB_TXN_TOKEN_SIZE
            %DB_VERB_FILEOPS_ALL %LOGREC_ARG %DB_RECNO
            %DB_REP_LEASE_EXPIRED %DB_HOTBACKUP_IN_PROGRESS
            %DB_ENV_DIRECT_LOG %DB_REPMGR_ACKS_ALL_AVAILABLE
            %DB_WRITECURSOR %DB_STAT_LOCK_OBJECTS
            %DB_TEST_RECYCLE %DB_TXN_ABORT %DB_PRIVATE
            %DB_PANIC_ENVIRONMENT %DB_OVERWRITE
            %DB_EVENT_REP_STARTUPDONE %DB_SURPRISE_KID
            %DB_REPMGR_ACKS_ONE_PEER %DB_REP_HOLDELECTION
            %DB_EVENT_REP_SITE_ADDED %DB_EVENT_REP_INIT_DONE
            %DB_MEM_THREAD %DB_EVENT_REP_CONNECT_ESTD
            %DB_ENV_NOFLUSH %DB_EVENT_REP_LOCAL_SITE_REMOVED
            %DB_LEGACY %DB_GROUP_CREATOR %DB_EID_MASTER
            %DB_HEAPVERSION %DB_OK_HEAP %DB_MEM_TRANSACTION
            %DB_EVENT_REP_CONNECT_TRY_FAILED %DB_NOFLUSH
            %DB_STAT_SUMMARY %DB_MEM_TRANSACTION
            %DB_HEAPMAGIC %DB_REPMGR_NEED_RESPONSE
            %DB_MEM_LOCKOBJECT %DB_MEM_LOGID %DB_MEM_LOCKER
            %DB_INTERNAL_DB %DB_MEM_LOCK %DB_HEAPOLDVER
            %DB_FAILCHK_ISALIVE %DB_BOOTSTRAP_HELPER
            %DB_HEAP_FULL %DB_STAT_ALLOC %DB_LOCAL_SITE
            %DB_NO_CHECKPOINT %DB_EVENT_REP_SITE_REMOVED
            %DB_EVENT_REP_CONNECT_BROKEN %DB_INIT_MUTEX);

@EXPORT = qw(pick Menu get_Menu_map);
use Config ();
our $canload=sub {};
BEGIN {
   our $canload=sub {};
   my $installprivlib=$Config::Config{'installprivlib'}||'';
   my $installsitelib=$Config::Config{'installsitelib'}||'';
   my $installvendorlib=$Config::Config{'installvendorlib'}||'';
   if ($installprivlib &&
         -e $installprivlib."/Module/Load/Conditional.pm") {
      $canload = sub {
         require $installprivlib."/Module/Load/Conditional.pm";
         my $module={};
         $module=$_[0] if ref $_[0] eq 'HASH';
         return Module::Load::Conditional::can_load(%$module);
      };
   } elsif ($installsitelib &&
         -e $installsitelib."/Module/Load/Conditional.pm") {
      $canload = sub {
         require $installsitelib."/Module/Load/Conditional.pm";
         my $module={};
         $module=$_[0] if ref $_[0] eq 'HASH';
         return Module::Load::Conditional::can_load(%$module);
      };
   } elsif ($installvendorlib &&
         -e $installvendorlib."/Module/Load/Conditional.pm") {
      $canload = sub {
         require $installvendorlib.
            "/Module/Load/Conditional.pm";
         my $module={};
         $module=$_[0] if ref $_[0] eq 'HASH';
         return Module::Load::Conditional::can_load(%$module);
      };
   } else {
      $canload = sub { return 0 };
   }
}

##############################################################
##############################################################
#
#  THIS BLOCK MARKED BY TWO LINES OF POUND SYMBOLS IS FOR
#  SETTINGS NEEDED BY THE MODULE   Net::FullAuto.  IF YOU ARE
#  USING   Term::Menus   OUTSIDE OF   Net::FullAuto,  YOU CAN
#  SAFELY IGNORE THIS SECTION. (That's 'ignore' - not 'remove')
#

BEGIN { ##  Begin  Net::FullAuto  Settings

   #####################################################################
   ####                                                              ###
   #### DEFAULT NAME OF  Net::FullAuto  menu_config_module_file IS:  ###
   ####                                                              ###
   #### ==> fa_menu.pm <==  If you rename the file, you must either  ###
   ####                                                              ###
   #### change the setting of $menu_config_module_file as well, or   ###
   #### set the $fa_menu_config variable in the BEGIN { } block      ###
   #### of the top level script invoking Net::FullAuto. (Advised)    ###
   ####                                                              ###
   #####################################################################
                                                                     ###
   our $menu_config_module_file='fa_menu_demo.pm';                   ###
                                                                     ###
   #####################################################################

   #####################################################################
   ####                                                              ###
   #### DEFAULT NAME OF  Net::FullAuto  custom_code_module_file IS:  ###
   ####                                                              ###
   #### ==> fa_code.pm <==  If you rename the file, you must either  ###
   ####                                                              ###
   #### change the setting of $custom_code_module_file as well, or   ###
   #### set the $fa_custom_code variable in the BEGIN { } block      ###
   #### of the top level script invoking Net::FullAuto. (Advised)    ###
   ####                                                              ###
   #####################################################################
                                                                     ###
   our $custom_code_module_file='fa_code_demo.pm';                   ###
                                                                     ###
   #####################################################################

   #####################################################################
   ####                                                              ###
   #### DEFAULT NAME OF Net::FullAuto configuration_module_file IS:  ###
   ####                                                              ###
   #### ==> fa_conf.pm <==  If you rename the file, you must either  ###
   ####                                                              ###
   #### change the setting of $custom_code_module_file as well, or   ###
   #### set the $fa_configuration variable in the BEGIN { } block    ###
   #### of the top level script invoking Net::FullAuto. (Advised)    ###
   ####                                                              ###
   #####################################################################
                                                                     ###
   our $configuration_module_file='fa_conf.pm';                      ###
                                                                     ###
   #####################################################################

   #####################################################################
   ####                                                              ###
   #### DEFAULT NAME OF Net::FullAuto hosts_config_module_file  IS:  ###
   ####                                                              ###
   #### ==> fa_host.pm <==  If you rename the file, you must either  ###
   ####                                                              ###
   #### change the setting of $hosts_module_file as well, or         ###
   #### set the $fa_hosts_config variable in the BEGIN { } block     ###
   #### of the top level script invoking Net::FullAuto. (Advised)    ###
   ####                                                              ###
   #####################################################################
                                                                     ###
   our $hosts_config_module_file='fa_host.pm';                       ###
                                                                     ###
   #####################################################################

   #####################################################################
   ####                                                              ###
   #### DEFAULT NAME OF  Net::FullAuto  maps_config_module_file IS:  ###
   ####                                                              ###
   #### ==> fa_maps.pm <==  If you rename the file, you must change  ###
   ####                                                              ###
   #### change the setting of $maps_config_module_file as well, or   ###
   #### set the $fa_mapping variable in the BEGIN { } block          ###
   #### of the top level script invoking Net::FullAuto. (Advised)    ###
   ####                                                              ###
   #####################################################################
                                                                     ###
   our $maps_config_module_file='fa_maps.pm';                        ###
                                                                     ###
   #####################################################################

   our $fullauto=0;
   my $default_modules='';
   if (defined caller(2) && -1<index caller(2),'FullAuto') {
      my $fa_path=$INC{'Net/FullAuto.pm'};
      $fullauto=1;
      my $progname=substr($0,(rindex $0,'/')+1,-3);
      substr($fa_path,-3)='';
      if (-f $fa_path.'/fa_defs.pm') {
         {
            no strict 'subs';
            require $fa_path.'/fa_defs.pm';
            $fa_defs::FA_Secure||='';
            if ($fa_defs::FA_Secure && -d $fa_defs::FA_Secure.'Defaults') {
               require BerkeleyDB if -1<index caller(2),'FullAuto';
               BerkeleyDB->import() if -1<index caller(2),'FullAuto';
               my $dbenv = BerkeleyDB::Env->new(
                  -Home  => $fa_defs::FA_Secure.'Defaults',
                  -Flags => DB_CREATE|DB_INIT_CDB|DB_INIT_MPOOL
               ) or die(
                  "cannot open environment for DB: $BerkeleyDB::Error\n",'','');
               #&acquire_semaphore(9361,
               #   "BDB DB Access: ".__LINE__);
               my $bdb = BerkeleyDB::Btree->new(
                     -Filename => "${progname}_defaults.db",
                     -Flags    => DB_CREATE,
                     -Env      => $dbenv
                  );
               unless ($BerkeleyDB::Error=~/Successful/) {
                  $bdb = BerkeleyDB::Btree->new(
                     -Filename => "${progname}_defaults.db",
                     -Flags    => DB_CREATE|DB_RECOVER_FATAL,
                     -Env      => $dbenv
                  );
                  unless ($BerkeleyDB::Error=~/Successful/) {
                     die "Cannot Open DB ${progname}_defaults.db:".
                         " $BerkeleyDB::Error\n";
                  }
               }
               my $username=getlogin || getpwuid($<);
               my $status=$bdb->db_get(
                     $username,$default_modules);
               $default_modules||='';
               $default_modules=~s/\$HASH\d*\s*=\s*//s
                  if -1<index $default_modules,'$HASH';
               $default_modules=eval $default_modules;
               $default_modules||={};
               undef $bdb;
               $dbenv->close();
               undef $dbenv;
            }
         }
      }
   }

   if (defined $main::fa_custom_code) {

      if (-1<index $main::fa_custom_code,'/') {
         require $main::fa_custom_code;
         my $cc=substr($main::fa_custom_code,
                (rindex $main::fa_custom_code,'/')+1,-3);
         import $cc;
         $Term::Menus::custom_code_module_file=$cc.'.pm';
      } elsif (-1<index caller(2),'FullAuto') {
         require 'Net/FullAuto/Custom/'.$main::fa_custom_code;
         my $cc=substr($main::fa_custom_code,
                (rindex $main::fa_custom_code,'/')+1,-3);
         import $cc;
         $Term::Menus::custom_code_module_file=$cc.'.pm';
      } else {
         require $main::fa_custom_code;
         my $cc=substr($main::fa_custom_code,0,-3);
         import $cc;
         $Term::Menus::custom_code_module_file=$main::fa_custom_code;
      }

   } elsif (defined caller(2) && -1<index caller(2),'FullAuto') {

      if (defined $default_modules
            && ref $default_modules eq 'HASH'
            && exists $default_modules->{'fa_code'}) {
         if (exists $default_modules->{'set'} &&
               $default_modules->{'set'} ne 'none') {
            {
               no strict "subs";
               my $set=$default_modules->{'set'};
               my $progname=substr($0,(rindex $0,'/')+1,-3);
               BerkeleyDB->import() if -1<index caller(2),'FullAuto';
               my $dbenv = BerkeleyDB::Env->new(
                  -Home  => $fa_defs::FA_Secure.'Sets',
                  -Flags => DB_CREATE|DB_INIT_CDB|DB_INIT_MPOOL
               ) or die(
                  "cannot open environment for DB: $BerkeleyDB::Error\n",'','');
               #&acquire_semaphore(9361,
               #   "BDB DB Access: ".__LINE__);
               my $bdb = BerkeleyDB::Btree->new(
                     -Filename => "${progname}_sets.db",
                     -Flags    => DB_CREATE,
                     -Env      => $dbenv
                  );
               unless ($BerkeleyDB::Error=~/Successful/) {
                  $bdb = BerkeleyDB::Btree->new(
                     -Filename => "${progname}_sets.db",
                     -Flags    => DB_CREATE|DB_RECOVER_FATAL,
                     -Env      => $dbenv
                  );
                  unless ($BerkeleyDB::Error=~/Successful/) {
                     die "Cannot Open DB ${progname}_sets.db:".
                         " $BerkeleyDB::Error\n";
                  }
               }
               my $username=getlogin || getpwuid($<);
               my $mysets='';
               my $status=$bdb->db_get(
                     $username,$mysets);
               $mysets||='';
               $mysets=~s/\$HASH\d*\s*=\s*//s
                  if -1<index $mysets,'$HASH';
               $mysets=eval $mysets;
               $mysets||={};
               undef $bdb;
               $dbenv->close();
               undef $dbenv;
               $Term::Menus::custom_code_module_file=
                  substr($mysets->{$set}->{'fa_code'},
                  (rindex $mysets->{$set}->{'fa_code'},'/')+1);
               require $mysets->{$set}->{fa_code};
               my $cc=substr($Term::Menus::custom_code_module_file,0,-3);
               import $cc;
            }
         } else {
            $Term::Menus::custom_code_module_file=
               substr($default_modules->{'fa_code'},
               (rindex $default_modules->{'fa_code'},'/')+1);
            require $default_modules->{'fa_code'};
            my $cc=substr($Term::Menus::custom_code_module_file,0,-3);
            import $cc;
         }
      } elsif ($Term::Menus::canload->( modules => { 
            'Net/FullAuto/Distro'.
            $Term::Menus::custom_code_module_file => 0 } )) {
         require 'Net/FullAuto/Distro/'.$Term::Menus::custom_code_module_file;
         my $cc=substr($Term::Menus::custom_code_module_file,0,-3);
         import $cc;
      }

   }

   if (defined $main::fa_configuration) {

      if (-1<index $main::fa_configuration,'/') {
         require $main::fa_configuration;
         my $cf=substr($main::fa_configuration,
                (rindex $main::fa_configuration,'/')+1,-3);
         import $cf;
         $configuration_module_file=$cf.'.pm';
      } elsif (-1<index caller(2),'FullAuto') {
         require 'Net/FullAuto/Custom/'.$main::fa_configuration;
         my $cf=substr($main::fa_configuration,
                (rindex $main::fa_configuration,'/')+1,-3);
         import $cf;
         $configuration_module_file=$cf.'.pm';
      } else {
         require $main::fa_configuration;
         my $cf=substr($main::fa_configuration,0,-3);
         import $cf;
         $configuration_module_file=$main::fa_configuration;
      }

   } elsif (defined caller(2) && -1<index caller(2),'FullAuto') {

      if (defined $default_modules
            && ref $default_modules eq 'HASH'
            && exists $default_modules->{'fa_conf'}) {
         $Term::Menus::configuration_module_file=
            substr($default_modules->{'fa_conf'},
            (rindex $default_modules->{'fa_conf'},'/')+1);
         require $default_modules->{'fa_conf'};
      } elsif ($Term::Menus::canload->( modules => {
            'Net/FullAuto/Distro/'.
            $Term::Menus::configuration_module_file => 0 } )) {
         require 'Net/FullAuto/Distro/'.
            $Term::Menus::configuration_module_file;
      }
      my $cf=substr($Term::Menus::configuration_module_file,0,-3);
      import $cf;

   }

   if (defined $main::fa_hosts_config) {

      if (-1<index $main::fa_hosts_config,'/') {
         require $main::fa_hosts_config;
         my $hc=substr($main::fa_hosts_config,
                (rindex $main::fa_hosts_config,'/')+1,-3);
         import $hc;
         $hosts_config_module_file=$hc.'.pm';
      } elsif (-1<index caller(2),'FullAuto') {
         require 'Net/FullAuto/Custom/'.$main::fa_hosts_config;
         my $hc=substr($main::fa_hosts_config,
                (rindex $main::fa_hosts_config,'/')+1,-3);
         import $hc;
         $hosts_config_module_file=$hc.'.pm';
      } else {
         require $main::fa_hosts_config;
         my $hc=substr($main::fa_hosts_config,0,-3);
         import $hc;
         $hosts_config_module_file=$main::fa_hosts_config;
      }

   } elsif (defined caller(2) && -1<index caller(2),'FullAuto') {

      if (defined $default_modules
            && ref $default_modules eq 'HASH'
            && exists $default_modules->{'fa_host'}) {
         $Term::Menus::hosts_config_module_file=
            substr($default_modules->{'fa_host'},
            (rindex $default_modules->{'fa_host'},'/')+1);
         require $default_modules->{'fa_host'};
      } elsif ($Term::Menus::canload->( modules => {
            'Net/FullAuto/Distro/'.
            $Term::Menus::hosts_config_module_file => 0 } )) {
         require 'Net/FullAuto/Distro/'.
            $Term::Menus::hosts_config_module_file;
      }
      my $hf=substr($Term::Menus::hosts_config_module_file,0,-3);
      import $hf;

   }

   if (defined $main::fa_maps_config) {

      if (-1<index $main::fa_maps_config,'/') {
         require $main::fa_maps_config;
         my $mp=substr($main::fa_maps_config,
                (rindex $main::fa_maps_config,'/')+1,-3);
         import $mp;
         $maps_config_module_file=$mp.'.pm';
      } elsif (-1<index caller(2),'FullAuto') {
         require 'Net/FullAuto/Custom/'.$main::fa_maps_config;
         my $mp=substr($main::fa_maps_config,
                (rindex $main::fa_maps_config,'/')+1,-3);
         import $mp;
         $maps_config_module_file=$mp.'.pm';
      } else {
         require $main::fa_maps_config;
         my $mp=substr($main::fa_maps_config,0,-3);
         import $mp;
         $maps_config_module_file=$main::fa_maps_config;
      }

   } elsif (defined caller(2) && -1<index caller(2),'FullAuto') {

      if (defined $default_modules
            && ref $default_modules eq 'HASH'
            && exists $default_modules->{'fa_maps'}) {
         $Term::Menus::maps_config_module_file=
            substr($default_modules->{'fa_maps'},
            (rindex $default_modules->{'fa_maps'},'/')+1);
         require $default_modules->{'fa_maps'};
      } elsif ($Term::Menus::canload->( modules => {
            'Net/FullAuto/Distro/'.
            $Term::Menus::maps_config_module_file => 0 } )) {
         require 'Net/FullAuto/Distro/'.
            $Term::Menus::maps_config_module_file;
      }
      my $mp=substr($Term::Menus::maps_config_module_file,0,-3);
      import $mp;

   }

   if (defined $main::fa_menu_config) {

      if (-1<index $main::fa_menu_config,'/') {
         require $main::fa_menu_config;
         my $mc=substr($main::fa_menu_config,
                (rindex $main::fa_menu_config,'/')+1,-3);
         import $mc;
         $menu_config_module_file=$mc.'.pm';
      } else {
         require $main::fa_menu_config;
         my $mc=substr($main::fa_menu_config,0,-3);
         import $mc;
         $menu_config_module_file=$main::fa_menu_config;
      }

   } elsif (defined caller(2) && -1<index caller(2),'FullAuto') {

      if (defined $default_modules
            && ref $default_modules eq 'HASH'
            && exists $default_modules->{'fa_menu'}) {
         $Term::Menus::menu_config_module_file=
            substr($default_modules->{'fa_menu'},
            (rindex $default_modules->{'fa_menu'},'/')+1);
         require $default_modules->{'fa_menu'};
      } elsif ($Term::Menus::canload->( modules => {
            'Net/FullAuto/Distro/'.
            $Term::Menus::menu_config_module_file => 0 } )) {
         require 'Net/FullAuto/Distro/'.
            $Term::Menus::menu_config_module_file;
      }
      my $mc=substr($Term::Menus::menu_config_module_file,0,-3);
      import $mc;

   }

}

our %email_defaults=();
if (%fa_code::email_defaults) {
   %email_defaults=%fa_code::email_defaults;
}
our %email_addresses=();
if (%fa_code::email_addresses) {
   %email_addresses=%fa_code::email_addresses;
}
our $passwd_file_loc='';
if (defined $fa_code::passwd_file_loc && $fa_code::passwd_file_loc) {
   $passwd_file_loc=$fa_code::passwd_file_loc;
}
our $test=0;
if (defined $fa_code::test && $fa_code::test) {
   $test=$fa_code::test;
}
our $timeout=30;
if (defined $fa_code::timeout && $fa_code::timeout) {
   $timeout=$fa_code::timeout;
}
our $log=0;
if (defined $fa_code::log && $fa_code::log) {
   $log=$fa_code::log;
}
our $tosspass=0;
if (defined $fa_code::tosspass && $fa_code::tosspass) {
   $tosspass=$fa_code::tosspass;
}

##  End  Net::FullAuto  Settings

##############################################################
##############################################################

##  Begin  Term::Menus

our $termwidth='';
our $termheight='';
our $data_dump_streamer=0;
our $term_input=0;
eval { require Term::ReadKey };
unless ($@) {
   import Term::ReadKey;
   eval {
      no strict 'subs';
      ($termwidth, $termheight) =
         Term::ReadKey::GetTerminalSize(STDOUT);
   };
   if ($@) {
      $termwidth='';$termheight='';
   }
} else {
   $termwidth='';$termheight='';
}
if ($termwidth) {
   eval { require Term::RawInput };
   unless ($@) {
      $term_input=1;
      import Term::RawInput;
   }
}
eval { require Data::Dump::Streamer };
unless ($@) {
   $data_dump_streamer=1;
   import Data::Dump::Streamer;
}
our $clearpath='';
if ($^O ne 'MSWin32' && $^O ne 'MSWin64') {
   if (-e '/usr/bin/clear') {
      $clearpath='/usr/bin/';
   } elsif (-e '/bin/clear') {
      $clearpath='/bin/';
   } elsif (-e '/usr/local/bin/clear') {
      $clearpath='/usr/local/bin/';
   }
}

our %LookUpMenuName=();
our $MenuMap=[];

our $noclear=1; # set to one to turn off clear for debugging

sub check_for_dupe_menus {

   my $m_flag=0;
   my $s_flag=0;
   foreach my $dir (@INC) {
      if (!$m_flag && -f "$dir/$Term::Menus::menu_config_module_file") {
         $m_flag=1;
         open(FH,"<$dir/$Term::Menus::menu_config_module_file");
         my $line='';my %menudups=();
         while ($line=<FH>) {
            if ($line=~/^[ \t]*\%(.*)\s*=/) {
               if (!exists $menudups{$1}) {
                  $menudups{$1}='';
               } else {
                  my $mcmf=$Term::Menus::menu_config_module_file;
                  my $die="\n       FATAL ERROR! - Duplicate Hash Blocks:"
                         ."\n              ->  \"%$1\" is defined more than once\n"
                         ."              in the $dir/$mcmf file.\n\n"
                         ."       Hint:  delete or comment-out all duplicates\n\n";
                  if ($Term::Menus::fullauto) {
                     print $die if !$Net::FullAuto::FA_Core::cron;
                     &Net::FullAuto::FA_Core::handle_error($die,'__cleanup__');
                  } else { die $die }
               }
            }
         }
      }
      if (!$s_flag && -f "$dir/$Term::Menus::custom_code_module_file") {
         $s_flag=1;
         open(FH,"<$dir/$Term::Menus::custom_code_module_file");
         my $line='';my %dups=();
         while ($line=<FH>) {
            if ($line=~/^[ \t]*\%(.*)\s*=/) {
               if (!exists $dups{$1}) {
                  $dups{$1}='';
               } else {
                  my $die="\n       FATAL ERROR! - Duplicate Hash Blocks:"
                         ."\n              ->  \"%$1\" is defined more "
                         ."than once\n              in the $dir/"
                         .$Term::Menus::custom_code_module_file
                         ." file.\n\n       Hint:  delete "
                         ."or comment-out all duplicates\n\n";
                  if ($Term::Menus::fullauto) {
                     print $die if !$Net::FullAuto::FA_Core::cron;
                     &Net::FullAuto::FA_Core::handle_error($die,'__cleanup__');
                  } else { die $die }
               }
            }
         }
      }
   }

   if ($Term::Menus::fullauto) {
      foreach my $symname (keys %Term::Menus::) {
         if (eval "\\%$symname") {
            my $hashref=eval "\\%$symname";
            HF: foreach my $key (keys %{$hashref}) {
               if (ref ${$hashref}{$key} eq 'HASH') {
                  foreach my $ky (keys %{${$hashref}{$key}}) {
                     if (lc($ky) eq 'text') {
                        $LookUpMenuName{$hashref}=$symname;
                        last HF;
                     }
                  }
               }
            }
         }
      }
   }

}

&check_for_dupe_menus() if defined $main::fa_menu_config
                                && $main::fa_menu_config;

{
   use Sys::Hostname;
   our $local_hostname=&Sys::Hostname::hostname;
}

my $count=0;
our $blanklines='';
if ($Term::Menus::termheight) {
   $count=$Term::Menus::termheight;
} else { $count=30 }
while ($count--) { $blanklines.="\n" }
our $parent_menu='';

sub fa_login
{

   my $fa_code='';my $menu_args='';my $to='';my $die='';
   my $start_menu_ref='';
   my $returned='';
   eval {
      my $m_c_m_f='';
      ($fa_code,$menu_args,$to,$m_c_m_f,$die)=
         &Net::FullAuto::FA_Core::fa_login(@_);
      if ($die) {
         print $die if !$Net::FullAuto::FA_Core::cron;
         &Net::FullAuto::FA_Core::handle_error($die,'__cleanup__');
      }
      $Term::Menus::menu_config_module_file=$m_c_m_f if $m_c_m_f;
      if ($m_c_m_f) {
         my $m_flag=0;
         my $s_flag=0;
         foreach my $dir (@INC) {
            if (!$m_flag && -f "$dir/$Term::Menus::menu_config_module_file") {
               $m_flag=1;
               open(FH,"<$dir/$Term::Menus::menu_config_module_file");
               my $line='';my %menudups=();
               while ($line=<FH>) {
                  if ($line=~/^[ \t]*\%(.*)\s*=/) {
                     if (!exists $menudups{$1}) {
                        $menudups{$1}='';
                     } else {
                        my $mcmf=$Term::Menus::menu_config_module_file;
                        my $die="\n       FATAL ERROR! - Duplicate Hash Blocks:"
                               ."\n              ->  \"%$1\" is defined more than once\n"
                               ."              in the $dir/$mcmf file.\n\n"
                               ."       Hint:  delete or comment-out all duplicates\n\n";
                        print $die if !$Net::FullAuto::FA_Core::cron;
                        &Net::FullAuto::FA_Core::handle_error($die,'__cleanup__');
                     }
                  }
               }
            }
            if (!$s_flag && -f "$dir/$Term::Menus::custom_code_module_file") {
               $s_flag=1;
               open(FH,"<$dir/$Term::Menus::custom_code_module_file");
               my $line='';my %dups=();
               while ($line=<FH>) {
                  if ($line=~/^[ \t]*\%(.*)\s*=/) {
                     if (!exists $dups{$1}) {
                        $dups{$1}='';
                     } else {
                        my $die="\n       FATAL ERROR! - Duplicate Hash Blocks:"
                               ."\n              ->  \"%$1\" is defined more "
                               ."than once\n              in the $dir/"
                               .$Term::Menus::custom_code_module_file
                               ." file.\n\n       Hint:  delete "
                               ."or comment-out all duplicates\n\n";
                        print $die if !$Net::FullAuto::FA_Core::cron;
                        &Net::FullAuto::FA_Core::handle_error($die,'__cleanup__');
                     }
                  }
               }
            }
         }
         require $Term::Menus::menu_config_module_file;
      } elsif (!$Term::Menus::canload->( modules => { 'Net/FullAuto/Custom/'.
            $Term::Menus::menu_config_module_file => 0 } )) {
         require 'Net/FullAuto/Distro/fa_menu_demo.pm';
      }
      my $mc=substr($Term::Menus::menu_config_module_file,
            (rindex $Term::Menus::menu_config_module_file,'/')+1,-3);
      import $mc;
      $start_menu_ref=eval '$'.$mc.'::start_menu_ref';
      $to||=0;
      $timeout=$to if $to;
      if ($fa_code) {
         &run_sub($fa_code,$menu_args);
      } elsif (ref $start_menu_ref eq 'HASH') {
         unless (keys %LookUpMenuName) {
            &check_for_dupe_menus();
         }
         #if (!exists $LookUpMenuName{$start_menu_ref}) {
         #   my $mcmf=$Term::Menus::menu_config_module_file;
         #   my $die="\n       FATAL ERROR! - The top level menu,"
         #          ." indicated\n              by the "
         #          ."\$start_menu_ref variable in\n       "
         #          ."       the $mcmf file, is NOT\n"
         #          ."              EXPORTED\n\n       Hint: "
         #          ."\@EXPORT = qw( %Menu_1 %Menu_2 ... )\;"
         #          ."\n\n\tour \$start_menu_ref=\\%Menu_1\;"
         #          ."\n\n       \[ Menu_1 is example - "
         #          ."name you choose is optional \]\n";
         #   &Net::FullAuto::FA_Core::handle_error($die);
         #}
         if ($Net::FullAuto::FA_Core::plan) {
            my $plann=shift @{$Net::FullAuto::FA_Core::plan};
            if (${$start_menu_ref}{Label} eq ${$plann}{Label}) {
               my $return=eval ${$plann}{Item};
               &Net::FullAuto::FA_Core::handle_error($@,'-1') if $@;
               return $return;
            } else {
               my $die="\n       FATAL ERROR! -  Plan Number ${$plann}{PlanID} does"
                      ."\n                       match the current logic flow."
                      ."\n\n      ";
               die($die);
            }
         }
         $returned=&Menu($start_menu_ref);
      } elsif ($start_menu_ref) {
         my $mcmf=$Term::Menus::menu_config_module_file;
         my $die="\n       FATAL ERROR! - The top level menu "
                ."block indicated\n              by the "
                ."\$start_menu_ref variable in the\n       "
                ."       $mcmf file, does not exist as"
                ."\n              a properly constructed and"
                ."\\or named hash\n              block in the"
                ." ".__PACKAGE__.".pm file\n\n       Hint:  "
                ."our \$start_menu_ref=\\%Menu_1\;\n\n       "
                ."\[ Menu_1 is example - name you choose is"
                ." optional \]\n\n       %Menu_1=\(\n"
                ."          Item_1 => { ... },\n        "
                ."...\n       \)\;\n";
         &Net::FullAuto::FA_Core::handle_error($die);
      } else {
         my $mcmf=$Term::Menus::menu_config_module_file;
         my $die="\n       FATAL ERROR! - The \$start_menu_ref\n"
                ."              variable in the $mcmf\n"
                ."              file, is not defined or properly"
                ."\n              initialized with the name of "
                ."the\n              menu hash block designated"
                ." for the\n              top level menu.\n\n"
                ."              Hint:  our \$start_menu_ref"
                ."=\\%Menu_1\;\n\n       \[ Menu_1 is example - "
                ."name you choose is optional \]\n\n       "
                ."%Menu_1=\(\n          Item_1 => { ... },\n"
                ."          ...\n       \)\;\n";
         &Net::FullAuto::FA_Core::handle_error($die);
      }
   };
   if ($@) {
      my $cmdlin=52;
      $cmdlin=47 if $fa_code;
      #&Net::FullAuto::FA_Core::handle_error($@,"-$cmdlin",'__cleanup__');
      my $errr=$@;
      $errr=~s/^\s*/\n       /s;
      print $errr;
   }
   #print "\n==> DONE!!!!!!!!!" if !$Net::FullAuto::FA_Core::cron &&
   #      !$Net::FullAuto::FA_Core::stdio;
   &Net::FullAuto::FA_Core::cleanup(1,$returned);

}

sub run_sub
{
   use if $Term::Menus::fullauto, "IO::Handle";
   use if $Term::Menus::fullauto, POSIX => qw(setsid);

   if ($Term::Menus::fullauto && defined $Net::FullAuto::FA_Core::service
         && $Net::FullAuto::FA_Core::service) {
      print "\n\n   ##### TRANSITIONING TO SERVICE ######".
            "\n\n   FullAuto will now continue running as".
            "\n   as a Service/Daemon. Now exiting".
            "\n   interactive mode ...\n\n";
      chdir '/'                 or die "Can't chdir to /: $!";
      umask 0;
      open STDIN, '/dev/null'   or die "Can't read /dev/null: $!";
      open STDOUT, '>/dev/null' or die "Can't write to /dev/null: $!";
      open STDERR, '>/dev/null' or die "Can't write to /dev/null: $!";
      defined(my $pid = fork)   or die "Can't fork: $!";
      exit if $pid;
      $pid = &setsid          or die "Can't start a new session: $!";
   }

   my $fa_code=$_[0];
   my $menu_args= (defined $_[1]) ? $_[1] : '';
   my $subfile=substr($Term::Menus::custom_code_module_file,0,-3).'::'
         if $Term::Menus::custom_code_module_file;
   $subfile||='';
   my $return=
      eval "\&$subfile$fa_code\(\@{\$menu_args}\)";
   &Net::FullAuto::FA_Core::handle_error($@,'-1') if $@;
   return $return;
}

sub get_all_hosts
{
   return Net::FullAuto::FA_Core::get_all_hosts(@_);
}

sub get_Menu_map_count
{
   my $map_count=0;$count=0;
   foreach my $map (@{$_[0]}) {
      $count=$map->[0];
      $map_count=$count if $map_count<$count;
   }
   return $map_count;
}

sub get_Menu_map
{
   my %tmphash=();my @menu_picks=();
   foreach my $map (@{$MenuMap}) {
      $tmphash{$map->[0]}=$map->[1]; 
   }
   foreach my $number (sort numerically keys %tmphash) {
      push @menu_picks, $tmphash{$number};
   }
   return @menu_picks;
}

sub Menu
{
#print "MENUCALLER=",(caller)[0]," and ",__PACKAGE__,"\n";<STDIN>;
#print "MENUCALLER=",caller,"\n";<STDIN>;
   my $MenuUnit_hash_ref=$_[0];
   my $select_many=0;
   if (exists ${$MenuUnit_hash_ref}{Select}) {
      if (${$MenuUnit_hash_ref}{Select}=~/many/i) {
         $select_many='NUTS';
         ${$MenuUnit_hash_ref}{Select}={};
      } elsif (${$MenuUnit_hash_ref}{Select}=~/one/i) {
         ${$MenuUnit_hash_ref}{Select}={};
      } 
   } else {
      ${$MenuUnit_hash_ref}{Select}={};
   }
   my $picks_from_parent=$_[1]||'';
   my $unattended=0;
   if ($picks_from_parent=~/\](Cron|Batch|Unattended|FullAuto)\[/i) {
      $unattended=1;
      undef $picks_from_parent;
   }
   my $recurse = (defined $_[2]) ? $_[2] : 0;
   my $FullMenu= (defined $_[3]) ? $_[3] : {};
   my $Selected= (defined $_[4]) ? $_[4] : {};
   my $Conveyed= (defined $_[5]) ? $_[5] : {};
   my $SavePick= (defined $_[6]) ? $_[6] : {};
   my $SaveMMap= (defined $_[7]) ? $_[7] : {};
   my $SaveNext= (defined $_[8]) ? $_[8] : {};
   my $Persists= (defined $_[9]) ? $_[9] : {};
   my $parent_menu= (defined $_[10]) ? $_[10] : '';
   my $no_wantarray=0;

   if ((defined $_[11] && $_[11]) ||
         ((caller)[0] ne __PACKAGE__ && !wantarray)) {
      $no_wantarray=1;
   }
   if (defined $_[12] && $_[12]) {
      return '','','','','','','','','','','',$_[12];
   }
   my $pmsi_regex=qr/\]p(?:r+evious[-_]*)*m*(?:e+nu[-_]*)
      *c*(?:h+osen[-_]*)*i*(?:t+ems[-_]*)*\[/xi;
   my $amlm_regex=qr/\]a(n+cestor[-_]*)*m*(e+nu[-_]*)
      *l*(a+bel[-_]*)*m*(a+p[-_]*)*\[/xi;
   my %Items=();my %negate=();my %result=();my %convey=();
   my %chosen=();my %default=();my %select=();my %mark=();
   my $pick='';my $picks=[];my $banner='';my %num__=();
   my $display_this_many_items=10;my $die_err='';
   my $master_substituted='';my $convey='';$mark{BLANK}=1;
   my $num=0;my @convey=();my $filtered=0;my $sorted='';
   foreach my $key (keys %{$MenuUnit_hash_ref}) {
      if (4<length $key && substr($key,0,4) eq 'Item') {
         $Items{substr($key,5)}=${$MenuUnit_hash_ref}{$key};
      }
   }
   $Persists->{unattended}=$unattended if $unattended;

   ############################################
   # Breakdown the MenuUnit into its Components
   ############################################

      # Breakdown Each Item into its Components
      #########################################

   while (++$num) {
      @convey=();
      last unless exists $Items{$num};
      if (exists ${$Items{$num}}{Negate} &&
            !(keys %{${$MenuUnit_hash_ref}{Select}})) {
            # || ${$MenuUnit_hash_ref}{Select} eq 'One')) {
         my $die="Can Only Use \"Negate =>\""
                ."\n\t\tElement in ".__PACKAGE__.".pm when the"
                ."\n\t\t\"Select =>\" Element is set to \'Many\'\n\n";
         &Net::FullAuto::FA_Core::handle_error($die) if $Term::Menus::fullauto;
         die $die;
      }
      my $con_regex=qr/\]c(o+nvey)*\[/i;
      if (exists ${$Items{$num}}{Convey}) {
         if (ref ${$Items{$num}}{Convey} eq 'ARRAY') {
            foreach my $line (@{${$Items{$num}}{Convey}}) {
               push @convey, $line;
            }
         } elsif (ref ${$Items{$num}}{Convey} eq 'CODE') {
            my $convey_code=${$Items{$num}}{Convey};
            if ($Term::Menus::data_dump_streamer) {
               $convey_code=
                  &Data::Dump::Streamer::Dump($convey_code)->Out();
#print "PICKSFROMPARENTXX=$picks_from_parent AND CONVEY_CODE=$convey_code\n";
               $convey_code=&transform_pmsi($convey_code,
                  $Conveyed,$SaveMMap,$pmsi_regex,$amlm_regex,
                  $picks_from_parent);
            }
#print "WHAT IS CDNOW=$convey_code<==\n";<STDIN>;
            $convey_code=~s/\$CODE\d*\s*=\s*//s;
#print "WHAT IS CDREALLYNOW=$convey_code<==\n";<STDIN>;
            my $eval_convey_code=eval $convey_code;
#print "WHAT IS THIS NOW=$eval_convey_code<==\n";
            $eval_convey_code||=sub {};
            @convey=$eval_convey_code->();
            #eval {
            #   my $die="\n       FATAL ERROR! - Error in Convey => "
            #          ."sub{ *CONTENT* },\n                      code block."
            #          ." To find error, copy the\n                      "
            #          ."*CONTENT* to a separate script, and\n"
            #          ."                      test for the error there. "
            #          ."Use the\n                      'use strict;' pragma."
            #          ."\n\n";
            #   @convey=$eval_convey_code->() or die $die;
            #};
            #if ($@) {
            #   die $@;
            #}
         } elsif (substr(${$Items{$num}}{Convey},0,1) eq '&') {
            if (defined $picks_from_parent &&
                          !ref $picks_from_parent) {
               my $transformed_convey=
                     &transform_pmsi(${$Items{$num}}{Convey},
                                     $Conveyed,$SaveMMap,
                                     $pmsi_regex,
                                     $amlm_regex,
                                     $picks_from_parent);
               @convey=eval $transformed_convey;
            }
         } else {
            push @convey, ${$Items{$num}}{Convey};
         }
         foreach my $item (@convey) {
            next if $item=~/^\s*$/s;
            my $text=${$Items{$num}}{Text};
            $text=~s/$con_regex/$item/g;
            $text=&transform_pmsi($text,
                  $Conveyed,$SaveMMap,$pmsi_regex,
                  $amlm_regex,$picks_from_parent);
            if (-1<index $text,"__Master_${$}__") {
               $text=~
                  s/__Master_${$}__/Local-Host: $Term::Menus::local_hostname/sg;
               $master_substituted="Local-Host: $Term::Menus::local_hostname";
            }
            if (exists ${$Items{$num}}{Include}) {
               if ($text=~/${$Items{$num}}{Include}/s) {
                  next if exists ${$Items{$num}}{Exclude} &&
                        $text=~/${$Items{$num}}{Exclude}/;
                  push @{$picks}, $text;
               } else { next }
            } elsif (exists ${$Items{$num}}{Exclude} &&
               $text=~/${$Items{$num}}{Exclude}/) {
               next;
            } else { push @{$picks}, $text }

            if (exists ${$Items{$num}}{Convey} &&
                  ${$Items{$num}}{Convey} ne '') {
               $convey{$text}=[$item,${$Items{$num}}{Convey}];
            } elsif (!exists ${$Items{$num}}{Convey}) {
               $convey{$text}=[$item,''];
            }
            $default{$text}=${$Items{$num}}{Default}
               if exists ${$Items{$num}}{Default};
#print "WHAT IS THIS=$text and NEGATE=",${$Items{$num}}{Negate}," and KEYS=",keys %{$Items{$num}},"\n";
            $negate{$text}=${$Items{$num}}{Negate}
               if exists ${$Items{$num}}{Negate};
            if (exists ${$FullMenu}{$MenuUnit_hash_ref}[2]{$text}) {
               $result{$text}=
                  ${$FullMenu}{$MenuUnit_hash_ref}[2]{$text};
            } elsif (exists ${$Items{$num}}{Result}) {
               $result{$text}=${$Items{$num}}{Result}
            }
            my $tsttt=${$Items{$num}}{Select};
            $select{$text}=${$Items{$num}}{Select}
               if exists ${$Items{$num}}{Select}
               && $tsttt=~/many/i;
            if (exists ${$Items{$num}}{Mark}) {
               $mark{$text}=${$Items{$num}}{Mark};
               my $lmt=length $mark{$text};
               $mark{BLANK}=$lmt if $mark{BLANK}<$lmt;
            }
            $filtered=1 if exists ${$Items{$num}}{Filter};
            $sorted=${$Items{$num}}{Sort}
               if exists ${$Items{$num}}{Sort};
            $chosen{$text}="Item_$num";
         }
      } else {
#print "PICKS_FROM_PARENT=$picks_from_parent\n";
         my $text=&transform_pmsi(${$Items{$num}}{Text},
                  $Conveyed,$SaveMMap,$pmsi_regex,$amlm_regex,
                  $picks_from_parent);
         if (-1<index ${$Items{$num}}{Text},"__Master_${$}__") {
            $text=~
               s/__Master_${$}__/Local-Host: $Term::Menus::local_hostname/sg;
            $master_substituted=
                             "Local-Host: $Term::Menus::local_hostname";
         }
         if (exists ${$Items{$num}}{Include}) {
            if (${$Items{$num}}{Text}=~/${$Items{$num}}{Include}/) {
               next if exists ${$Items{$num}}{Exclude} &&
                     ${$Items{$num}}{Text}=~/${$Items{$num}}{Exclude}/;
               push @{$picks}, $text;
            } else { next }
         } elsif (exists ${$Items{$num}}{Exclude} &&
            ${$Items{$num}}{Text}=~/${$Items{$num}}{Exclude}/) {
            next;
         } else { push @{$picks}, $text }
         $convey{${$Items{$num}}{Text}}=['',${$Items{$num}}{Convey}]
            if exists ${$Items{$num}}{Convey};
         $default{$text}=${$Items{$num}}{Default}
            if exists ${$Items{$num}}{Default};
         $negate{$text}=${$Items{$num}}{Negate}
            if exists ${$Items{$num}}{Negate};
         if (exists ${$FullMenu}{$MenuUnit_hash_ref}[2]{$text}) {
            $result{$text}=
               ${$FullMenu}{$MenuUnit_hash_ref}[2]{$text};
         } elsif (exists ${$Items{$num}}{Result}) {
            $result{$text}=${$Items{$num}}{Result}
         }
         #$result{$text}=${$Items{$num}}{Result}
         #   if exists ${$Items{$num}}{Result};
         my $tsttt=${$Items{$num}}{Select}||'';
         $select{$text}=${$Items{$num}}{Select}
            if exists ${$Items{$num}}{Select}
            && $tsttt=~/many/i;
         if (exists ${$Items{$num}}{Mark}) {
            $mark{$text}=${$Items{$num}}{Mark};
            my $lmt=length $mark{$text};
            $mark{BLANK}=$lmt if $mark{BLANK}<$lmt;
         }
         $filtered=1 if exists ${$Items{$num}}{Filter};
         $sorted=${$Items{$num}}{Sort}
            if exists ${$Items{$num}}{Sort};
         $chosen{$text}="Item_$num";
         $num__{$text}=${$Items{$num}}{__NUM__}
            if exists ${$Items{$num}}{__NUM__};
      } $banner='';
   }


      #########################################
      # End Items Breakdown

   $banner=${$_[0]}{Banner}
      if exists ${$_[0]}{Banner};
   if (ref $banner eq 'CODE') {
      my $banner_code=$banner;
      if ($Term::Menus::data_dump_streamer) {
         $banner_code=
            &Data::Dump::Streamer::Dump($banner_code)->Out();
#print "PICKSFROMPARENTXX=$picks_from_parent AND CONVEY_CODE=$convey_code\n";
         $banner_code=&transform_pmsi($banner_code,
            $Conveyed,$SaveMMap,$pmsi_regex,$amlm_regex,
            $picks_from_parent);
      }
#print "WHAT IS CDNOW=$banner_code<==\n";<STDIN>;
      $banner_code=~s/\$CODE\d*\s*=\s*//s;
#print "WHAT IS CDREALLYNOW=$banner_code<==\n";<STDIN>;
      my $eval_banner_code=eval $banner_code;
#print "WHAT IS THIS NOW=$eval_banner_code<==\n";
      $eval_banner_code||=sub {};
      eval {
         my $die="\n"
                ."       FATAL ERROR! - Error in Banner => sub{ *CONTENT* },\n"
                ."                      code block. To find error, copy the\n"
                ."                      *CONTENT* to a separate script, and\n"
                ."                      test for the error there. Use the\n"
                ."                      'use strict;' pragma.\n\n";
         $banner=$eval_banner_code->() or die $die;
      };
      if ($@) {
         die $@;
      }
   } else {
      $banner=&transform_pmsi($banner,
         $Conveyed,$SaveMMap,$pmsi_regex,$amlm_regex,
         $picks_from_parent);
   }
   if ($banner && unpack('a1',$banner) eq '&' &&
         defined $picks_from_parent &&
         !ref $picks_from_parent) {
      my @banner=eval $banner;
      $banner=join '',@banner;
   }
   $display_this_many_items=${$_[0]}{Display}
      if exists ${$_[0]}{Display};


   ############################################
   # End MenuUnit Breakdown
   ############################################

   my $cl_def=0;
   foreach my $key (keys %{$SaveNext}) {
      if (${$FullMenu}{$key}[5] eq 'ERASE') {
         ${$FullMenu}{$key}[5]='' if !exists ${$SavePick}{$key};
         $cl_def=1;
         last;
      }
   }
   %default=() if defined ${$FullMenu}{$MenuUnit_hash_ref}[5]
      && !$cl_def;
   my $nm_=(keys %num__)?\%num__:{};
   ${$FullMenu}{$MenuUnit_hash_ref}=[ $MenuUnit_hash_ref,
      \%negate,\%result,\%convey,\%chosen,\%default,
      \%select,\%mark,$nm_,$filtered,$picks ];
   #if (exists ${$MenuUnit_hash_ref}{Select} &&
   #      ${$MenuUnit_hash_ref}{Select} eq 'Many') {
   if ($select_many || keys %{${$MenuUnit_hash_ref}{Select}}) {
      ($pick,$FullMenu,$Selected,$Conveyed,$SavePick,
              $SaveMMap,$SaveNext,$Persists,$parent_menu)=&pick(
                        $picks,$banner,
                        $display_this_many_items,'','',
                        $MenuUnit_hash_ref,++$recurse,
                        $picks_from_parent,$parent_menu,
                        $FullMenu,$Selected,$Conveyed,$SavePick,
                        $SaveMMap,$SaveNext,$Persists,
                        #\@convey,$no_wantarray,$sorted,
                        $no_wantarray,$sorted,
                        $select_many);
      if ($Term::Menus::fullauto && $master_substituted) {
         $pick=~s/$master_substituted/__Master_${$}__/sg;
      }
      if ($pick eq ']quit[') {
         return ']quit['
      } elsif ($pick eq '-' || $pick eq '+') {
#print "PICKMINUSPLUS=$pick\n";
         return $pick,$FullMenu,$Selected,$Conveyed,
                    $SavePick,$SaveMMap,$SaveNext,$Persists;
      } elsif ($pick=~/DONE/) {
         return $pick,$FullMenu,$Selected,$Conveyed,
                       $SavePick,$SaveMMap,$SaveNext,$Persists;
      } elsif (ref $pick eq 'ARRAY' && wantarray
            && !$no_wantarray && 1==$recurse) {
         my @choyce=@{$pick};undef @{$pick};undef $pick;
         return @choyce
      } elsif ($pick) { return $pick }
   } else {
      ($pick,$FullMenu,$Selected,$Conveyed,$SavePick,
              $SaveMMap,$SaveNext,$Persists,$parent_menu)
              =&pick($picks,$banner,$display_this_many_items,
                       '','',$MenuUnit_hash_ref,++$recurse,
                       $picks_from_parent,$parent_menu,
                       $FullMenu,$Selected,$Conveyed,$SavePick,
                       $SaveMMap,$SaveNext,$Persists,
                       #\@convey,$no_wantarray,$sorted,
                       $no_wantarray,$sorted,
                       $select_many);
#print "WAHT IS ALL=$pick and FULL=$FullMenu and SEL=$Selected and CON=$Conveyed and SAVE=$SavePick and LAST=$SaveMMap and NEXT=$SaveNext and PERSISTS=$Persists  and PARENT=$parent_menu<==\n";
      if ($Term::Menus::fullauto && $master_substituted) {
         $pick=~s/$master_substituted/__Master_${$}__/sg;
      }
      if ($pick eq ']quit[') {
         return ']quit['
      } elsif ($pick eq '-' || $pick eq '+') {
#print "PICKMINUSPLUS2=$pick\n";
         if ($select_many || keys %{${$Selected}{$MenuUnit_hash_ref}}) {
            return '+',$FullMenu,$Selected,$Conveyed,
                       $SavePick,$SaveMMap,$SaveNext,$Persists;
         } else {
            return $pick,$FullMenu,$Selected,$Conveyed,
                       $SavePick,$SaveMMap,$SaveNext,$Persists;
         }
      } elsif ($pick=~/DONE/) {
         return $pick,$FullMenu,$Selected,$Conveyed,
                       $SavePick,$SaveMMap,$SaveNext,$Persists;
      } elsif (ref $pick eq 'ARRAY') {
         if (wantarray && 1==$recurse) {
            my @choyce=@{$pick};undef @{$pick};undef $pick;
            return @choyce
         } elsif (!$picks_from_parent &&
               !(keys %{${$MenuUnit_hash_ref}{Select}})) {
               #${$MenuUnit_hash_ref}{Select} eq 'One') {
            return $pick->[0];
         } else { return $pick }
      } elsif ($pick) { return $pick }
   }

}

sub transform_sicm
{

#print "TRANSFROM_SCIM_CALLER=",caller,"\n";
   ## sicm - [s]elected [i]tems [c]urrent [m]enu
   my ($text,$sicm_regex,$numbor,$all_menu_items_array,
       $picks,$return_from_child_menu,$log_handle)=@_;
   my $selected=[];my $replace='';
   my $expand_array_flag=0;
   if ((-1<index $text,'][[') && (-1<index $text,']][')) {
      unless ($text=~/^\s*\]\[\[\s*/s && $text=~/\s*\]\]\[\s*$/s) {
         my $die="\n       FATAL ERROR! - The --RETURN-ARRAY-- Macro"
                ."\n            Boundary indicators: '][[' and ']]['"
                ."\n            are only supported at the beginning"
                ."\n            and end of the return instructions."
                ."\n            Nothing but white space should precede"
                ."\n            the left indicator, nor extend beyond"
                ."\n            the right indicator.\n"
                ."\n       Your String:\n"
                ."\n            $text\n"
                ."\n       Remedy: Recreate your return instructions"
                ."\n            to conform to this convention. Also"
                ."\n            be sure to use the Macro delimiter"
                ."\n            indicator ']|[' to denote return array"
                ."\n            element separation boundaries."
                ."\n       Example:\n"
                ."\n            '][[ ]S[ ]|[ ]P[{Menu_One} ]|[ SomeString ]]['"
                ."\n";
         if (defined $log_handle &&
               -1<index $log_handle,'*') {
            print $log_handle $die;
            close($log_handle);
         }
      }
      $expand_array_flag=1;
   }
   if (keys %{$picks} && !$return_from_child_menu) {
      foreach my $key (sort numerically keys %{$picks}) {
         push @{$selected},${$all_menu_items_array}[$key-1];
      }
      $replace=&Data::Dump::Streamer::Dump($selected)->Out();
      $replace=~s/\$ARRAY\d*\s*=\s*//s;
      $replace=~s/\'/\\\'/sg;
      if ($expand_array_flag) {
         $replace='eval '.$replace;
      }
   } else {
      $replace=${$all_menu_items_array}[$numbor-1];
   }
   while ($text=~m/($sicm_regex)/g) {
      my $esc_one=$1;
      $esc_one=~s/\]/\\\]/;$esc_one=~s/\[/\\\[/;
      $text=~s/$esc_one/$replace/g;
   }
   return $text;

}

sub transform_pmsi
{

#print "TRANSFORM_PMSI CALLER=",caller,"\n";
   ## pmsi - [p]revious [m]enu [s]elected [i]tems 
   my ($text,$Conveyed,$SaveMMap,$pmsi_regex,$amlm_regex,
       $picks_from_parent,$log_handle)=@_;
#print "CONVEYED=$Conveyed and PICKS=$picks_from_parent<==\n";
   my $expand_array_flag=0;
   $text=~s/\s?$//s;
   if ((-1<index $text,'][[') && (-1<index $text,']][')) {
      unless ($text=~/^\s*\]\[\[\s*/s && $text=~/\s*\]\]\[\s*$/s) {
         my $die="\n       FATAL ERROR! - The --RETURN-ARRAY-- Macro"
                ."\n            Boundary indicators: '][[' and ']]['"
                ."\n            are only supported at the beginning"
                ."\n            and end of the return instructions."
                ."\n            Nothing but white space should precede"
                ."\n            the left indicator, nor extend beyond"
                ."\n            the right indicator.\n"
                ."\n       Your String:\n"
                ."\n            $text\n"
                ."\n       Remedy: Recreate your return instructions"
                ."\n            to conform to this convention. Also"
                ."\n            be sure to use the Macro delimiter"
                ."\n            indicator ']|[' to denote return array"
                ."\n            element separation boundaries."
                ."\n       Example:\n"
                ."\n            '][[ ]S[ ]|[ ]P[{Menu_One} ]|[ SomeString ]]['"
                ."\n";
         if (defined $log_handle &&
               -1<index $log_handle,'*') {
            print $log_handle $die;
            close($log_handle);
         }
      }
      $expand_array_flag=1;
   }
   while ($text=~m/($pmsi_regex(?:\{[^}]+\})*)/sg) {
      my $esc_one=$1;
      $esc_one=~s/\]/\\\]/;$esc_one=~s/\[/\\\[/;
      $esc_one=~s/\{/\{\(/;$esc_one=~s/\}/\)\}/;
      while ($esc_one=~/\{/ && $text=~m/$esc_one/) {
         unless (exists ${$Conveyed}{$1}) {
            my $die="\n       FATAL ERROR! - The Menu Label:  \"$1\""
                   ."\n            describes a Menu that is *NOT* in the"
                   ."\n            invocation history of this process.\n"
                   ."\n       This Error is usually the result of a missing,"
                   ."\n            Menu, a Menu block that is not exported or"
                   ."\n            was not coded ABOVE the parent Menu hash"
                   ."\n            block, or whose Label was missing or"
                   ."\n            mis-spelled or mis-labeled.\n"
                   ."\n       Remedy: Be sure to ALWAYS Label your Menu"
                   ."\n            blocks, and that the Label is the SAME"
                   ."\n            identical name as the Menu hash block"
                   ."\n            itself. Also be sure to use a unique"
                   ."\n            name for every Menu.\n"
                   ."\n       Example:   my %Example_Menu=(\n"
                   ."\n                     Label  => 'Example_Menu',\n"
                   ."\n                     Item_1 => {"
                   ."\n                            ...   # ]P[ is a Macro 'Previous'"
                   ."\n                        Result => sub { return ']P[{Parent_Menu}' },"
                   ."\n                  );"
                   ."\n                  my %Parent_Menu=(\n"
                   ."\n                     Label  => 'Parent_Menu',\n"
                   ."\n                     Item_1 => {"
                   ."\n                            ..."
                   ."\n                        Result => \\%Example_Menu,"
                   ."\n                            ..."
                   ."\n                  );\n"
                   ."\n";
            if (defined $log_handle &&
                  -1<index $log_handle,'*') {
               print $log_handle $die;
               close($log_handle);
            }
            if ($Term::Menus::fullauto) {
               &Net::FullAuto::FA_Core::handle_error($die);
            } else { die $die }
         }
         my $replace=${$Conveyed}{$1};
         if (ref $replace) {
            $replace=&Data::Dump::Streamer::Dump(${$Conveyed}{$1})->Out();
            my $type=ref ${$Conveyed}{$1};
            $replace=~s/\$$type\d*\s*=\s*//s;
            $replace=~s/\'/\\\'/sg;
            if ($expand_array_flag) {
               $replace='eval '.$replace;
            }
         }
         $text=~s/$esc_one/$replace/se;
      }
      my $replace='';
      if (ref $picks_from_parent eq 'ARRAY') {
         $replace=&Data::Dump::Streamer::Dump($picks_from_parent)->Out();
         my $type=ref $picks_from_parent;
         $replace=~s/\$$type\d*\s*=\s*//s;
         $replace=~s/\'/\\\'/sg;
         if ($expand_array_flag) {
            $replace='eval '.$replace;
         }
      } else {
         $replace=$picks_from_parent;
      }
      $text=~s/$esc_one/$replace/s;
   }
   while ($text=~m/($amlm_regex(?:\{[^}]+\})*)/sg) {
      my $esc_one=$1;
      $esc_one=~s/\]/\\\]/;$esc_one=~s/\[/\\\[/;
      $esc_one=~s/\{/\{\(/;$esc_one=~s/\}/\)\}/;
      my $replace=${$Conveyed}{$1};
      if (ref $replace) {
         $replace=&Data::Dump::Streamer::Dump(${$Conveyed}{$1})->Out();
         my $type=ref ${$Conveyed}{$1};
         $replace=~s/\$$type\d*\s*=\s*//s;
         $replace=~s/\'/\\\'/sg;
         if ($expand_array_flag) {
            $replace='eval '.$replace;
         }
      }
      $text=~s/$esc_one/$replace/se;
   }
   return $text;

}

sub pick # USAGE: &pick( ref_to_choices_array,
             #  (Optional)       banner_string,
             #  (Optional)       display_this_many_items,
             #  (Optional)       return_index_only_flag,
             #  (Optional)       log_file_handle,
             #  ----------
             #  For Use With Sub-Menus
             #  ----------
             #  (Optional)       MenuUnit_hash_ref,
             #  (Optional)       recurse_level,
             #  (Optional)       picks_from_parent,
             #  (Optional)       parent_menu,
             #  (Optional)       menus_cfg_file,
             #  (Optional)       Full_Menu_data_structure,
             #  (Optional)       Selected_data_structure,
             #  (Optional)       Conveyed_data_structure,
             #  (Optional)       SavePick_data_structure,
             #  (Optional)       SaveMMap_data_structure,
             #  (Optional)       SaveNext_data_structure,
             #  (Optional)       Persists_data_structure,
             #  (Optional)       no_wantarray_flag,
             #  (Optional)       sorted
             #  (Optional)       select_many )
{

#print "PICKCALLER=",caller," and Argument 7 =>$_[6]<=\n";sleep 3;

   #  "pick" --> This function presents the user with
   #  with a list of items from which to choose.

   my @all_menu_items_array=@{$_[0]};
   my $banner=defined $_[1] ? $_[1] : "\n   Please Pick an Item :";
   my $display_this_many_items=defined $_[2] ? $_[2] : 10;
   my $return_index_only_flag=(defined $_[3]) ? 1 : 0;
   my $log_handle= (defined $_[4]) ? $_[4] : '';

   # Used Only With Cascasding Menus (Optional)
   my $MenuUnit_hash_ref= (defined $_[5]) ? $_[5] : {};
   ${$MenuUnit_hash_ref}{Select}||={};
   my $recurse_level= (defined $_[6]) ? $_[6] : 1;
   my $picks_from_parent= (defined $_[7]) ? $_[7] : '';
   my $parent_menu= (defined $_[8]) ? $_[8] : '';
   my $FullMenu= (defined $_[9]) ? $_[9] : {};
   my $Selected= (defined $_[10]) ? $_[10] : {};
   my $Conveyed= (defined $_[11]) ? $_[11] : {};
   my $SavePick= (defined $_[12]) ? $_[12] : {};
   my $SaveMMap= (defined $_[13]) ? $_[13] : {};
   my $SaveNext= (defined $_[14]) ? $_[14] : {};
   my $Persists= (defined $_[15]) ? $_[15] : {};
   my $no_wantarray= (defined $_[16]) ? $_[16] : 0;
   my $sorted= (defined $_[17]) ? $_[17] : 0;
   my $select_many= (defined $_[18]) ? $_[18] : 0;

   my %items=();my %picks=();my %negate=();
   my %exclude=();my %include=();my %default=();
   my %labels=();
   foreach my $menuhash (keys %{$FullMenu}) {
      if (exists ${$FullMenu}{$menuhash}[0]->{Label}) {
         $labels{${$FullMenu}{$menuhash}[0]->{Label}}=
            ${$FullMenu}{$menuhash}[0];
      }
   }
   if ($SavePick && exists ${$SavePick}{$MenuUnit_hash_ref}) {
      %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
   }
   my $num_pick=$#all_menu_items_array+1;
   my $caller=(caller(1))[3]||'';
   #unless ($Persists->{unattended}) {
   #   if ($^O ne 'cygwin') {
   #      unless ($noclear) {
   #         if ($^O eq 'MSWin32' || $^O eq 'MSWin64') {
   #            system("cmd /c cls");
   #            print "\n";
   #         } else {
   #            print `${Term::Menus::clearpath}clear`."\n";
   #         }
   #      } else { print "ONE\n";print $blanklines }
   #   } else { print "TWO\n";print $blanklines }
   #}
   my $numbor=0;                    # Number of Item Selected
   my $ikey='';                     # rawInput Key - key used
                                    #    to end menu. Can be
                                    #    any non-alphanumeric
                                    #    key like Enter or
                                    #    Right Arrow.
   my $return_from_child_menu=0;

   my $choose_num='';
   my $convey='';
   my $menu_output='';
   my $hidedefaults=0;
   my $start=0;
   my $got_default=0;

   sub delete_Selected
   {
      my $Selected=$_[2];
      my $SavePick=$_[3];
      my $SaveNext=$_[4];
      my $Persists=$_[5];
      if ($_[1]) {
         my $result=${$Selected}{$_[0]}{$_[1]};
         delete ${$Selected}{$_[0]}{$_[1]};
         delete ${$SavePick}{$_[0]}{$_[1]};
         if ($result) {
            &delete_Selected($result,'',
                $Selected,$SavePick,$SaveNext);
         } delete ${$SaveNext}{$_[0]};
      } else {
         if (keys %{${$Selected}{$_[0]}}) {
            foreach my $key (keys %{${$Selected}{$_[0]}}) {
               delete ${$Selected}{$_[0]}{$key};
               delete ${$SavePick}{$_[0]}{$key};
               delete ${$SaveNext}{$_[0]};
            }
         } else {
            foreach my $key (keys %{${$SavePick}{$_[0]}}) {
               delete ${$SavePick}{$_[0]}{$key};
               delete ${$SaveNext}{$_[0]};
            }
         }
      } delete ${$SaveNext}{$_[0]};
      return $SaveNext;

   }

   sub find_Selected
   {
      my $Selected=$_[2];
      if ($_[1]) {
         my $result=${$Selected}{$_[0]}{$_[1]};
         if (substr($result,0,1) eq '&') {
            return 0;
         } else {
            return &find_Selected($result,'',$Selected);
         }
      } else {
         if (keys %{${$Selected}{$_[0]}}) {
            foreach my $key (keys %{${$Selected}{$_[0]}}) {
               my $result=${$Selected}{$_[0]}{$key};
               return '+' if substr($result,0,1) eq '&';
               my $output=&find_Selected($result,'',$Selected);
               return '+' if $output eq '+';
            }
         }
      }
   }

   sub get_subs_from_menu
   {
      my $Selected=$_[0];
      my @subs=();
      foreach my $key (keys %{$Selected}) {
         foreach my $item (keys %{${$Selected}{$key}}) {
            if (substr(${$Selected}{$key}{$item},0,1) eq '&') {
               push @subs, escape_quotes(
                  unpack('x1 a*',${$Selected}{$key}{$item}));
            } elsif (ref ${$Selected}{$key}{$item} eq 'CODE') {
               push @subs, ${$Selected}{$key}{$item};
            } 
         }
      } return @subs;
   }

   my $get_result = sub {

#print "GET_RESULT CALLER=",caller,"\n";

      # $_[0] => $MenuUnit_hash_ref
      # $_[1] => \@all_menu_items_array
      # $_[2] => $picks
      # $_[3] => $picks_from_parent

      my $convey=[];
      my $FullMenu=$_[4];
      my $Conveyed=$_[5];
      my $Selected=$_[6];
      my $SaveNext=$_[7];
      my $Persists=$_[8];
      my $parent_menu=$_[9];
      ${$Term::Menus::LookUpMenuName}{$_[0]}=${$_[0]}{'Label'}
         unless exists ${$Term::Menus::LookUpMenuName}{$_[0]};
      my $pick=(keys %{$_[2]})[0] || '';
      if ($pick && exists ${$FullMenu}{$_[0]}[3]{${$_[1]}[$pick-1]}) {
         if ($pick && exists ${$_[0]}{${$FullMenu}{$_[0]}
                            [4]{${$_[1]}[$pick-1]}}{Convey}) {
            my $contmp='';
            if (0<$#{[keys %{$_[2]}]}) {
               foreach my $numb (sort numerically keys %{$_[2]}) {
                  $contmp=${${$FullMenu}{$_[0]}[3]}
                                   {${$_[1]}[$numb-1]}[0];
                  $contmp=~s/\s?$//s;
                  push @{$convey}, $contmp;
               }
            } else {
               $convey=${${${$FullMenu}{$_[0]}[3]}{${$_[1]}[$pick-1]}}[0];
               $convey=~s/\s?$//s;
            }
            $convey='SKIP' if $convey eq '';
            if (ref $convey eq 'ARRAY' && $#{$convey}==0) {
               $convey=$convey->[0];
            }
         }
#print "WHAT IS CONVEYXXXXXXXXXXXXX=@{$convey} and PICK=$pick<==\n";<STDIN>;
         if ($pick && exists ${$_[0]}{${$FullMenu}{$_[0]}
               [4]{${$_[1]}[$pick-1]}}{Convey} &&
               ref ${$_[0]}{${$FullMenu}{$_[0]}
               [4]{${$_[1]}[$pick-1]}}{Convey} eq 'HASH') {
#print "ARE WE HEREEEEEEEEEEEEEEEEE\n";<STDIN>;
            ${$Conveyed}{${$Term::Menus::LookUpMenuName}{$_[0]}}=$convey;
            $parent_menu=${$Term::Menus::LookUpMenuName}{$_[0]};
            if (ref ${$_[0]}{${$FullMenu}{$_[0]}
                  [4]{${$_[1]}[$pick-1]}}{'Result'} eq 'HASH') {
               if (exists ${$_[0]}{${$FullMenu}{$_[0]}
                     [4]{${$_[1]}[$pick-1]}}{'Result'}{'Label'}) {
                  $Term::Menus::LookUpMenuName{${$_[0]}{${$FullMenu}{$_[0]}
                     [4]{${$_[1]}[$pick-1]}}{'Result'}}=
                     ${$_[0]}{${$FullMenu}{$_[0]}
                     [4]{${$_[1]}[$pick-1]}}{'Result'}{'Label'};
                  $parent_menu=$Term::Menus::LookUpMenuName{$_[0]};
               } else {
                  my $mcmf=$Term::Menus::menu_config_module_file;
                  my $die="The \"Result1 =>\" Setting".
                          "\n\t\tFound in the Menu Unit -> ".
                          "${$MenuUnit_hash_ref}{'Label'}\n\t\tis a ".
                          "HASH reference to a Menu Unit\,\n\t\t".
                          "that does NOT EXIST or is NOT EXPORTED".
                          "\n\n\tHint: Make sure the Names of all".
                          "\n\t      Menu Hash Blocks in the\n\t".
                          "      $mcmf file are\n\t".
                          "      listed in the \@EXPORT list\n\t".
                          "      found at the beginning of\n\t".
                          "      the $mcmf file\n\n\t".
                          "our \@EXPORT = qw( %Menu_1 %Menu_2 ... )\;\n";
                  die $die;
               }
            } elsif (unpack('a1',
                  ${$_[0]}{${$FullMenu}{$_[0]}
                  [4]{${$_[1]}[$pick-1]}}{'Result'})
                  ne '&') {
            }
         }
         ${$Conveyed}{${$_[0]}{'Label'}}=$convey;
      } elsif ($_[3]) {
         $convey=$_[3];
         ${$Conveyed}{${$_[0]}{'Label'}}=$convey;
      } elsif ($pick) {
         $convey=${$_[1]}[$pick-1];
         ${$Conveyed}{${$_[0]}{'Label'}}=$convey;
      }
      $convey='' if !$convey ||
            (ref $convey eq 'ARRAY' && $#{$convey}==-1);
      my $test_item=${$FullMenu}{$_[0]}[2]{${$_[1]}[$pick-1]}
         if $pick;
      $test_item||='';
      if ($pick &&
            exists ${$FullMenu}{$_[0]}[2]{${$_[1]}[$pick-1]}) {
#print "WHAT IS TEST_ITEM=$test_item and KEYS=",(join " ",keys %{$test_item}),"\n";
         if ((ref $test_item eq 'HASH' &&
                   exists $test_item->{Item_1})
                   || substr($test_item,0,1) eq '&'
                   || ref $test_item eq 'CODE') {
            my $con_regex=qr/\]c(o+nvey)*\[/i;
            my $sicm_regex=
               qr/\]s(e+lected[-_]*)*i*(t+ems[-_]*)
                  *c*(u+rrent[-_]*)*m*(e+nu[-_]*)*\[/xi;
            my $pmsi_regex=qr/\]p(r+evious[-_]*)*m*(e+nu[-_]*)
                  *s*(e+lected[-_]*)*i*(t+ems[-_]*)*\[/xi;
            my $amlm_regex=qr/\]a(n+cestor[-_]*)*m*(e+nu[-_]*)
                  *l*(a+bel[-_]*)*m*(a+p[-_]*)*\[/xi;
            if (ref $test_item eq 'HASH' &&
                    !exists ${$Term::Menus::LookUpMenuName}{$test_item}) {
               if (exists ${$test_item}{'Label'}) {
                  $Term::Menus::LookUpMenuName{$test_item}=
                     ${$test_item}{'Label'};
               } else {
                  my $mcmf=$Term::Menus::menu_config_module_file;
                  my $die="The \"Result2 =>\" Setting".
                          "\n\t\tFound in the Menu Unit -> ".
                          "${$MenuUnit_hash_ref}{'Label'}\n\t\tis a ".
                          "HASH reference to a Menu Unit\,\n\t\t".
                          "that does NOT EXIST or is NOT EXPORTED".
                          "\n\n\tHint: Make sure the Names of all".
                          "\n\t      Menu Hash Blocks in the\n\t".
                          "      $mcmf file are\n\t".
                          "      listed in the \@EXPORT list\n\t".
                          "      found at the beginning of\n\t".
                          "      the $mcmf file\n\n\t".
                          "our \@EXPORT = qw( %Menu_1 %Menu_2 ... )\;\n";
                  die $die;
               }
            }
            if ($test_item=~/$con_regex|$pmsi_regex|$amlm_regex|$sicm_regex/) {
               $test_item=&transform_sicm($test_item,$sicm_regex,$numbor,
                             \@all_menu_items_array,$_[2],
                             $return_from_child_menu,$log_handle);
               $test_item=&transform_pmsi($test_item,
                       $Conveyed,$SaveMMap,$pmsi_regex,$amlm_regex,
                       $picks_from_parent,$log_handle);
            } elsif (ref $test_item eq 'CODE') {
               my $cd='';
               if ($Term::Menus::data_dump_streamer) {
                  #tie *memhand, "TMMemHandle";
                  #my $me=\*memhand;
                  #print $me &Data::Dump::Streamer::Dump($test_item)->Out();
                  #$cd=<$me>;
                  $cd=&Data::Dump::Streamer::Dump($test_item)->Out();
                  $cd=&transform_sicm($cd,$sicm_regex,$numbor,
                         \@all_menu_items_array,$_[2],
                         $return_from_child_menu,$log_handle);
                  $cd=&transform_pmsi($cd,
                         $Conveyed,$SaveMMap,$pmsi_regex,
                         $amlm_regex,$picks_from_parent);
               }
               $cd=~s/\$CODE\d*\s*=\s*//s;
               eval { $test_item=eval $cd };
               if ($@) {
                  if (unpack('a11',$@) eq 'FATAL ERROR') {
                     if (defined $log_handle &&
                           -1<index $log_handle,'*') {
                        print $log_handle $@;
                        close($log_handle);
                     }
                     die $@;
                  } else {
                     my $die="\n       FATAL ERROR! - The Local "
                            ."System $Term::Menus::local_hostname Conveyed\n"
                            ."              the Following "
                            ."Unrecoverable Error Condition :\n\n"
                            ."       $@";
                     if (defined $log_handle &&
                           -1<index $log_handle,'*') {
                        print $log_handle $die;
                        close($log_handle);
                     }
                     if ($parent_menu && wantarray && !$no_wantarray) {
                        return '',
                           $FullMenu,$Selected,$Conveyed,
                           $SavePick,$SaveMMap,$SaveNext,
                           $Persists,$parent_menu,$die;
                     } elsif ($Term::Menus::fullauto) {
                        &Net::FullAuto::FA_Core::handle_error($die);
                     } else { die $die }
                  }
               }
               $Selected={ key => { item => $test_item } };
               return $FullMenu,$Conveyed,$SaveNext,
                      $Persists,$Selected,$convey,$parent_menu;
            }
            if ($test_item=~/Convey\s*=\>/) {
               if ($convey ne 'SKIP') {
                  $test_item=~s/Convey\s*=\>/$convey/g;
               } else {
                  $test_item=~s/Convey\s*=\>/${$_[1]}[$pick-1]/g;
               }
            }
            if ($test_item=~/Text\s*=\>/) {
               $test_item=~s/Text\s*=\>/${$_[1]}[$pick-1]/g;
            }
         } else {
            my $die="The \"Result3 =>\" Setting\n              -> "
                   .${$FullMenu}{$_[0]}[2]{${$_[1]}[$_[2]-1]}
                   ."\n              Found in the Menu Unit -> "
                   .$MenuUnit_hash_ref
                   ."\n              is not a Menu Unit\,"
                   ." and Because it Does Not Have"
                   ."\n              an \"&\" as"
                   ." the Lead Character, $0"
                   ."\n              Cannot Determine "
                   ."if it is a Valid SubRoutine.\n\n";
            die $die;
         }
      }
      chomp($pick) if $pick;
      ${$Selected}{$_[0]}{$pick}=$test_item if $pick;
      if ($pick && ref ${$_[0]}{${$FullMenu}{$_[0]}
            [4]{${$_[1]}[$pick-1]}}{'Result'} eq 'HASH') {
         if (exists ${$_[0]}{${$FullMenu}{$_[0]}
               [4]{${$_[1]}[$pick-1]}}{'Result'}{'Label'}) {
            ${$SaveNext}{$_[0]}=
               ${${$FullMenu}{$_[0]}[2]}
               {${$_[1]}[$pick-1]};
         } else {
            my $mcmf=$Term::Menus::menu_config_module_file;
            my $die="The \"Result4 =>\" Setting".
                   "\n\t\tFound in the Menu Unit -> ".
                   "${$MenuUnit_hash_ref}{'Label'}\n\t\tis a ".
                   "HASH reference to a Menu Unit\,\n\t\t".
                   "that does NOT EXIST or is NOT EXPORTED".
                   "\n\n\tHint: Make sure the Names of all".
                   "\n\t      Menu Hash Blocks in the\n\t".
                   "      $mcmf file are\n\t".
                   "      listed in the \@EXPORT list\n\t".
                   "      found at the beginning of\n\t".
                   "      the $mcmf file\n\n\t".
                   "our \@EXPORT = qw( %Menu_1 %Menu_2 ... )\;\n";
            die $die;
         }
      }
      return $FullMenu,$Conveyed,$SaveNext,
             $Persists,$Selected,$convey,$parent_menu;
   };

   my $sum_menu=0;my $filtered_menu=0;my $defaults_exist=0;
   while (1) {
      if ($num_pick-$start<=$display_this_many_items) {
         $choose_num=$num_pick-$start;
      } else { $choose_num=$display_this_many_items }
      $numbor=$start+$choose_num+1;my $done=0;my $savechk=0;my %pn=();
      my $sorted_flag=0;
      $Persists->{$MenuUnit_hash_ref}={} unless exists
         $Persists->{$MenuUnit_hash_ref};
      if (!exists $Persists->{$MenuUnit_hash_ref}{defaults} &&
               defined ${[keys %{${$FullMenu}{$MenuUnit_hash_ref}[5]}]}[0]) {
         my $it=${[keys %{${$FullMenu}{$MenuUnit_hash_ref}[5]}]}[0];
         my $def=${$FullMenu}{$MenuUnit_hash_ref}[5]{$it};
         if ($def) {
            $def='.*' if $def eq '*';
            foreach my $item (
                  @{[keys %{${$FullMenu}{$MenuUnit_hash_ref}[5]}]}) {
               if ($item=~/$def/) {
                  $Persists->{$MenuUnit_hash_ref}{defaults}=1;
               } 
            }
         }
      }
      $Persists->{$MenuUnit_hash_ref}{defaults}=0 unless exists
         $Persists->{$MenuUnit_hash_ref}{defaults};
      my $plann='';my $plannn='';
      if (ref $Net::FullAuto::FA_Core::plan eq 'HASH') {
         my $plann=shift @{$Net::FullAuto::FA_Core::plan};
         $plannn=${$plann}{Item}; 
         my $plan_='';
         if (substr($plannn,2,5) eq 'ARRAY') {
            ${$MenuUnit_hash_ref}{Label}||='Unlabeled';
            my $eval_plan=substr($plannn,1,-1);
            $plan_=eval $eval_plan;
         } else {
            $plan_=$plannn;
         }
         if (${$MenuUnit_hash_ref}{Label} eq ${$plann}{Label}) {
            return $plan_;
         } else {
            my $die="\n       FATAL ERROR! -  Plan Number ${$plann}{PlanID}"
                   ." does"
                   ."\n                       match the current logic flow."
                   ."\n\n      ";
            die($die);
         }
      }
#print "NUMBORX=$numbor<==\n";
      while ($numbor=~/\d+/ &&
            ($numbor<=$start || $start+$choose_num < $numbor)) {
         my $menu_text='';my $picknum_for_display='';
         $menu_text.=$banner if defined $banner;
         $menu_text.="\n\n";
#print "WHAT IS START=$start\n";
         my $picknum=$start+1;
         my $numlist=$choose_num;
         my $mark='';
         my $mark_len=${$FullMenu}{$MenuUnit_hash_ref}[7]{BLANK};
         while ($mark_len--) {
            $mark.=' ';
         }
         my $mark_blank=$mark;
         my $mark_flg=0;my $prev_menu=0;
         while (0 < $numlist) {
            if (exists $picks{$picknum}) {
               $mark_flg=1;
               if ($return_from_child_menu) {
                  $mark=$mark_blank;
                  substr($mark,-1)=$picks{$picknum}=$return_from_child_menu;
                  %{${$SavePick}{$MenuUnit_hash_ref}}=%picks;
                  $prev_menu=$picknum;
#print "DO WE GET HERE3 and SEL=${$MenuUnit_hash_ref}{Select}!\n";
               } else {
                  $mark=$mark_blank;
                  substr($mark,-1)=$picks{$picknum};
               }
#print "DO WE GET HERE4 and SEL=${$MenuUnit_hash_ref}{Select}!\n";
               #if ((${$MenuUnit_hash_ref}{Select} eq 'Many'
               my $gotmany=($select_many ||
                     (keys %{${$MenuUnit_hash_ref}{Select}})) ? 1 : 0;
               if (($gotmany
                     && $numbor=~/^[Ff]$/) || ($picks{$picknum} ne
                     '+' && $picks{$picknum} ne '-' &&
                     !$gotmany)) {
                     #${$MenuUnit_hash_ref}{Select} ne 'Many')) {
#print "DO WE GET HERE5! and ${$MenuUnit_hash_ref}{Select}\n";
                  $mark_flg=1;
                  $mark=$mark_blank;
                  substr($mark,-1)='*';
                  if ((exists ${$FullMenu}{$MenuUnit_hash_ref}[2]
                        {$all_menu_items_array[$picknum-1]}) && ref
                        ${$FullMenu}{$MenuUnit_hash_ref}[2]
                        {$all_menu_items_array[$picknum-1]} eq 'HASH' &&
                        (exists ${$FullMenu}{$MenuUnit_hash_ref}[2]
                        {$all_menu_items_array[$picknum-1]}{Item_1})) {
                     if (exists ${$FullMenu}{$MenuUnit_hash_ref}[3]
                                      {$all_menu_items_array[$picknum-1]}) {
                        $convey=${${$FullMenu}{$MenuUnit_hash_ref}[3]
                                      {$all_menu_items_array[$picknum-1]}}[0];
                     } else { $convey=$all_menu_items_array[$picknum-1] }
                     $SaveNext=$SavePick;
                     eval {
                        ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
                           $SaveMMap,$SaveNext,$Persists)=&Menu(${$FullMenu}
                           {$MenuUnit_hash_ref}[2]
                           {$all_menu_items_array[$picknum-1]},$convey,
                           $recurse_level,$FullMenu,
                           $Selected,$Conveyed,$SavePick,
                           $SaveMMap,$SaveNext,$Persists,
                           $MenuUnit_hash_ref,$no_wantarray);
                     };
                     die $@ if $@;
                     chomp($menu_output) if !(ref $menu_output);
#print "WHAT IS MENU1=$menu_output and SEL${$MenuUnit_hash_ref}{Select}\n";
                     if ($menu_output eq '-') {
                        $picks{$picknum}='-';
                        $mark=$mark_blank;
                        substr($mark,-1)='-';
                     } elsif ($menu_output eq '+') {
                        $picks{$picknum}='+';
                        $mark=$mark_blank;
                        substr($mark,-1)='+';
                     } elsif ($menu_output eq 'DONE_SUB') {
#print "DONE_SUB1\n";
                        return 'DONE_SUB';
                     } elsif ($menu_output eq 'DONE') {
                        if (1==$recurse_level) {
                           my $subfile=substr(
                                 $Term::Menus::custom_code_module_file,0,-3)
                                 .'::'
                                 if $Term::Menus::custom_code_module_file;
                           $subfile||='';
                           foreach my $sub (&get_subs_from_menu($Selected)) {
                              my @resu=();
                              if (ref $sub eq 'CODE') {
                                 if ($Term::Menus::fullauto && (!exists
                                       ${$MenuUnit_hash_ref}{'NoPlan'} ||
                                       !${$MenuUnit_hash_ref}{'NoPlan'})
                                       && defined
                                       $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN1\n";
                                    if (-1==
                                          $#{$Net::FullAuto::FA_Core::makeplan{
                                          'Plan'}} && !exists
                                          $Net::FullAuto::FA_Core::makeplan->{
                                          'Title'}) {
                                       $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                          =$pn{$numbor}[0];
                                    }
                                    push @{$Net::FullAuto::FA_Core::makeplan->{
                                            'Plan'}},
                                         { Label  => ${$MenuUnit_hash_ref}
                                                        {'Label'},
                                           Number => $numbor,
                                           PlanID =>
                                              $Net::FullAuto::FA_Core::makeplan->{Number},
                                           Item   =>
                                              &Data::Dump::Streamer::Dump($sub)->Out()
                                         }
                                 }
                                 @resu=$sub->();
                                 if (-1<$#resu) {
                                    if (0<$#resu && wantarray && !$no_wantarray) {
                                       return @resu;
                                    } else {
#print "RETURN RESU9\n";
                                       return return_result($resu[0],
                                          $MenuUnit_hash_ref,$Conveyed);
                                    } return 'DONE_SUB';
                                 }
                              }
                              eval {
                                 if ($subfile) {
                                    if ($Term::Menus::fullauto && (!exists
                                          ${$MenuUnit_hash_ref}{'NoPlan'} ||
                                          !${$MenuUnit_hash_ref}{'NoPlan'})
                                          && defined
                                          $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN2\n";
                                       if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                             'Plan'}} && !exists
                                             $Net::FullAuto::FA_Core::makeplan->{
                                             'Title'}) {
                                          $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                             =$pn{$numbor}[0];
                                       }
                                       push @{$Net::FullAuto::FA_Core::makeplan->{
                                               'Plan'}},
                                            { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                              Number => $numbor,
                                              PlanID =>
                                                 $Net::FullAuto::FA_Core::makeplan->{Number},
                                              Item   => "&$subfile$sub" }
                                    }
                                    eval "\@resu=\&$subfile$sub";
                                    my $firsterr=$@||'';


                                    if ((-1<index $firsterr,
                                          'Undefined subroutine') &&
                                          (-1<index $firsterr,$sub)) {
                                       eval "\@resu=\&main::$sub";
                                       my $seconderr=$@||'';my $die='';
                                       my $c=
                                          $Term::Menus::custom_code_module_file;
                                       if ($seconderr=~/Undefined subroutine/) {
                                          if (${$FullMenu}{$MenuUnit_hash_ref}
                                                [2]{$all_menu_items_array[
                                                $numbor-1]}) {
                                             $die="The \"Result15 =>\" Setting"
                                                 ."\n\t\t-> " . ${$FullMenu}
                                                 {$MenuUnit_hash_ref}[2]
                                                 {$all_menu_items_array[
                                                 $numbor-1]}
                                                 ."\n\t\tFound in the Menu "
                                                 ."Unit -> ".
                                                 ${$Term::Menus::LookUpMenuName}
                                                 {$MenuUnit_hash_ref}."\n\t\t"
                                                 ."Specifies a Subroutine"
                                                 ." that Does NOT Exist"
                                                 ."\n\t\tin the User Code File "
                                                 .$c.",\n\t\tnor was a routine "
                                                 ."with that name\n\t\tlocated"
                                                 ." in the main:: script.\n";
                                          } else {
                                             $die=
                                                "$firsterr\n       $seconderr"
                                          }
                                       } else { $die=$seconderr }
                                       &Net::FullAuto::FA_Core::handle_error(
                                          $die);
                                    } elsif ($firsterr) {
                                       &Net::FullAuto::FA_Core::handle_error(
                                          $firsterr);
                                    }
                                 } else {
                                    eval "\@resu=\&main::$sub";
                                    die $@ if $@;
                                 }
                              };
                              if ($@) {
                                 if (unpack('a11',$@) eq 'FATAL ERROR') {
                                    if (defined $log_handle &&
                                          -1<index $log_handle,'*') {
                                       print $log_handle $@;
                                       close($log_handle);
                                    }
                                    die $@;
                                 } else {
                                    my $die="\n       FATAL ERROR! - The Local "
                                       ."System $Term::Menus::local_hostname "
                                       ."Conveyed\n"
                                       ."              the Following "
                                       ."Unrecoverable Error Condition :\n\n"
                                       ."       $@";
                                    if (defined $log_handle &&
                                          -1<index $log_handle,'*') {
                                       print $log_handle $die;
                                       close($log_handle);
                                    }
                                    if ($Term::Menus::fullauto) {
                                       &Net::FullAuto::FA_Core::handle_error(
                                          $die);
                                    } else { die $die }
                                  }
                              } elsif (-1<$#resu) {
                                 if (0<$#resu && wantarray && !$no_wantarray) {
                                    return @resu;
                                 } else {
#print "RETURN RESU10\n";
                                    return return_result($resu[0],
                                       $MenuUnit_hash_ref,$Conveyed);
                                 }
                              }
                           }
#print "DONE_SUB2\n";
 return 'DONE_SUB';
                        } else { return 'DONE' }
                     } elsif ($menu_output) {
#print "WHAT IS MENU3=$menu_output\n";<STDIN>;
                        return $menu_output;
                     } else {
                        $picks{$picknum}='+';
                        $mark=$mark_blank;
                        substr($mark,-1)='+';
                     }
                  } else {
                     $picks{$picknum}='*';
                  }
               }
            } else {
               $mark='';
               my $mark_len=${$FullMenu}{$MenuUnit_hash_ref}[7]{BLANK};
               while ($mark_len--) {
                  $mark.=' ';
               }
            }
            $mark=${$FullMenu}{$MenuUnit_hash_ref}[7]
                  {$all_menu_items_array[$picknum-1]}
               if exists ${$FullMenu}{$MenuUnit_hash_ref}[7]
                  {$all_menu_items_array[$picknum-1]};
#print "WHAT IS MARKNOW=$mark<==\n";
            if (!$hidedefaults &&
                  ref ${$FullMenu}{$MenuUnit_hash_ref}[5] eq 'HASH' 
                  && ${$FullMenu}{$MenuUnit_hash_ref}[5]
                  {$all_menu_items_array[$picknum-1]} && (${$FullMenu}
                  {$MenuUnit_hash_ref}[5]{$all_menu_items_array[$picknum-1]}
                  eq '*' || $all_menu_items_array[$picknum-1]=~
                  /${$FullMenu}{$MenuUnit_hash_ref}[5]{$all_menu_items_array[$picknum-1]}/
                  )) {
               $picks{$picknum}='*';
               $mark=$mark_blank;
               substr($mark,-1)='*';$mark_flg=1;
            }
            $picknum_for_display=$picknum;
#print "WHAT IS MARKNOW2=$mark<==\n";
            if (ref ${$FullMenu}{$MenuUnit_hash_ref}[8] eq 'HASH'
                  && keys %{${$FullMenu}{$MenuUnit_hash_ref}[8]} &&
                  exists ${$FullMenu}{$MenuUnit_hash_ref}[8]
                  {$all_menu_items_array[$picknum-1]}
                  && ${$FullMenu}{$MenuUnit_hash_ref}[8]
                  {$all_menu_items_array[$picknum-1]}) {
#print "WHAT IS MARKNOW3=$mark<==\n";
               $picknum_for_display=
                  ${$FullMenu}{$MenuUnit_hash_ref}[8]
                  {$all_menu_items_array[$picknum-1]};
               $mark=$mark_blank;
               substr($mark,-1)=${$SavePick}{$MenuUnit_hash_ref}{$picknum_for_display}
                  || ' ' unless $picks{$picknum};
               $mark_flg=1 unless $mark=~/^ +$/;
               $Persists->{$MenuUnit_hash_ref}{defaults}=1
                 if $Persists->{$parent_menu}{defaults};
               if (${$FullMenu}{$MenuUnit_hash_ref}[9]) {
                  $filtered_menu=1;
               } else {
                  $sum_menu=1;
               }
            }
#print "WHAT IS MARKNOW4=$mark<==\n";
            $pn{$picknum_for_display}=
               [ $all_menu_items_array[$picknum-1],$picknum ];
            $menu_text.="   $mark  $picknum_for_display. "
                       ."\t$all_menu_items_array[$picknum-1]\n";
            if (exists ${$FullMenu}{$MenuUnit_hash_ref}[6]{$all_menu_items_array[$picknum-1]}) {
               my $tstt=${$FullMenu}{$MenuUnit_hash_ref}[6]{$all_menu_items_array[$picknum-1]};
               if ($tstt=~/many/i) {
                  ${$MenuUnit_hash_ref}{Select}{$picknum_for_display}='many';  
               } else {
                  #${$MenuUnit_hash_ref}{Select}{$picknum_for_display}='one';
               }
            } else {
               #${$MenuUnit_hash_ref}{Select}{$picknum_for_display}='one';
            }
            if ($mark=~/^ +$/ || (exists $picks{$picknum} ||
                  exists $picks{$picknum_for_display})) {
               ${$_[0]}[$picknum_for_display-1]=
                  $all_menu_items_array[$picknum-1];
            }
            $picknum++;
            $numlist--;
         } $hidedefaults=1;$picknum--;
#print "WHAT IS MARKNOW5=$mark<==\n";
         if ($Term::Menus::fullauto && (!exists
               ${$MenuUnit_hash_ref}{'NoPlan'} ||
               !${$MenuUnit_hash_ref}{'NoPlan'}) &&
               $Net::FullAuto::FA_Core::makeplan &&
               $Persists->{$MenuUnit_hash_ref}{defaults} &&
               !($filtered_menu || $sum_menu)) {
            ${$MenuUnit_hash_ref}{Label}||='Unlabeled';
            my %askmenu=(

                  Label  => 'askmenu',
                  Item_1 => {

                     Text => "Use the result saved with the \"Plan\""

                            },
                  Item_2 => {

                     Text => "Use the \"Default\" setting to determine result"

                            },
                  NoPlan => 1,
                  Banner => "   FullAuto has determined that the ".
                            ${$MenuUnit_hash_ref}{Label} . " Menu has been\n".
                            "   configured with a \"Default\" setting."

            );
            my $answ=Menu(\%askmenu);
            if ($answ eq ']quit[') {
               return ']quit['
            }
            if (-1==index $answ,'result saved') {
#print "IN MAKEPLAN3\n";
               if (-1==$#{$Net::FullAuto::FA_Core::makeplan{'Plan'}} &&
                     !exists $Net::FullAuto::FA_Core::makeplan->{'Title'}) {
                  $Net::FullAuto::FA_Core::makeplan->{'Title'}=$pn{$numbor}[0];
               }
               push @{$Net::FullAuto::FA_Core::makeplan->{'Plan'}},
                    { Label  => ${$MenuUnit_hash_ref}{'Label'},
                      Number => 'Default',
                      PlanID =>
                         $Net::FullAuto::FA_Core::makeplan->{Number},
                      Item   => '' };
               $got_default=1;
            }
         }
         unless ($Persists->{unattended}) {
            if ($^O ne 'cygwin') {
               unless ($noclear) {
                  if ($^O eq 'MSWin32' || $^O eq 'MSWin64') {
                     system("cmd /c cls");
                     print "\n";
                  } else {
                     print `${Term::Menus::clearpath}clear`."\n";
                  }
               } else { print $blanklines }
            } else { print $blanklines }
            print $menu_text;my $ch=0;
            #if (${$MenuUnit_hash_ref}{Select} eq 'Many') {
            if ($select_many || (keys %{${$MenuUnit_hash_ref}{Select}})) {
               print "\n";
               unless (keys %{${$FullMenu}{$MenuUnit_hash_ref}[1]}) {
                  print "   a.  Select All.";$ch=1;
               }
               if ($mark_flg==1 || $Persists->{$MenuUnit_hash_ref}{defaults}) {
                  print "   c.  Clear All.";print "\n" if $ch;
               }
               print "   f.  Finish.\n";
               if ($filtered_menu || $sum_menu) {
                  print "\n   (Type '<' to return to previous Menu)\n";
               }
               if ($Persists->{$MenuUnit_hash_ref}{defaults} &&
                     !($filtered_menu || $sum_menu)) {
                  print "\n   == Defaults Selections Exist! == ",
                        "(Type '*' to view them)\n";
               }
            } else {
               if ($Persists->{$MenuUnit_hash_ref}{defaults}) {
                  print "\n";
                  print "   c.  Clear Default Selection.\n";
                  print "   f.  Finish with Default Selection.\n";
                  if ($filtered_menu || $sum_menu) {
                     print "\n   (Type '<' to return to previous Menu)\n";
                  } else {
                     print "\n   == Default Selection Exists! == ",
                           "(Type '*' to view it)\n";
                  }
               } elsif ($filtered_menu || $sum_menu) {
                  print "\n   (Type '<' to return to previous Menu)\n";
               }
            }
            if ($display_this_many_items<$num_pick) {
               print "\n   $num_pick Total Choices\n",
                     "\n   Press ENTER \(or \"d\"\) to scroll downward\n",
                     "\n   OR \"u\" to scroll upward  ",
                     "\(Type \"quit\" to quit\)\n";
            } else { print"\n   \(Type \"quit\" to quit\)\n" }
            if ($Term::Menus::term_input) {
               print "\n";
               ($numbor,$ikey)=rawInput("   PLEASE ENTER A CHOICE: ");
               print "\n";
            } else {
               print"\n   PLEASE ENTER A CHOICE: ";
               $numbor=<STDIN>;
            } $picknum_for_display=$numbor;chomp $picknum_for_display;
         } elsif ($Persists->{$MenuUnit_hash_ref}{defaults}) {
            $numbor='f';
         } elsif (wantarray && !$no_wantarray) {
            my $die="\n       FATAL ERROR! - 'Unattended' mode cannot be\n"
                   ."                         used without a Plan or Default\n"
                   ."                         Selections being available.";
            return '',$die;
         } else {
            my $die="\n       FATAL ERROR! - 'Unattended' mode cannot be\n"
                   ."                         used without a Plan or Default\n"
                   ."                         Selections being available.";
            die($die);
         }
         #if (0) {
         #if ($numbor=~/^[Ff]$/ && (((wantarray && !$no_wantarray
         #      #&& (exists ${$MenuUnit_hash_ref}{Select} &&
         #      && ($select_many || (keys %{${$MenuUnit_hash_ref}{Select}}))) ||
         #      #${$MenuUnit_hash_ref}{Select} eq 'Many')) ||
         #      $Persists->{$MenuUnit_hash_ref}{defaults}) ||
         #      ($filtered_menu||$sum_menu))) {
         if ($numbor=~/^[Ff]$/ &&
               ($Persists->{$MenuUnit_hash_ref}{defaults} ||
               ($filtered_menu||$sum_menu))) {
#print "GOT HERE AND FILTER_MENU=$filtered_menu && RECURSE_LEVEL=$recurse_level\n";
            # FINISH
            my $choice='';my @keys=();
            my $chosen='';
            if ($filtered_menu) {
               $chosen=$parent_menu;
               return '-',
                  $FullMenu,$Selected,$Conveyed,
                  $SavePick,$SaveMMap,$SaveNext,
                  $Persists,$parent_menu;
            } elsif ($sum_menu) {
               $chosen=$parent_menu;
               return '-',
                  $FullMenu,$Selected,$Conveyed,
                  $SavePick,$SaveMMap,$SaveNext,
                  $Persists,$parent_menu;
            } else { $chosen=$MenuUnit_hash_ref }
            @keys=keys %picks;
            if (-1==$#keys) {
               if ($Persists->{$MenuUnit_hash_ref}{defaults}) {
#print "WHY DO WE THINK DEFAULTS EXIST?\n";
                  if ($filtered_menu || $sum_menu) {
                     $chosen=$parent_menu;
                  }
                  my $it=${[keys %{${$FullMenu}{$chosen}[5]}]}[0];
                  my $def=${$FullMenu}{$chosen}[5]{$it};
                  $def='.*' if $def eq '*';
                  if ($def) {
                     my $cnt=1;
                     foreach my $item (sort @{[keys %{${$FullMenu}{$chosen}[5]}]}) {
                        if ($item=~/$def/) {
                           $picks{$cnt}='*';
                           push @keys, $item;
                        } $cnt++
                     }
                  }
               } else {
                  @keys=keys %{${$SavePick}{$parent_menu}};
#print "WHAT ARE THE FLIPPIN KEYS???=@keys<==\n";
                  if (-1==$#keys) {
### DO CONDITIONAL FOR THIS!!!!!!!!!!!!!!!!!
                     if ($^O ne 'cygwin') {
                        unless ($noclear) {
                           if ($^O eq 'MSWin32' || $^O eq 'MSWin64') {
                              system("cmd /c cls");
                              print "\n";
                           } else {
                              print `${Term::Menus::clearpath}clear`."\n";
                           }
                        } else { print "FIVE\n";print $blanklines }
                     } else { print "SIX\n";print $blanklines }
                     print "\n\n       Attention USER! :\n\n       ",
                           "You have selected \"f\" to finish your\n",
                           "       selections, BUT -> You have not actually\n",
                           "       selected anything!\n\n       Do you wish ",
                           "to quit or re-attempt selecting?\n\n       ",
                           "Type \"quit\" to quit or ENTER to continue ... ";
                     if ($Term::Menus::term_input) {
                        print "\n";
                        ($choice,$ikey)=rawInput("   PLEASE ENTER A CHOICE: ");
                        print "\n";
                     } else {
                        print"\n   PLEASE ENTER A CHOICE: ";
                        $choice=<STDIN>;
                     } 
                     chomp($choice);
                     next if lc($choice) ne 'quit';
                     return ']quit['
                  } 
               }
            }
            my $return_values=0;
            sub numerically { $a <=> $b }
            my %dupseen=();my @pickd=();
            foreach my $pk (sort numerically keys %picks) {
               $return_values=1 if !exists
                  ${$FullMenu}{$chosen}[2]{${$_[0]}[$pk-1]}
                  || !keys
                  %{${$FullMenu}{$chosen}[2]{${$_[0]}[$pk-1]}};
               if (${${$FullMenu}{$parent_menu}[10]}[$pk-1] &&
                     !${$_[0]}[$pk-1]) {
                  my $txt=${${$FullMenu}{$parent_menu}[10]}[$pk-1];
                  if (-1<index $txt,"__Master_${$}__") {
                     my $lhn=$Term::Menus::local_hostname;
                     $txt=~s/__Master_${$}__/Local-Host: $lhn/sg;
                  }
                  unless (exists $dupseen{$txt}) {
                     push @pickd, $txt;
                  } $dupseen{$txt}='';
               } elsif (${$_[0]}[$pk-1]) {
                  my $txt=${$_[0]}[$pk-1];
                  if (-1<index $txt,"__Master_${$}__") {
                     my $lhn=$Term::Menus::local_hostname;
                     $txt=~s/__Master_${$}__/Local-Host: $lhn/sg;
                  }
                  unless (exists $dupseen{$txt}) {
                     push @pickd, $txt;
                  } $dupseen{$txt}='';
               } elsif ($pn{$picknum}) {
                  my $txt=$pn{$picknum}[0];
                  if (-1<index $txt,"__Master_${$}__") {
                     my $lhn=$Term::Menus::local_hostname;
                     $txt=~s/__Master_${$}__/Local-Host: $lhn/sg;
                  }
                  unless (exists $dupseen{$txt}) {
                     push @pickd, $txt;
                  } $dupseen{$txt}='';
               }
            }
#print "RETURNING4 and PICKD=@pickd\n";#<STDIN>;
            if ($return_values && $Term::Menus::fullauto &&
                   (!exists ${$MenuUnit_hash_ref}{'NoPlan'} ||
                   !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                   defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN4\n";
               if (-1==$#{$Net::FullAuto::FA_Core::makeplan{'Plan'}} &&
                     !exists $Net::FullAuto::FA_Core::makeplan->{'Title'}) {
                  $Net::FullAuto::FA_Core::makeplan->{'Title'}=
                     "Multiple Selections";
               }
               unless ($got_default) {
                  push @{$Net::FullAuto::FA_Core::makeplan->{'Plan'}},
                       { Label  => ${$MenuUnit_hash_ref}{'Label'},
                         Number => 'Multiple',
                         PlanID =>
                            $Net::FullAuto::FA_Core::makeplan->{Number},
                         Item   => "'".
                                   &Data::Dump::Streamer::Dump(\@pickd)->Out().
                                   "'" }
               }
            }
            return \@pickd if $return_values;
#print "DONE2\n";
            return 'DONE';
         } elsif ($numbor=~/^\s*%(.*)/s) {
            my $one=$1||'';
            chomp $one;
            $one=qr/$one/ if $one;
            my @spl=();
            chomp $numbor;
            my $cnt=0;my $ct=0;my @splice=();
            my $sort_ed='';
            if ($one) {

            } elsif ($sorted && $sorted eq 'forward') {
               @spl=reverse @all_menu_items_array;$sort_ed='reverse';
            } else { @spl=sort @all_menu_items_array;$sort_ed='forward' }
            next if $#spl==-1;
            my %sort=();
            foreach my $line (@all_menu_items_array) {
               $cnt++;
               if (exists $pn{$picknum} &&
                     exists ${$FullMenu}{$MenuUnit_hash_ref}[8]
                     {$pn{$picknum}[0]} && ${$FullMenu}
                     {$MenuUnit_hash_ref}[8]{$pn{$picknum}[0]} &&
                     keys %{${$FullMenu}{$MenuUnit_hash_ref}[8]
                     {$pn{$picknum}[0]} && ${$FullMenu}
                     {$MenuUnit_hash_ref}[8]{$pn{$picknum}[0]}}) {
                  $sort{$line}=${$FullMenu}{$MenuUnit_hash_ref}[8]{$line};
               } else { $sort{$line}=$cnt }
            } $cnt=0;
            my $chosen='';
            if (!$sorted) {
               $chosen={
                  Label  => ${$MenuUnit_hash_ref}{Label},
                  Select => ${$MenuUnit_hash_ref}{Select},
                  Banner => ${$MenuUnit_hash_ref}{Banner},
               };
               my $cnt=0;
               foreach my $text (@spl) {
                  my $num=$sort{$text};
                  $cnt++;
                  if (exists $picks{$num}) {
                     $chosen->{'Item_'.$cnt}=
                        { Text => $text,Default => '*',__NUM__=>$num };
                  } else {
                     $chosen->{'Item_'.$cnt}=
                        { Text => $text,__NUM__=>$num };
                  }
                  $chosen->{'Item_'.$cnt}{Result}=
                     ${${$MenuUnit_hash_ref}{${${$FullMenu}
                     {$MenuUnit_hash_ref}[4]}{$text}}}{'Result'}
                     if exists ${${$MenuUnit_hash_ref}{${${$FullMenu}
                     {$MenuUnit_hash_ref}[4]}{$text}}}{'Result'};
                  $chosen->{'Item_'.$cnt}{Sort}=$sort_ed;
               } $sorted=$sort_ed;
            } else {
               @all_menu_items_array=reverse @all_menu_items_array;
               next;
            }
            $Term::Menus::LookUpMenuName{$chosen}
               =${$chosen}{'Label'};
            %{${$SavePick}{$chosen}}=%picks;
            eval {
               ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
                  $SaveMMap,$SaveNext,$Persists)=&Menu($chosen,
                  $picks_from_parent,
                  $recurse_level,$FullMenu,
                  $Selected,$Conveyed,$SavePick,
                  $SaveMMap,$SaveNext,$Persists,
                  $MenuUnit_hash_ref,$no_wantarray);
            };
            die $@ if $@;
            chomp($menu_output) if !(ref $menu_output);
#print "WHAT IS MENU4=$menu_output\n";
            if ($menu_output eq '-') {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq '+') {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq 'DONE_SUB') {
#print "DONE_SUB3\n";
               return 'DONE_SUB';
            } elsif ($menu_output eq 'DONE') {
               if (1==$recurse_level) {
                  my $subfile=substr($Term::Menus::custom_code_module_file,0,-3)
                        .'::' if $Term::Menus::custom_code_module_file;
                  $subfile||='';
                  foreach my $sub (&get_subs_from_menu($Selected)) {
                     my @resu=();
                     if (ref $sub eq 'CODE') {
                        if ($Term::Menus::fullauto && (!exists
                              ${$MenuUnit_hash_ref}{'NoPlan'} ||
                              !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                              defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN5\n";
                           if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                 'Plan'}} && !exists
                                 $Net::FullAuto::FA_Core::makeplan->{
                                 'Title'}) {
                              $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                 =$pn{$numbor}[0];
                           }
                           push @{$Net::FullAuto::FA_Core::makeplan->{
                                  'Plan'}},
                                { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                  Number => $numbor,
                                  PlanID =>
                                     $Net::FullAuto::FA_Core::makeplan->{
                                     'Number'},
                                  Item   => 
                                     &Data::Dump::Streamer::Dump($sub)->Out() }
                        }
                        @resu=$sub->();
                        if (-1<$#resu) {
                           if (0<$#resu && wantarray && !$no_wantarray) {
                              return @resu;
                           } else {
#print "RETURN RESU11\n";
                              return return_result($resu[0],
                                 $MenuUnit_hash_ref,$Conveyed);
                           }
                        }
                        $done=1;last
                     }
                     eval {
                        if ($subfile) {
                           if ($Term::Menus::fullauto && (!exists
                                 ${$MenuUnit_hash_ref}{'NoPlan'} ||
                                 !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                                 defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN6\n";
                              if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                    'Plan'}} && !exists
                                    $Net::FullAuto::FA_Core::makeplan->{
                                    'Title'}) {
                                 $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                    =$pn{$numbor}[0];
                              }
                              push @{$Net::FullAuto::FA_Core::makeplan->{
                                      'Plan'}},
                                   { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                     Number => $numbor,
                                     PlanID =>
                                        $Net::FullAuto::FA_Core::makeplan->{
                                        'Number'},
                                     Item   => "&$subfile$sub" }
                           }
                           eval "\@resu=\&$subfile$sub";
                           my $firsterr=$@||'';
                           if ((-1<index $firsterr,'Undefined subroutine') &&
                                 (-1<index $firsterr,$sub)) {
                              eval "\@resu=\&main::$sub";
                              my $seconderr=$@||'';my $die='';
                              if ($seconderr=~/Undefined subroutine/) {
                                 if (${$FullMenu}{$MenuUnit_hash_ref}
                                       [2]{$all_menu_items_array[$numbor-1]}) {
                                    $die="The \"Result15 =>\" Setting"
                                        ."\n\t\t-> " . ${$FullMenu}
                                        {$MenuUnit_hash_ref}[2]
                                        {$all_menu_items_array[$numbor-1]}
                                        ."\n\t\tFound in the Menu Unit -> "
                                        .${$Term::Menus::LookUpMenuName}
                                        {$MenuUnit_hash_ref}."\n\t\t"
                                        ."Specifies a Subroutine"
                                        ." that Does NOT Exist"
                                        ."\n\t\tin the User Code File "
                                        .$Term::Menus::custom_code_module_file
                                        .",\n\t\tnor was a routine with "
                                        ."that name\n\t\tlocated in the"
                                        ." main:: script.\n";
                                 } else { $die="$firsterr\n       $seconderr" }
                              } else { $die=$seconderr }
                              &Net::FullAuto::FA_Core::handle_error($die);
                           } elsif ($firsterr) {
                              &Net::FullAuto::FA_Core::handle_error($firsterr);
                           }
                        } else {
                           eval "\@resu=\&main::$sub";
                           die $@ if $@;
                        }
                     };
                     if ($@) {
                        if (unpack('a11',$@) eq 'FATAL ERROR') {
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $@;
                              close($log_handle);
                           }
                           die $@;
                        } else {
                           my $die="\n       FATAL ERROR! - The Local "
                              ."System $Term::Menus::local_hostname Conveyed\n"
                              ."              the Following "
                              ."Unrecoverable Error Condition :\n\n"
                              ."       $@";
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $die;
                              close($log_handle);
                           }
                           if ($Term::Menus::fullauto) {
                              &Net::FullAuto::FA_Core::handle_error($die);
                           } else { die $die }
                        }
                     } elsif (-1<$#resu) {
                        if (0<$#resu && wantarray && !$no_wantarray) {
                           return @resu;
                        } else {
#print "RETURN RESU12\n";
                           return return_result($resu[0],
                              $MenuUnit_hash_ref,$Conveyed);
                        }
                     }
                  }
#print "DONE_SUB4\n";
 return 'DONE_SUB';
               } else { return 'DONE' }
            } elsif ($menu_output) {
#print "WHAT IS MENU5=$menu_output\n";
               return $menu_output;
            } else { %picks=%{${$SavePick}{$MenuUnit_hash_ref}} }
         } elsif ($numbor=~/^\*\s*$/s) {
            if ($sum_menu) {
               print "\n   WARNING!: Only -ONE- Level of Summation is Supported!\n";
               sleep 2;
               last;
            }
            my @splice=();
            my @spl=();
            if ($filtered_menu) {
#print "ARE WE FILTERED??\n";
               foreach my $key (keys %{${$SavePick}{$parent_menu}}) {
                  $picks{$key}='*';
               }
               foreach my $key (keys %picks) {
                  if ($parent_menu) {
                     ${${$SavePick}{$parent_menu}}{$key}='*';
                  } else {
                     ${${$SavePick}{$MenuUnit_hash_ref}}{$key}='*';
                  }
               }
            }
            if ($Persists->{$MenuUnit_hash_ref}{defaults}) {
               my $it=${[keys %{${$FullMenu}{$MenuUnit_hash_ref}[5]}]}[0];
               my $def=${$FullMenu}{$MenuUnit_hash_ref}[5]{$it};
               $def='.*' if $def eq '*';
               if ($def) {
                  my $cnt=1;
                  foreach my $item (sort @{[keys %{${$FullMenu}{
                                         $MenuUnit_hash_ref}[5]}]}) {
                     if ($item=~/$def/) {
                        $picks{$cnt}='*';
                     } $cnt++
                  }
               }
            }
            foreach my $pick (sort numerically keys %picks) {
               push @splice,($pick-1)
            }
            foreach my $spl (@splice) {
               if ($parent_menu) {
                  push @spl, ${${$FullMenu}{$parent_menu}[10]}[$spl];
               } else {
                  push @spl, ${${$FullMenu}{$MenuUnit_hash_ref}[10]}[$spl];
               }
            }
            my $chosen={
               Label  => ${$MenuUnit_hash_ref}{Label},
               Select => ${$MenuUnit_hash_ref}{Select},
               Banner => ${$MenuUnit_hash_ref}{Banner},
            }; my $cnt=0;
            my $hash_ref=$parent_menu||$MenuUnit_hash_ref;
            foreach my $text (@spl) {
#print "WHAT IS TEXT=$text\n";
               my $num=shift @splice;
               $cnt++;
               $chosen->{'Item_'.$cnt}=
                  { Text => $text,Default => '*',__NUM__=>$num+1 };
               $chosen->{'Item_'.$cnt}{Result}=
                  ${${$MenuUnit_hash_ref}{${${$FullMenu}
                  {$MenuUnit_hash_ref}[4]}{$text}}}{'Result'}
                  if exists ${${$MenuUnit_hash_ref}{${${$FullMenu}
                  {$MenuUnit_hash_ref}[4]}{$text}}}{'Result'};
               $chosen->{'Item_'.$cnt}{Filter}=1;
            }
#print "NUMBOR=$numbor AND KEYS PICKS=",keys %picks,"\n";
            $Term::Menus::LookUpMenuName{$chosen}
               =${$chosen}{'Label'};
            %{${$SavePick}{$chosen}}=%picks;
            $hidedefaults=1;
            eval {
               my ($ignore1,$ignore2,$ignore3)=('','','');
               ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
                  $SaveMMap,$SaveNext,$Persists,$ignore1,$ignore2,
                  $ignore3)
                  =&Menu($chosen,$picks_from_parent,
                  $recurse_level,$FullMenu,
                  $Selected,$Conveyed,$SavePick,
                  $SaveMMap,$SaveNext,$Persists,
                  $MenuUnit_hash_ref,$no_wantarray);
            };
            die $@ if $@;
#print "WHAT IS MENU6=$menu_output\n";
            chomp($menu_output) if !(ref $menu_output);
            if ($menu_output eq '-') {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq '+') {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq 'DONE_SUB') {
#print "DONE_SUB5\n";
               return 'DONE_SUB';
            } elsif ($menu_output eq 'DONE') {
               if (1==$recurse_level) {
                  my $subfile=substr($Term::Menus::custom_code_module_file,0,-3)
                             .'::' if $Term::Menus::custom_code_module_file;
                  $subfile||='';
                  foreach my $sub (&get_subs_from_menu($Selected)) {
                     my @resu=();
                     if (ref $sub eq 'CODE') {
                        if ($Term::Menus::fullauto && (!exists
                              ${$MenuUnit_hash_ref}{'NoPlan'} ||
                              !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                              defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN7\n";
                           if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                 'Plan'}} && !exists
                                 $Net::FullAuto::FA_Core::makeplan->{
                                 'Title'}) {
                              $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                 =$pn{$numbor}[0];
                           }
                           push @{$Net::FullAuto::FA_Core::makeplan->{
                                   'Plan'}},
                                { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                  Number => $numbor,
                                  PlanID =>
                                     $Net::FullAuto::FA_Core::makeplan->{Number},
                                  Item   => &Data::Dump::Streamer::Dump($sub)->Out() }
                        }
                        @resu=$sub->();
                        if (-1<$#resu) {
                           if (0<$#resu && wantarray && !$no_wantarray) {
                              return @resu;
                           } else {
#print "RETURN RESU13\n";
                              return return_result($resu[0],
                                 $MenuUnit_hash_ref,$Conveyed);
                           }
                        }
                        $done=1;last
                     }
                     eval {
                        if ($subfile) {
                           if ($Term::Menus::fullauto && (!exists
                                 ${$MenuUnit_hash_ref}{'NoPlan'} ||
                                 !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                                 defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN8\n";
                              if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                    'Plan'}} && !exists
                                    $Net::FullAuto::FA_Core::makeplan->{
                                    'Title'}) {
                                 $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                    =$pn{$numbor}[0];
                              }
                              push @{$Net::FullAuto::FA_Core::makeplan->{
                                      'Plan'}},
                                   { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                     Number => $numbor,
                                     PlanID =>
                                        $Net::FullAuto::FA_Core::makeplan->{Number},
                                     Item   => "&$subfile$sub" }
                           }
                           eval "\@resu=\&$subfile$sub";
                           my $firsterr=$@||'';
                           if ((-1<index $firsterr,'Undefined subroutine') &&
                                 (-1<index $firsterr,$sub)) {
                              eval "\@resu=\&main::$sub";
                              my $seconderr=$@||'';my $die='';
                              if ($seconderr=~/Undefined subroutine/) {
                                 if (${$FullMenu}{$MenuUnit_hash_ref}
                                       [2]{$all_menu_items_array[$numbor-1]}) {
                                    $die="The \"Result15 =>\" Setting"
                                        ."\n\t\t-> " . ${$FullMenu}
                                        {$MenuUnit_hash_ref}[2]
                                        {$all_menu_items_array[$numbor-1]}
                                        ."\n\t\tFound in the Menu Unit -> "
                                        .${$Term::Menus::LookUpMenuName}
                                        {$MenuUnit_hash_ref}."\n\t\t"
                                        ."Specifies a Subroutine"
                                        ." that Does NOT Exist"
                                        ."\n\t\tin the User Code File "
                                        .$Term::Menus::custom_code_module_file
                                        .",\n\t\tnor was a routine with "
                                        ."that name\n\t\tlocated in the"
                                        ." main:: script.\n";
                                 } else { $die="$firsterr\n       $seconderr" }
                              } else { $die=$seconderr }
                              &Net::FullAuto::FA_Core::handle_error($die);
                           } elsif ($firsterr) {
                              &Net::FullAuto::FA_Core::handle_error($firsterr);
                           }
                        } else {
                           eval "\@resu=\&main::$sub";
                           die $@ if $@;
                        }
                     };
                     if ($@) {
                        if (unpack('a11',$@) eq 'FATAL ERROR') {
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $@;
                              close($log_handle);
                           }
                           die $@;
                        } else {
                           my $die="\n       FATAL ERROR! - The Local "
                              ."System $Term::Menus::local_hostname Conveyed\n"
                              ."              the Following "
                              ."Unrecoverable Error Condition :\n\n"
                              ."       $@";
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $die;
                              close($log_handle);
                           }
                           if ($Term::Menus::fullauto) {
                              &Net::FullAuto::FA_Core::handle_error($die);
                           } else { die $die }
                        }
                     } elsif (-1<$#resu) {
                        if (0<$#resu && wantarray && !$no_wantarray) {
                           return @resu;
                        } else {
#print "RETURN RESU14\n";
                           return return_result($resu[0],
                              $MenuUnit_hash_ref,$Conveyed);
                        }
                     }
                  }
#print "DONE_SUB6\n";
 return 'DONE_SUB';
               } else { return 'DONE' }
            } elsif ($menu_output) {
#print "WHAT IS MENU7=$menu_output\n";
               return $menu_output;
            } else { %picks=%{${$SavePick}{$MenuUnit_hash_ref}} }
         } elsif ($numbor=~/^\s*\/(.+)$/s) {
            ## SLASH SEARCH
            if ($filtered_menu) {
               print "\n   WARNING!: Only -ONE- Level of Search is Supported!\n";
               sleep 2;
               last;
            }
            my $one=$1||'';
            chomp $one;
            $one=~s/\*/[\*]/g;
            $one=~s/\+/[\+]/g;
            $one=qr/$one/ if $one;
            my @spl=();
            chomp $numbor;
            my $def='';
            unless (exists $Persists->{$MenuUnit_hash_ref}{defaults}) {
               my $it=${[keys %{${$FullMenu}{$MenuUnit_hash_ref}[5]}]}[0];
               $def=${$FullMenu}{$MenuUnit_hash_ref}[5]{$it};
               $def='.*' if $def eq '*';
               if ($def) {
                  my $cnt=1;
                  foreach my $item (sort
                        @{[keys %{${$FullMenu}{$MenuUnit_hash_ref}[5]}]}) {
                     if ($item=~/$def/) {
                        $picks{$cnt}='*';
                     } $cnt++
                  }
               }
            }

            my $cnt=0;my $ct=0;my @splice=();
            foreach my $pik (@all_menu_items_array) {
               $cnt++;
               if ($pik=~/$one/s) {
                  push @spl, $pik;
                  $splice[$ct++]=$cnt;
               }
            }
            next if $#spl==-1;
            my $chosen={
               Label  => ${$MenuUnit_hash_ref}{Label},
               Select => ${$MenuUnit_hash_ref}{Select},
               Banner => ${$MenuUnit_hash_ref}{Banner},
            }; $cnt=0;
            foreach my $text (@spl) {
               my $num=$splice[$cnt];
               $cnt++;
               if (exists $picks{$num}) {
                  $chosen->{'Item_'.$cnt}=
                     { Text => $text,Default => '*',__NUM__=>$num };
               } elsif ($def && $text=~/$def/) {
                  $chosen->{'Item_'.$cnt}=
                     { Text => $text,Default => '*',__NUM__=>$num };
                  $picks{$num}='*';
               } else {
                  $chosen->{'Item_'.$cnt}=
                     { Text => $text,__NUM__=>$num };
               }
               $chosen->{'Item_'.$cnt}{Result}=
                  ${${$MenuUnit_hash_ref}{${${$FullMenu}
                  {$MenuUnit_hash_ref}[4]}{$text}}}{'Result'}
                  if exists ${${$MenuUnit_hash_ref}{${${$FullMenu}
                  {$MenuUnit_hash_ref}[4]}{$text}}}{'Result'};
               $chosen->{'Item_'.$cnt}{Filter}=1;
            }
            $Term::Menus::LookUpMenuName{$chosen}
               =${$chosen}{'Label'};
            %{${$SavePick}{$chosen}}=%picks;
            eval {
               ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
                  $SaveMMap,$SaveNext,$Persists)=&Menu(
                  $chosen,$picks_from_parent,
                  $recurse_level,$FullMenu,
                  $Selected,$Conveyed,$SavePick,
                  $SaveMMap,$SaveNext,$Persists,
                  $MenuUnit_hash_ref,$no_wantarray);
            };
            die $@ if $@;
            chomp($menu_output) if !(ref $menu_output);
#print "WHAT IS MENU8=$menu_output\n";
            if ($menu_output eq '-' && exists
                  ${$SavePick}{$MenuUnit_hash_ref}) {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq '+' && exists
                  ${$SavePick}{$MenuUnit_hash_ref}) {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq 'DONE_SUB') {
#print "DONE_SUB7\n";
               return 'DONE_SUB';
            } elsif ($menu_output eq 'DONE') {
               if (1==$recurse_level) {
                  my $subfile=substr($Term::Menus::custom_code_module_file,0,-3)
                             .'::' if $Term::Menus::custom_code_module_file;
                  $subfile||='';
                  foreach my $sub (&get_subs_from_menu($Selected)) {
                     my @resu=();
                     if (ref $sub eq 'CODE') {
                        if ($Term::Menus::fullauto && (!exists
                              ${$MenuUnit_hash_ref}{'NoPlan'} ||
                              !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                              defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN9\n";
                           if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                 'Plan'}} && !exists
                                 $Net::FullAuto::FA_Core::makeplan->{
                                 'Title'}) {
                              $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                 =$pn{$numbor}[0];
                           }
                           push @{$Net::FullAuto::FA_Core::makeplan->{
                                   'Plan'}},
                                { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                  Number => $numbor,
                                  PlanID =>
                                     $Net::FullAuto::FA_Core::makeplan->{Number},
                                  Item   => &Data::Dump::Streamer::Dump($sub)->Out() }
                        }
                        @resu=$sub->();
                        if (-1<$#resu) {
                           if (0<$#resu && wantarray && !$no_wantarray) {
                              return @resu;
                           } else {
#print "RETURN RESU15\n";
                              return return_result($resu[0],
                                 $MenuUnit_hash_ref,$Conveyed);
                           }
                        }
                        $done=1;last
                     }
                     eval {
                        if ($subfile) {
                           if ($Term::Menus::fullauto && (!exists
                                 ${$MenuUnit_hash_ref}{'NoPlan'} ||
                                 !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                                 defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN10\n";
                              if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                    'Plan'}} && !exists
                                    $Net::FullAuto::FA_Core::makeplan->{
                                    'Title'}) {
                                 $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                    =$pn{$numbor}[0];
                              }
                              push @{$Net::FullAuto::FA_Core::makeplan->{
                                      'Plan'}},
                                   { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                     Number => $numbor,
                                     PlanID =>
                                        $Net::FullAuto::FA_Core::makeplan->{Number},
                                     Item   => "&$subfile$sub" }
                           }
                           eval "\@resu=\&$subfile$sub";
                           my $firsterr=$@||'';
                           if ((-1<index $firsterr,'Undefined subroutine') &&
                                 (-1<index $firsterr,$sub)) {
                              eval "\@resu=\&main::$sub";
                              my $seconderr=$@||'';my $die='';
                              if ($seconderr=~/Undefined subroutine/) {
                                 if (${$FullMenu}{$MenuUnit_hash_ref}
                                       [2]{$all_menu_items_array[$numbor-1]}) {
                                    $die="The \"Result15 =>\" Setting"
                                        ."\n\t\t-> " . ${$FullMenu}
                                        {$MenuUnit_hash_ref}[2]
                                        {$all_menu_items_array[$numbor-1]}
                                        ."\n\t\tFound in the Menu Unit -> "
                                        .${$Term::Menus::LookUpMenuName}
                                        {$MenuUnit_hash_ref}."\n\t\t"
                                        ."Specifies a Subroutine"
                                        ." that Does NOT Exist"
                                        ."\n\t\tin the User Code File "
                                        .$Term::Menus::custom_code_module_file
                                        .",\n\t\tnor was a routine with "
                                        ."that name\n\t\tlocated in the"
                                        ." main:: script.\n";
                                 } else { $die="$firsterr\n       $seconderr" }
                              } else { $die=$seconderr }
                              &Net::FullAuto::FA_Core::handle_error($die);
                           } elsif ($firsterr) {
                              &Net::FullAuto::FA_Core::handle_error($firsterr);
                           }
                        } else {
                           eval "\@resu=\&main::$sub";
                           die $@ if $@;
                        }
                     };
                     if ($@) {
                        if (unpack('a11',$@) eq 'FATAL ERROR') {
                           die $@;
                        } else {
                           my $die="\n       FATAL ERROR! - The Local "
                                  ."System $Term::Menus::local_hostname "
                                  ."Conveyed\n"
                                  ."              the Following "
                                  ."Unrecoverable Error Condition :\n\n"
                                  ."       $@";
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $die;
                              close($log_handle);
                           }
                           if ($Term::Menus::fullauto) {
                              &Net::FullAuto::FA_Core::handle_error($die);
                           } else { die $die }
                        }
                     } elsif (-1<$#resu) {
                        if (0<$#resu && wantarray && !$no_wantarray) {
                           return @resu;
                        } else {
#print "RETURN RESU16\n";
                           return return_result($resu[0],
                              $MenuUnit_hash_ref,$Conveyed);
                        }
                     }
                  }
#print "DONE_SUB8\n";
 return 'DONE_SUB';
               } else { return 'DONE' }
            } elsif ($menu_output eq '-') {
#print "NEGATIVE\n";
               $return_from_child_menu='-';
            } elsif ($menu_output eq '+') {
               $return_from_child_menu='+';
            } elsif ($menu_output) {
#print "WHAT IS MENU_OUTPUT=${$menu_output}[0]<==\n" if ref $menu_output eq 'ARRAY';
#print "WHAT IS MENU9=",(join ' ',@{$menu_output}),"\n" if ref $menu_output eq 'ARRAY';
               return $menu_output;
            }
         } elsif (($numbor=~/^\</ || $ikey eq 'LEFTARROW') && $FullMenu) {
            if ($recurse_level==1) {
               print "\n   WARNING! - You are at the First Menu!\n";
               sleep 2;
            } elsif (grep { /\+|\*/ } values %picks) {
               return '+',
                  $FullMenu,$Selected,$Conveyed,
                  $SavePick,$SaveMMap,$SaveNext,
                  $Persists,$parent_menu;
            } else {
               return '-',
                  $FullMenu,$Selected,$Conveyed,
                  $SavePick,$SaveMMap,$SaveNext,
                  $Persists,$parent_menu;
            } last;
         } elsif (($numbor=~/^\>/ || $ikey eq 'RIGHTARROW') && exists
                  ${$SaveNext}{$MenuUnit_hash_ref}) {
            $MenuMap=${$SaveMMap}{$MenuUnit_hash_ref};
            my $tyt=${$FullMenu}
                  {$MenuUnit_hash_ref}[2]
                  {$all_menu_items_array[(keys %{${$SavePick}{
                  $MenuUnit_hash_ref}})[0]-1]};
#print "MENU UNIT REF=$MenuUnit_hash_ref\n";
#print "MENU FOR NEXT MENU=",&Data::Dump::Streamer::Dump($tyt)->Out(),"\n";<STDIN>;
#print "MENUMAP FOR NEXT MENU=",&Data::Dump::Streamer::Dump($MenuMap)->Out(),"\n";<STDIN>;
            $convey=[];
            foreach my $numb (sort numerically keys %picks) {
               push @{$convey}, $all_menu_items_array[$numb-1];
            }
            eval {
               my ($ignore1,$ignore2,$ignore3)=('','','');
               ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
                  $SaveMMap,$SaveNext,$Persists,$ignore1,$ignore2,
                  $ignore3)
                  =&Menu(${$FullMenu}
                  {$MenuUnit_hash_ref}[2]
                  {$all_menu_items_array[(keys %{${$SavePick}{
                  $MenuUnit_hash_ref}})[0]-1]},$convey,
                  $recurse_level,$FullMenu,
                  $Selected,$Conveyed,$SavePick,
                  $SaveMMap,$SaveNext,$Persists,
                  $MenuUnit_hash_ref,$no_wantarray);
            };
            die $@ if $@;
            chomp($menu_output) if !(ref $menu_output);
#print "WHAT IS MENU10=$menu_output\n";
            if ($menu_output eq 'DONE_SUB') {
#print "DONE_SUB9\n";
               return 'DONE_SUB';
            } elsif ($menu_output eq 'DONE') {
               if (1==$recurse_level) {
                  if ($Term::Menus::fullauto && (!exists
                        ${$MenuUnit_hash_ref}{'NoPlan'} ||
                        !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                        defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN11\n";
                     if (-1==$#{$Net::FullAuto::FA_Core::makeplan{'Plan'}} &&
                           !exists $Net::FullAuto::FA_Core::makeplan->{
                           'Title'}) {
                        $Net::FullAuto::FA_Core::makeplan->{'Title'}
                           =$pn{$numbor}[0];
                     }
                     unless ($got_default) {
                        push @{$Net::FullAuto::FA_Core::makeplan->{'Plan'}},
                             { Label  => ${$MenuUnit_hash_ref}{'Label'},
                               Number => $numbor,
                               PlanID =>
                                  $Net::FullAuto::FA_Core::makeplan->{Number},
                               Item   => $pn{$numbor}[0] }
                     }
                  }
                  my $subfile=substr($Term::Menus::custom_code_module_file,0,-3)
                             .'::' if $Term::Menus::custom_code_module_file;
                  $subfile||='';
                  foreach my $sub (&get_subs_from_menu($Selected)) {
                     my @resu=();
                     if (ref $sub eq 'CODE') {
                        if ($Term::Menus::fullauto && (!exists
                              ${$MenuUnit_hash_ref}{'NoPlan'} ||
                              !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                              defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN12\n";
                           if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                 'Plan'}} && !exists
                                 $Net::FullAuto::FA_Core::makeplan->{
                                 'Title'}) {
                              $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                 =$pn{$numbor}[0];
                           }
                           push @{$Net::FullAuto::FA_Core::makeplan->{
                                  'Plan'}},
                                { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                  Number => $numbor,
                                  PlanID =>
                                     $Net::FullAuto::FA_Core::makeplan->{Number},
                                  Item   => &Data::Dump::Streamer::Dump($sub)->Out() }
                        }
                        @resu=$sub->();
                        if (-1<$#resu) {
                           if (0<$#resu && wantarray && !$no_wantarray) {
                              return @resu;
                           } else {
#print "RETURN RESU17\n";
                              return return_result($resu[0],
                                 $MenuUnit_hash_ref,$Conveyed);
                           }
                        }
                        $done=1;last
                     }
                     eval {
                        if ($subfile) {
                           if ($Term::Menus::fullauto && (!exists
                                 ${$MenuUnit_hash_ref}{'NoPlan'} ||
                                 !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                                 defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN13\n";
                              if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                    'Plan'}} && !exists
                                    $Net::FullAuto::FA_Core::makeplan->{
                                    'Title'}) {
                                 $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                    =$pn{$numbor}[0];
                              }
                              push @{$Net::FullAuto::FA_Core::makeplan->{
                                      'Plan'}},
                                   { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                     Number => $numbor,
                                     PlanID =>
                                        $Net::FullAuto::FA_Core::makeplan->{Number},
                                     Item   => "&$subfile$sub" }
                           }
                           eval "\@resu=\&$subfile$sub";
                           my $firsterr=$@||'';
                           if ((-1<index $firsterr,'Undefined subroutine') &&
                                 (-1<index $firsterr,$sub)) {
                              eval "\@resu=\&main::$sub";
                              my $seconderr=$@||'';my $die='';
                              if ($seconderr=~/Undefined subroutine/) {
                                 if (${$FullMenu}{$MenuUnit_hash_ref}
                                      [2]{$all_menu_items_array[$numbor-1]}) {
                                    $die="The \"Result15 =>\" Setting"
                                        ."\n\t\t-> " . ${$FullMenu}
                                        {$MenuUnit_hash_ref}[2]
                                        {$all_menu_items_array[$numbor-1]}
                                        ."\n\t\tFound in the Menu Unit -> "
                                        .${$Term::Menus::LookUpMenuName}
                                        {$MenuUnit_hash_ref}."\n\t\t"
                                        ."Specifies a Subroutine"
                                        ." that Does NOT Exist"
                                        ."\n\t\tin the User Code File "
                                        .$Term::Menus::custom_code_module_file
                                        .",\n\t\tnor was a routine with "
                                        ."that name\n\t\tlocated in the"
                                        ." main:: script.\n";
                                 } else { $die="$firsterr\n       $seconderr" }
                              } else { $die=$seconderr }
                              &Net::FullAuto::FA_Core::handle_error($die);
                           } elsif ($firsterr) {
                              &Net::FullAuto::FA_Core::handle_error($firsterr);
                           }
                        } else {
                           eval "\@resu=\&main::$sub";
                           die $@ if $@;
                        }
                     };
                     if ($@) {
                        if (unpack('a11',$@) eq 'FATAL ERROR') {
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $@;
                              close($log_handle);
                           }
                           die $@;
                        } else {
                           my $die="\n       FATAL ERROR! - The Local "
                              ."System $Term::Menus::local_hostname Conveyed\n"
                              ."              the Following "
                              ."Unrecoverable Error Condition :\n\n"
                              ."       $@";
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $die;
                              close($log_handle);
                           }
                           if ($Term::Menus::fullauto) {
                              &Net::FullAuto::FA_Core::handle_error($die);
                           } else { die $die }
                        }
                     } elsif (-1<$#resu) {
                        if (0<$#resu && wantarray && !$no_wantarray) {
                           return @resu;
                        } else {
#print "RETURN RESU18\n";
                           return return_result($resu[0],
                              $MenuUnit_hash_ref,$Conveyed);
                        }
                     }
                  } 
#print "DONE_SUB10\n";
return 'DONE_SUB';
               } else { return 'DONE' }
            } elsif ($menu_output eq '-') {
               $return_from_child_menu='-';
            } elsif ($menu_output eq '+') {
               $return_from_child_menu='+';
            } elsif ($menu_output) {
               return $menu_output;
            }
         } elsif ($numbor=~/^quit$/i) {
            return ']quit['
         } elsif (!keys %{${$FullMenu}{$MenuUnit_hash_ref}[1]}
                                             && $numbor=~/^[Aa]$/) {
            #if (${$MenuUnit_hash_ref}{Select} eq 'One') {
            if (!$select_many && !(keys %{${$MenuUnit_hash_ref}{Select}})) {
               print "\n   ERROR: Cannot Select All Items\n".
                     "          When 'Select' is NOT set to 'Many'\n";
               sleep 2;next;
            }
            if ($sum_menu || $filtered_menu) {
               foreach my $num (0..$#all_menu_items_array) {
                  $picks{$num+1}='*';
               }
               foreach my $key (keys %{${$FullMenu}{$MenuUnit_hash_ref}[8]}) {
                  ${$SavePick}{$parent_menu}{${$FullMenu}
                     {$MenuUnit_hash_ref}[8]{$key}}='*';
               }
            } else {
               my $nmp=$num_pick-1;
               foreach my $pck (0..$nmp) {
                  if ($select_many || exists ${$FullMenu}{$MenuUnit_hash_ref}[6]->{$all_menu_items_array[$pck]}) {
                     $picks{$pck+1}='*'
                  }
               }
               #my $ch_num=$num_pick;
               #while (1) {
               #   $picks{$ch_num--}='*';
               #   last if $ch_num==0;
               #}
            }
         } elsif ($numbor=~/^[Cc]$/) {
            ## CLEAR ALL CLEARALL
#print "WHAT IS SUM_MENU=$sum_menu and FILTERED_MENU=$filtered_menu\n";sleep 2;
            #if ($sum_menu || $filtered_menu) {
               foreach my $key (keys %{${$FullMenu}{$MenuUnit_hash_ref}[8]}) {
                  delete ${$SavePick}{$parent_menu}{${$FullMenu}
                     {$MenuUnit_hash_ref}[8]{$key}};
               }
               foreach my $pick (keys %picks) {
                  if (exists $picks{$pick}) {
#print "PICKKK=$pick\n";
                     #if ($picks{$pick} eq '*') {
                        delete $picks{$pick};
                        delete $items{$pick};
                        delete ${$Selected}{$MenuUnit_hash_ref}{$pick};
                        delete ${$Selected}{$parent_menu}{$pick};  
                        delete ${$SavePick}{$MenuUnit_hash_ref}{$pick};
                        delete ${$SavePick}{$parent_menu}{$pick};
                        delete ${$SaveNext}{$MenuUnit_hash_ref};
                     #} elsif ($picks{$pick} eq '+' || $picks{$pick} eq '-') {
                     #   &delete_Selected($MenuUnit_hash_ref,$pick,
                     #      $Selected,$SavePick,$SaveNext,$Persists);
                        #$SaveNext=$SavePick;
                     #   delete $picks{$pick};
                     #   delete $items{$pick};
                     #}
                  }
               } ${$FullMenu}{$parent_menu}[5]='';
               $return_from_child_menu=0;
               $Persists->{$MenuUnit_hash_ref}{defaults}=0;
               $Persists->{$parent_menu}{defaults}=0 if defined $parent_menu; 
            #} else {
            #   foreach my $pick (keys %picks) {
#print "PICKOK=$pick\n";
            #      if (exists $picks{$pick}) {
            #         if ($picks{$pick} eq '*') {
            #            delete $picks{$pick};
            #            delete $items{$pick};
            #            delete ${$Selected}{$MenuUnit_hash_ref}{$pick};
            #         } elsif ($picks{$pick} eq '+') {
            #            &delete_Selected($MenuUnit_hash_ref,$pick,
            #               $Selected,$SavePick,$SaveNext,$Persists);
            #            $SaveNext=$SavePick;
            #            delete $picks{$pick};
            #            delete $items{$pick};
            #         }
            #      }
            #   } ${$FullMenu}{$MenuUnit_hash_ref}[5]='';
            #   $Persists->{$MenuUnit_hash_ref}{defaults}=0;
            #}
         }
         if ($numbor=~/^u$/i || $ikey eq 'UPARROW' || $ikey eq 'PAGEUP') {
            if (0<=$start-$display_this_many_items) {
               $start=$start-$display_this_many_items;
            } else { $start=0 }
            $numbor=$start+$choose_num+1;
            last;
         } elsif (((!$ikey || $ikey eq 'ENTER') &&
               ($numbor=~/^()$/ || $numbor=~/^\n/)) || $numbor=~/^d$/i
               || $ikey eq 'DOWNARROW' || $ikey eq 'PAGEDOWN') {
            if ($display_this_many_items<$num_pick-$start) {
               $start=$start+$display_this_many_items;
            } else { $start=0 }
            $hidedefaults=0;
            $numbor=$start+$choose_num+1;
            last;
         } chomp $numbor;
         if (!((keys %picks) && $numbor=~/^[Ff]$/) &&
               $numbor!~/^\d+$/ && !$return_from_child_menu) {
#print "WELL HELLO FFFF\n";
            $numbor=$start+$choose_num+1;
            last;
         } elsif (exists $pn{$numbor} || ((keys %picks) && $numbor=~/^[Ff]$/)) {
            # NUMBOR CHOSEN
%pn=() unless %pn;
#print "ARE WE HERE and PN=$pn{$numbor} and NUMBOR=$numbor and SUM=$sum_menu\n";
#print "PICKS=",keys %picks,"\n";
#print "ALLLLL=${$FullMenu}{$MenuUnit_hash_ref}[2]{$pn{$numbor}[0]}<==\n";
            my $callertest=__PACKAGE__."::Menu";
            if ($Persists->{$MenuUnit_hash_ref}{defaults}) {
               $Persists->{$MenuUnit_hash_ref}{defaults}=0;
               $Persists->{$parent_menu}{defaults}=0 if $parent_menu;
               foreach my $pick (keys %picks) {
                  if (exists $picks{$pick} && !$picks{$numbor}) {
                     if ($picks{$pick} eq '*') {
                        delete $picks{$pick};
                        delete $items{$pick};
                        delete ${$Selected}{$MenuUnit_hash_ref}{$pick};
                     } elsif ($picks{$pick} eq '+') {
                        &delete_Selected($MenuUnit_hash_ref,$pick,
                           $Selected,$SavePick,$SaveNext,$Persists);
                        $SaveNext=$SavePick;
                        delete $picks{$pick};
                        delete $items{$pick};
                     }
                  }
               } ${$FullMenu}{$MenuUnit_hash_ref}[5]='';
            }
            $pn{$numbor}[1]||=1;
#print "WHAT IS PN1=$pn{$numbor}[1] and NUMBOR=$numbor and WHAT ARE PICKS=",(join ' ',keys %picks)," and FILTERED=$filtered_menu\n";<STDIN>; 
            my $digital_numbor=($numbor=~/^\d+$/) ? $numbor : 1;
            #if (${$MenuUnit_hash_ref}{Select} eq 'Many' && $numbor!~/^[Ff]$/) {
#print "WHAT ARE THE KEYS=",keys %{${$MenuUnit_hash_ref}{Select}},"\n";<STDIN>;
            if (($select_many || (exists ${$MenuUnit_hash_ref}{Select}{$numbor}))
                  && $numbor!~/^[Ff]$/) {
#print "HOWDY DOWDY\n";<STDIN>;
               if (exists $picks{$numbor}) {
                  if ($picks{$numbor} eq '*') {
                     delete $picks{$numbor};
                     delete $items{$numbor};
                     delete ${$Selected}{$MenuUnit_hash_ref}{$numbor};
                     delete ${$SavePick}{$parent_menu}{$numbor}
                        if $sum_menu || $filtered_menu;
                  } else {
                     &delete_Selected($MenuUnit_hash_ref,$numbor,
                         $Selected,$SavePick,$SaveNext,$Persists);
                     $SaveNext=$SavePick;
                     delete $picks{$numbor};
                     delete $items{$numbor};
                  }
               } elsif (($sum_menu || $filtered_menu) && (exists
                     ${$SavePick}{$parent_menu}{$numbor})) {
                  if ($Persists->{$parent_menu}{defaults}) {
                     $Persists->{$parent_menu}{defaults}=0;
                     $Persists->{$MenuUnit_hash_ref}{defaults}=0;
                     foreach my $pick (keys %picks) {
                        if (exists $picks{$pick} && !$picks{$numbor}) {
                           if ($picks{$pick} eq '*') {
                              delete $picks{$pick};
                              delete $items{$pick};
                              delete ${$Selected}{$parent_menu}{$pick};
                           } elsif ($picks{$pick} eq '+') {
                              &delete_Selected($parent_menu,$pick,
                                 $Selected,$SavePick,$SaveNext,$Persists);
                              $SaveNext=$SavePick;
                              delete $picks{$pick};
                              delete $items{$pick};
                           }
                        }
                     } ${$FullMenu}{$MenuUnit_hash_ref}[5]='';
                  }
                  delete ${$Selected}{$MenuUnit_hash_ref}{$numbor};
                  delete $picks{$numbor};
                  delete $items{$numbor};
                  delete ${$SaveNext}{$MenuUnit_hash_ref};
                  delete ${$SavePick}{$parent_menu}{$numbor};
               } else {
#print "WHAT IS THIS=$all_menu_items_array[$numbor-1] and THIS=$pn{$numbor}[0]\n";
                  $items{$numbor}=${$FullMenu}{$MenuUnit_hash_ref}
                                   [4]{$all_menu_items_array[$numbor-1]};
                                   #          [4]{$pn{$numbor}[0]};
                  ${$SavePick}{$parent_menu}{$numbor}='*'
                     if $sum_menu || $filtered_menu;
                  my $skip=0;
#print "HELLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO AND NUMBOR=$numbor and NEGATE=",keys %{${$FullMenu}{$MenuUnit_hash_ref}[1]}," and PICKS=",keys %picks," and ITEM BLOCK ITEM BELONGS TO=",$items{$numbor},"\n";<STDIN>;
#print "WHAT IS THIS NEGATE ARRAY CONTENTS=",@{${$FullMenu}{$MenuUnit_hash_ref}[1]->{$all_menu_items_array[$numbor-1]}},"\n" if  exists ${$FullMenu}{$MenuUnit_hash_ref}[1]->{$all_menu_items_array[$numbor-1]};<STDIN>;
                  foreach my $key (keys %picks) {
#print "CYCLING KEYS=$key and THISBABY=@{${$FullMenu}{$MenuUnit_hash_ref}[1]->{$all_menu_items_array[$key-1]}}\n";<STDIN>;
                     if (exists ${$FullMenu}{$MenuUnit_hash_ref}[1]->{$all_menu_items_array[$key-1]}
                           && (grep { $items{$numbor} eq $_ }
                           @{${$FullMenu}{$MenuUnit_hash_ref}[1]->{$all_menu_items_array[$key-1]}})) {
#print "WHAT IS THIS=$key and NEGATE=",${$FullMenu}{$MenuUnit_hash_ref}[1]->{$all_menu_items_array[$key-1]},"\n";
# print "WE HAVE VICTORY=$key and THIS=$items{$key}\n";
#}
                     #if ($picks{$key} ne '-' &&
                     #      exists ${$FullMenu}{$MenuUnit_hash_ref}[1]->{$all_menu_items_array[$numbor-1]} &&
                     #      (grep { $items{$numbor} eq $_ }
                     #      @{${$FullMenu}{$MenuUnit_hash_ref}[1]->{$all_menu_items_array[$numbor-1]}})) {
                           #@{$negate{$key}})) {
                        my $warn="\n   WARNING! You Cannot Select ";
                        $warn.="Line $numbor while Line $key is Selected!\n";
                        print "$warn";sleep 2;
                        $skip=1;
                     } elsif ($picks{$key} eq '-') {
                        delete ${$Selected}{$MenuUnit_hash_ref}{$key};
                        delete $picks{$key};
                        delete ${$SaveNext}{$MenuUnit_hash_ref};
                     }
                  }
                  if ($skip==0) {
                     $picks{$numbor}='*';
#print "WHAT IS THIS=$all_menu_items_array[$numbor-1] and THIS=$pn{$numbor}[0]\n";
                     $negate{$numbor}=
                        ${${$FullMenu}{$MenuUnit_hash_ref}[1]}
                        {$all_menu_items_array[$numbor-1]};
                        #{$pn{$numbor}[0]};
                     %{${$SavePick}{$MenuUnit_hash_ref}}=%picks;
                  }
               }
               if ($prev_menu && $prev_menu!=$numbor) {
                  &delete_Selected($MenuUnit_hash_ref,$prev_menu,
                     $Selected,$SavePick,$SaveNext,$Persists);
                  delete $picks{$prev_menu};
                  delete $items{$prev_menu};
               }
            } elsif (($numbor=~/^\d+$/ &&
                         (ref ${$FullMenu}{$MenuUnit_hash_ref}[2]
                         {$all_menu_items_array[$digital_numbor-1]||
                         $all_menu_items_array[$pn{$digital_numbor}[1]-1]}
                         eq 'HASH')) || ($numbor=~/^[Ff]$/ &&
                         ref ${$FullMenu}{$MenuUnit_hash_ref}[2]
                         {$all_menu_items_array[((keys %picks)[0]||1)-1]}
                         eq 'HASH')) {
               my $numbor_is_eff=0;
               if ($numbor=~/^[Ff]$/) {
                  $numbor=(keys %picks)[0];
                  $numbor_is_eff=1;
               }
               if (exists ${$FullMenu}{$MenuUnit_hash_ref}[2]
                         {$all_menu_items_array[$numbor-1]||$all_menu_items_array[$pn{$numbor}[1]-1]}{'Label'}||
                         exists $labels{(keys %{${$FullMenu}
                         {$MenuUnit_hash_ref}[2]
                         {$all_menu_items_array[$digital_numbor-1]}})[0]}) {
                  my $menyou='';
                  if (exists $labels{(keys %{${$FullMenu}
                         {$MenuUnit_hash_ref}[2]
                         {$all_menu_items_array[$digital_numbor-1]}})[0]}) {
                     my %men_result=%{${$FullMenu}
                         {$MenuUnit_hash_ref}[2]
                         {$all_menu_items_array[$digital_numbor-1]}};
#print "WHAT IS THIS=",(join " ",keys %men_result),"\n";
                     delete $men_result{Label} if exists $men_result{Label};
                     $menyou=&Data::Dump::Streamer::Dump($labels{
                           (keys %men_result)[0]})->Out();
#print "MENYOU=$menyou<==\n";<STDIN>;
                     $menyou=~s/\$HASH\d*\s*=\s*//s;
                     #$menyou=~s/\'/\\\'/sg;
                     my $mnyou=eval $menyou;
                     $mnyou->{Label}=(keys %men_result)[1]||rand();
#print "WHAT IS THE LABEL=",$mnyou->{Label},"<==\n";
#print "WHAT IS THE CONVEY=$mnyou->{Item_1}->{Convey}<==\n";
                     ${$FullMenu}
                        {$MenuUnit_hash_ref}[2]
                        {$all_menu_items_array[$numbor-1]}=$mnyou;
                     my $itemnum=${$FullMenu}{$MenuUnit_hash_ref}[4]
                                 {$all_menu_items_array[$numbor-1]};
                     ${$MenuUnit_hash_ref}{$itemnum}->{Result}->{Label}=
                        $labels{(keys %men_result)[0]}->{Label};
#print "SO INCREDIBLY AWESOME=",keys %{$mnyou},"\n";<STDIN>;
                  }
                  chomp($numbor);
                  unless ($numbor_is_eff) {
                     if (exists $picks{$numbor}) {
                        ${$FullMenu}{$MenuUnit_hash_ref}[5]='ERASE';
                        $hidedefaults=0;
                        $SaveNext=$SavePick;
                        if ($picks{$numbor} eq '*') {
                           delete $picks{$numbor};
                           delete $items{$numbor};
                           delete ${$Selected}{$MenuUnit_hash_ref}{$numbor};
                        } elsif ($picks{$numbor} ne ' ') {
                           &delete_Selected($MenuUnit_hash_ref,$numbor,
                              $Selected,$SavePick,$SaveNext,$Persists);
                           delete $picks{$numbor};
                           delete $items{$numbor};
                        }
                     }
                     if ($prev_menu && $prev_menu!=$numbor) {
                        ${$FullMenu}{$MenuUnit_hash_ref}[5]='ERASE';
                        $hidedefaults=0;
                        $SaveNext=$SavePick;
                        &delete_Selected($MenuUnit_hash_ref,$prev_menu,
                           $Selected,$SavePick,$SaveNext,$Persists);
                        delete $picks{$prev_menu};
                        delete $items{$prev_menu};
                     }
                  } else {
                     foreach my $key (keys %picks) {
                        if (($start<=$key) || ($key<=$start+$choose_num)) {
                           $numbor=$key;
                           last;
                        }
                     }
                  }
                  $picks{$numbor}='-' if !(keys %picks) || $numbor!~/^[Ff]$/;
                  ($FullMenu,$Conveyed,$SaveNext,$Persists,$Selected,
                     $convey,$parent_menu)
                     =$get_result->($MenuUnit_hash_ref,
                     \@all_menu_items_array,\%picks,
                     $picks_from_parent,$FullMenu,$Conveyed,$Selected,
                     $SaveNext,$Persists,$parent_menu);
#print "CONVEYXXXXX=@{$convey}<==\n";<STDIN>;
                  %{${$SavePick}{$MenuUnit_hash_ref}}=%picks;
                  ${$Conveyed}{${$MenuUnit_hash_ref}{'Label'}}=[];
                  if (0<$#{[keys %picks]}) {
                     foreach my $key (sort numerically keys %picks) {
                        push @{${$Conveyed}{${$MenuUnit_hash_ref}{'Label'}}},
                               $all_menu_items_array[$key-1];
                     }
                  } else {
                     ${$Conveyed}{${$MenuUnit_hash_ref}{'Label'}}=
                        $all_menu_items_array[$numbor-1];
                  }
#print "WHAT IS CONVEY=$convey and PICKS=",keys %picks,"\n";
#print "WAHT IS BEING CONVEYED=",(join " ",@{${$Conveyed}{${$MenuUnit_hash_ref}{'Label'}}}),"\n";
#print "GOING TO NEW MENU AND JUST CONVEYED=",${$MenuUnit_hash_ref}{'Label'},"\n";<STDIN>;
                  my $mcount=0;
                  unless (exists ${$SaveMMap}{$MenuUnit_hash_ref}) {
                     if ($parent_menu) {
                        my $parent_map=&Data::Dump::Streamer::Dump(
                              ${$SaveMMap}{$parent_menu})->Out();
                        $parent_map=~s/\$ARRAY\d*\s*=\s*//s;
                        ${$SaveMMap}{$MenuUnit_hash_ref}=eval $parent_map;
                        $mcount=&get_Menu_map_count(
                           ${$SaveMMap}{$MenuUnit_hash_ref});
                     } else {
                        ${$SaveMMap}{$MenuUnit_hash_ref}=[];
                     }
                  }
#print "WHAT IS ALL THIS=@{$convey}<==\n";<STDIN>;
                  if (ref $convey eq 'ARRAY') {
                     push @{${$SaveMMap}{$MenuUnit_hash_ref}},
                        [ ++$mcount, $convey->[0] ];
                  } else {
                     push @{${$SaveMMap}{$MenuUnit_hash_ref}},
                        [ ++$mcount, $convey ];
                  }
                  $MenuMap=${$SaveMMap}{$MenuUnit_hash_ref};
                  eval {
                     ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
                        $SaveMMap,$SaveNext,$Persists,$parent_menu)
                        =&Menu(${$FullMenu}
                        {$MenuUnit_hash_ref}[2]
                        {$all_menu_items_array[$numbor-1]},$convey,
                        $recurse_level,$FullMenu,
                        $Selected,$Conveyed,$SavePick,
                        $SaveMMap,$SaveNext,$Persists,
                        $MenuUnit_hash_ref,$no_wantarray);
                  };
                  die $@ if $@;
                  chomp($menu_output) if !(ref $menu_output);
#print "WHAT IS MENU12=$menu_output<==\n";
                  if ($menu_output eq '-') {
                     $return_from_child_menu='-';
                  } elsif ($menu_output eq '+') {
                     $return_from_child_menu='+';
                  } elsif ($menu_output eq 'DONE_SUB') {
#print "DONE_SUB11\n";
                     return 'DONE_SUB';
                  } elsif ($menu_output eq 'DONE' and 1<$recurse_level) {
                     return 'DONE';
                  } elsif ($menu_output) {
#print "WHAT IS MENU12=$menu_output<==\n";
                     return $menu_output;
                  } else {
                     if ($Term::Menus::fullauto && (!exists
                           ${$MenuUnit_hash_ref}{'NoPlan'} ||
                           !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                           defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN14\n";
                        if (-1==$#{$Net::FullAuto::FA_Core::makeplan{'Plan'}}
                              && !exists
                              $Net::FullAuto::FA_Core::makeplan->{'Title'}) {
                           $Net::FullAuto::FA_Core::makeplan->{'Title'}
                              =$all_menu_items_array[$numbor-1];
                        }
                     unless ($got_default) {
                        push @{$Net::FullAuto::FA_Core::makeplan->{'Plan'}},
                             { Label  => ${$MenuUnit_hash_ref}{'Label'},
                               Number => $numbor,
                               PlanID =>
                                  $Net::FullAuto::FA_Core::makeplan->{Number},
                               Item   => $all_menu_items_array[$numbor-1] }
                        }
                     }
                     my $subfile=substr(
                           $Term::Menus::custom_code_module_file,0,-3).'::'
                           if $Term::Menus::custom_code_module_file;
                     $subfile||='';
                     foreach my $sub (&get_subs_from_menu($Selected)) {
                        my @resu=();
                        if (ref $sub eq 'CODE') {
                           if ($Term::Menus::fullauto && (!exists
                                 ${$MenuUnit_hash_ref}{'NoPlan'} ||
                                 !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                                 defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN15\n";
                              if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                    'Plan'}} && !exists
                                    $Net::FullAuto::FA_Core::makeplan->{
                                    'Title'}) {
                                 $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                    =$all_menu_items_array[$numbor-1];
                              }
                              push @{$Net::FullAuto::FA_Core::makeplan->{
                                     'Plan'}},
                                   { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                     Number => $numbor,
                                     PlanID =>
                                        $Net::FullAuto::FA_Core::makeplan->{Number},
                                     Item   =>
                                        &Data::Dump::Streamer::Dump($sub)->Out()
                                   }
                           }
                           @resu=$sub->();
                           if (-1<$#resu) {
                              if (0<$#resu && wantarray && !$no_wantarray) {
                                 return @resu;
                              } else {
#print "RETURN RESU1\n";
                                 return return_result($resu[0],
                                    $MenuUnit_hash_ref,$Conveyed);
                              }
                           }
                           $done=1;last
                        }
                        eval {
                           if ($subfile) {
                              if ($Term::Menus::fullauto && (!exists
                                    ${$MenuUnit_hash_ref}{'NoPlan'} ||
                                    !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                                    defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN16\n";
                                 if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                       'Plan'}} && !exists
                                       $Net::FullAuto::FA_Core::makeplan->{
                                       'Title'}) {
                                    $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                       =$all_menu_items_array[$numbor-1];
                                 }
                                 push @{$Net::FullAuto::FA_Core::makeplan->{
                                         'Plan'}},
                                      { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                        Number => $numbor,
                                        PlanID =>
                                           $Net::FullAuto::FA_Core::makeplan->{Number},
                                        Item   => "&$subfile$sub" }
                              }
                              eval "\@resu=\&$subfile$sub";
                              my $firsterr=$@||'';
                              if ((-1<index $firsterr,'Undefined subroutine') &&
                                    (-1<index $firsterr,$sub)) {
                                 eval "\@resu=\&main::$sub";
                                 my $seconderr=$@||'';my $die='';
                                 my $c=
                                    $Term::Menus::custom_code_module_file;
                                 if ($seconderr=~/Undefined subroutine/) {
                                    if (${$FullMenu}{$MenuUnit_hash_ref}[2]
                                          {$all_menu_items_array[$numbor-1]}) {
                                       $die="The \"Result15 =>\" Setting"
                                           ."\n\t\t-> " . ${$FullMenu}
                                           {$MenuUnit_hash_ref}[2]
                                           {$all_menu_items_array[$numbor-1]}
                                           ."\n\t\tFound in the Menu Unit -> "
                                           .${$Term::Menus::LookUpMenuName}
                                           {$MenuUnit_hash_ref}."\n\t\t"
                                           ."Specifies a Subroutine"
                                           ." that Does NOT Exist"
                                           ."\n\t\tin the User Code File "
                                           .$c.",\n\t\tnor was a routine with "
                                           ."that name\n\t\tlocated in the"
                                           ." main:: script.\n";
                                    } else {
                                       $die="$firsterr\n       $seconderr"
                                    }
                                 } else { $die=$seconderr }
                                 &Net::FullAuto::FA_Core::handle_error($die);
                              } elsif ($firsterr) {
                                 &Net::FullAuto::FA_Core::handle_error(
                                    $firsterr);
                              }
                           } else {
                              eval "\@resu=\&main::$sub";
                              die $@ if $@;
                           }
                        };
                        if ($@) {
                           if (unpack('a11',$@) eq 'FATAL ERROR') {
                              if (defined $log_handle &&
                                    -1<index $log_handle,'*') {
                                 print $log_handle $@;
                                 close($log_handle);
                              }
                              die $@;
                           } else {
                              my $die="\n       FATAL ERROR! - The Local "
                                 ."System $Term::Menus::local_hostname "
                                 ."Conveyed\n"
                                 ."              the Following "
                                 ."Unrecoverable Error Condition :\n\n"
                                 ."       $@";
                              if (defined $log_handle &&
                                    -1<index $log_handle,'*') {
                                 print $log_handle $die;
                                 close($log_handle);
                              }
                              if ($parent_menu && wantarray && !$no_wantarray) {
                                 return '',
                                    $FullMenu,$Selected,$Conveyed,
                                    $SavePick,$SaveMMap,$SaveNext,
                                    $Persists,$parent_menu,$die;
                              } elsif ($Term::Menus::fullauto) {
                                 &Net::FullAuto::FA_Core::handle_error($die);
                              } else { die $die }
                           }
                        } elsif (-1<$#resu) {
                           if (0<$#resu && wantarray && !$no_wantarray) {
                              return @resu;
                           } else {
#print "RETURN RESU2\n";
                              return return_result($resu[0],
                                 $MenuUnit_hash_ref,$Conveyed);
                           }
                        }
                     }
#print "DONE_SUB12\n";
 return 'DONE_SUB';
                  }
               } else {
                  my $mcmf=$Term::Menus::menu_config_module_file;
                  my $die="The \"Result11 =>\" Setting".
                          "\n\t\tFound in the Menu Unit -> ".
                          "${$MenuUnit_hash_ref}{'Label'}\n\t\tis a ".
                          "HASH reference to a Menu Unit\,\n\t\t".
                          "that does NOT EXIST or is NOT EXPORTED".
                          "\n\n\tHint: Make sure the Names of all".
                          "\n\t      Menu Hash Blocks in the\n\t".
                          "      $mcmf file are\n\t".
                          "      listed in the \@EXPORT list\n\t".
                          "      found at the beginning of\n\t".
                          "      the $mcmf file\n\n\t".
                          "our \@EXPORT = qw( %Menu_1 %Menu_2 ... )\;\n";
                  die $die;
               }
            } elsif ($FullMenu && $caller eq $callertest &&
                  ($select_many || (keys %{${$MenuUnit_hash_ref}{Select}}))) {
                  #${$MenuUnit_hash_ref}{Select} eq 'Many') {
               if ($numbor!~/^[Ff]$/ && exists $picks{$numbor}) {
                  if ($picks{$numbor} eq '*') {
                     delete $picks{$numbor};
                     delete $items{$numbor};
                     delete ${$Selected}{$MenuUnit_hash_ref}{$numbor};
                  } else {
                     &delete_Selected($MenuUnit_hash_ref,$numbor,
                        $Selected,$SavePick,$SaveNext,$Persists);
                     $SaveNext=$SavePick;
                     delete $picks{$numbor};
                     delete $items{$numbor};
                  } last;
               }
               if (keys %{${$FullMenu}{$MenuUnit_hash_ref}[2]}) {
                  $numbor=(keys %picks)[0] if $numbor=~/^[Ff]$/;
                  #if (ref ${$FullMenu}{$MenuUnit_hash_ref}[2]{$pn{$numbor}[0]}
#print "PICKNUM=$picknum and @all_menu_items_array\n";
                  if (ref ${$FullMenu}{$MenuUnit_hash_ref}[2]{$all_menu_items_array[$picknum-1]}
                          eq 'CODE') {
#print "GOT CODE\n";
                     my $cd='';
                     my $sub=${$FullMenu}{$MenuUnit_hash_ref}[2]
                              {$all_menu_items_array[$picknum-1]};
                     #        {$pn{$numbor}[0]};
                     my $sicm_regex=
                        qr/\]s(e+lected[-_]*)*i*(t+ems[-_]*)
                           *c*(u+rrent[-_]*)*m*(e+nu[-_]*)*\[/xi;
                     my $pmsi_regex=qr/\]p(r+evious[-_]*)*m*(e+nu[-_]*)
                        *s*(e+lected[-_]*)*i*(t+ems[-_]*)*\[/xi;
                     my $amlm_regex=qr/\]a(n+cestor[-_]*)*m*(e+nu[-_]*)
                        *l*(a+bel[-_]*)*m*(a+p[-_]*)*\[/xi;
                     my $select_ed=[];
                     if (0<$#{[keys %picks]}) {
                        foreach my $key (keys %picks) {
                           push @{$select_ed}, $pn{$key}[0];
                        }
                     } else {
                        $select_ed=$pn{$numbor}[0];
                     }
                     if ($Term::Menus::data_dump_streamer) {
                        $cd=&Data::Dump::Streamer::Dump($sub)->Out();
                        $cd=&transform_sicm($cd,$sicm_regex,$numbor,
                               \@all_menu_items_array,\%picks,
                               $return_from_child_menu,$log_handle);
                        $cd=&transform_pmsi($cd,
                               $Conveyed,$SaveMMap,$pmsi_regex,
                               $amlm_regex,$picks_from_parent);
                     }
                     $cd=~s/\$CODE\d*\s*=\s*//s;
                     $sub=eval $cd;
                     if ($@) {
                        my $die='';
                        if (unpack('a11',$@) eq 'FATAL ERROR') {
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $@;
                              close($log_handle);
                           }
                           die $@;
                        } else {
                           $die="\n       FATAL ERROR! - The Local "
                                  ."System $Term::Menus::local_hostname"
                                  ." Conveyed\n"
                                  ."              the Following "
                                  ."Unrecoverable Error Condition :\n\n"
                                  ."       $@";
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $die;
                              close($log_handle);
                           }
                        }
                        if ($Term::Menus::fullauto) {
                           &Net::FullAuto::FA_Core::handle_error($die);
                        } else { die $die }
                     }
                     my @resu=$sub->();
                     if (-1<$#resu) {
                        if (0<$#resu && wantarray && !$no_wantarray) {
                           return @resu;
                        } else {
#print "RETURN RESU3=$resu[0]<==\n";
                           return return_result($resu[0],
                              $MenuUnit_hash_ref,$Conveyed);
                        }
                     }
                  } elsif (defined $pn{$numbor}[0] &&
                        exists ${$FullMenu}{$MenuUnit_hash_ref}[2]{$pn{$numbor}[0]} &&
                        substr(${$FullMenu}{$MenuUnit_hash_ref}
                        [2]{$pn{$numbor}[0]},0,1) ne '&') {
                     my $die="The \"Result12 =>\" Setting\n              -> "
                            .${$FullMenu}{$MenuUnit_hash_ref}[2]
                            {$pn{$numbor}[0]}
                            ."\n              Found in the Menu Unit -> "
                            .$MenuUnit_hash_ref
                            ."\n              is not a Menu Unit\,"
                            ." and Because it Does Not Have"
                            ."\n              an \"&\" as"
                            ." the Lead Character, $0"
                            ."\n              Cannot Determine "
                            ."if it is a Valid SubRoutine.\n\n";
                     die $die;
                  } elsif (!defined $pn{$numbor}[0] ||
                        !exists ${$FullMenu}{$MenuUnit_hash_ref}[2]{$pn{$numbor}[0]}) {
                     my @resu=map { $all_menu_items_array[$_-1] } keys %picks;
                     if (wantarray && !$no_wantarray) {
                        return @resu;
                     } elsif ($#resu==0) {
                        return @resu;
                     } else {
                        return \@resu;
                     }
                  }
                  if (${$FullMenu}{$MenuUnit_hash_ref}[2]
                                   {$pn{$numbor}[0]}) { }
                  ($FullMenu,$Conveyed,$SaveNext,
                     $Persists,$Selected,$convey,$parent_menu)
                     =$get_result->($MenuUnit_hash_ref,
                     \@all_menu_items_array,\%picks,$picks_from_parent,
                     $FullMenu,$Conveyed,$Selected,$SaveNext,
                     $Persists,$parent_menu);
                  my %pick=();
                  $pick{$numbor}='*';
                  %{${$SavePick}{$MenuUnit_hash_ref}}=%pick;
                  if ($Term::Menus::fullauto && (!exists
                        ${$MenuUnit_hash_ref}{'NoPlan'} ||
                        !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                        defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN17\n";
                     if (-1==$#{$Net::FullAuto::FA_Core::makeplan{'Plan'}} &&
                           !exists
                           $Net::FullAuto::FA_Core::makeplan->{'Title'}) {
                        $Net::FullAuto::FA_Core::makeplan->{'Title'}
                           =$pn{$numbor}[0];
                     }
                     unless ($got_default) {
                        push @{$Net::FullAuto::FA_Core::makeplan->{'Plan'}},
                             { Label  => ${$MenuUnit_hash_ref}{'Label'},
                               Number => $numbor,
                               PlanID =>
                                  $Net::FullAuto::FA_Core::makeplan->{Number},
                               Item   => $pn{$numbor}[0] }
                     }
                  }
                  my $subfile=substr($Term::Menus::custom_code_module_file,0,-3)
                             .'::' if $Term::Menus::custom_code_module_file;
                  $subfile||='';
                  foreach my $sub (&get_subs_from_menu($Selected)) {
                     my @resu=();
                     if (ref $sub eq 'CODE') {
                        if ($Term::Menus::fullauto && (!exists
                              ${$MenuUnit_hash_ref}{'NoPlan'} ||
                              !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                              defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN18\n";
                           if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                 'Plan'}} && !exists
                                 $Net::FullAuto::FA_Core::makeplan->{
                                 'Title'}) {
                              $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                 =$pn{$numbor}[0];
                           }
                           push @{$Net::FullAuto::FA_Core::makeplan->{
                                  'Plan'}},
                                { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                  Number => $numbor,
                                  PlanID =>
                                     $Net::FullAuto::FA_Core::makeplan->{Number},
                                  Item   => 
                                     &Data::Dump::Streamer::Dump($sub)->Out()
                                }
                        }
                        @resu=$sub->();
                        if (-1<$#resu) {
                           if (0<$#resu && wantarray && !$no_wantarray) {
                              return @resu;
                           } else {
#print "RETURN RESU4\n";
                              return return_result($resu[0],
                                 $MenuUnit_hash_ref,$Conveyed);
                           }
                        }
                        $done=1;last
                     }
                     eval {
                        if ($subfile) {
                           if ($Term::Menus::fullauto && (!exists
                                 ${$MenuUnit_hash_ref}{'NoPlan'} ||
                                 !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                                 defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN19\n";
                              if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                    'Plan'}} && !exists
                                    $Net::FullAuto::FA_Core::makeplan->{
                                    'Title'}) {
                                 $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                    =$pn{$numbor}[0];
                              }
                              push @{$Net::FullAuto::FA_Core::makeplan->{
                                      'Plan'}},
                                   { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                     Number => $numbor,
                                     PlanID =>
                                        $Net::FullAuto::FA_Core::makeplan->{Number},
                                     Item   => "&$subfile$sub" }
                           }
                           eval "\@resu=\&$subfile$sub";
                           my $firsterr=$@||'';
                           if ((-1<index $firsterr,'Undefined subroutine') &&
                                 (-1<index $firsterr,$sub)) {
                              eval "\@resu=\&main::$sub";
                              my $seconderr=$@||'';my $die='';
                              if ($seconderr=~/Undefined subroutine/) {
                                 if (${$FullMenu}{$MenuUnit_hash_ref}
                                       [2]{$all_menu_items_array[$numbor-1]}) {
                                    $die="The \"Result15 =>\" Setting"
                                        ."\n\t\t-> " . ${$FullMenu}
                                        {$MenuUnit_hash_ref}[2]
                                        {$all_menu_items_array[$numbor-1]}
                                        ."\n\t\tFound in the Menu Unit -> "
                                        .${$Term::Menus::LookUpMenuName}
                                        {$MenuUnit_hash_ref}."\n\t\t"
                                        ."Specifies a Subroutine"
                                        ." that Does NOT Exist"
                                        ."\n\t\tin the User Code File "
                                        .$Term::Menus::custom_code_module_file
                                        .",\n\t\tnor was a routine with "
                                        ."that name\n\t\tlocated in the"
                                        ." main:: script.\n";
                                 } else { $die="$firsterr\n       $seconderr" }
                              } else { $die=$seconderr }
                              &Net::FullAuto::FA_Core::handle_error($die);
                           } elsif ($firsterr) {
                              &Net::FullAuto::FA_Core::handle_error($firsterr);
                           }
                        } else {
                           eval "\@resu=\&main::$sub";
                           die $@ if $@;
                        }
                     };
                     if ($@) {
                        if (unpack('a11',$@) eq 'FATAL ERROR') {
                           die $@;
                        } else {
                           my $die="\n       FATAL ERROR! - The Local "
                                  ."System $Term::Menus::local_hostname "
                                  ."Conveyed\n"
                                  ."              the Following "
                                  ."Unrecoverable Error Condition :\n\n"
                                  ."       $@";
                           if (defined $log_handle &&
                                -1<index $log_handle,'*') {
                              print $log_handle $die;
                              close($log_handle);
                           }
                           if ($parent_menu && wantarray && !$no_wantarray) {
                              return '',
                                 $FullMenu,$Selected,$Conveyed,
                                 $SavePick,$SaveMMap,$SaveNext,
                                 $Persists,$parent_menu,$die;
                           } elsif ($Term::Menus::fullauto) {
                              &Net::FullAuto::FA_Core::handle_error($die);
                           } else { die $die }
                        }
                     } else {
                        if (-1<$#resu) {
                           if (0<$#resu && wantarray && !$no_wantarray) {
                              return @resu;
                           } else {
#print "RETURN RESU5\n";
                              return return_result($resu[0],
                                 $MenuUnit_hash_ref,$Conveyed);
                           }
                        }
                        $done=1;last
                     }
                  }
               } else { $done=1;last }
#print "DONE_SUB13\n";
               return 'DONE_SUB';
            } elsif (keys %{${$FullMenu}{$MenuUnit_hash_ref}[2]} 
                  && exists ${$FullMenu}{$MenuUnit_hash_ref}[2]
                  {$pn{$numbor}[0]}) {
               if (ref ${$FullMenu}{$MenuUnit_hash_ref}[2]{$pn{$numbor}[0]}
                     eq 'CODE') {
#print "GOT CODE\n";
                  my $cd='';
                  my $sub=${$FullMenu}{$MenuUnit_hash_ref}[2]{$pn{$numbor}[0]};
                  my $sicm_regex=
                     qr/\]s(e+lected[-_]*)*i*(t+ems[-_]*)
                        *c*(u+rrent[-_]*)*m*(e+nu[-_]*)*\[/xi;
                  my $pmsi_regex=qr/\]p(r+evious[-_]*)*m*(e+nu[-_]*)
                     *s*(e+lected[-_]*)*i*(t+ems[-_]*)*\[/xi;
                  my $amlm_regex=qr/\]a(n+cestor[-_]*)*m*(e+nu[-_]*)
                     *l*(a+bel[-_]*)*m*(a+p[-_]*)*\[/xi;
                  if ($Term::Menus::data_dump_streamer) {
                     $cd=&Data::Dump::Streamer::Dump($sub)->Out();
                     $cd=&transform_sicm($cd,$sicm_regex,$numbor,
                            \@all_menu_items_array,\%picks,
                            $return_from_child_menu,$log_handle);
                     $cd=&transform_pmsi($cd,
                            $Conveyed,$SaveMMap,$pmsi_regex,
                            $amlm_regex,$picks_from_parent);
                  }
                  $cd=~s/\$CODE\d*\s*=\s*//s;
                  $sub=eval $cd;
                  if ($@) {
                     my $die='';
                     if (unpack('a11',$@) eq 'FATAL ERROR') {
                        if (defined $log_handle &&
                              -1<index $log_handle,'*') {
                           print $log_handle $@;
                           close($log_handle);
                        }
                        die $@;
                     } else {
                        $die="\n       FATAL ERROR! - The Local "
                               ."System $Term::Menus::local_hostname Conveyed\n"
                               ."              the Following "
                               ."Unrecoverable Error Condition :\n\n"
                               ."       $@";
                        if (defined $log_handle &&
                              -1<index $log_handle,'*') {
                           print $log_handle $die;
                           close($log_handle);
                        }
                     }
                     if ($Term::Menus::fullauto) {
                        &Net::FullAuto::FA_Core::handle_error($die);
                     } else { die $die }
                  }
                  my @resu=$sub->();
                  if (-1<$#resu) {
                     if (0<$#resu && wantarray && !$no_wantarray) {
                        return @resu;
                     } else {
                        return return_result($resu[0],
                           $MenuUnit_hash_ref,$Conveyed);
                     }
                  }
               } elsif (substr(${$FullMenu}{$MenuUnit_hash_ref}
                     [2]{$pn{$numbor}[0]},0,1) ne '&') {
                  my $die="The \"Result14 =>\" Setting\n              -> "
                         .${$FullMenu}{$MenuUnit_hash_ref}[2]{$pn{$numbor}[0]}
                         ."\n              Found in the Menu Unit -> "
                         .$MenuUnit_hash_ref
                         ."\n              is not a Menu Unit\,"
                         ." and Because it Does Not Have"
                         ."\n              an \"&\" as"
                         ." the Lead Character, $0"
                         ."\n              Cannot Determine "
                         ."if it is a Valid SubRoutine.\n\n";
                  die $die;
               }
               if (${$FullMenu}{$MenuUnit_hash_ref}[2]
                                {$pn{$numbor}[0]}) { }
               $picks{$numbor}='';
               ($FullMenu,$Conveyed,$SaveNext,$Persists,
                  $Selected,$convey,$parent_menu)
                  =$get_result->($MenuUnit_hash_ref,
                  \@all_menu_items_array,\%picks,$picks_from_parent,
                  $FullMenu,$Conveyed,$Selected,$SaveNext,
                  $Persists,$parent_menu);
               my %pick=();
               $pick{$numbor}='*';
               %{${$SavePick}{$MenuUnit_hash_ref}}=%pick;
               my $subfile=substr($Term::Menus::custom_code_module_file,0,-3)
                  .'::' if $Term::Menus::custom_code_module_file;
               $subfile||='';
               foreach my $sub (&get_subs_from_menu($Selected)) {
                  my @resu=();
                  if (ref $sub eq 'CODE') {
                     if ($Term::Menus::fullauto && (!exists
                           ${$MenuUnit_hash_ref}{'NoPlan'} ||
                           !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                           defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN20\n";
                        if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                              'Plan'}} && !exists
                              $Net::FullAuto::FA_Core::makeplan->{
                              'Title'}) {
                           $Net::FullAuto::FA_Core::makeplan->{'Title'}
                              =$pn{$numbor}[0];
                        }
                        push @{$Net::FullAuto::FA_Core::makeplan->{
                               'Plan'}},
                             { Label  => ${$MenuUnit_hash_ref}{'Label'},
                               Number => $numbor,
                               PlanID =>
                                  $Net::FullAuto::FA_Core::makeplan->{Number},
                               Item   => &Data::Dump::Streamer::Dump($sub)->Out() }
                     }
                     @resu=$sub->();
                     if (-1<$#resu) {
                        if (0<$#resu && wantarray && !$no_wantarray) {
                           return @resu;
                        } else {
#print "RETURN RESU7\n";
                           return return_result($resu[0],
                              $MenuUnit_hash_ref,$Conveyed);
                        }
                     }
                     $done=1;last
                  }
                  eval {
                     if ($subfile) {
                        if ($Term::Menus::fullauto && (!exists
                              ${$MenuUnit_hash_ref}{'NoPlan'} ||
                              !${$MenuUnit_hash_ref}{'NoPlan'}) &&
                              defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN21\n";
                           if (-1==$#{$Net::FullAuto::FA_Core::makeplan{
                                 'Plan'}} && !exists
                                 $Net::FullAuto::FA_Core::makeplan->{
                                 'Title'}) {
                              $Net::FullAuto::FA_Core::makeplan->{'Title'}
                                 =$pn{$numbor}[0];
                           }
                           push @{$Net::FullAuto::FA_Core::makeplan->{
                                   'Plan'}},
                                { Label  => ${$MenuUnit_hash_ref}{'Label'},
                                  Number => $numbor,
                                  PlanID =>
                                     $Net::FullAuto::FA_Core::makeplan->{Number},
                                  Item   => "&$subfile$sub" }
                        }
                        eval "\@resu=\&$subfile$sub";
                        my $firsterr=$@||'';
                        if ((-1<index $firsterr,'Undefined subroutine') &&
                              (-1<index $firsterr,$sub)) {
                           eval "\@resu=\&main::$sub";
                           my $seconderr=$@||'';my $die='';
                           if ($seconderr=~/Undefined subroutine/) {
                              if (${$FullMenu}{$MenuUnit_hash_ref}
                                    [2]{$all_menu_items_array[$numbor-1]}) {
                                 $die="The \"Result15 =>\" Setting"
                                     ."\n\t\t-> " . ${$FullMenu}
                                     {$MenuUnit_hash_ref}[2]
                                     {$all_menu_items_array[$numbor-1]}
                                     ."\n\t\tFound in the Menu Unit -> "
                                     .${$Term::Menus::LookUpMenuName}
                                     {$MenuUnit_hash_ref}."\n\t\t"
                                     ."Specifies a Subroutine"
                                     ." that Does NOT Exist"
                                     ."\n\t\tin the User Code File "
                                     .$Term::Menus::custom_code_module_file
                                     .",\n\t\tnor was a routine with "
                                     ."that name\n\t\tlocated in the"
                                     ." main:: script.\n";
                              } else { $die="$firsterr\n       $seconderr" }
                           } else { $die=$seconderr }
                           &Net::FullAuto::FA_Core::handle_error($die);
                        } elsif ($firsterr) {
                           &Net::FullAuto::FA_Core::handle_error($firsterr);
                        }
                     } else {
                        eval "\@resu=\&main::$sub";
                        die $@ if $@;
                     }
                  };
                  if ($@) {
                     if (unpack('a11',$@) eq 'FATAL ERROR') {
                        die $@;
                     } else {
                        my $die="\n       FATAL ERROR! - The Local "
                               ."System $Term::Menus::local_hostname Conveyed\n"
                               ."              the Following "
                               ."Unrecoverable Error Condition :\n\n"
                               ."       $@";
                        if (defined $log_handle &&
                              -1<index $log_handle,'*') {
                           print $log_handle $die;
                           close($log_handle);
                        }
                        if ($parent_menu && wantarray && !$no_wantarray) {
                           return '',
                              $FullMenu,$Selected,$Conveyed,
                              $SavePick,$SaveMMap,$SaveNext,
                              $Persists,$parent_menu,$die;
                        } elsif ($Term::Menus::fullauto) {
                           &Net::FullAuto::FA_Core::handle_error($die,'-28');
                        } else { die $die }
                     }
                  } else {
#print "ARE WE HERE????\n";sleep 10;
                     if (-1<$#resu) {
                        if (0<$#resu && wantarray && !$no_wantarray) {
                           return @resu;
                        } else {
#print "RETURN RESU8\n";
                           return return_result($resu[0],
                              $MenuUnit_hash_ref,$Conveyed);
                        }
                     }
                     $done=1;last
                  }
               }
#print "DONE_SUB14\n";sleep 5;
 return 'DONE_SUB';
            } else { $done=1 }
            last if !$return_from_child_menu;
         }
      } last if $done;
   }
   #if (${$MenuUnit_hash_ref}{Select} eq 'Many') {
   if ($select_many || (keys %{${$MenuUnit_hash_ref}{Select}})) {
      my @picks=();
      foreach (keys %picks) {
         my $pik=$all_menu_items_array[$_-1];
         push @picks, $pik;
      } undef @all_menu_items_array;
      if ($MenuUnit_hash_ref) {
         #unless ($Persists->{unattended}) {
         #   if ($^O ne 'cygwin') {
         #      unless ($noclear) {
         #         if ($^O eq 'MSWin32' || $^O eq 'MSWin64') {
         #            system("cmd /c cls");
         #            print "\n";
         #         } else {
         #            print `${Term::Menus::clearpath}clear`."\n";
         #         }
         #      } else { print "SEVEN\n";print $blanklines }
         #   } else { print "EIGHT\n";print $blanklines }
         #}
         return \@picks,
                $FullMenu,$Selected,$Conveyed,
                $SavePick,$SaveMMap,$SaveNext,
                $Persists,$parent_menu;
      } else {
         return @picks;
      }
   }
   my $pick=$all_menu_items_array[$numbor-1];
   undef @all_menu_items_array;
   if ($Term::Menus::fullauto && (!exists ${$MenuUnit_hash_ref}{'NoPlan'} ||
         !${$MenuUnit_hash_ref}{'NoPlan'}) &&
         defined $Net::FullAuto::FA_Core::makeplan) {
#print "IN MAKEPLAN23\n";
      if (-1==$#{$Net::FullAuto::FA_Core::makeplan{'Plan'}} &&
            !exists $Net::FullAuto::FA_Core::makeplan->{'Title'}) {
         $Net::FullAuto::FA_Core::makeplan->{'Title'}=$pick;
      }
      unless ($got_default) {
         push @{$Net::FullAuto::FA_Core::makeplan->{'Plan'}},
              { Label  => ${$MenuUnit_hash_ref}{'Label'},
                Number => $numbor,
                PlanID =>
                   $Net::FullAuto::FA_Core::makeplan->{Number},
                Item   => $pick }
      }
   }
   if (wantarray) {
      return $pick,
          $FullMenu,$Selected,$Conveyed,
          $SavePick,$SaveMMap,$SaveNext,
          $Persists,$parent_menu;
   } else {
      return $pick;
   }

}

sub return_result {

   my $result_string=$_[0];
   my $MenuUnit_hash_ref=$_[1];
   my $Conveyed=$_[2];
   ${$MenuUnit_hash_ref}{'Label'}||='';
   ${$Conveyed}{${$MenuUnit_hash_ref}{'Label'}}=
      $result_string;
   my $result_array=[];
   if ((-1<index $result_string,'][[') &&
         (-1<index $result_string,']][')) {
      $result_string=~s/^\s*\]\[\[\s*//s;
      $result_string=~s/\s*\]\]\[\s*$//s;
      my @elems=split /\s*\]\|\[\s*/,$result_string;
      foreach my $elem (@elems) {
         if (unpack('a5',$elem) eq 'eval ') {
            $elem=unpack('x5 a*',$elem);
            push @{$result_array}, eval $elem;
         } else {
            push @{$result_array}, $elem;
         }
      }
   } return [ $result_string ];

}

sub escape_quotes {

   my $sub=$_[0];
   return $sub if -1==index $sub,'"';
   my $routine=substr($sub,0,(index $sub,'(')+1);
   my $args=substr($sub,(index $sub,'(')+1,-1);
   $args=~s/[']/!%!'%!%/g;
   $args=~s/^\s*(["]|!%!)//;$args=~s/(["]|%!%)\s*$//;
   my @args=split /(?:["]|%!%)\s*,\s*(?:["]|!%!)/, $args;
   my @newargs=();
   foreach my $arg (@args) {
      $arg=~s/(!%!|%!%)//g;
      if ($arg=~/^[']/) {
         push @newargs, $arg;
      } else {
         $arg=~s/["]/\\"/g;
         push @newargs, '"'.$arg.'"';
      }
   }
   $sub=$routine;
   foreach my $arg (@newargs) {
      $sub.=$arg.",";
   }
   chop $sub;
   $sub.=')';
   return $sub;

}

1;

package TMMemHandle;

use strict;
sub TIEHANDLE {
   my $class = shift;
   bless [], $class;
}

sub PRINT {
   my $self = shift;
   push @$self, join '', @_;
}

sub PRINTF {
   my $self = shift;
   my $fmt = shift;
   push @$self, sprintf $fmt, @_;
}

sub READLINE {
   my $self = shift;
   shift @$self;
}

1;

__END__;

######################## User Documentation ##########################


## To format the following documentation into a more readable format,
## use one of these programs: perldoc; pod2man; pod2html; pod2text.
## For example, to nicely format this documentation for printing, you
## may use pod2man and groff to convert to postscript:
##   pod2man Term/Menus.pm | groff -man -Tps > Term::Menus.ps

=head1 NAME

Term::Menus - Create Powerful Terminal, Console and CMD Enviroment Menus

=head1 SYNOPSIS

C<use Term::Menus;>

see METHODS section below

=head1 DESCRIPTION

Term::Menus allows you to create powerful Terminal, Console and CMD environment
menus. Any perl script used in a Terminal, Console or CMD environment can
now include a menu facility that includes sub-menus, forward and backward
navigation, single or multiple selection capabilities, dynamic item creation
and customized banners. All this power is simple to implement with a straight
forward and very intuitive configuration hash structure that mirrors the actual
menu architechture needed by the application. A separate configuration file is
optional. Term::Menus is cross platform compatible.

Term::Menus is a stand-alone - other CPAN modules are not needed for its
implementation ( so it's *easy* to install! ;-) )

Term::Menus was initially conceived and designed to work seemlessly
with the perl based Network Process Automation Utility Module called
Net::FullAuto (Available in CPAN :-) - however, it is not itself dependant
on other Net::FullAuto components, and will work with *any* perl
script/application.


Reasons to use this module are:

=over 2

=item *

You have a list (or array) of items, and wish to present the user a simple
CMD enviroment menu to pick a single item and return that item as a scalar
(or simple string). Example:

   use Term::Menus;

   my @list=('First Item','Second Item','Third Item');
   my $banner="  Please Pick an Item:";
   my $selection=&pick(\@list,$banner);
   print "SELECTION = $selection\n";

The user sees ==>


   Please Pick an Item:

      1.        First Item
      2.        Second Item
      3.        Third Item

   (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 2 >-<ENTER>----------------------------------

The user sees ==>

   SELECTION = Second Item

=item *

You have a large list of items and need scrolling capability:

   use Term::Menus;

   my @list=`ls -1 /bin`;
   my $banner="   Please Pick an Item:";
   my $selection=&pick(\@list,$banner);
   print "SELECTION = $selection\n";

The user sees ==>

   Please Pick an Item:

      1.        arch
      2.        ash
      3.        awk
      4.        basename
      5.        bash
      6.        cat
      7.        chgrp
      8.        chmod
      9.        chown
      10.       cp

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--<ENTER>--------------------------------------

   Please Pick an Item:

      11.       cpio
      12.       csh
      13.       cut
      14.       date
      15.       dd
      16.       df
      17.       echo
      18.       ed
      19.       egrep
      20.       env

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 14 >-<ENTER>----------------------------------

The user sees ==>

   SELECTION = date

=item *

You need to select multiple items and return the selected list:

   use Term::Menus;

   my @list=`ls -1 /bin`;
   my %Menu_1=(

      Item_1 => {

         Text    => "/bin Utility - ]Convey[",
         Convey  => [ `ls -1 /bin` ],

      },

      Select => 'Many',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS = @selections\n";

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 3 >-<ENTER>----------------------------------

--< 7 >-<ENTER>----------------------------------

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
   *  3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
   *  7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< f >-<ENTER>----------------------------------

The user sees ==>

   SELECTIONS = /bin Utility - awk /bin Utility - chgrp


=item *

You need sub-menus:

   use Term::Menus;

   my %Menu_2=(

      Label  => 'Menu_2',
      Item_1 => {

         Text   => "]Previous[ is a ]Convey[ Utility",
         Convey => [ 'Good','Bad' ]
      },

      Select => 'One',
      Banner => "\n   Choose an Answer :"
   );

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => \%Menu_2,

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS=@selections\n";

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 5 >-<ENTER>----------------------------------

   Choose an Answer :

      1.        bash is a Good Utility
      2.        bash is a Bad Utility

   (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 1 >-<ENTER>----------------------------------

The user sees ==>

   SELECTIONS = bash is a Good Utility

=item *

You want to use a perl subroutine to create the text items or banner:

(Note: READ THE COMMENTS embedded in the Menu_2 sample following.
       The syntax is a bit tricky and MUST be created exactly as
       described - otherwise it will NOT work!)

   package current_package_name; # Qualify subroutine calls with
                                 # &main:: if not using
                                 # a package architechture

   use Term::Menus;

   sub create_items {

      my $previous=shift;
      my @textlines=();
      push @textlines, "$previous is a Good Utility";
      push @textlines, "$previous is a Bad Utility";
      return @testlines;
             ## return value must NOT be an array
             ## not an array reference

   }

   sub create_banner {

      my $previous=shift;
      return "\n   Choose an Answer for $previous :"
             ## return value MUST be a string for banner

   }

   my %Menu_2=(

      Label  => 'Menu_2',
      Item_1 => {

         Text   => "]Convey[",
         Convey => "&current_package_name::create_items(\"]Previous[\")",

                   # IMPORTANT! '&' *must* be used to denote subroutine
                   #            as the first character

                   #      &current_package_name:: qualifier or &main::
                   #      quaifiler MUST be used - otherwise
                   #      Term::Menus cannot locate it

                   #      embedded quote characters must be escaped

                   #      enclosing double quotes MUST be used - this is
                   #      a STRING being passed to Term::Menus that will
                   #      then be internally eval-ed during runtime
                   #      after the macro ]Previous[ is substituted

                   #      other macros and values can be passed as
                   #      arguments as follows:

                   #      (\"]Previous[\",\"AnyString\")

      },

      Select => 'One',
      Banner => "&current_package_name::create_banner(\"]Previous[\")",

                ## or "&main::create_banner(\"]Previous[\")",
                ## if using in top level script (file does NOT
                ## have .pm extension)
   );

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => \%Menu_2,

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS=@selections\n";

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 5 >-<ENTER>----------------------------------

   Choose an Answer for bash :

      1.        bash is a Good Utility
      2.        bash is a Bad Utility

   (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 1 >-<ENTER>----------------------------------

The user sees ==>

   SELECTIONS = bash is a Good Utility

=back

More examples are in the B<EXAMPLES> section below.

Usage questions should be directed to the Usenet newsgroup
comp.lang.perl.modules.

Contact me, Brian Kelly <Brian.Kelly@fullautosoftware.net>,
if you find any bugs or have suggestions for improvements.

=head2 What To Know Before Using

=over 2

=item *

There are two methods available with Term::Menus - &pick() and &Menu().
C<&Menu()> uses C<&pick()> - you can get the same results using
only
C<&Menu()>. However, if you need to simply pick one item from a single
list - use C<&pick()>. The syntax is simpler, and you'll write less code.
;-)

=item *

You'll need to be running at least Perl version 5.002 to use this
module.  This module does not require any libraries that don't already
come with a standard Perl distribution.

=back

=head1 METHODS

=over 4

=item B<pick> - create a simple menu

    $pick = &pick ($list|\@list|['list',...],[$Banner]);

Where I<$list> is a variable containing a array or list reference.
This argument can also be a escaped array (sending a reference) or
an anonymous array (which also sends a reference).

I<$Banner> is an optional argument sending a customized Banner to
top the simple menu - giving instructions, descriptions, etc.
The default is "Please Pick an Item:"

=item B<Menu> - create a complex Menu

    $pick  = &Menu ($list|\@list|['list',...],[$Banner]);

Where I<$pick> is a variable containing a array or list reference
of the pick or picks.

    @picks = &Menu ($Menu_1|\%Menu_1|{ Label => 'Menu_1' });

Where I<$Menu_1> is a hash reference to the top level Menu
Configuration Hash Structure.

=back

=head2  Menu Configuration Hash Structures

=over 4

These are the building blocks of the overall Menu architecture. Each
hash structure represents a I<menu screen>. A single menu layer, has
only one hash structure defining it. A menu with a single sub-menu
will have two hash structures. The menus connect via the C<Result>
element of an I<Item> - C<Item_1> - hash structure in parent menu
C<%Menu_1>:


   my %Menu_2=(

      Label  => 'Menu_2',
      Item_1 => {

         Text   => "]Previous[ is a ]Convey[ Utility",
         Convey => [ 'Good','Bad' ]
      },

      Select => 'One',
      Banner => "\n   Choose an Answer :"
   );

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => \%Menu_2,

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

=back

=head3  Menu Component Elements

Each Menu Configuration Hash Structure consists of elements that define
and control it's behavior, appearance, constitution and purpose. An
element's syntax is as you would expect it to be in perl - a key string
pointing to an assocaited value: C<key =E<gt> value>. The following
items
list supported key names and ther associated value types:

=over 4

=item

B<Display> => 'Integer'

=item

=over 2

=item

The I<Display> key is an I<optional> key that determines the number
of Menu
Items that will be displayed on each screen. This is useful when the items
are multi-lined, or the screen size is bigger or smaller than the default
number utilizes in the most practical fashion. The default number is 10.

   Display => 15,

=back

=item

B<Label> => 'Char String consisting of ASCII Characters'

=item

=over 2

=item

The I<Label> key provides a unique identifier to each Menu Structure.
I<Every Menu Configuration Hash Structure B<must> have a valid and
unique Label element> Otherwise C<&Menu()> will throw an error.

   Label => 'Menu_1',

=back

=item

B<Item_E<lt>intE<gt>> => { Item Configuration Hash
Structure }

=item

=over 2

=item

The I<Item_E<lt>intE<gt>> elements define customized menu items.
There are
essentially two methods for creating menu items: The I<Item_E<lt>intE<gt>>
elements, and the C<]Convey[> macro (described later). The difference being
that the C<]Convey[> macro turns an Item Conguration Hash into an Item
I<Template> -> a B<powerful> way to I<Item>-ize large lists
or quantities
of data that would otherwise be difficult - even impossible - to anticipate
and cope with manually.

   Item_1 => { Text => 'Item 1' },
   Item_2 => { Text => 'Item 2' },

Items created via C<]Convey[> macros have two drawbacks:

=over 2

=item *

They all have the same format.

=item *

They all share the same C<Result> element.

=back

The syntax and usage of I<Item_E<lt>intE<gt>> elements is important
and
extensive enough warrant it's own section. See B<I<Item Configuration Hash
Structures>> below.

=back

=item

B<Select> => 'One' --or-- 'Many'

=item

=over 2

=item

The MENU LEVEL I<Select> element determines whether this particular menu
layer allows the selection of multiple items - or a single item. The 
default is 'One'.

   Select => 'Many',

=back

=item

B<Banner> => 'Char String consisting of ASCII Characters'

=item

=over 2

=item

The I<Banner> element provides a customized descriptive header to the menu.
I<$Banner> is an optional element - giving instructions, descriptions, etc.
The default is "Please Pick an Item:"

   Banner => "The following items are for selection,\n".
             "\tEnjoy the Experience!",

B<NOTE:>   Macros (like  C<]Previous[> )  I<can> be used in Banners!   :-)   ( See Item Configuration Macros below )

=back

=back

=head3 Item Congfiguration Hash Structures

Each Menu Item can have an independant configurtion. Each Menu Configuration
Hash Structure consists of elements that define and control it's behavior,
appearance, constitution and purpose. An element's syntax is as you would
expect it to be in perl - a key string pointing to an assocaited value: key
=> value. The following items list supported key names and ther associated
value types:

=over 4

=item

B<Text> => 'Char String consisting of ASCII Characters'

=item

=over 2

=item

The I<Text> element provides a customized descriptive string for the Item.
It is the text the user will see displayed, describing the selection.

   Text => 'This is Item_1',

=back

=item

B<Convey> => [ List ] --or-- @List --or-- $Scalar --or-- 'ASCII String'

=item

=over 2

=item

The I<Convey> element has a twofold purpose; it provides for the contents
of the C<]Convey[> macro, and defines or contains the string or result that
is passed on to child menus - if any. Use of this configuration element is
I<optional>. If C<Convey> is not a list, then it's value is passed onto child
menus. If C<Convey> I<is> a list, then the Item selected is passed onto the
children - if any. It is important to note, I<when used>, that only the
resulting I<Convey> string - B<I<NOT>> the the Item C<Text> value or string,
is conveyed to child menus. When the C<Convey> element is not used, the
full Item C<Text> value B<is> conveyed to the children - if any. However, the
full contents of the C<Text> element is I<returned> as the I<Result> of the
operation when the user completes all menu activity. See the I<Macro> section
below for more information.

   Convey => [ `ls -1` ] ,

=back

=item

B<Default> => 'Char String' --or-- Perl regular expression - qr/.../

=item

=over 2

=item

The I<Default> element provides a means to pre-select certain elements,
as if the items were selected by the user. This can be done with two
constructs - simple string or pre-compiled regular expression.
Note: The C<Default> element is available only when the C<Select> element
is set to C<'Many'> - C<Select => 'Many',>

   Default => 'base|chown',

   Default => qr/base|chown/i,

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
   *  4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
   *  9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

=back

=item

B<Select> => 'One' --or-- 'Many'

=item

=over 2

=item

The ITEM LEVEL I<Select> element provides a means to inform Term::Menus
that the specific items of a single ITEM BLOCK (as opposed to full menu)
are subject to multiple selecting - or just single selection. This is
useful in particular for Directory Tree navigation - where files can
be multi-selected (or tagged), yet when a directory is selectedi, it
forces an immediate navigation and new menu - showing the contents of
the just selected directory.

B<NOTE:> See the B<RECURSIVELY CALLED MENUS> section for more information.

   Select => 'More',

The user sees ==>

   d  1.        bin
   d  2.        blib
   d  3.        dist
   d  4.        inc
   d  5.        lib
   d  6.        Module
   d  7.        t
      8.        briangreat2.txt
   *  9.        ChangeLog
      10.       close.perl

   a.  Select All.   f.  Finish.

   49 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

=back

=item

B<Exclude> => 'Char String' --or-- Perl regular expression - qr/.../

=item

=over 2

=item

The I<Exclude> element provides a means to remove matching elements
from the Menu seen by the user. This element is useful only when the
C<]Convey[> macro is used to populate items. This can be done with two
constructs - simple string or pre-compiled regular expression.

   Exclude => 'base|chown',

   Exclude => qr/base|chown/i,

=back

=item

B<Include> => 'Char String' --or-- Perl regular expression - qr/.../

=item

=over 2

=item

The I<Include> element provides a means to create items filtered from a larger
list of potential items available via the C<]Convey[> macro. This element is
useful only when the C<]Convey[> macro is used to populate items. The
C<Exclude> element can be used in conjunction with C<Include> to further
refine the final list of items used to construct the menu. The C<Include>
element - when used - always takes presidence, and the C<Exclude> will be used
only on the C<Include> filtered results. This element can be used with
two value constructs - simple string or pre-compiled regular expression.

   Include => 'base|chown',

   Include => qr/base|chown/i,

=back

=item

B<Result> => \%Menu_2  --or --  "&any_method()",

=item

=over 2

=item

I<Result> is an I<optional> element that also has two important uses:

=item *

For selecting the child menu next in the chain of operation and conveyance,

   Result => \%Menu_2,

--or--

=item *

For building customized method arguements using C<&Menu()>'s built-in
macros.

=item

   Result => "&any_method($arg1,\"]Selected[\",\"]Previous[\")",

B<NOTE:> I<ALWAYS> be sure to surround the subroutine or method calling
syntax with DOUBLE QUOTES. (You can use single quotes if you don't want
interpolation). Quotes are necessary because you're telling C<&Menu()> -
I<not> Perl - what method you want invoked. C<&Menu()> won't invoke the method
until after all other processing - where Perl will try to invoke it the first
time it encounters the line during runtime - lo----ng before a user gets a
chance to see or do I<anything>. B<BUT> - be sure I<B<NOT>> to use quotes
when assigning a child menu reference to the C<Result> value.

Again, I<Result> is an I<optional> element. The default behavior when
C<Result> is omitted from the Item Configuration element, is for the selection
to be returned to the C<&Menu()>'s calling script/module/app. If the C<Select>
element was set to C<'One'>, then that item is returned regardless of whether
the Perl structure receiving the output is an array or scalar. If there were
multiple selections - i.e., C<Select> is set to C<'Many'> - then, depending
on what structure is set for receiving the output, will determine whether
C<&Menu()> returns a list (i.e. - array), or I<reference> to an array.

=back

=back

=head3 Item Congfiguration Macros

Each Menu Item can utilize a very powerful set of configuration I<Macros>.
These constructs principally act as purveyors of information - from one
menu to another, from one element to another. There are currently three
available Macros:

=over 4

=item

B<]Convey[>

=item

=over 2

=item

C<]Convey[> is used in conjunction with the I<Convey> element (described)
earlier. It's purpose to "convey" or transport or carry a list item associated
with the C<Convey> element - and replace the C<]Convey[> Macro in the C<Text>
element value with that list item. The I<Convey> mechanism utilizing the
C<Convey> Macro is essentially an I<Item multiplier>. The entire contents of
the list associated with the I<Convey> element will be turned into it's own
C<Item> when the menu is displayed.

   use Term::Menus;

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => \%Menu_2,

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS=@selections\n";

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

B<NOTE:>     C<]C[>  can be used as a shorthand for  C<]Convey[>.

=back

=item

B<]Previous[>

=item

=over 2

=item

C<]Previous[> can be used in child menus. The C<]Previous[> Macro contains
the I<Selection> of the parent menu. Unlike the C<]Convey[> Macro, the
C<]Previous[> Macro can be used in both the C<Text> element value, and the
C<Result> element values (when constructing method calls):

The C<]Previous[> Macro can also be used in the Banner.

   use Term::Menus;

   my %Menu_2=(

      Label  => 'Menu_2',
      Item_1 => {

         Text   => "]Previous[ is a ]Convey[ Utility",
         Convey => [ 'Good','Bad' ]
      },

      Select => 'One',
      Banner => "\n   Choose an Answer :"
   );

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => \%Menu_2,

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS=@selections\n";

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 5 >-<ENTER>----------------------------------

   Choose an Answer :

      1.        bash is a Good Utility
      2.        bash is a Bad Utility

   (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 1 >-<ENTER>----------------------------------

The user sees ==>

   SELECTIONS = bash is a Good Utility

B<NOTE:>     C<]P[>  can be used as a shorthand for  C<]Previous[>.

=back

=item

B<]Previous[{> <I<Menu_Label>> B<}>

=item

=over 2

=item

C<]Previous[{Menu_Label}> can be used in child menus. The C<]Previous[{Menu_Label}> 
Macro contains the I<Selection> of any preceding menu specified with the C<Menu_Label> 
string. The C<]Previous[{Menu_Label}> follows the same conventions as the C<]Previous[>
Macro - but enables access to the selection of i<any> preceding menu. This is very
useful for Menu trees more than two levels deep.

The C<]Previous[{Menu_Label}> Macro can also be used in the Banner.

   use Term::Menus;

   my %Menu_3=(

      Label  => 'Menu_3',
      Item_1 => {

         Text   => "]Convey[ said ]P[{Menu_1} is a ]Previous[ Utility!",
         Convey => [ 'Bob','Mary' ]
      },

      Select => 'One',
      Banner => "\n   Who commented on ]Previous[{Menu_1}? :"
   );

   my %Menu_2=(

      Label  => 'Menu_2',
      Item_1 => {

         Text   => "]Previous[ is a ]C[ Utility",
         Convey => [ 'Good','Bad' ],
         Result => \%Menu_3,
      },

      Select => 'One',
      Banner => "\n   Is ]P[ Good or Bad? :"
   );

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => \%Menu_2,

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS=@selections\n";

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   PLEASE ENTER A CHOICE:

--< 5 >-<ENTER>----------------------------------

   Is bash Good or Bad? :

      1.        bash is a Good Utility
      2.        bash is a Bad Utility

   (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 1 >-<ENTER>----------------------------------

   Who commented on bash? :

      1.        Bob said bash is a Good Utility!
      2.        Mary said bash is a Good Utility!

   (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 2 >-<ENTER>----------------------------------


The user sees ==>

   SELECTIONS = Mary said bash is a Good Utility!

B<NOTE:>     C<]P[>  can be used as a shorthand for  C<]Previous[>.

C<]P[{Menu_Label}>  can be used as a shorthand for C<]Previous[{Menu_Label}>.

C<]C[> can be used as a shorthand for C<]Convey[>.

=back

=item

B<]Selected[>

=item

=over 2

=item

C<]Selected[> can only be used in a I<terminal> menu. B<(> I<A terminal menu is
the last menu in the chain, or the last menu the user sees. It is the menu that
defines the> C<Result> I<element with a method> C<Result =E<gt> &any_method()>,
I<or does not have a> C<Result> I<element included or defined.> B<)>
C<]Selected[> is used to pass the selection of the I<current> menu to the
C<Result> element method of the current menu:

   use Term::Menus;

   sub selected { print "\n   SELECTED ITEM = $_[0]\n" }

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => "&selected(]Selected[)",

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS=@selections\n";

B<NOTE:>     C<]S[>  can be used as a shorthand for  C<]Selected[>.

B<NOTE:>     if you want to return output from the Result subroutine,
             you must include a 'return' statement. So the sub above:

                sub selected { print "\n   SELECTED ITEM = $_[0]\n" }

             Becomes:

                sub selected { print "\n   SELECTED ITEM = $_[0]\n";return $_[0] }

=back

=back

=head1 RECURSIVELY CALLED MENUS

There are occasions where it is desirable to re-use the same Menu template/hash configuration with dynamically discovered data. One obvious example of this is navigating directory trees. Each subsequent directory selection could potentially contain deeper levels of directories. Essentially, any data structured in any kind of relational tree layout is subject to this kind of navigation approach. Be warned however, unlike most other functionality that is handled almost entirely by the Term::Menus module, the code for doing recursive templating is mostly contained in the template/hash configuration itself. There is a "helper routine" (&get_Menu_map) that Term::Menus provides to assist with the creation of recursively-friendly configurations, but given the highly data-centric characteristics of such functionality, most of the working code must be left to the authoring and management of the user.


=head3 &get_Menu_map()

This is a helper routine that returns a list of ancestor menu results. This is needed when wanting to navigate a directory tree for instance. Imagine a directory path that looks like this: /one/two/three. A call to &get_Menu_map() when processing directory three with return this list: ('one','two').

=over4

=item

=over 2

=item

The following code is an example of how to use recursion for navigating a directory tree. (Note: As of 6/3/2011, this is BRAND NEW functionality, and work on this feature continues.):

   use Term::Menus;

   %dir_menu=(

      Label => 'dir_menu',
      Item_1 => {

         Text => "]C[",
         Mark => "d",
         Convey => sub {
 
            if ("]P[") {

               my $dir="]P[";
               if (substr($dir,0,1) eq '[') {
                  $dir=${eval $dir}[0];
               }
               $dir||='.';
               my @files=();
               my @return=();
               my @map=get_Menu_map;
               my $path=join "/", @map;
               opendir(DIR,"./$path") || die $!;
               @files = readdir(DIR);
               closedir(DIR);
               foreach my $entry (@files) {
                  next if $entry eq '.';
                  next if $entry eq '..';
                  if (-1<$#map) {
                     next unless -d "$path/$entry";
                  } else {
                     next unless -d $entry;
                  } 
                  push @return, $entry;
               }
               return @return;

            }
            my @files=();
            my @return=();
            opendir(DIR,'.') || die $!;
            @files = readdir(DIR);
            closedir(DIR);
            foreach my $entry (@xfiles) {
               next if $entry eq '.';
               next if $entry eq '..';
               next unless -d $entry;
               push @return, $entry;
            }
            return @return;

         },
         Result => { 'dir_menu'=>'recurse' },

      },
      Item_2 => {

         Text => "]C[",
         Select => 'Many',
         Convey => sub {

            if ("]P[") {
               my $dir="]P[";
               if (substr($dir,0,1) eq '[') {
                  $dir=${eval $dir}[0];
               }
               $dir||='.';
               my @files=();
               my @return=();
               my @map=get_Menu_map;
               my $path=join "/", @map;
               opendir(DIR,"./$path") || die $!;
               @files = readdir(DIR);
               closedir(DIR);
               foreach my $entry (@files) {
                  next if $entry eq '.';
                  next if $entry eq '..';
                  if (-1<$#map) {
                     next if -d "$path/$entry";
                  } else {
                     next if -d $entry;
                  }
                  push @return, $entry;
               }
               return @return;

            }
            my @files=();
            my @return=();
            opendir(DIR,'.') || die $!;
            @files = readdir(DIR);
            closedir(DIR);
            foreach my $entry (@xfiles) {
               next if $entry eq '.';
               next if $entry eq '..';
               next if -d $entry;
               push @return, $entry;
            }
            return @return;

         },
      },

   );

   my $selection=Menu(\%dir_menu);

   if (ref $selection eq 'ARRAY') {
      print "\nSELECTION=",(join " ",@{$selection}),"\n";
   } else {
      print "\nSELECTION=$selection\n";
   }

=back

=back

=head1 USAGE and NAVIGATION

Usage of C<&pick()> and/or C<&Menu()> during the runtime of a script in which
one or both are included, is simple and intuitive. Nearly everything the end
user needs in terms of instruction is included on-screen. The
script-writer/developer/programmer can also include whatever instructions s/he
deems necessary and/or helpful in the customizable C<Banner> (as described
above). There is however, one important feature about using C<&Menu()> with
sub-menus that's important to know about.

=head3 Forward  ' B<E<gt>> ' and  Backward  ' B<E<lt>> ' Navigation

When working with more than one C<&Menu()> screen, it's valuable to know how
to navigate back and forth between the different C<&Menu()> levels/layers.  For
example, above was illustrated the output for two layers of menus - a parent
and a child:

=over 4

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< 5 >-<ENTER>----------------------------------

The user sees ==>

   Choose an Answer :

      1.        bash is a Good Utility
      2.        bash is a Bad Utility

   (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

=back

In the above example, suppose that the user "fat-fingered" his/her
choice, and really didn't want to "bash" bash, but wanted to bash
awk instead. Is restarting the whole script/application now necessary?
Suppose it was a process that had run overnight, and the user is seeing
this menu through fogged glasses from the steam rising out of their
morning coffee? Having to run the whole job again would not be welcome news
for the BOSS. THANKFULLY, navigation makes this situation avoidable.
All the user would have to do is type ' B<E<lt>> ' to go backward to the
previous menu, and ' B<E<gt>> ' to go forward to the next menu (assuming there
is one in each case):

The user sees ==>

   Choose an Answer :

      1.        bash is a Good Utility
      2.        bash is a Bad Utility

   (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

 --<  >  >-<ENTER>-----------------------------

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
   -  5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

Note in the above example the Dash ' B<-> ' in front of item B<5.> This informs
the user that s/he had previously selected this item. To clear the selection,
the user would simply choose item B<5> again. This effectively deletes the
previous choice and restores the menu for a new selection. If the user was
satisfied with the choice, and was simply double checking thier selection, they
simply repeat the navigation process by typing ' B<E<gt>> ' - then <ENTER>
-
and returning to the child menu they left.

If the child menu was a I<multiple-selection> menu, and the user had made some
selections before navigating back to the parent menu, the user would see a
' B<+> ' rather than a ' B<-> '. This informs the user that selections were
made in the child menu.

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
   +  5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

=head3 View Sorted Items ' B<%> '

When working with numerous items in a single menu, it may be desirable to see
the set of choices organized in either descending or reverse acscii order.
Term::Menus provides this feature with the I<Percent> ' B<%> ' key.  Simply
type ' B<%> ' and the items will be sorted in descending ascii order. Type
' B<%> ' again, and you will see the items reverse sorted. Assume that we have
the following menus.

=over 4

The user sees ==>

   Please select all files for immediate transfer:

   *  1.        addr2name.awk has  **NOT**  been transferred
   *  2.        awk.exe has  **NOT**  been transferred
      3.        gawk-3.1.4.exe has  **NOT**  been transferred
   *  4.        gawk.exe has  **NOT**  been transferred
      5.        igawk has  **NOT**  been transferred
      6.        pgawk-3.1.4.exe has  **NOT**  been transferred
      7.        pgawk.exe has  **NOT**  been transferred
   *  8.        822-date has been transferred
      9.        DllPlugInTester.exe has been transferred
   *  10.       ELFDump.exe has been transferred

   a.  Select All.   c.  Clear All.
   f.  Finish.

   929 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< % >-<ENTER>----------------------------------

The user sees ==>

   Please select all files for immediate transfer:

   *  8.        822-date has been transferred
      9.        DllPlugInTester.exe has been transferred
   *  10.       ELFDump.exe has been transferred
      11.       GraphicsMagick++-config has been transferred
      12.       GraphicsMagick-config has been transferred
      13.       X11 has been transferred
      14.       [.exe has been transferred
      15.       a2p.exe has been transferred
      16.       aclocal has been transferred
      17.       aclocal-1.4 has been transferred

   a.  Select All.   c.  Clear All.
   f.  Finish.

   929 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

And if we choose to enter ' B<%> ' I<again>

--< % >-<ENTER>----------------------------------

The user sees ==>

   Please select all files for immediate transfer:

      929.      znew has been transferred
      928.      zmore has been transferred
      927.      zless has been transferred
      926.      zipsplit.exe has been transferred
      925.      zipnote.exe has been transferred
      924.      zipinfo has been transferred
      923.      zipgrep has been transferred
      922.      zipcloak.exe has been transferred
      921.      zip.exe has been transferred
      920.      zgrep has been transferred

   a.  Select All.   c.  Clear All.
   f.  Finish.

   929 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

This submenu of selections works just like any other menu. The user can
deselect an item, clear all items, re-choose all items, etc. The choices made
here are preserved when-or-if the user navigates back to the original (parent)
menu. In other words, if Item 1. is deselected in the sorted menu, Item 1.
will also be deselected in the parent menu above.

=back

=head3 View Summary of Selected Items ' B<*> '

When working with numerous items in a single menu, it is desirable to see the
set of choices made before leaving the menu and committing to a non-returnable
forward (perhaps even critical) process. Term::Menus provides this feature
with the I<Star> ' B<*> ' key. Assume we have the following menu with 93 Total
Choices. Assume further that we have selected items 1,3,9 & 11. Note that we
cannot see Item 11 on the first screen since this menu is configured to show
only 10 Items at a time.

=over 4

The user sees ==>

   Choose a /bin Utility :

   *  1.        /bin Utility - arch
      2.        /bin Utility - ash
   *  3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
   *  9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

--< * >-<ENTER>----------------------------------

The user sees ==>

   Choose a /bin Utility :

   *  1.        /bin Utility - arch
   *  3.        /bin Utility - awk
   *  9.        /bin Utility - chown
   *  11.       /bin Utility - cpio

   (Type "quit" to quit)

   PLEASE ENTER A CHOICE:

This submenu of selections works just like any other menu. The user can
deselect an item, clear all items, re-choose all items, etc. The choices made
here are preserved when-or-if the user navigates back to the original (parent)
menu. In other words, if Item 1. is deselected in the summary menu, Item 1.
will also be deselected in the parent menu above.

=back

=head1 EXAMPLES

=head1 AUTHOR

Brian M. Kelly <Brian.Kelly@fullautosoftware.net>

=head1 COPYRIGHT

Copyright (C) 2000, 2001, 2002, 2003, 2004,
              2005, 2006, 2007, 2008, 2010,
              2011
by Brian M. Kelly.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License.
(http://www.opensource.org/licenses/gpl-license.php).

