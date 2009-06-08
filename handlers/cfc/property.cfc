<cfcomponent>
	
	<cfproperty name="name" />
	<cfproperty name="column" />
	<cfproperty name="datatype" />
	<cfproperty name="length" />
	<cfproperty name="fieldtype" />
	<cfproperty name="generator" />
	<cfproperty name="fkcolumn" />
	<cfproperty name="cfc" />
	<cfproperty name="missingRowIgnored" type="boolean" default="true" />
	<cfproperty name="inverse" type="boolean" default="true" />
	<cfproperty name="cascade" />
	<cfproperty name="collectiontype" />
	<cfproperty name="singularName" />
	
	<cffunction name="getCFML" output="FALSE" access="public"  returntype="string" hint="Gets the CFML for a property. " >
		<cfset var result = "" />
		
		<cfset result = result & '<cfproperty' />		
		
		<cfif len(getName())>
			<cfset result = ListAppend(result, 'name="#getName()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getColumn())>
       		<cfset result = ListAppend(result, 'column="#getColumn()#"', " ") /> 
       	</cfif>
       
      	<cfif len(getDatatype())>
       		<cfset result = ListAppend(result, 'datatype="#getDatatype()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getFieldtype())>
       		<cfset result = ListAppend(result, 'fieldtype="#getFieldtype()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getGenerator())>
       		<cfset result = ListAppend(result, 'generator="#getGenerator()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getCFC())>
       		<cfset result = ListAppend(result, 'cfc="#getCFC()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getFkColumn())>
       		<cfset result = ListAppend(result, 'fkColumn="#getFkColumn()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getmissingRowIgnored())>
       		<cfset result = ListAppend(result, 'missingRowIgnored="#getmissingRowIgnored()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getinverse())>
       		<cfset result = ListAppend(result, 'inverse="#getinverse()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getcascade())>
       		<cfset result = ListAppend(result, 'cascade="#getcascade()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getcollectiontype())>
       		<cfset result = ListAppend(result, 'collectiontype="#getcollectiontype()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getSingularName())>
       		<cfset result = ListAppend(result, 'SingularName="#getSingularName()#"', " ") /> 
       	</cfif>
       	
		<cfset result = result & ' />' />
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="getCfScript" output="FALSE" access="public"  returntype="string" hint="Gets the CfScript for a property. " >
		<cfset var result = "" />
		
		<cfset result = result & 'property' />		
		
		<cfif len(getName())>
			<cfset result = ListAppend(result, 'name="#getName()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getColumn())>
       		<cfset result = ListAppend(result, 'column="#getColumn()#"', " ") /> 
       	</cfif>
       
      	<cfif len(getDatatype())>
       		<cfset result = ListAppend(result, 'datatype="#getDatatype()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getFieldtype())>
       		<cfset result = ListAppend(result, 'fieldtype="#getFieldtype()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getGenerator())>
       		<cfset result = ListAppend(result, 'generator="#getGenerator()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getCFC())>
       		<cfset result = ListAppend(result, 'cfc="#getCFC()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getFkColumn())>
       		<cfset result = ListAppend(result, 'fkColumn="#getFkColumn()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getmissingRowIgnored())>
       		<cfset result = ListAppend(result, 'missingRowIgnored="#getmissingRowIgnored()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getinverse())>
       		<cfset result = ListAppend(result, 'inverse="#getinverse()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getcascade())>
       		<cfset result = ListAppend(result, 'cascade="#getcascade()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getcollectiontype())>
       		<cfset result = ListAppend(result, 'collectiontype="#getcollectiontype()#"', " ") /> 
       	</cfif>
       	
       	<cfif len(getSingularName())>
       		<cfset result = ListAppend(result, 'SingularName="#getSingularName()#"', " ") /> 
       	</cfif>
       	
		<cfset result = result & ';' />
		
		<cfreturn result />
	</cffunction>
	
</cfcomponent>