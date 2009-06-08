<!---    cfc.cfc

CREATED				: Terrence Ryan
DESCRIPTION			: Allows you to write the representation of CFC code to an object, for writing CFC's dynamically. .
---->
<cfcomponent output="false" extends="CFPage" displayname="CFC (ColdFusion Component)" hint="A CFC representation of a generated CFC." >

	<cfproperty name="extends" />
	<cfproperty name="output" type="boolean"  default="false"/>
	<cfproperty name="persistent" type="boolean" default="false" />
	<cfproperty name="table" />
	<cfproperty name="entityname" />


	<cffunction name="init" output="false" hint="Psuedo constructor, and all around nice function." >
		
		<cfset variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator") />
		<cfset setExtension('cfc') />
		<cfset setOutput(FALSE) /> 
		
		<cfset variables.constructorArray = ArrayNew(1) />
		<cfset variables.functionArray = ArrayNew(1) />
		<cfset variables.propertyArray = ArrayNew(1) />
		
		
		<cfreturn This />
	</cffunction>


	
	<cffunction access="public" name="addproperty" output="FALSE" returntype="void" hint="Adds the code of a property to the CFC.">
		<cfargument name="property" type="property" required="no" hint="The property to add to the cfc." />
		<cfset ArrayAppend(variables.propertyArray, arguments.property) />
	</cffunction>

	<cffunction name="generateCFMLHeader" output="FALSE" access="public"  returntype="string" hint="" >
		<cfset var header = '<cfcomponent' />
		
		<cfif len(getExtends()) gt 0>
			<cfset header = ListAppend(header, 'extends="#getExtends()#"', ' ')  />
		</cfif>
		
		<cfif len(getPersistent())>
			<cfset header = ListAppend(header, 'persistent="#getPersistent()#"', ' ')  />
		</cfif>
		
		<cfif len(getTable()) gt 0>
			<cfset header = ListAppend(header, 'table="#getTable()#"', ' ')  />
		</cfif>
		
		<cfif len(getEntityName()) gt 0>
			<cfset header = ListAppend(header, 'entityName="#getEntityName()#"', ' ')  />
		</cfif>
		
		<cfif len(getOutput())>
			<cfset header = ListAppend(header, 'output="#getOutput()#"', ' ')  />
		</cfif>
		
		<cfset header = ListAppend(header, '>' & variables.lineBreak, ' ')  />
		
		<cfreturn header />
	</cffunction>
	
	<cffunction name="generateCFMLFooter" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var footer = '</cfcomponent>' & variables.lineBreak />
		<cfreturn footer />
	</cffunction>
	
	<cffunction name="generateCFMLProperties" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var props = variables.lineBreak />
		<cfloop array="#variables.propertyArray#" index="propObj">
			<cfset props = props & "	" & propObj.getCFML() & variables.lineBreak  />
		</cfloop>
		<cfreturn props />
	</cffunction>
	
	<cffunction name="generateCFMLConstructor" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var constructor = variables.lineBreak />
		<cfloop array="#variables.constructorArray#" index="constructorLine">
			<cfset constructor = constructor & "	" & constructorLine & variables.lineBreak  />
		</cfloop>
		<cfreturn constructor />
	</cffunction>
	
	<cffunction name="generateCFMLFunctions" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var body = variables.lineBreak />
		<cfloop array="#variables.functionArray#" index="funcObj">
			<cfset body = body & variables.lineBreak & funcObj.getCFML() & variables.lineBreak  />
		</cfloop>
		<cfreturn body />
	</cffunction>

	<cffunction access="public" name="getCFML" output="false" returntype="string" hint="Returns the actual cfml cfc code.">
		<cfset var results = "" />

		<!--- Add the header to the cfc feed. --->
		<cfset results = results & generateCFMLHeader() />
		<cfset results = results & generateCFMLProperties()   />
		<cfset results = results & generateCFMLConstructor() />
		<cfset results = results & generateCFMLFunctions() />
		<!--- Add the footer to the cfc feed. --->
		<cfset results = results & generateCFMLFooter() />

		<cfreturn results />
	</cffunction>
	

</cfcomponent>