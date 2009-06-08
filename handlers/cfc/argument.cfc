<cfcomponent>
	
	<cfproperty name="name" />
	<cfproperty name="type" />
	<cfproperty name="required" />
	<cfproperty name="defaultvalue" />
	<cfproperty name="hint" />
	
	<cffunction name="init" output="FALSE" access="public"  returntype="any" hint="Psuedo constructor that allows us to play our object games." >
		<cfset variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator") />
		<cfreturn This />
	</cffunction>

	<cffunction name="getCFML" output="FALSE" access="public"  returntype="string" hint="Gets the argument as cfml. " >
		<cfset var argCFML = '<cfargument' />
		
		<cfset argCFML = ListAppend(argCFML, 'name="#getName()#"', ' ')  />
		
		<cfif len(getType())>
			<cfset argCFML = ListAppend(argCFML, 'type="#getType()#"', ' ')  />
		</cfif>
		
		<cfif len(getRequired()) gt 0 and IsBoolean(GetRequired()) and getRequired()>
			<cfset argCFML = ListAppend(argCFML, 'required="#getRequired()#"', ' ')  />
		</cfif>
		
		<cfif len(getDefaultvalue()) gt 0 and IsBoolean(GetRequired()) and not getRequired()>
			<cfset argCFML = ListAppend(argCFML, 'default="#getDefaultvalue()#"', ' ')  />
		</cfif>
		
		<cfif len(getHint())>
			<cfset argCFML = ListAppend(argCFML, 'hint="#getHint()#"', ' ')  />
		</cfif>
		
		<cfset argCFML = ListAppend(argCFML, ' />' & variables.lineBreak, ' ')  />
		
		<cfreturn argCFML />
	</cffunction>
	
	<cffunction name="getCFScript" output="FALSE" access="public"  returntype="string" hint="Gets the argument as cfml. " >
		<cfset var argCFML = '' />
		
		<cfset argCFML = ListAppend(argCFML, '#getName()#', ' ')  />
		
		<cfif len(getType())>
			<cfset argCFML = ListPrepend(argCFML, '#getType()#', ' ')  />
		</cfif>
		
		<cfif len(getRequired()) gt 0 and IsBoolean(GetRequired()) and getRequired()>
			<cfset argCFML = ListPrepend(argCFML, 'required', ' ')  />
		</cfif>
		
		<cfif len(getDefaultvalue()) gt 0>
			<cfset argCFML = ListAppend(argCFML, '="#getDefaultvalue()#"', ' ')  />
		</cfif>
		
	
		
		<cfreturn argCFML />
	</cffunction>

</cfcomponent>