<cfcomponent>

	<cffunction name="init" output="FALSE" access="public"  returntype="any" hint="Psuedo constructor that allows us to play our object games." >
		<cfargument name="datasource" type="string" required="TRUE" hint="" />
		
		<cfset variables.ds = arguments.datasource />
		
		<cfreturn This />
	</cffunction>

	<cffunction name="getTables" output="FALSE" access="public"  returntype="struct" hint="" >
	
		<cfset var tables = QueryNew('') />
		<cfdbinfo datasource="#variables.ds#" type="tables"  name="tables" />
		
		<cfquery name="tables" dbtype="query">
			SELECT 	DISTINCT * 
			FROM 	tables
			WHERE	TABLE_TYPE = 'TABLE'
		</cfquery>
		
		
		<cfset local.result.tables = tables />
		<cfreturn local.result />
	</cffunction>

	<cffunction name="getTableData" output="FALSE" access="public"  returntype="struct" hint="" >
		<cfargument name="table" type="string" required="TRUE" hint="" />	
	
		<cfset var foreignkeys = "" />
	
		<cfdbinfo datasource="#variables.ds#" type="columns" table="#arguments.table#" name="local.result.columns" />
		<cfdbinfo datasource="#variables.ds#" type="foreignkeys" table="#arguments.table#" name="foreignkeys" />
		<cfdbinfo datasource="#variables.ds#" type="index" table="#arguments.table#" name="local.result.index" />
		
		<cfquery name="local.result.foreignkeys" dbtype="query">
			SELECT DISTINCT * 
			FROM 			foreignkeys
		</cfquery>
		
		<cfreturn local.result />
	</cffunction>

</cfcomponent>