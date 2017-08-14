



function inherit(baseClass)
	if type(baseClass) ~= "table" then
		outputDebugString("Attempt to inherit non table value",1)
		error(debug.traceback())
	end
	local class = { super = baseClass}
	class.metatable = {
		__index = baseClass
	}
	setmetatable(class,class.metatable)
	return class
end

function new(class,...)
	outputDebugString("New instance")
	local instance = { class = class }
	setmetatable(instance,{
		__index = class
	})
	if rawget(class,"constructor") then
		class.constructor(instance,...)
	end

	callConstructors(instance,class,...)
	return instance
end

function newSingleton(class,...)
	local instance = { class = class }
	setmetatable(instance,{
		__index = class
	})
	
	instance.isClass = false
	return instance
end

function callConstructors(instance,class,...)
	if rawget(class,"constructor") then
		class.constructor(instance,...)
	end

	local current = class
	while current do
		if rawget(current,"subConstructor") then
			current.subConstructor(instance,...)
		end
		current = current.__index
	end
end


function delete(instance,...)
	if rawget(self, "destructor") then
		self:destructor(...)
	end
end