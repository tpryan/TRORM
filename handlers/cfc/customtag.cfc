<!---    customTag.cfc

CREATED				: Terrence Ryan
DESCRIPTION			: Allows you to write the representation of customtag code to an object, for writing customtags's dynamically. .
---->
<cfcomponent output="false" extends="CFPage" >


	<cffunction name="init" output="false" hint="Psuedo constructor, and all around nice function." >
		<cfargument name="name" type="string" required="yes" />
		<cfargument name="fileLocation" type="string" required="yes"  />
		
		<cfset setExtension('cfm') />
		<cfset setName(arguments.Name) />
		<cfset setFileLocation(arguments.fileLocation) />
		
		<cfset variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator") />

		<cfset variables.header = "<!--- #getName()#.cfm --->" & variables.lineBreak & '<cfprocessingdirective suppresswhitespace="yes">' & variables.lineBreak />
		<cfset variables.attributes = "" />
		<cfset variables.body = CreateObject("java","java.lang.StringBuilder").Init() />
		<cfset variables.footer = "</cfprocessingdirective>" & variables.lineBreak & '<cfexit method="exitTag" />' & variables.lineBreak  />
		
		<cfreturn This />
	</cffunction>


	<cffunction access="public" name="addAttribute" output="false" returntype="void" hint="Adds a cfparam'ed attribute to the custom tag. ">
		<cfargument name="name" type="string" required="yes" hint="A name for the attribute." />
		<cfargument name="type" type="string" required="no" default="" hint="The type of variable it is" />
		<cfargument name="required" type="boolean" required="no" default="FALSE" hint="Whether or not the variable is required." />
		<cfargument name="defaultvalue" type="string" required="no" default="" hint="What to default the variable to. " />
		

		<cfset var attributeString = '<cfparam name="attributes.' & arguments.name & '"' />

		<cfif len(arguments.type gt 1)>
			<cfset attributeString = attributeString & ' type="' & arguments.type & '"' />
		</cfif>

		<cfif not arguments.required AND len(arguments.defaultvalue gt 1)>
			<cfset attributeString = attributeString & ' default="' & arguments.defaultvalue & '"' />
		</cfif>

		<cfset attributeString = attributeString & " />" & variables.lineBreak />


		<cfset variables.attributes = variables.attributes & attributeString />
	</cffunction>


	<cffunction access="public" name="getCFML" output="false" returntype="string" hint="Returns the actual cf code.">
		<cfset var i=0 />
		<cfset var results = CreateObject("java","java.lang.StringBuilder").Init() />

		<!--- Add the header to the custom tag. --->
		<cfset results.append(variables.header) />
		<cfset results.append(variables.attributes) />
		<cfset results.append(variables.body) />

		<!--- Add the footer to the custom tag. --->
		<cfset results.append(variables.footer) />

		<cfreturn results />
	</cffunction>
	

</cfcomponent>