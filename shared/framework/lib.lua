local classes = {}

function getClassByName(name)
	return classes[name]
end

function registerClass(class,name)
	classes[name] = class
end

function inherit(baseClass,name)
	if type(baseClass) ~= "table" then
		outputDebugString("Attempt to inherit non table value",1)
		error(debug.traceback())
	end
	local class = { super = baseClass}
	class.metatable = {
		__index = baseClass
	}
	setmetatable(class,class.metatable)
	if baseClass.onInherit then
		baseClass:onInherit(class)
	end
	registerClass(class,name)
	return class
end

function new(class,...)
	local instance = { class = class, isClass = false }
	setmetatable(instance,{
		__index = class,
		__newindex = class.__newindex
	})
	if rawget(class,"constructor") then
		class.constructor(instance,...)
	end

	callConstructors(instance,class,...)
	return instance
end

function newSingleton(class,...)
	local instance = { class = class, isClass = false }
	setmetatable(instance,{
		__index = class,
	})
	
	return instance
end

function callConstructors(instance,class,...)
	local current = class.super
	while current do
		if rawget(current,"subConstructor") then
			current.subConstructor(instance,...)
		end
		current = current.super
	end

	if rawget(class,"constructor") then
		class.constructor(instance,...)
	end
end


function delete(instance,...)
	local current = class.super
	while current do
		if rawget(current,"subDestructor") then
			current.subDestructor(instance,...)
		end
		current = current.super
	end

	if rawget(self, "destructor") then
		self:destructor(...)
	end
end