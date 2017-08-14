Database = inherit(Object)

function Database:constructor()
	self.handle = dbConnect( "mysql", string.format("dbname=%s;host=%s;port=%s",config.database.schema,config.database.host,config.database.port), config.database.username, config.database.password, "suppress=1060" )

	if not self.handle then
		error("Unable to establish connection with database. Are your datbase configs set correctly?")
	end
end

function Database:exec(...)
	outputConsole(dbPrepareString(self.handle,...))
	dbExec(self.handle,...)
end

function Database:query(callback,query,...)
	dbQuery(self.queryCallback.bind(self,callback),self.handle,query,...)
end

function Database:queryCallback(callback,queryHandle)
	local results = dbPoll(queryHandle,0)
	callback(results)
end