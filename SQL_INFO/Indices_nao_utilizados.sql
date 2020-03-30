SELECT
   OBJECT_SCHEMA_NAME(i.OBJECT_ID) AS SchemaName,
   OBJECT_NAME(i.OBJECT_ID) AS TableName,
   i.name AS IndexName,
   i.index_id AS IndexID,
   8 * SUM(a.used_pages) AS 'Indexsize'
FROM sys.indexes AS i
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
WHERE OBJECT_NAME(i.OBJECT_ID)='TB_OPERACAO'
AND i.index_id in (SELECT
    indexes.index_id
FROM
    sys.dm_db_index_usage_stats
    INNER JOIN sys.objects ON dm_db_index_usage_stats.OBJECT_ID = objects.OBJECT_ID
    INNER JOIN sys.indexes ON indexes.index_id = dm_db_index_usage_stats.index_id AND dm_db_index_usage_stats.OBJECT_ID = indexes.OBJECT_ID
WHERE objects.name ='TB_OPERACAO' and
    
    dm_db_index_usage_stats.user_lookups = 0
    AND
    dm_db_index_usage_stats.user_seeks = 0
    AND
    dm_db_index_usage_stats.user_scans = 0)
GROUP BY i.OBJECT_ID,i.index_id,i.name
ORDER BY 5