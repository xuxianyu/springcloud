# 
# Thanks to  Joseph Wilkicki for submitting this file's contents
#
# In your Quartz properties file, you'll need to set 
# org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.HSQLDBDelegate
#
# Some users report the need to change the fields
# with datatype "OTHER" to datatype "BINARY" with
# particular versions (e.g. 1.7.1) of HSQLDB
#

CREATE TABLE qrtz_job_details
(
  SCHED_NAME VARCHAR(120) NOT NULL,
  JOB_NAME LONGVARCHAR(80) NOT NULL,
  JOB_GROUP LONGVARCHAR(80) NOT NULL,
  DESCRIPTION LONGVARCHAR(120) NULL,
  JOB_CLASS_NAME LONGVARCHAR(128) NOT NULL,
  IS_DURABLE LONGVARCHAR(1) NOT NULL,
  IS_NONCONCURRENT LONGVARCHAR(1) NOT NULL,
  IS_UPDATE_DATA LONGVARCHAR(1) NOT NULL,
  REQUESTS_RECOVERY LONGVARCHAR(1) NOT NULL,
  JOB_DATA OTHER NULL,
  PRIMARY KEY (SCHED_NAME, JOB_NAME, JOB_GROUP)
);

CREATE TABLE qrtz_triggers
(
  SCHED_NAME     VARCHAR(120) NOT NULL,
  TRIGGER_NAME LONGVARCHAR(80) NOT NULL,
  TRIGGER_GROUP LONGVARCHAR(80) NOT NULL,
  JOB_NAME LONGVARCHAR(80) NOT NULL,
  JOB_GROUP LONGVARCHAR(80) NOT NULL,
  DESCRIPTION LONGVARCHAR(120) NULL,
  NEXT_FIRE_TIME NUMERIC(13)  NULL,
  PREV_FIRE_TIME NUMERIC(13)  NULL,
  PRIORITY       INTEGER      NULL,
  TRIGGER_STATE LONGVARCHAR(16) NOT NULL,
  TRIGGER_TYPE LONGVARCHAR(8) NOT NULL,
  START_TIME     NUMERIC(13)  NOT NULL,
  END_TIME       NUMERIC(13)  NULL,
  CALENDAR_NAME LONGVARCHAR(80) NULL,
  MISFIRE_INSTR  NUMERIC(2)   NULL,
  JOB_DATA OTHER NULL,
  PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  FOREIGN KEY (SCHED_NAME, JOB_NAME, JOB_GROUP)
  REFERENCES QRTZ_JOB_DETAILS (SCHED_NAME, JOB_NAME, JOB_GROUP)
);

CREATE TABLE qrtz_simple_triggers
(
  SCHED_NAME      VARCHAR(120) NOT NULL,
  TRIGGER_NAME LONGVARCHAR(80) NOT NULL,
  TRIGGER_GROUP LONGVARCHAR(80) NOT NULL,
  REPEAT_COUNT    NUMERIC(7)   NOT NULL,
  REPEAT_INTERVAL NUMERIC(12)  NOT NULL,
  TIMES_TRIGGERED NUMERIC(10)  NOT NULL,
  PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
  REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

CREATE TABLE qrtz_cron_triggers
(
  SCHED_NAME VARCHAR(120) NOT NULL,
  TRIGGER_NAME LONGVARCHAR(80) NOT NULL,
  TRIGGER_GROUP LONGVARCHAR(80) NOT NULL,
  CRON_EXPRESSION LONGVARCHAR(120) NOT NULL,
  TIME_ZONE_ID LONGVARCHAR(80),
  PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
  REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

CREATE TABLE qrtz_simprop_triggers
(
  SCHED_NAME  VARCHAR(120)   NOT NULL,
  TRIGGER_NAME LONGVARCHAR(200) NOT NULL,
  TRIGGER_GROUP LONGVARCHAR(200) NOT NULL,
  STR_PROP_1 LONGVARCHAR(512) NULL,
  STR_PROP_2 LONGVARCHAR(512) NULL,
  STR_PROP_3 LONGVARCHAR(512) NULL,
  INT_PROP_1  NUMERIC(9)     NULL,
  INT_PROP_2  NUMERIC(9)     NULL,
  LONG_PROP_1 NUMERIC(13)    NULL,
  LONG_PROP_2 NUMERIC(13)    NULL,
  DEC_PROP_1  NUMERIC(13, 4) NULL,
  DEC_PROP_2  NUMERIC(13, 4) NULL,
  BOOL_PROP_1 LONGVARCHAR(1) NULL,
  BOOL_PROP_2 LONGVARCHAR(1) NULL,
  PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
  REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

CREATE TABLE qrtz_blob_triggers
(
  SCHED_NAME VARCHAR(120) NOT NULL,
  TRIGGER_NAME LONGVARCHAR(80) NOT NULL,
  TRIGGER_GROUP LONGVARCHAR(80) NOT NULL,
  BLOB_DATA OTHER NULL,
  PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
  REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

CREATE TABLE qrtz_calendars
(
  SCHED_NAME VARCHAR(120) NOT NULL,
  CALENDAR_NAME LONGVARCHAR(80) NOT NULL,
  CALENDAR OTHER NOT NULL,
  PRIMARY KEY (SCHED_NAME, CALENDAR_NAME)
);

CREATE TABLE qrtz_paused_trigger_grps
(
  SCHED_NAME VARCHAR(120) NOT NULL,
  TRIGGER_GROUP  LONGVARCHAR(80) NOT NULL,
  PRIMARY KEY (SCHED_NAME, TRIGGER_GROUP)
);

CREATE TABLE qrtz_fired_triggers
(
  SCHED_NAME VARCHAR(120) NOT NULL,
  ENTRY_ID LONGVARCHAR(95) NOT NULL,
  TRIGGER_NAME LONGVARCHAR(80) NOT NULL,
  TRIGGER_GROUP LONGVARCHAR(80) NOT NULL,
  INSTANCE_NAME LONGVARCHAR(80) NOT NULL,
  FIRED_TIME NUMERIC(13)  NOT NULL,
  SCHED_TIME NUMERIC(13)  NOT NULL,
  PRIORITY   INTEGER      NOT NULL,
  STATE LONGVARCHAR(16) NOT NULL,
  JOB_NAME LONGVARCHAR(80) NULL,
  JOB_GROUP LONGVARCHAR(80) NULL,
  IS_NONCONCURRENT LONGVARCHAR(1) NULL,
  REQUESTS_RECOVERY LONGVARCHAR(1) NULL,
  PRIMARY KEY (SCHED_NAME, ENTRY_ID)
);

CREATE TABLE qrtz_scheduler_state
(
  SCHED_NAME        VARCHAR(120) NOT NULL,
  INSTANCE_NAME LONGVARCHAR(80) NOT NULL,
  LAST_CHECKIN_TIME NUMERIC(13)  NOT NULL,
  CHECKIN_INTERVAL  NUMERIC(13)  NOT NULL,
  PRIMARY KEY (SCHED_NAME, INSTANCE_NAME)
);

CREATE TABLE qrtz_locks
(
  SCHED_NAME VARCHAR(120) NOT NULL,
  LOCK_NAME  LONGVARCHAR(40) NOT NULL,
  PRIMARY KEY (SCHED_NAME, LOCK_NAME)
);

COMMIT;
