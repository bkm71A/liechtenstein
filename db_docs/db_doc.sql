.LOGON testdbc/CLMS_SIURIP_DA_EX,teradata;
.SET WIDTH 2048
.EXPORT REPORT FILE = test_tables.txt

SELECT  '<tr><td width=22%>&nbsp;<a href=Nationwide_tables/' 
  || TRIM(t1.DatabaseName) || '_' || TRIM(t1.TableName) || '.html>'
  || TRIM(COALESCE(t1.DatabaseName,'---')) || '</a></td><td width=60%>'
  || TRIM(COALESCE(t1.TableName,'---'))
  || '</td><td>' || TRIM(COALESCE(t1.Version,'---'))
  || '</td><td>' || TRIM(COALESCE( CASE t1.TableKind
                                    WHEN 'V' THEN 'View'
                                    WHEN 'T' THEN 'Table'
                                    ELSE 'Not view or table'
                                   END,'---'))
  || '</td><td>' || TRIM(COALESCE(t1.CreatorName,'---'))
  || '</td><td>' || TRIM(COALESCE(t1.RequestText,'---'))
  || '</td><td>' || TRIM(COALESCE(CAST(t1.CreateTimeStamp AS VARCHAR(50)),'---'))
  || '</td></tr>' as tbl_row
FROM DBC.TABLES t1
WHERE UPPER(t1.DatabaseName) LIKE '%MAGNIFY%'
AND t1.TableKind IN ('V','T')
ORDER BY t1.DatabaseName,t1.TableName

.SET WIDTH 2048
.EXPORT REPORT FILE = test_columns.txt

SELECT TRIM(t1.DatabaseName) || '_' || TRIM(t1.TableName),
  '<tr><td>' || TRIM(COALESCE(t2.ColumnName,'---')) 
  || '</td><td>' || TRIM(COALESCE(t2.ColumnFormat,'---')) 
  || '</td><td>' || TRIM(COALESCE(t2.ColumnType,'---'))
  || '</td><td>' || TRIM(COALESCE(CAST(t2.ColumnLength AS VARCHAR(50)),'---'))
  || '</td><td>' || TRIM(COALESCE(t2.DefaultValue,'---'))
  || '</td><td>' || TRIM(COALESCE(t2.Nullable,'---'))
  || '</td><td>' || TRIM(COALESCE(CAST(t2.DecimalTotalDigits AS VARCHAR(50)),'---'))
  || '</td><td>' || TRIM(COALESCE(CAST(t2.DecimalFractionalDigits AS VARCHAR(50)),'---'))
  || '</td><td>' || TRIM(COALESCE(t2.CreatorName,'---'))
  || '</td><td>' || TRIM(COALESCE(CAST(t2.CreateTimeStamp AS VARCHAR(50)),'---'))
  || '</td><td>' || TRIM(COALESCE(t2.CharType,'---'))  
  || '</td></tr>' as tbl_row
FROM DBC.TABLES t1 INNER JOIN DBC.Columns t2
ON t1.DatabaseName = t2.DatabaseName
AND t1.TableName = t2.TableName
WHERE UPPER(t1.DatabaseName) LIKE '%MAGNIFY%'
AND t1.TableKind IN ('V','T')
ORDER BY t1.DatabaseName,t1.TableName,t2.ColumnName
