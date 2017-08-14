Object = {}

Object.isClass = true
registerClass(Object,"object")

function Object:new(...)
	return new(self,...)
end

function Object:delete()
	delete(self)
end

