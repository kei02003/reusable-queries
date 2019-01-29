;WITH junk
     AS (SELECT Table_Name
                ,Field_Name
                ,Topic_Order
                ,Topic + Char(10) + Char(13) + CASE WHEN Topic LIKE 'ACC ICD%' AND Cast(Topic_text AS VARCHAR(max)) LIKE '[0-9]%' THEN 'ICD_' ELSE '' END
                 + Cast(Topic_Text AS VARCHAR(max))AS DescriptionTXT
         FROM   SS_Field_Info y)


SELECT DISTINCT fi.Table_Name
                ,fi.Field_Name
                ,UpdateTXT = 'UPDATE EDWAdmin.CatalystAdmin.ColumnBASE set DescriptionTXT = '''
                             + Replace( Replace( Stuff ( (SELECT ' '+DescriptionTXT FROM junk y WHERE y.Table_Name = fi.Table_Name AND y.Field_name = fi.Field_Name ORDER BY Topic_Order FOR XML path ('')), 1, 1, ''), '&#x0D;', ''), '''', '''''')
                             + ''' WHERE SourceTableNM = '''
                             + fi.Table_name
                             + ''' and SourceColumnNM = '''
                             + fi.Field_Name + ''''
FROM   SS_Field_Info fi
       JOIN SS_MasterTables mt
         ON fi.Table_Name = mt.Master_Table
WHERE  mt.Module = 'Event_EP' 
