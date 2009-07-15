<!---<cffile action="write" file="/Users/terry/Sites/centaur.dev/TerryRyansORMCodeJumpstart/sample.xml" output="#ideeventInfo#" />
--->
<!---<cffile action="read" file="/Users/terryr/Sites/centaur.dev/TerryRyansORMCodeJumpstart/sample.xml" variable="ideeventInfo" />
--->
<cfset generator = CreateObject('component', 'cfc.generator').init() />
<cfset boltInfo = parseBoltInput(ideeventinfo) />

<cfif boltInfo.view>
	<cfset conditionallyCreateDirectory("#boltInfo.location#/customTags/")/>
	<cffile action="copy" source="#ExpandPath('./storage/pageWrapper.cfm')#" destination="#boltInfo.location#/customTags/pageWrapper.cfm" />

</cfif>


<cfif boltInfo.appCFC>
	<cfset appCFC=generator.createAppCFC(ideeventinfo) >
	<cfset index=generator.createIndex(ideeventinfo) >
	
	<cfif boltInfo.ORMAsCFscript>
		<cfset appCFC.write('cfscript') >
	<cfelse>	
		<cfset appCFC.write() >
	</cfif>
	
	<cfset index.write() >
	
</cfif> 

<cfif boltInfo.DoAll>
	<cfdbinfo datasource="#boltInfo.dbname#" name="tables" type="tables"/>
	
	<cfquery name="tables" dbtype="query">
		SELECT *
		from tables
		WHERE table_type != 'SYSTEM TABLE'
	</cfquery>

	<cfloop query="tables">
		<cfset tempInfo = XMLParse(ideeventinfo) />
		<cfset tempInfo.event.IDE.rdsview.database.table.XMLAttributes['name'] = table_name />
		<cfset StructDelete(tempInfo.event.IDE.rdsview.database.table, "fields") />
	
		<cfset ormCFC=generator.createORMCFC(tempInfo) >

		<cfif boltInfo.ORMAsCFscript>
			<cfset ormCFC.write('cfscript') >
		<cfelse>	
			<cfset ormCFC.write() >
		</cfif>
		
		
		<cfif boltInfo.generateRemoteServices>
			<cfset ormServiceCFC=generator.createORMServiceCFC(tempInfo) >	
		
			<cfif boltInfo.ORMAsCFscript>
				<cfset ormServiceCFC.write('cfscript') >
			<cfelse>	
				<cfset ormServiceCFC.write() >
			</cfif>
		</cfif>
		
		
		<cfif boltInfo.view>
			<cfset view=generator.createView(tempInfo) >
			<cfset view.write() >
			
			<cfset customTag=generator.createViewListCustomTag(tempInfo) >
			<cfset customTag.write() >
			
			<cfset customTag=generator.createViewReadCustomTag(tempInfo) >
			<cfset customTag.write() >
			
			<cfset customTag=generator.createViewEditCustomTag(tempInfo) >
			<cfset customTag.write() >
			
			
		</cfif> 
	
	
	
	</cfloop>	


<cfelse>

	<!--- call function to generate ORM CFC --->
	<cfset ormCFC=generator.createORMCFC(ideeventinfo) >

	<cfif boltInfo.ORMAsCFscript>
		<cfset ormCFC.write('cfscript') >
	<cfelse>	
		<cfset ormCFC.write() >
	</cfif>
	
	<cfif boltInfo.generateRemoteServices>
		<cfset ormServiceCFC=generator.createORMServiceCFC(ideeventinfo) >	
	
		<cfif boltInfo.ORMAsCFscript>
			<cfset ormServiceCFC.write('cfscript') >
		<cfelse>	
			<cfset ormServiceCFC.write() >
		</cfif>
	</cfif>
	
	<cfif boltInfo.view>
		<cfset view=generator.createView(ideeventinfo) >
		<cfset view.write() >
		
		<cfset customTag=generator.createViewListCustomTag(ideeventinfo) >
		<cfset customTag.write() >
		
		<cfset customTag=generator.createViewReadCustomTag(ideeventinfo) >
		<cfset customTag.write() >
		
		
	</cfif> 
</cfif>		
	
<cffunction name="parseBoltInput" output="FALSE" access="public"  returntype="struct" hint="" >
	<cfargument name="inputXML" required="yes" >
	
	<cfset var result = structNew() />
	<cfset var xmldoc = XMLParse(inputXML) >        
    
    <cfset var genAppCFC = XMLSearch(xmldoc, "/event/user/input[@name='generateAppCFC']")[1].XMLAttributes.value> 
   	<cfset var genView = XMLSearch(xmldoc, "/event/user/input[@name='generateView']")[1].XMLAttributes.value> 
	<cfset var ORMAsCFscript = XMLSearch(xmldoc, "/event/user/input[@name='ORMAsCFscript']")[1].XMLAttributes.value> 
	<cfset var DoAll = XMLSearch(xmldoc, "/event/user/input[@name='DoAll']")[1].XMLAttributes.value> 
	<cfset var dbname=XMLDoc.event.ide.rdsview.database[1].XMLAttributes.name />
	<cfset var generateRemoteServices = XMLSearch(xmldoc, "/event/user/input[@name='generateRemoteServices']")[1].XMLAttributes.value> 
	<cfset var location = XMLSearch(xmldoc, "/event/user/input[@name='Location']")[1].XMLAttributes.value />
	
	<cfset result.appCFC = genAppCFC />
	<cfset result.view = genView />
	<cfset result.ORMAsCFscript = ORMAsCFscript />
	<cfset result.DoAll = DoAll />
	<cfset result.dbname = dbname />
	<cfset result.location = location />
	<cfset result.generateRemoteServices = generateRemoteServices />
	<cfreturn result />
</cffunction>		

<cffunction access="public" name="conditionallyCreateDirectory" output="false" returntype="void" description="Checks to see if a directory exists if it doesn't it creates it." >
		<cfargument name="directory" type="string" required="yes" default="" hint="Driectory to create if it doesn't already exist." />

		<cfif not DirectoryExists(arguments.directory)>
			<cfdirectory directory="#arguments.directory#" action="create" />
		</cfif>

	</cffunction>
			
