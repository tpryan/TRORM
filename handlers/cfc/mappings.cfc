<cfcomponent>
<cfscript >
	dbfields.int="integer";
	dbfields.integer="integer";
	dbfields.smallint="short";
	dbfields.number="big_decimal";
	dbfields.number="big_decimal";

	dbfields.varchar="string";
	dbfields.varchar2="string";
	dbfields.char="character";

	dbfields.boolean="boolean";
	dbfields.yes_no="yes_no";
	dbfields.true_false="true_false";

	dbfields.date="date";
	dbfields.time="time";
	dbfields.timestamp="timestamp";
	dbfields.datetime="timestamp";

	dbfields.clob="clob";
	dbfields.blob="blob";

</cfscript>

	<cffunction name="getDataType" access="public" returntype="String">
		<cfargument name="dbtype" type="string" required="true" />

		<cftry>
			<cfreturn structFind(dbfields,dbtype) >			
		<cfcatch>
		</cfcatch>
		</cftry>
		<!--- return empty string if datatype not found --->
		<cfreturn "">

	</cffunction>

</cfcomponent>