
-- simple insertions.

INSERT INTO pdm.replicationlog(
	cchistoryid, createtime, applytime, applyduration, command)
	VALUES (1, current_timestamp, NULL, NULL, '{}'::jsonb);

INSERT INTO pdm.replicationlog(
	cchistoryid, createtime, applytime, applyduration, command)
	VALUES (2, current_timestamp, NULL, NULL, '{}'::jsonb);

INSERT INTO pdm.replicationlog(
	cchistoryid, createtime, applytime, applyduration, command)
	VALUES (3, current_timestamp, NULL, NULL, '{}'::jsonb);

INSERT INTO pdm.replicationlog(
	cchistoryid, createtime, applytime, applyduration, command)
	VALUES (6, current_timestamp, NULL, NULL, '{}'::jsonb);

delete from pdm.replicationlog;

select * from pdm.replicationlog;
