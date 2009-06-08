<cfcomponent extends="cfc">
	
	
	<cffunction name="init" output="false" hint="Psuedo constructor, and all around nice function." >
		
		<cfset variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator") />
		
		<cfset setOutput(FALSE) /> 
		<cfset setExtension('cfc') />
		<cfset variables.constructorArray = ArrayNew(1) />
		<cfset variables.functionArray = ArrayNew(1) />
		<cfset variables.propertyArray = ArrayNew(1) />
		<cfset variables.appPropertyArray = ArrayNew(1) />
		
		
		<cfreturn This />
	</cffunction>
	
	<cffunction access="public" name="addApplicationProperty" output="FALSE" returntype="void" hint="Adds the code of a property to the CFC.">
		<cfargument name="name" type="string" required="no" hint="The name of the app property to add to the cfc." />
		<cfargument name="value" type="string" required="no" hint="The value of the app property to add to the cfc." />
		<cfargument name="surroundwithQuotes" type="boolean" required="no" hint="Whether or not to surround the value with quotes." />
		
		<cfset var appProp = structNew() />
		<cfset appProp.name = arguments.name />
		<cfset appProp.value = arguments.value />
		
		<cfif structKeyExists(arguments, "surroundwithQuotes")>
			<cfset appProp.quote = arguments.surroundwithQuotes />
		<cfelse>
			<cfset appProp.quote = "" />
		</cfif>
		
		
		<cfset ArrayAppend(variables.appPropertyArray, appProp) />
	</cffunction>
	
	<cffunction name="generateCFMLApplicationProperties" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var props = variables.lineBreak />
		<cfloop array="#variables.appPropertyArray#" index="propStruct">
			<cfif (isNumeric(propStruct.value) or isBoolean(propStruct.value)) OR (ISBoolean(propStruct.quote) and not propStruct.quote) >
				<cfset props = props & '	<cfset This.' & propStruct.name & ' = ' & propStruct.value & ' />' & variables.lineBreak  />
			<cfelse>
				<cfset props = props & '	<cfset This.' & propStruct.name & ' = "' & propStruct.value & '" />' & variables.lineBreak  />
			</cfif>
			
			
		</cfloop>
		
		<cfreturn props />
	</cffunction>
	
	<cffunction name="generateCFScriptApplicationProperties" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var props = variables.lineBreak />
		
		<cfloop array="#variables.appPropertyArray#" index="propStruct">
			<cfif (isNumeric(propStruct.value) or isBoolean(propStruct.value)) OR (ISBoolean(propStruct.quote) and not propStruct.quote) >
				<cfset props = props & '	This.' & propStruct.name & ' = ' & propStruct.value & ';' & variables.lineBreak  />
			<cfelse>
				<cfset props = props & '	This.' & propStruct.name & ' = "' & propStruct.value & '";' & variables.lineBreak  />
			</cfif>
			
			
		</cfloop>
		<cfreturn props />
	</cffunction>
	
	<cffunction access="public" name="getCFML" output="false" returntype="string" hint="Returns the actual cfml cfc code.">
		<cfset var results = "" />

		<!--- Add the header to the cfc feed. --->
		<cfset results = results & generateCFMLHeader() />
		<cfset results = results & generateCFMLProperties()   />
		<cfset results = results & generateCFMLApplicationProperties()   />
		<cfset results = results & generateCFMLConstructor() />
		<cfset results = results & generateCFMLFunctions() />
		<!--- Add the footer to the cfc feed. --->
		<cfset results = results & generateCFMLFooter() />

		<cfreturn results />
	</cffunction>
	
	<cffunction access="public" name="getCFScript" output="false" returntype="string" hint="Returns the actual CFScript cfc code.">
		<cfset var results = "" />

		<!--- Add the header to the cfc feed. --->
		<cfset results = results & generateCFScriptHeader() />
		<cfset results = results & generateCFScriptProperties()   />
		<cfset results = results & generateCFScriptApplicationProperties()   />
		<cfset results = results & generateCFScriptConstructor() />
		<cfset results = results & generateCFScriptFunctions() />
		<!--- Add the footer to the cfc feed. --->
		<cfset results = results & generateCFScriptFooter() />

		<cfreturn results />
	</cffunction>
	
</cfcomponent>