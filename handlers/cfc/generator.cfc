component{

	public generator function init(){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");	
		variables.ormmapper = CreateObject("component", "mappings");
	
		import ".*";
	
		return This;
	}

	public cfc function createORMServiceCFC(string inputXML){
	
	    var BoltInfo = parseBoltInput(arguments.inputXML);
	    var table = BoltInfo.table;
	    var dbname = BoltInfo.dbname;
	    var fileLocation = BoltInfo.location;
	    var dataIntrospector =  New dataIntrospection(dbname);
	    var tableData = dataIntrospector.getTableData(table);
	    
		if (listlen(table,'.') eq 2){
			table= listgetat(table,2,'.');
		}
	    
	    table = LCase(table);
	    
	    var cfc  = New cfc();
	    cfc.setName(table & "Service");
	    cfc.setFileLocation(fileLocation & "/remote");
	    
		//create list method
		var func= CreateObject('component','function').init();
		func.setName('list');
		func.setAccess('remote');
		func.setReturnType('array');
		func.setReturnResult('EntityLoad("#table#")');
		cfc.addFunction(func);
		
		//Create get method
		var arg = New Argument();
		arg.setName('id');
		arg.setRequired(true);
		arg.setType('numeric');
		var func= CreateObject('component','function').init();
		func.setName('get');
		func.setAccess('remote');
		func.setReturnType('any');
		func.AddArgument(arg);
		
		func.setReturnResult('EntityLoad("#table#", arguments.id, true)');
		cfc.addFunction(func);
		
		//Update Method
		var arg = New Argument();
		arg.setName("#table#");
		arg.setRequired(true);
		arg.setType("any");
		
		var func= CreateObject('component','function').init();
		func.setName("update");
		func.setAccess("remote");
		func.setReturnType("void");
		func.AddArgument(arg);
		func.AddOperation('		<cfset arguments.#table#.nullifyZeroID() />');
		func.AddOperation('		<cfset EntitySave(arguments.#table#) />');
		func.AddOperationScript('		arguments.#table#.nullifyZeroID();');
		func.AddOperationScript('		EntitySave(arguments.#table#);');		
		cfc.addFunction(func);
		
		//Delete Method
		var func= CreateObject('component','function').init();
		func.setName("destroy");
		func.setAccess("remote");
		func.setReturnType("void");
		func.AddArgument(arg);
		func.AddOperation('		<cfset EntityDelete(arguments.#table#) />');
		func.AddOperationScript('		EntityDelete(arguments.#table#);');		
		cfc.addFunction(func);
		
		//Search Method
		var func= CreateObject('component','function').init();
		func.setName("search");
		func.setAccess("remote");
		func.setReturnType("array");
		func.addLocalVariable("hqlString","string","FROM employees ");
		func.addLocalVariable("whereClause","string","");
		
		var arg = New Argument();
		arg.setName("q");
		arg.setType("string");
		arg.setDefaultValue("");
		func.addArgument(arg);
		
		
		
		
		func.AddOperationScript('		if (len(arguments.q) gt 0){');		
		func.AddOperation('		<cfif len(arguments.q) gt 0>');
		
		
		for (i=1;i lte tableData.columns.recordCount; i++){
			var column = Lcase(tableData.columns.column_name[i]);
			func.AddOperationScript('			whereClause  = ListAppend(whereClause, " #column# LIKE ''%##arguments.q##%''", "|"); 	  ');		
			
			func.AddOperation('				<cfset whereClause  = ListAppend(whereClause, " #column# LIKE ''%##arguments.q##%''", "|") />');		
		}
		
		func.AddOperationScript('			whereClause = Replace(whereClause, "|", " OR ", "all");');	
		func.AddOperation('			<cfset whereClause = Replace(whereClause, "|", " OR ", "all") />');	
		
		func.AddOperationScript('		}');		
		func.AddOperation('		</cfif>');
		
		func.AddOperationScript('		if (len(whereClause) gt 0){');	
		func.AddOperationScript('			hqlString = hqlString & " WHERE " & whereClause;');	
		func.AddOperationScript('		}');	
		
		func.AddOperation('		<cfif if len(whereClause) gt 0>');
		func.AddOperation('			<cfset hqlString = hqlString & " WHERE " & whereClause />');
		func.AddOperation('		</cfif>');
		
		func.setReturnResult('ormExecuteQuery(hqlString)');
		cfc.addFunction(func);		
		
		return cfc;
	}    

	public cfc function createORMCFC(string inputXML){
	
	    var BoltInfo = parseBoltInput(arguments.inputXML);
	    var table = BoltInfo.table;
	    var dbname = BoltInfo.dbname;
	    var fileLocation = BoltInfo.location;
	    var dataIntrospector =  New dataIntrospection(dbname);
	    var tableData = dataIntrospector.getTableData(table);
	    
		if (listlen(table,'.') eq 2){
			table= listgetat(table,2,'.');
		}
	    table = LCase(table);
	    
	    var cfc  = New cfc();
	    cfc.setName(table);
	    cfc.setFileLocation(fileLocation & "/cfc");
	    //cfc.setTable(table);
	    //cfc.setEntityname(table);
	    cfc.setPersistent(true);
	    
	
		for (i=1; i lte tableData.columns.recordCount; i++){
	        
	        datatype=ormmapper.getdatatype(tableData.columns.type_name[i]);   
	       	
	       	property = New property();
	       	property.setName(LCase(tableData.columns.column_name[i]));
	       	//property.setColumn(tableData.columns.column_name[i]);
	       	property.setOrmType(datatype);
	       	
	       	if (tableData.columns.column_size[i] gt 0){
	       		property.setLength(tableData.columns.column_size[i]);
	       	}
	       	
	       	if (tableData.columns.is_PrimaryKey[i]){
	       		property.setFieldtype('id');
	       		property.setGenerator('increment');
	       	}	
	       	else if (tableData.columns.is_ForeignKey[i]){
	       		property.setName(tableData.columns.referenced_primarykey_table[i]);
	       		property.setFieldtype('many-to-one');
	       		property.setFkcolumn(tableData.columns.referenced_primarykey[i]);
	       		property.setCFC(tableData.columns.referenced_primarykey_table[i]);
	       		property.setInverse(true);
	       		property.SetmissingRowIgnored(true);
	       	}	
	       	//else {
	       	//	property.setFieldtype('column');
			//}	
	        
	        cfc.AddProperty(property);
	    }
	   
	   	for (i=1; i lte tableData.foreignkeys.recordCount; i++){
			property = New property();
			property.setName(tableData.foreignkeys.fktable_name[i]);
	   		property.setFieldtype('one-to-many');
	   		property.setFkcolumn(tableData.foreignkeys.fkcolumn_name[i]);
	   		property.setCFC(tableData.foreignkeys.fktable_name[i]);
	   		property.setCascade("all-delete-orphan");
	   		cfc.AddProperty(property);
			
		}
		
		var func= CreateObject('component','function').init();
		func.setName('getIDName');
		func.setAccess("public");
		func.setReturnType("string");
		func.addLocalVariable("id", "string", 'StructFindValue( GetMetaData(This), "id")[1].owner.name', false);
		func.setReturnResult('id');
		cfc.addFunction(func);
		
		var func= CreateObject('component','function').init();
		func.setName('getIDValue');
		func.setAccess("public");
		func.setReturnType("any");
		func.setReturnResult('variables[getIDName()]');
		cfc.addFunction(func);
		
		var arg = New Argument();
		arg.setName("idvalue");
		arg.setRequired(false);
		arg.setType("any");
		
		var func= CreateObject('component','function').init();
		func.setName('setIDValue');
		func.setAccess("public");
		func.setReturnType('void');
		func.AddOperation('		<cfset variables[getIDName()] = arguments.idvalue />');
		func.AddOperationScript('		variables[getIDName()] = arguments.idvalue;');	
		func.AddArgument(arg);
		cfc.addFunction(func);
		
		
		var func= CreateObject('component','function').init();
		func.setName('nullifyZeroID');
		func.setAccess("public");
		func.setReturnType('void');
		func.AddOperation('		<cfif getIDValue() eq 0>');
		func.AddOperation('			<cfset variables[getIDName()] = JavaCast("Null", "") />');	
		func.AddOperation('		</cfif>');
		func.AddOperationScript('		if (getIDValue() eq 0){');
		func.AddOperationScript('			variables[getIDName()] = JavaCast("Null", "");');
		func.AddOperationScript('		}');
		cfc.addFunction(func);
		
		return cfc;
	}
	
	public applicationCFC function createAppCFC(string inputXML){
		
		var BoltInfo = parseBoltInput(arguments.inputXML) ;
	    var table = BoltInfo.table ;
	    var dbname = BoltInfo.dbname ;
	    var fileLocation = BoltInfo.location ;
	    
	    var appCFC  =  New applicationCFC();
	    appCFC.setName('Application') ;
	    appCFC.setFileLocation(fileLocation) ;
	    appCFC.addApplicationProperty('name', dbname) ;
	    appCFC.addApplicationProperty('ormenabled', true) ;
	    appCFC.addApplicationProperty('datasource', dbname) ;
	    appCFC.addApplicationProperty("customTagPaths", "ExpandPath('customtags/')", false) ;
	    appCFC.addApplicationProperty("ormsettings", "{cfclocation = ExpandPath('cfc/') }", false) ;
	    
		return appCFC ;
	
	
	}
	
	public CFPage function createIndex(string inputXML){
		
		var BoltInfo = parseBoltInput(arguments.inputXML);
	    var dbname = BoltInfo.dbname;
	    var fileLocation = BoltInfo.location;
	    var dataIntrospector =  New dataIntrospection(dbname);
	    var tableData = dataIntrospector.getTables();
	    var i = dataIntrospector.getTables();
	    
	    var index  =  New CFPage("index", fileLocation);  
	    index.AppendBody('<cfsetting showdebugoutput="false" />');
	    index.AppendBody('<cf_pageWrapper>');
	    index.AppendBody('<h1>#dbname#</h1>');
	    index.AppendBody('<ul>');
	    
	    for (i=1; i lte tableData.tables.recordCount; i++){
	    	index.AppendBody('	<li><a href="#tableData.tables.table_name[i]#.cfm">#tableData.tables.table_name[i]#</a></li>');
	    }
	    
	    
	    index.AppendBody('</ul>');
	    index.AppendBody('<cf_pageWrapper>');
		return index ;
	
	
	}

	public CFPage function createView(string inputXML){
		var BoltInfo = parseBoltInput(arguments.inputXML);
	    var table = BoltInfo.table;
	    var dbname = BoltInfo.dbname;
	    var fileLocation = BoltInfo.location;
	    var dataIntrospector = New dataIntrospection(dbname);
	    var tableData = dataIntrospector.getTableData(table);
	    
	    table = LCase(table);
	    
	    var view  = New CFPage(table, fileLocation);
	    view.AppendBody('<cfsetting showdebugoutput="false" />');
	    view.AppendBody('<cfparam name="url.method" type="string" default="list" />');
	    view.AppendBody('<cfparam name="url.id" type="numeric" default="0" />');
	    view.AppendBody('<cfparam name="url.message" type="string" default="" />');
	    view.AppendBody('<cfimport path="cfc.*" />');
		view.AppendBody();
	   	view.AppendBody('<cf_pageWrapper>');
	   	view.AppendBody('<h1>#dbname#</h1>');
	   	view.AppendBody('<h2>#table#</h2>');
		view.AppendBody('<cfoutput><p><a href="index.cfm">Main</a> / <a href="##cgi.script_name##">#table# List</a></cfoutput>');
		view.AppendBody();
	    view.AppendBody('<cfswitch expression="##url.method##" >');
		view.AppendBody();
	   	view.AppendBody('	<cfcase value="list">');
	    view.AppendBody('		<cfset #table#Array = entityLoad("' & table  & '") />');
	    view.AppendBody('		<cf_#table#List #table#Array = "###table#Array##" message="##url.message##" /> ');
	    view.AppendBody('	</cfcase>');
		view.AppendBody();
	    view.AppendBody('	<cfcase value="read">');
	    view.AppendBody('		<cfset #table# = entityLoad("' & table  & '", url.id, true) />');
	    view.AppendBody('		<cf_#table#Read #table# = "###table###" /> ');
	    view.AppendBody('	</cfcase>');
		view.AppendBody();
	    view.AppendBody('	<cfcase value="edit">');
	    view.AppendBody('		<cfif url.id eq 0>');
	    view.AppendBody('			<cfset #table# = New ' & table  & '() />');
	    view.AppendBody('		<cfelse>');
	    view.AppendBody('			<cfset #table# = entityLoad("' & table  & '", url.id, true) />');
	    view.AppendBody('		</cfif>');
		view.AppendBody();
	    view.AppendBody('		<cf_#table#Edit #table# = "###table###" message="##url.message##" /> ');
	    view.AppendBody('	</cfcase>');
		view.AppendBody();
	    view.AppendBody('	<cfcase value="edit_process">');
	    view.AppendBody('		<cfset #table# = EntityNew("' & table  & '") />');
	    
	    for (i= 1; i lte tableData.columns.recordCount; i++){
	    	if(tableData.columns.is_primarykey[i]){
	    		view.AppendBody('		<cfif form.#tableData.columns.column_name[i]# gt 0>');
	    		view.AppendBody('			<cfset #table#.set#tableData.columns.column_name[i]#(form.#tableData.columns.column_name[i]#)  />');
	    		view.AppendBody('		</cfif>');
	    	}
	    	else{ 
	    		view.AppendBody('		<cfset #table#.set#tableData.columns.column_name[i]#(form.#tableData.columns.column_name[i]#)  />');
	    	}
	    }
	    view.AppendBody('		<cfset EntitySave(#table#) />');
	    view.AppendBody('		<cfset ORMFlush() />');
	    view.AppendBody('		<cflocation url ="##cgi.script_name##?method=edit&id=###table#.getIDValue()##&message=updated" />');
	    
	    view.AppendBody('	</cfcase>');
	    view.AppendBody();
	    view.AppendBody('	<cfcase value="delete_process">');
	    view.AppendBody('		<cfset #table# = entityLoad("' & table  & '", url.id, true) />');
	    view.AppendBody('		<cfset EntityDelete(#table#) />');
 	    view.AppendBody('		<cfset ORMFlush() />');
		view.AppendBody('		<cflocation url ="##cgi.script_name##?method=list&message=deleted" />');
	    view.AppendBody('	</cfcase>');
		view.AppendBody();   
	    view.AppendBody('</cfswitch>');
		view.AppendBody();
	    view.AppendBody('</cf_pageWrapper>');
	    return view;
	}
	
	public CustomTag function createViewListCustomTag(string inputXML){
		var BoltInfo = parseBoltInput(arguments.inputXML);
	    var table = BoltInfo.table;
	    var dbname = BoltInfo.dbname;
	    var fileLocation = BoltInfo.location;
	    var dataIntrospector = new dataIntrospection(dbname);
	    var tableData = dataIntrospector.getTableData(table);
		 
		 table = LCase(table);  
		    
	    var ct  = CreateObject("component", "customtag").init(table & "List", fileLocation & "/customTags");
		ct.addAttribute(table & "Array", "array", true);
			
		ct.AppendBody('<cfset message = attributes.message /> ');
		ct.AppendBody('<cfif CompareNoCase(message, "deleted") eq 0>');
		ct.AppendBody('	<p class="alert">Record deleted</p>');
		ct.AppendBody('<cfelse>');
		ct.AppendBody('	<p></p>');
		ct.AppendBody('</cfif>');
		ct.AppendBody('	<p><a href="?method=edit">New</a></p>');	
		ct.AppendBody('<table>');
		ct.AppendBody('	<thead>');
		ct.AppendBody('		<tr>');
		
		//system.dump(tableData);
		//abort;
		for (i = 1; i lte tableData.columns.recordCount; i++){
		 	if (not tableData.columns.is_foreignkey[i]){
		 		ct.AppendBody('			<th>#tableData.columns.column_name[i]#</th>');
			}
		}
		ct.AppendBody('		</tr>');
		ct.AppendBody('	</thead>');
		
		ct.AppendBody('	<tbody>');
		ct.AppendBody('	<cfoutput>');
		ct.AppendBody('	<cfloop array="##attributes.#table#Array##" index="#table#">');
		
		ct.AppendBody('		<tr>');
		for (i = 1; i lte tableData.columns.recordCount; i++){
		 	if (not tableData.columns.is_foreignkey[i]){
		 		ct.AppendBody('			<td>###table#.get#tableData.columns.column_name[i]#()##</td>');
			}
		}
		ct.AppendBody('			<td><a href="?method=read&id=###table#.getIDValue()##">Read</a></td>');
		ct.AppendBody('			<td><a href="?method=edit&id=###table#.getIDValue()##">Edit</a></td>');
		ct.AppendBody('			<td><a href="?method=delete_process&id=###table#.getIDValue()##" onclick="if (confirm(''Are you sure?'')) { return true}; return false"">Delete</a></td>');
		ct.AppendBody('		</tr>');
		ct.AppendBody('	</cfloop>');
		ct.AppendBody('	</cfoutput>');
		ct.AppendBody('	</tbody>');
		
		
		ct.AppendBody('</table>');
	    
	    return ct;
	}
	
	public CustomTag function createViewReadCustomTag(string inputXML){
		var BoltInfo = parseBoltInput(arguments.inputXML);
	    var table = BoltInfo.table;
	    var dbname = BoltInfo.dbname;
	    var fileLocation = BoltInfo.location;
	    var dataIntrospector = new dataIntrospection(dbname);
	    var tableData = dataIntrospector.getTableData(table);
		  
		 table = LCase(table); 
		    
	    var ct  = CreateObject("component", "customtag").init(table & "Read", fileLocation & "/customTags");
		ct.addAttribute(table, 'any', true);
		ct.AppendBody('<cfset #table# = attributes.#table# /> ');
		ct.AppendBody('<table>');
		ct.AppendBody('	<tbody>');
		ct.AppendBody('	<cfoutput>');
		
		
		//system.dump(tableData);
		//abort;
		for (i = 1; i lte tableData.columns.recordCount; i++){
		 	if (not tableData.columns.is_foreignkey[i]){
		 		ct.AppendBody('		<tr>');
		 		ct.AppendBody('			<th>#tableData.columns.column_name[i]#</th>');
		 		ct.AppendBody('			<td>###table#.get#tableData.columns.column_name[i]#()##</td>');
				ct.AppendBody('		</tr>');
			}
		}
		
		ct.AppendBody('	</cfoutput>');
		ct.AppendBody('	</tbody>');
		
		
		
		
		
		ct.AppendBody('</table>');
	    
	    return ct;
	}
	
	public CustomTag function createViewEditCustomTag(string inputXML){
		var BoltInfo = parseBoltInput(arguments.inputXML);
	    var table = BoltInfo.table;
	    var dbname = BoltInfo.dbname;
	    var fileLocation = BoltInfo.location;
	    var dataIntrospector = new dataIntrospection(dbname);
	    var tableData = dataIntrospector.getTableData(table);
		  
		 table = LCase(table); 
		    
	    var ct  = CreateObject("component", "customtag").init(table & "Edit", fileLocation & "/customTags");
		ct.addAttribute(table, 'any', true);
		ct.addAttribute('message', 'string', false, "");
		ct.AppendBody('<cfset #table# = attributes.#table# /> ');
		ct.AppendBody('<cfset message = attributes.message /> ');
		ct.AppendBody('<cfif CompareNoCase(message, "updated") eq 0>');
		ct.AppendBody('	<p class="alert">Records updated</p>');
		ct.AppendBody('<cfelse>');
		ct.AppendBody('	<p></p>');
		ct.AppendBody('</cfif>');
		ct.AppendBody('<table>');
		ct.AppendBody('	<tbody>');
		ct.AppendBody('	<cfoutput>');
		ct.AppendBody('	<form action="?method=edit_process" method="post">');
		
		
		//writeDump(tableData);
		//abort;
		for (i = 1; i lte tableData.columns.recordCount; i++){
		 	if (not tableData.columns.is_foreignkey[i]){
		 		
		 		if (tableData.columns.is_primarykey[i]){
		 			ct.AppendBody('			<input name="#tableData.columns.column_name[i]#" type="hidden" value="###table#.get#tableData.columns.column_name[i]#()##" />');
		 		}
		 		else{
		 			ct.AppendBody('		<tr>');
		 			ct.AppendBody('			<th><label for="#tableData.columns.column_name[i]#">#tableData.columns.column_name[i]#:</label></th>');
		 			ct.AppendBody('			<td><input name="#tableData.columns.column_name[i]#" type="text" id="#tableData.columns.column_name[i]#" value="###table#.get#tableData.columns.column_name[i]#()##" /></td>');
					ct.AppendBody('		</tr>');
				}
			}
		}
		ct.AppendBody('		<tr>');
		ct.AppendBody('			<th />');
		ct.AppendBody('			<td><input name="save" type="submit" value="Save" /></td>');
		ct.AppendBody('		</tr>');
		ct.AppendBody('	</form>');
		ct.AppendBody('	</cfoutput>');
		ct.AppendBody('	</tbody>');
		
		
		
		
		
		ct.AppendBody('</table>');
	    
	    return ct;
	}

	public struct function parseBoltInput(string inputXML){
		var result = structNew();
		var xmldoc = XMLParse(inputXML);
		var location = XMLSearch(xmldoc, "/event/user/input[@name='Location']");
		        
	    result.dbname=XMLDoc.event.ide.rdsview.database[1].XMLAttributes.name;    
	    result.table=XMLDoc.event.ide.rdsview.database[1].table[1].XMLAttributes.name;        
	    result.location = location[1].XMLAttributes.value;

		return result;	
	}	
	
}