-- This is a Hive program. Hive is an SQL-like language that compiles
-- into Hadoop Map/Reduce jobs. It's very popular among analysts at
-- Facebook, because it allows them to query enormous Hadoop data
-- stores using a language much like SQL.
 
-- Our logs are stored on the Hadoop Distributed File System, in the
-- directory /logs/randomhacks.net/access.  They're ordinary Apache
-- logs in *.gz format.
--
-- We want to pretend that these gzipped log files are a database table,
-- and use a regular expression to split lines into database columns.
CREATE EXTERNAL TABLE access_log(
  host STRING,
  identity STRING,
  user STRING,
  time STRING,
  request STRING,
  status STRING,
  size STRING,
  referer STRING,
  agent STRING)
PARTITIONED BY( logType STRING, year INT, month INT, day INT, hour INT ) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
  "input.regex" = "([^ ]*) ([^ ]*) ([^ ]*) (-|\\[[^\\]]*\\]) ([^ \"]*|\"[^\"]*\") (-|[0-9]*) (-|[0-9]*)(?: ([^ \"]*|\"[^\"]*\") ([^ \"]*|\"[^\"]*\"))?",
  "output.format.string" = "%1$s %2$s %3$s %4$s %5$s %6$s %7$s %8$s %9$s"
)
STORED AS TEXTFILE 
LOCATION '/logs/apache/';

alter table access_log add partition (logType='access', year=2013, month=09, day=07, hour=19) location '/logs/apache/access/2013/09/07/19';

([^ ]*) ([^ ]*) ([^ ]*) (-|\\[[^\\]]*\\]) ([^ \"]*|\"[^\"]*\") (-|[0-9]*) (-|[0-9]*)(?: ([^ \"]*|\"[^\"]*\") ([^ \"]*|\"[^\"]*\"))?
([^ ]*) ([^ ]*) ([^ ]*) (?:-|\[([^\]]*)\]) ([^ \"]*|\"[^\"]*\") (-|[0-9]*) (-|[0-9]*) (\"-|.*\")? (.*)?



([^ ]*) ([^ ]*) ([^ ]*) (?:-|\[([^\]]*)\]) ([^ \"]*|\"[^\"]*\") (-|[0-9]*) (-|[0-9]*)(?: ([^ \"]*|\"[^\"]*\") ([^ \"]*|\"[^\"]*\"))?
([^ ]*) ([^ ]*) ([^ ]*) (?:-|\[([^\]]*)\]) ([^ \"]*|\"[^\"]*\") (-|[0-9]*) (.*)?
