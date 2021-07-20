DECLARE @ms_ticks_now BIGINT

SELECT @ms_ticks_now = ms_ticks
FROM sys.dm_os_sys_info;

SELECT TOP 15 record_id
	,dateadd(ms, - 1 * (@ms_ticks_now - [timestamp]), GetDate()) AS EventTime
	,SQLProcessUtilization
	,SystemIdle
	,100 - SystemIdle - SQLProcessUtilization AS OtherProcessUtilization
FROM (
	SELECT record.value('(./Record/@id)[1]', 'int') AS record_id
		,record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS SystemIdle
		,record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization
		,TIMESTAMP
	FROM (
		SELECT TIMESTAMP
			,convert(XML, record) AS record
		FROM sys.dm_os_ring_buffers
		WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
			AND record LIKE '%<SystemHealth>%'
		) AS x
	) AS y
ORDER BY record_id DESC

select 'Sessao: '+CONVERT(VARCHAR(19),preso.session_id) +' - '+ preso.host_name +' - '+ preso.program_name +' ('+preso.login_name+' - '+ preso.status+' )' "QUEM ESTÁ PRESO",
       'Sessao: '+CONVERT(VARCHAR(19),prend.session_id) +' - '+ prend.host_name +' - '+ prend.program_name +' ('+prend.login_name+' - '+ prend.status+' )' "QUEM ESTÁ PRENDENDO",
       case when prend.is_user_process=0 then 'INTERNA' else 'USUARIO' end "TIPO DE SESSAO",
       case when prend.is_user_process=0 then '(NÃO MATAR)' else 'kill '+CONVERT(VARCHAR(19),prend.session_id) end "COMANDO PARA MATAR A SESSÃO QUE ESTÁ PRENDENDO",
       'DBCC INPUTBUFFER('+CONVERT(VARCHAR(19),prend.session_id)+')' "COMANDO QUE ESTA PRENDENDO"
from sys.dm_exec_requests req
join sys.dm_exec_sessions preso on preso.session_id=req.session_id
left join sys.dm_exec_sessions prend on prend.session_id=req.blocking_session_id
where blocking_session_id<>0
