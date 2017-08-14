DbClass = inherit(Object)
DbClass.dbVariables = {}

DbClass.metatable.__index = function(self,key)
	if rawget(self,"isClass") == nil then
		if rawget(self,key) then
			return rawget(self,key)
		end
		if self.super then
			return self.super[key]
		end
		return nil
	else
		local instanceVariables = rawget(self,"instanceVariables")
		local instanceVariable = instanceVariables[key]
		if not instanceVariable then
			if rawget(self,key) then
				return rawget(self,key)
			end
			if self.super then
				return self.super[key]
			end
			return nil
		end
		return instanceVariable:get()
	end
end

DbClass.metatable.__newindex = function(self,key,value)
	if self.isClass then
		rawset(self,key,value)
	else
		local instanceVariables = rawget(self,"instanceVariables")
		local instanceVariable = instanceVariables[key]
		if not instanceVariable then
			instanceVariables[key] = instanceVariable:new(key,value)
			return
		end
		instanceVariable:set(value)
	end
end

DbClass.tableName = "DbClass"

function DbClass:constructor(id)
	rawset(self,"instanceVariables",{})
	if not self.class.isDatabaseSetup then
		self:setupDatabase()
	end
	self.id = id
	if id then
		self:requestData()
	end
end
DbClass.subConstructor = DbClass.constrcutor

function DbClass:setupDatabase()
	self:getDatabase():exec(string.format("CREATE TABLE IF NOT EXISTS `%s` ( `id` INT ) ",self.class.tableName))
	for key,dataType in pairs(self.class.dbVariables) do
		self:getDatabase():exec(string.format("ALTER TABLE `%s` ADD `%s` %s;",self.class.tableName,key,dataType))
	end
end

function DbClass:getDatabase()
	return FrameworkCore:new().database
end

function DbClass:requestData()
	local query = "SELECT ";
	for key,_ in pairs(self.class.dbVariables) do 
		query = query .. key ..","
	end
	query = query:sub(0,query:len() -1)
	query = query .. string.format(" \nFROM `%s`",self.tableName)
	query = query .. string.format(" \n WHERE id = %s",self.id)

	self:getDatabase():query(self.loadData.bind(self),query)
end

function DbClass:loadData(data)
	local row = data[1]
	for key,data in pairs(row) do
		self[key] = data
	end
end

function DbClass:registerDatabaseVariable(key,dataType)
	local class = self
	if not self.isClass then
		class = self.class
	end
	class.dbVariables[key] = dataType
	if self.class.isDatabaseSetup then
		self:getDatabase():exec(string.format("ALTER TABLE `%s` ADD `%s` %s;",class.tableName,key,dataType))
	end
end

function DbClass:int(key,digits)
	self:registerDatabaseVariable(key,string.format("INT(%s)",digits or "11"))
end
