<cfcomponent output="false">

	<!---*****************************************************--->
	<!---init--->
	<!---This is the pseudo constructor that allows us to play little object games.--->
	<!---*****************************************************--->
	<cffunction access="public" name="init" output="FALSE" returntype="any" hint="This is the pseudo constructor that allows us to play little object games." >
		<cfreturn This />
	</cffunction>

	<!--- TODO: Go back and do this the right way. --->
	<cffunction access="public" name="getUIType" output="false" returntype="string" description="Retrieves information for handling different datatypes." >
		<cfargument name="datatype" type="string" required="yes" hint="A sql datatype to analyze." />

		<cfset var result = structNew() />

		<cfset result.cfsqltype = "" />
		<cfset result.argumenttype = "" />
		<cfset result.defaultvalue = "" />

		<cfswitch expression="#arguments.datatype#">
			<cfcase value="text,ntext">
				<cfset result.argumenttype = "string" />
			</cfcase>
			<cfcase value="clob,nclob">
				<cfset result.argumenttype = "string" />
			</cfcase>
			<cfcase value="int,smallint">
				<cfset result.argumenttype = "numeric" />
			</cfcase>
			<cfcase value="numeric">
				<cfset result.argumenttype = "numeric" />
			</cfcase>
			<cfcase value="tinyint">
				<cfset result.argumenttype = "numeric" />
			</cfcase>
			<cfcase value="float,number">
				<cfset result.argumenttype = "numeric" />
			</cfcase>
			<cfcase value="money,decimal,smallmoney">
				<cfset result.argumenttype = "numeric" />
			</cfcase>
			<cfcase value="datetime,smalldatetime,timestamp">
				<cfset result.argumenttype = "date" />
			</cfcase>
			<cfcase value="binary,varbinary">
				<cfset result.argumenttype = "any" />
			</cfcase>
			<cfcase value="image">
				<cfset result.argumenttype = "any" />
			</cfcase>
			<cfcase value="blob">
				<cfset result.argumenttype = "any" />
			</cfcase>
			<cfcase value="char,nchar">
				<cfset result.argumenttype = "string" />
			</cfcase>
			<cfcase value="bit">
				<cfset result.argumenttype = "any" />
			</cfcase>
			<cfcase value="bigint">
				<cfset result.argumenttype = "numeric" />
			</cfcase>
			<cfcase value="real">
				<cfset result.argumenttype = "numeric" />
			</cfcase>
			<cfcase value="sql_variant">
				<cfset result.argumenttype = "string" />
			</cfcase>
			<cfcase value="uniqueidentifier">
				<cfset result.argumenttype = "string" />
			</cfcase>
			<cfdefaultcase>
				<cfif findNoCase("varchar", arguments.datatype)>
					<cfset result.argumenttype = "string" />
				</cfif>
			</cfdefaultcase>
		</cfswitch>


		<cfreturn result.argumenttype />
	</cffunction>




</cfcomponent>