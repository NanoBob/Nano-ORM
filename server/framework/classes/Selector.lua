Selector = inherit(Object)

function Selector:constructor( targetClass )
	self.targetClass = targetClass
	self.whereClauses = {}
end

function Selector:where(...)
	local args = { ... }
	local whereString = ""
	for _,arg in ipairs(args) do
		whereString = whereString .. arg .. " "
	end
	if #self.whereClauses == 0 then
		self.whereClauses[1] = "WHERE "
	end	
	local clause = self.whereClauses[#self.whereClauses]
	clause = clause .. whereString
	self.whereClauses[#self.whereClauses] = clause
	return self
end

function Selector:orWhere(...)
	local args = { ... }
	local whereString = ""
	for _,arg in ipairs(args) do
		whereString = whereString .. arg .. " "
	end
	local clause = "OR " .. whereString
	self.whereClauses[#self.whereClauses + 1] = clause
	return self
end

function Selector:orderBy(...)
	local args = { ... }
	local orderString = ""
	for _,arg in ipairs(args) do
		orderString = orderString .. arg .. " "
	end
	if not self.orderBy then
		self.orderBy = "ORDER BY "
	end
	self.orderBy = self.orderBy .. orderString
	return self
end

function Selector:limit(limit)
	self.limit = limit
	return self
end

function Selector:get(callback)
	local query = "SELECT ";
	for key,_ in pairs(targetClass.dbVariables) do 
		query = query .. key ..","
	end
	query = query:sub(0,query:len() -1)
	query = query .. string.format(" \nFROM `%s`",targetClass.tableName)

	if limit then
		query = query .. " \n LIMIT " .. tonumber(self.limit)
	end

	for _,whereString in ipairs(self.whereClauses) do
		query = query .. " \n " .. whereString
	end

	if self.orderBy then
		query = query .. " \n " .. self.orderBy
	end


	self.targetClass:getDatabase():query(self.loadData.bind(self),query)

	return true
end