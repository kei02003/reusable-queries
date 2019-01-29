/*Displays the source entities for each SAM Entity*/
WITH AllTables AS (
	SELECT DISTINCT
		t.TableID
		,sam.DestinationObjectPrefixCD
		, t.DataMartID
		,t.DatabaseNM + '.' + t.SchemaNM + '.' + t.ViewNM AS EntityNM
		,ta.TableID AS SourceTableID
		,ta.DatabaseNM + '.' + ta.SchemaNM + '.' + ta.ViewNM AS SourceEntityNM
		,ta.DatabaseNM AS SourceEntityDatabaseNM
		, ta.SchemaNM AS SourceEntitySchemaNM
	FROM EDWAdmin.CatalystAdmin.TableBASE t
		INNER JOIN EDWAdmin.CatalystAdmin.BindingBASE b ON b.DestinationEntityID = t.TableID
		INNER JOIN EDWAdmin.CatalystAdmin.BindingDependencyBASE bd ON bd.BindingID = b.BindingID
		INNER JOIN EDWAdmin.CatalystAdmin.TableBASE ta ON ta.TableID = bd.SourceEntityID
		INNER JOIN EDWAdmin.CatalystAdmin.SAMBASE sam ON t.DataMartID = sam.DataMartID
	WHERE 
		t.DatabaseNM = 'SAM'
		AND t.SchemaNM = 'Finance'
		AND t.ViewNM like '%common%'
		--AND sam.DestinationObjectPrefixCD = 'ReadmissionExplorer'
)
SELECT DISTINCT
	--EntityNM
	--,
	SourceEntityNM
	--,',' + ColumnNM
FROM AllTables
WHERE
1= 1 
--AND	SourceEntityDatabaseNM != 'SAM'
--AND AllTables.SourceEntitySchemaNM != 'Readmissions'
	
--ORDER BY 1, 2