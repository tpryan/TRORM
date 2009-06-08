<cfcomponent displayname="CFPage" hint="A cfc representation of a cfpage. ">
	<cfproperty name="name" hint="The name of the page" />
	<cfproperty name="fileLocation" hint="File path of the page" />
	<cfproperty name="extension" />
	
	
	<cffunction name="init" output="false" hint="Psuedo constructor, and all around nice function." >
		<cfargument name="name" type="string" required="yes" />
		<cfargument name="fileLocation" type="string" required="yes"  />
		
		<cfset setExtension('cfm') />
		<cfset setName(arguments.Name) />
		<cfset setFileLocation(arguments.fileLocation) />
		<cfset variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator") />
		<cfset variables.body = CreateObject("java","java.lang.StringBuilder").Init() />
		<cfset variables.bodyScript = CreateObject("java","java.lang.StringBuilder").Init() />
		
		<cfreturn This />
	</cffunction>
	
	<cffunction access="public" name="appendBody" output="FALSE" returntype="void" hint="Adds code content to the body of a custom tag.">
		<cfargument name="bodyContent" type="string" required="yes" hint="Content to append to the body of the custom tag. " />

		<cfset variables.body.append(arguments.bodyContent & variables.lineBreak)  />
	</cffunction>
	
	<cffunction access="public" name="appendBodyScript" output="FALSE" returntype="void" hint="Adds code content to the body of a custom tag in script.">
		<cfargument name="bodyContent" type="string" required="yes" hint="Content to append to the body of the custom tag. " />

		<cfset variables.bodyScript.append(arguments.bodyContent & variables.lineBreak)  />
	</cffunction>
	
	<cffunction access="public" name="getCFML" output="false" returntype="string" hint="Returns the actual cf code.">
		<cfset var i=0 />
		<cfset var results = CreateObject("java","java.lang.StringBuilder").Init() />

		<!--- Add the header to the custom tag. --->
		<cfset results.append(variables.body) />


		<cfreturn results />
	</cffunction>
	
	<cffunction name="write" output="FALSE" access="public"  returntype="string" hint="Writes the CFC to disk. " >
		<cfargument name="format" type="string" default="cfml" hint="cfml or cfscript" />
		
		<cfset conditionallyCreateDirectory(getFileLocation()) />
		
		<cfif CompareNoCase(arguments.format, "cfml") eq 0>
			<cffile action="write" file="#getFileLocation()#/#getName()#.#getExtension()#" nameconflict="overwrite" output="#Trim(getCFML())#" >
		<cfelseif CompareNoCase(arguments.format, "cfscript") eq 0>
			<cffile action="write" file="#getFileLocation()#/#getName()#.#getExtension()#" nameconflict="overwrite" output="#Trim(getCFScript())#" >
		</cfif>
		
	</cffunction>
	
	<cffunction access="public" name="conditionallyCreateDirectory" output="false" returntype="void" description="Checks to see if a directory exists if it doesn't it creates it." >
		<cfargument name="directory" type="string" required="yes" default="" hint="Driectory to create if it doesn't already exist." />

		<cfif not DirectoryExists(arguments.directory)>
			<cfdirectory directory="#arguments.directory#" action="create" />
		</cfif>

	</cffunction>
	
	
</cfcomponent>