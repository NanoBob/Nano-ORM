Singleton = inherit(Object,"Singleton")

function Singleton:new(...)
	if self.instance then
		return self.instance
	end
	local instance = newSingleton(self,...)
	self.instance = instance
	callConstructors(instance,self)
	return instance
end

function Singleton:destroy()
	self.class.instance = nil
	destroy(self)
end

