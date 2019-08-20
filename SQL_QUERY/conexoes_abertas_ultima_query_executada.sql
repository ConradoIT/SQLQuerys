SELECT   
    c.session_id as Id_Sessao, 
	c.net_transport as Protocolo,
    s.open_transaction_count as TransacoesAbertas, 
	s.status as StatusConexao, 
	s.host_name as NomeHost, 
	s.program_name as NomePrograma,   
    s.login_name as NomeUsuario, 
	s.nt_domain as Dominio,   
    s.nt_user_name as NomeUsuarioRede, 
	c.connect_time as TempoDeConexao,   
    s.login_time as TempodeLogin,
	Query.text   
FROM sys.dm_exec_connections AS c  
JOIN sys.dm_exec_sessions AS s ON c.session_id = s.session_id  
CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) as Query
