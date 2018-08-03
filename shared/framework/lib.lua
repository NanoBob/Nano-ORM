local classes = {}

function getClassFromName(name)
	return classes[name]
end

function registerClass(class,name)
	classes[name] = class
end

function nullFunc()

end

function inherit(baseClass,name)
	if type(baseClass) ~= "table" then
		outputDebugString("Attempt to inherit non table value",1)
		error(debug.traceback())
	end
	local class = { super = baseClass, className = name}
	class.metatable = {
		__index = baseClass,
		__call = function(self,...) return self:new(...) end,
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
	class.instances[#class.instances + 1] = instance
	return instance
end

function newSingleton(class,...)
	local instance = { class = class, isClass = false }
	setmetatable(instance,{
		__index = class,
	})
	class.instances[#class.instances + 1] = instance
	
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


function destroy(instance,...)
	for i,classInstance in pairs(instance.class.instances) do
		if classInstance == instance then
			table.remove(instance.class.instances,i)
		end
	end

	local current = instance.class.super
	while current do
		if rawget(current,"subDestructor") then
			current.subDestructor(instance,...)
		end
		current = current.super
	end

	if rawget(instance.class, "destructor") then
		instance:destructor(...)
	end
end