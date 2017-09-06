Selector = inherit(Object,"Selector")

function Selector:constructor( targetClass )
	self.targetClass = targetClass
	self.whereClauses = {}
	self.whereArgs = {}
	if not targetClass.isDatabaseSetup then
		targetClass:setupDatabase()
	end
end

function Selector:where(...)
	local args = { ... }
	if #args == 2 then
		args[3] = args[2]
		args[2] = "="
	end
	local field = args[1]
	local operator = args[2]
	local value = args[3]
	
	local whereString = field .. " " .. operator .. " ? "
	
	local clause = self.whereClauses[#self.whereClauses]
	if #self.whereClauses == 0 then
		self.whereClauses[1] = "WHERE "
		clause = "WHERE "
	else
		clause = clause .. "AND "
	end	

	clause = clause .. whereString
	self.whereClauses[#self.whereClauses] = clause
	self.whereArgs[#self.whereArgs + 1] = value
	return self
end

function Selector:orWhere(...)
	local args = { ... }
	if #args == 2 then
		args[3] = args[2]
		args[2] = "="
	end
	local field = args[1]
	local operator = args[2]
	local value = args[3]
	
	local whereString = field .. " " .. operator .. " ? "

	local clause = "OR " .. whereString
	self.whereClauses[#self.whereClauses + 1] = clause
	self.whereArgs[#self.whereArgs + 1] = value
	return self
end

function Selector:orderBy(...)
	local args = { ... }
	local orderString = ""
	for _,arg in ipairs(args) do
		orderString = orderString .. arg .. " "
	end
	if not self.orderByString then
		self.orderByString = "ORDER BY "
	end
	self.orderByString = self.orderByString .. orderString
	return self
end

function Selector:limit(limit)
	self.selectorLimit = limit
	return self
end

function Selector:generateQuery()
	local query = "SELECT id,";
	for key,_ in pairs(self.targetClass.dbVariables) do 
		query = query .. key ..","
	end
	query = query:sub(0,query:len() -1)
	query = query .. string.format(" \nFROM `%s`",self.targetClass.tableName)

	if limit then
		query = query .. " \n LIMIT " .. tonumber(self.limit)
	end

	for _,whereString in ipairs(self.whereClauses) do
		query = query .. " \n " .. whereString
	end

	if self.orderByString then
		query = query .. " \n " .. self.orderByString
	end

	if self.selectorLimit then
		query = query .. " \n LIMIT " .. self.selectorLimit
	end
	return query
end

function Selector:get(callback)
	local query = self:generateQuery()

	self.targetClass:getDatabase():query(self.handleGet.bind(self,callback),query,unpack(self.whereArgs))

	return self
end

function Selector:first(callback)
	local query = self:generateQuery()

	self.targetClass:getDatabase():query(self.handleFirst.bind(self,callback),query,unpack(self.whereArgs))

	return self
end

function Selector:handleFirst(callback,data)
	local data = data
	if type(callback) == "table" then
		data = callback
	end	
	local models = {}
	for _,modelData in pairs(data) do
		models[#models + 1] = self.targetClass:new({modelData})
	end
	if type(callback) == "function" then
		callback(models[1] or false)
	end
end

function Selector:handleGet(callback,data)
	local data = data
	if type(callback) == "table" then
		data = callback
	end	
	local models = {}
	for _,modelData in pairs(data) do
		models[#models + 1] = self.targetClass:new({modelData})
	end
	if type(callback) == "function" then
		callback(models)
	end
end