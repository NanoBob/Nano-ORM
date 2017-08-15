Object = {}

Object.isClass = true
registerClass(Object,"object")

function Object:onInherit(newClass)
	newClass.instances = {}
end

function Object:new(...)
	return new(self,...)
end

function Object:destroy()
	destroy(self)
end

