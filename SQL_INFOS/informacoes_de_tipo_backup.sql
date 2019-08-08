SELECT 
   DATABASE_ID as [Id Banco],  
   NAME [Nome Banco], 
   COMPATIBILITY_LEVEL [Versao Sql], 
   RECOVERY_MODEL_DESC [Modo Backup] 
FROM SYS.DATABASES
WHERE RECOVERY_MODEL_DESC = 'FULL'
