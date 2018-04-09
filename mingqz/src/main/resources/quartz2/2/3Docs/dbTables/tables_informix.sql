{}
{Thanks TO Keith Chew FOR submitting this.}
{}
{USE the StdJDBCDelegate WITH Informix.}
{}
{note that Informix has a 18 cahracter LIMIT ON the TABLE NAME, so the prefix had TO be shortened TO "q" instread of "qrtz_"}

CREATE TABLE qblob_triggers (
  SCHED_NAME    VARCHAR(120) NOT NULL,
  TRIGGER_NAME  VARCHAR(80)  NOT NULL,
  TRIGGER_GROUP VARCHAR(80)  NOT NULL,
  BLOB_DATA BYTE IN TABLE
);

ALTER TABLE qblob_triggers
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);


CREATE TABLE qcalendars (
  SCHED_NAME    VARCHAR(120) NOT NULL,
  CALENDAR_NAME VARCHAR(80)  NOT NULL,
  CALENDAR BYTE IN TABLE NOT NULL
);

ALTER TABLE qcalendars
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, CALENDAR_NAME);


CREATE TABLE qcron_triggers (
  SCHED_NAME      VARCHAR(120) NOT NULL,
  TRIGGER_NAME    VARCHAR(80)  NOT NULL,
  TRIGGER_GROUP   VARCHAR(80)  NOT NULL,
  CRON_EXPRESSION VARCHAR(120) NOT NULL,
  TIME_ZONE_ID    VARCHAR(80)
);

ALTER TABLE qcron_triggers
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);


CREATE TABLE qfired_triggers (
  SCHED_NAME        VARCHAR(120) NOT NULL,
  ENTRY_ID          VARCHAR(95)  NOT NULL,
  TRIGGER_NAME      VARCHAR(80)  NOT NULL,
  TRIGGER_GROUP     VARCHAR(80)  NOT NULL,
  INSTANCE_NAME     VARCHAR(80)  NOT NULL,
  FIRED_TIME        NUMERIC(13)  NOT NULL,
  SCHED_TIME        NUMERIC(13)  NOT NULL,
  PRIORITY          INTEGER      NOT NULL,
  STATE             VARCHAR(16)  NOT NULL,
  JOB_NAME          VARCHAR(80),
  JOB_GROUP         VARCHAR(80),
  IS_NONCONCURRENT  VARCHAR(1),
  REQUESTS_RECOVERY VARCHAR(1)
);

ALTER TABLE qfired_triggers
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, ENTRY_ID);


CREATE TABLE qpaused_trigger_grps (
  SCHED_NAME    VARCHAR(120) NOT NULL,
  TRIGGER_GROUP VARCHAR(80)  NOT NULL
);

ALTER TABLE qpaused_trigger_grps
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, TRIGGER_GROUP);


CREATE TABLE qscheduler_state (
  SCHED_NAME        VARCHAR(120) NOT NULL,
  INSTANCE_NAME     VARCHAR(80)  NOT NULL,
  LAST_CHECKIN_TIME NUMERIC(13)  NOT NULL,
  CHECKIN_INTERVAL  NUMERIC(13)  NOT NULL
);

ALTER TABLE qscheduler_state
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, INSTANCE_NAME);


CREATE TABLE qlocks (
  SCHED_NAME VARCHAR(120) NOT NULL,
  LOCK_NAME  VARCHAR(40)  NOT NULL
);

ALTER TABLE qlocks
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, LOCK_NAME);


CREATE TABLE qjob_details (
  SCHED_NAME        VARCHAR(120) NOT NULL,
  JOB_NAME          VARCHAR(80)  NOT NULL,
  JOB_GROUP         VARCHAR(80)  NOT NULL,
  DESCRIPTION       VARCHAR(120),
  JOB_CLASS_NAME    VARCHAR(128) NOT NULL,
  IS_DURABLE        VARCHAR(1)   NOT NULL,
  IS_NONCONCURRENT  VARCHAR(1)   NOT NULL,
  IS_UPDATE_DATA    VARCHAR(1)   NOT NULL,
  REQUESTS_RECOVERY VARCHAR(1)   NOT NULL,
  JOB_DATA BYTE IN TABLE
);

ALTER TABLE qjob_details
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, JOB_NAME, JOB_GROUP);


CREATE TABLE qsimple_triggers (
  SCHED_NAME      VARCHAR(120) NOT NULL,
  TRIGGER_NAME    VARCHAR(80)  NOT NULL,
  TRIGGER_GROUP   VARCHAR(80)  NOT NULL,
  REPEAT_COUNT    NUMERIC(7)   NOT NULL,
  REPEAT_INTERVAL NUMERIC(12)  NOT NULL,
  TIMES_TRIGGERED NUMERIC(10)  NOT NULL
);

ALTER TABLE qsimple_triggers
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);


CREATE TABLE qsimprop_triggers
(
  SCHED_NAME    VARCHAR(120)   NOT NULL,
  TRIGGER_NAME  VARCHAR(200)   NOT NULL,
  TRIGGER_GROUP VARCHAR(200)   NOT NULL,
  STR_PROP_1    VARCHAR(512)   NULL,
  STR_PROP_2    VARCHAR(512)   NULL,
  STR_PROP_3    VARCHAR(512)   NULL,
  INT_PROP_1    NUMERIC(9)     NULL,
  INT_PROP_2    NUMERIC(9)     NULL,
  LONG_PROP_1   NUMERIC(13)    NULL,
  LONG_PROP_2   NUMERIC(13)    NULL,
  DEC_PROP_1    NUMERIC(13, 4) NULL,
  DEC_PROP_2    NUMERIC(13, 4) NULL,
  BOOL_PROP_1   VARCHAR(1)     NULL,
  BOOL_PROP_2   VARCHAR(1)     NULL,
);

ALTER TABLE qsimprop_triggers
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);


CREATE TABLE qtriggers (
  SCHED_NAME     VARCHAR(120) NOT NULL,
  TRIGGER_NAME   VARCHAR(80)  NOT NULL,
  TRIGGER_GROUP  VARCHAR(80)  NOT NULL,
  JOB_NAME       VARCHAR(80)  NOT NULL,
  JOB_GROUP      VARCHAR(80)  NOT NULL,
  DESCRIPTION    VARCHAR(120),
  NEXT_FIRE_TIME NUMERIC(13),
  PREV_FIRE_TIME NUMERIC(13),
  PRIORITY       INTEGER,
  TRIGGER_STATE  VARCHAR(16)  NOT NULL,
  TRIGGER_TYPE   VARCHAR(8)   NOT NULL,
  START_TIME     NUMERIC(13)  NOT NULL,
  END_TIME       NUMERIC(13),
  CALENDAR_NAME  VARCHAR(80),
  MISFIRE_INSTR  NUMERIC(2),
  JOB_DATA BYTE IN TABLE
);

ALTER TABLE qtriggers
  ADD CONSTRAINT PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);


ALTER TABLE qblob_triggers
  ADD CONSTRAINT FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
REFERENCES qtriggers;


ALTER TABLE qcron_triggers
  ADD CONSTRAINT FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
REFERENCES qtriggers;


ALTER TABLE qsimple_triggers
  ADD CONSTRAINT FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
REFERENCES qtriggers;

ALTER TABLE qsimprop_triggers
  ADD CONSTRAINT FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
REFERENCES qtriggers;

ALTER TABLE qtriggers
  ADD CONSTRAINT FOREIGN KEY (SCHED_NAME, JOB_NAME, JOB_GROUP)
REFERENCES qjob_details; 
