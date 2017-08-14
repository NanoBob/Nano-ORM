DbClass = inherit(Object,"DbClass")
DbClass.dbVariables = {}

function DbClass:onInherit(newClass)

	-- changing sub classes meta tables to support the custom instance variables

	newClass.dbVariables = {}

	newClass.__index = function(self,key)
		--outputServerLog(toJSON(self))
		--outputServerLog("GETTING " .. tostring(key) .. "(" .. tostring(rawget(self,"isClass")) .. ")")
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
				if rawget(self,"class") then
					return rawget(self,"class")[key]
				end
				return nil
			end
			return instanceVariable:get()
		end
	end

	newClass.__newindex = function(self,key,value)
		--outputServerLog("SETTING " .. tostring(key) .. "  to " .. tostring(value))
		if self.isClass then
			rawset(self,key,value)
		else
			local instanceVariables = rawget(self,"instanceVariables")
			local instanceVariable = instanceVariables[key]
			if not instanceVariable then
				instanceVariables[key] = InstanceVariable:new(key,value)
				return
			end
			instanceVariable:set(value)
		end
	end
end

DbClass.tableName = "DbClass"

function DbClass:constructor(id,...)
	getmetatable(self).__index = self.class.__index
	rawset(self,"instanceVariables",{})
	if not self.class.isDatabaseSetup then
		self:setupDatabase()
	end
	self.id = id
	local args = { ... }
	if id and args[1] == nil then
		self:requestData()
	elseif id and type(args[1] == "table") then
		self:loadData(args[1])
	else
		self.exists = false
		self:newConstructor(id,...)
	end
end

DbClass.subConstructor = DbClass.constructor

-- placeholder functions to prevent errors if functions are not overwritten in sub classes

function DbClass:newConstructor()  end
function DbClass:dataConstructor() end

-- creating the database

function DbClass:setupDatabase()
	self:getDatabase():exec(string.format("CREATE TABLE IF NOT EXISTS `%s` ( `id` INT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id) )",self.class.tableName))
	for key,dataType in pairs(self.class.dbVariables) do
		self:getDatabase():exec(string.format("ALTER TABLE `%s` ADD `%s` %s;",self.class.tableName,key,dataType))
	end
end

function DbClass:getDatabase()
	return FrameworkCore:new().database
end

-- loading from database

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
	if row then
		self.exists = true
		for key,data in pairs(row) do
			self:loadVariable(key,data)
		end
		if self.dataConstructor then
			self:dataConstructor(true)
		end
	else
		self.exists = false
		if self.dataConstructor then
			self:dataConstructor(false)
		end
	end
end

function DbClass:loadVariable(key,value)
	local vars = rawget(self,"instanceVariables")
	if not vars then return end
	local var = vars[key]
	if not var then
		self[key] = value
		var = vars[key]
	end
	local datatype = self.dbVariables[key]
	if not datatype then return end
	var:fromDatatype(value,datatype)
end

-- saving to database

function DbClass:saveVariable(key)
	local vars = rawget(self,"instanceVariables")
	if not vars then return end
	local var = vars[key]
	if not var then return end
	local datatype = self.class.dbVariables[key]
	if not datatype then return end
	return var:toDatatype(datatype)
end

function DbClass:save()
	if self.exists then
		self:update()
	else
		self:insert()
	end
end

function DbClass:insert()
	local queryCache = {}
	for key,_ in pairs(self.class.dbVariables) do
		queryCache[key] = { self:saveVariable(key) }
	end
	local execArgs = {}

	local query = "INSERT INTO `" .. self.tableName .. "` ("
	for key,variable in pairs(queryCache) do
		query = query .. string.format(" `%s`,",key)
	end
	if query == "INSERT INTO `" .. self.tableName .. "` (" then
		return
	end
	query = query:sub(0,query:len()-1) .. ")\n VALUES("
	for key,variable in pairs(queryCache) do
		query = query .. " ?,"
		execArgs[#execArgs + 1] = variable[1]
	end
	query = query:sub(0,query:len()-1) .. ");"
	self:getDatabase():exec(query,unpack(execArgs))
end

function DbClass:update()
	local queryCache = {}
	for key,_ in pairs(self.class.dbVariables) do
		queryCache[key] = { self:saveVariable(key) }
	end
	local execArgs = {}

	local query = "UPDATE `" .. self.tableName .. "`\n SET ("
	for key,variable in pairs(queryCache) do
		if variable[2] then
			query = query .. " ? = ? "
			execArgs[#execArgs + 1] = key
			execArgs[#execArgs + 1] = variable[1]
		end
	end
	if query ~= "UPDATE `" .. self.tableName .. "`\n SET (" then
		query = query .. ");"
		self:getDatabase():exec(query)
	end
end

-- database field functions

function DbClass:registerDatabaseVariable(key,dataType)
	local class = self
	if not self.isClass then
		class = self.class
	end
	class.dbVariables[key] = dataType
	if class.isDatabaseSetup then
		self:getDatabase():exec(string.format("ALTER TABLE `%s` ADD `%s` %s;",class.tableName,key,dataType))
	end
end

function DbClass:int(key,digits)
	self:registerDatabaseVariable(key,string.format("INT(%s)",digits or "11"))
end

function DbClass:float(key,digits,decimalDigits)
	self:registerDatabaseVariable(key,string.format("FLOAT(%s,%s)",digits or "22",decimalDigits or "11"))
end

function DbClass:string(key)
	self:registerDatabaseVariable(key,"text")
end

function DbClass:json(key)
	self:registerDatabaseVariable(key,"json")
end

function DbClass:position()
	self:registerDatabaseVariable("x","float(10,5)")
	self:registerDatabaseVariable("y","float(10,5)")
	self:registerDatabaseVariable("z","float(10,5)")
end

function DbClass:rotation()
	self:registerDatabaseVariable("rx","float(7,4)")
	self:registerDatabaseVariable("ry","float(7,4)")
	self:registerDatabaseVariable("rz","float(7,4)")
end

function DbClass:rotation()
	self:registerDatabaseVariable("rx","float(7,4)")
	self:registerDatabaseVariable("ry","float(7,4)")
	self:registerDatabaseVariable("rz","float(7,4)")
end

function DbClass:foreign()
	self:registerDatabaseVariable("foreignType","text")
	self:registerDatabaseVariable("foreignID","INT(11)")
end

-- relation methods

-- selector methods

function DbClass:select()
	return Selector:new(self.class)
end