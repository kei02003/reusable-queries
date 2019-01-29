  /*Query to capture the SQL in a binding and to see the history of SQL changes*/
       SELECT DISTINCT
              t.TableID
              ,t.DatabaseNM + '.' + t.SchemaNM + '.' + t.ViewNM AS EntityNM
              , oa.AttributeValueLongTXT
			  --, mal.UpdatedByNM
			  --, mal.ChangedDTS
			  --, mal.BeforeVAL
			  --, mal.AfterVAL
			  
       FROM EDWAdmin.CatalystAdmin.TableBASE t
              INNER JOIN EDWAdmin.CatalystAdmin.BindingBASE b ON b.DestinationEntityID = t.TableID
              INNER JOIN EDWAdmin.CatalystAdmin.ObjectAttributeBASE oa ON b.BindingID = oa.ObjectID
			  /*Commented out until we get SELECT permissions*/
			--  INNER JOIN EDWAdmin.CatalystAdmin.MetadataAuditLogBASE mal ON oa.ObjectID = mal.ObjectID
       WHERE 
              t.DatabaseNM = 'SAMReporting'
              AND t.SchemaNM = 'Diabetes'
			  AND oa.ObjectTypeCD = 'Binding'
			  AND oa.AttributeValueLongTXT IS NOT NULL 
			  /*Optional*/
			  --AND b.BindingNM LIKE ''
