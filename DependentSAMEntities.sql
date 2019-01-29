/*Displays the dependent entities for each SAM Entity*/
WITH AllTables AS (
	SELECT DISTINCT 
		t.TableID
		,t.DatabaseNM + '.' + t.SchemaNM + '.' + t.ViewNM AS EntityNM
		,ta.TableID AS DependentTableID
		,ta.DatabaseNM + '.' + ta.SchemaNM + '.' + ta.ViewNM AS DependentEntityNM
		,ta.DatabaseNM AS DependentEntityDatabaseNM
		, sam.DestinationObjectPrefixCD
	FROM EDWAdmin.CatalystAdmin.TableBASE t
		INNER JOIN EDWAdmin.CatalystAdmin.EntityBASE ent
		ON t.DataMartID = ent.DataMartID
		INNER JOIN EDWAdmin.CatalystAdmin.BindingDependencyNewBASE bd ON ent.EntityID = bd.SourceEntityID
		INNER JOIN EDWAdmin.CatalystAdmin.BindingBASE b ON bd.BindingID = b.BindingID
		INNER JOIN EDWAdmin.CatalystAdmin.TableBASE ta ON ta.TableID = b.DestinationEntityID
		INNER JOIN EDWAdmin.CatalystAdmin.SAMBASE sam ON ta.DataMartID = sam.DataMartID
	WHERE 
		t.DatabaseNM = 'SAM'
		AND t.SchemaNM = 'Finance'
		AND t.ViewNM like '%common%'
)
SELECT DISTINCT
	--EntityNM
	--,
	AllTables.DestinationObjectPrefixCD
	,DependentEntityNM
	--,',' + ColumnNM
FROM AllTables
WHERE AllTables.DependentEntityNM NOT LIKE '%common%'
--ORDER BY 1, 2