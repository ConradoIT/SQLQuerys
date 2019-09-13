SELECT * FROM 
(
   SELECT
       T.NAME AS ENTIDADE,
       P.ROWS AS REGISTROS,
       SUM(A.TOTAL_PAGES) * 8 AS ESPACOTOTALKB,
       SUM(A.USED_PAGES) * 8 AS ESPACOUSADOKB,
       (SUM(A.TOTAL_PAGES) - SUM(A.USED_PAGES)) * 8 AS ESPACONAOUSADOKB,
   	SUM(A.TOTAL_PAGES) * 8 / 1024 AS ESPACOTOTALMB,
       SUM(A.USED_PAGES) * 8 / 1024 AS ESPACOUSADOMB,
       (SUM(A.TOTAL_PAGES) - SUM(A.USED_PAGES)) * 8 / 1024 AS ESPACONAOUSADOMB,
       SUM(A.TOTAL_PAGES) * 8 / 1024 / 1024 AS ESPACOTOTALGB,
       SUM(A.USED_PAGES) * 8 / 1024 / 1024 AS ESPACOUSADOGB,
       (SUM(A.TOTAL_PAGES) - SUM(A.USED_PAGES)) * 8 / 1024 / 1024 AS ESPACONAOUSADOGB
   FROM
       SYS.TABLES T
   INNER JOIN
       SYS.INDEXES I ON T.OBJECT_ID = I.OBJECT_ID
   INNER JOIN
       SYS.PARTITIONS P ON I.OBJECT_ID = P.OBJECT_ID AND I.INDEX_ID = P.INDEX_ID
   INNER JOIN
       SYS.ALLOCATION_UNITS A ON P.PARTITION_ID = A.CONTAINER_ID
   LEFT OUTER JOIN
       SYS.SCHEMAS S ON T.SCHEMA_ID = S.SCHEMA_ID
   WHERE
       T.NAME NOT LIKE 'DT%'
       AND T.IS_MS_SHIPPED = 0
       AND I.OBJECT_ID > 255
   GROUP BY
       T.NAME, S.NAME, P.ROWS
) AS T
ORDER BY T.ESPACOUSADOKB DESC    