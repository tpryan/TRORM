<!---    function.cfc

CREATED				: Terrence Ryan
DESCRIPTION			: Allows you to write the representation of cffunction code to an object, for writing functions dynamically. .
---->
<cfcomponent output="false" >

	<cfproperty name="name" />
	<cfproperty name="output" type="boolean"  default="false"/>
	<cfproperty name="access" />
	<cfproperty name="hint" />
	<cfproperty name="returntype" />
	<cfproperty name="ReturnResult" />

	<cffunction name="init" output="false" hint="Psuedo constructor, and all around nice function." >
		
		<cfset variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator") />
		
		<cfset variables.arguments = ArrayNew(1) />
		<cfset variables.localvariables = ArrayNew(1) />
		<cfset variables.operation = CreateObject("java","java.lang.StringBuilder").Init() />
		<cfset variables.operationScript = CreateObject("java","java.lang.StringBuilder").Init() />
		
		<cfreturn This />
	</cffunction>


	<cffunction access="public" name="addArgument" output="false" returntype="void" description="Adds argument to a function. ">
		<cfargument name="argument" type="argument" required="TRUE" hint="" />
		<cfset ArrayAppend(variables.arguments, arguments.argument) />
	</cffunction>

	<cffunction access="public" name="AddLocalVariable" output="false" returntype="void" description="Adds var scope delclaration to a function.">
		<cfargument name="LocalVariable" type="string" required="yes" />
		<cfargument name="type" type="string" required="no" default="string" />
		<cfargument name="value" type="string" required="no" default="" />
		<cfargument name="quote" type="boolean" default="TRUE" />

		<cfset ArrayAppend(variables.localVariables, Duplicate(arguments)) />

	</cffunction>

	<cffunction access="public" name="AddOperation" output="false" returntype="void" description="Adds code section to the function.">
		<cfargument name="Operation" type="string" required="yes" />

		<cfset variables.operation = variables.operation.append(arguments.operation & lineBreak) />

	</cffunction>

	<cffunction access="public" name="AddOperationScript" output="false" returntype="void" description="Adds code section to the function.">
		<cfargument name="Operation" type="string" required="yes" />

		<cfset variables.operationScript = variables.operationScript.append(arguments.operation & lineBreak) />

	</cffunction>
	
	
	<cffunction name="generateCFMLHeader" output="FALSE" access="public"  returntype="string" hint="" >
		<cfset var header = '	<cffunction' />
		
		<cfif len(getName()) gt 0>
			<cfset header = ListAppend(header, 'name="#getName()#"', ' ')  />
		</cfif>
		
		<cfif len(getAccess()) gt 0>
			<cfset header = ListAppend(header, 'access="#getAccess()#"', ' ')  />
		</cfif>
		
		<cfif len(getOutput())>
			<cfset header = ListAppend(header, 'output="#getOutput()#"', ' ')  />
		</cfif>
		
		<cfif len(getReturntype()) gt 0>
			<cfset header = ListAppend(header, 'returnType="#getReturntype()#"', ' ')  />
		</cfif>
		
		<cfset header = ListAppend(header, '>' & variables.lineBreak, ' ')  />
		
		<cfreturn header />
	</cffunction>
	
	<cffunction name="generateCFScriptHeader" output="FALSE" access="public"  returntype="string" hint="" >
		<cfset var header = '' />
		<cfset var IsPreFunction = false />
		
		<cfif len(getAccess()) gt 0>
			<cfset var IsPreFunction = true />
			<cfset header = '	#getAccess()#'  />
		</cfif>
		
		<cfif len(getReturntype()) gt 0>
			<cfset var IsPreFunction = true />
			<cfif IsPreFunction>
				<cfset header = ListAppend(header, '#getReturntype()#', ' ')  />
			<cfelse>
				<cfset header = '	#getReturntype()#'  />
			</cfif>
			
			
		</cfif>
		
		<cfif IsPreFunction>
			<cfset header = ListAppend(header, 'function', ' ')  />
		<cfelse>
			<cfset header =	'	function' />
		</cfif>
		
		
		
		<cfset header = ListAppend(header, '#getName()#(' & generateCfscriptArguments()  & ')', ' ')  />
		
		
		<cfif len(getOutput())>
			<cfset header = ListAppend(header, 'output="#getOutput()#"', ' ')  />
		</cfif>
		
		
		
		<cfset header = ListAppend(header, '{' & variables.lineBreak, ' ')  />
		
		<cfreturn header />
	</cffunction>
	
	<cffunction name="generateCFMLFooter" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var footer = '	</cffunction>' & variables.lineBreak />
		<cfreturn footer />
	</cffunction>
	
	<cffunction name="generateCFScriptFooter" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var footer = '	}' & variables.lineBreak />
		<cfreturn footer />
	</cffunction>
	
	<cffunction name="generateCFMLArguments" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var results =""  />
		
		<cfloop array="#variables.arguments#" index="argObj">
			<cfset results = results & "		" & argObj.getCFML() />
		</cfloop>
		
		<cfreturn results />	
	</cffunction>
	
	<cffunction name="generateCFScriptArguments" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var results =""  />
		
		<cfloop array="#variables.arguments#" index="argObj">
			<cfset results = ListAppend(results,argObj.getCFScript()) />
		</cfloop>
		
		<cfset results = Replace(results, ",", ", ","ALL") />
		
		<cfreturn results />	
	</cffunction>
	
	<cffunction name="generateCFMLLocalVariables" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var results =""  />
		<cfset var temp="" />
		
		<cfif ArrayLen(variables.localVariables) gt 0>
			<cfset results = variables.linebreak  />
		</cfif>
		
		<cfloop array="#variables.localVariables#" index="localVar">
			
			
			<cfif len(localVar.value) gt 0>
				<cfif localVar.quote>
					<cfset temp = '		<cfset var #localVar.localvariable# = "#localVar.value#" />' & variables.lineBreak />
				<cfelse>
					<cfset temp = '		<cfset var #localVar.localvariable# = #localVar.value# />' & variables.lineBreak />
				</cfif>
				
			<cfelseif CompareNoCase(localVar.type, "struct") eq 0>
				<cfset temp = "		<cfset var #localVar.localvariable# = StructNew() />" & variables.lineBreak />
			<cfelse>	
				<cfset temp = "		<cfset var #localVar.localvariable# = """" />" & variables.lineBreak />
			</cfif>
			
			<cfset results = results & temp />
		</cfloop>
		
		<cfset results = results & variables.linebreak  />
		
		<cfreturn results />
	</cffunction>
	
	
	<cffunction name="generateCFScriptLocalVariables" output="FALSE" access="private"  returntype="string" hint="" >
		<cfset var results =""  />
		<cfset var temp="" />
		
		<cfif ArrayLen(variables.localVariables) gt 0>
			<cfset results = variables.linebreak  />
		</cfif>
		
		<cfloop array="#variables.localVariables#" index="localVar">
			
			
			<cfif len(localVar.value) gt 0>
				<cfif localVar.quote>
					<cfset temp = '		var #localVar.localvariable# = "#localVar.value#" ;' & variables.lineBreak />
				<cfelse>
					<cfset temp = '		var #localVar.localvariable# = #localVar.value# ;' & variables.lineBreak />
				</cfif>
				
			<cfelseif CompareNoCase(localVar.type, "struct") eq 0>
				<cfset temp = "		var #localVar.localvariable# = StructNew() ;" & variables.lineBreak />
			<cfelse>	
				<cfset temp = "		var #localVar.localvariable# = """" ;" & variables.lineBreak />
			</cfif>
			
			<cfset results = results & temp />
		</cfloop>
		
		<cfset results = results & variables.linebreak  />
		
		<cfreturn results />
	</cffunction>
	

	<cffunction access="public" name="getCFML" output="false" returntype="string" description="Returns the actual cf function code.">
		<cfset var i=0 />
		<cfset var results="" />


		<cfset results = results & generateCFMLHeader() />
		<cfset results = results & generateCFMLArguments() />
		<cfset results = results & generateCFMLLocalVariables() />
		<cfset results = results & operation />
		<cfif compareNoCase(getReturnType(), "void") neq 0>
			<cfset results = results.concat('		<cfreturn #getReturnResult()# />' & variables.lineBreak) />
		</cfif>
		<cfset results = results.concat(generateCFMLFooter()) />

		<cfreturn results />
	</cffunction>
	
	
	<cffunction access="public" name="getCFScript" output="false" returntype="string" description="Returns the actual cf function code.">
		<cfset var i=0 />
		<cfset var results="" />


		<cfset results = results & generateCFScriptHeader() />
		<cfset results = results & generateCFScriptLocalVariables() />
		<cfset results = results & operationScript />
		<cfif compareNoCase(getReturnType(), "void") neq 0>
			<cfset results = results.concat('		return #getReturnResult()#;' & variables.lineBreak) />
		</cfif>
		<cfset results = results.concat(generateCFScriptFooter()) />

		<cfreturn results />
	</cffunction>
</cfcomponent>