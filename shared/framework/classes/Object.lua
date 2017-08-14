Object = {}

Object.isClass = true

function Object:new()
	return new(self)
end

function Object:delete()
	delete(self)
end

