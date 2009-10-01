<cfcomponent extends="component" accessors="true" >
	
	
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
		
		<cfset var appProp = structNew() />
		<cfset appProp.name = arguments.name />
		<cfset appProp.value = arguments.value />
		<cfset ArrayAppend(variables.appPropertyArray, appProp) />
	</cffunction>
	
	<cffunction name="generateCFMLApplicationProperties" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var props = variables.lineBreak />
		
		<cfloop array="#variables.appPropertyArray#" index="propStruct">
			<cfif isNumeric(propStruct.value) or isBoolean(propStruct.value)>
				<cfset props = props & '	<cfset This.' & propStruct.name & ' = ' & propStruct.value & ' />' & variables.lineBreak  />
			<cfelse>
				<cfset props = props & '	<cfset This.' & propStruct.name & ' = "' & propStruct.value & '" />' & variables.lineBreak  />
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
	
</cfcomponent>