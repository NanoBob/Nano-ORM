InstanceVariable = inherit(Object,"InstanceVariable")

function InstanceVariable:constructor(key,value)
	self.key = key
	self.value = value
	self.changed = false
end

function InstanceVariable:set(newValue)
	self.value = newValue
	self.changed = true
end

function InstanceVariable:get()
	return self.value
end

function InstanceVariable:toDatatype(type)
	if type == "json" then
		return toJSON(self:get()), self.changed
	else
		return self:get(), self.changed
	end
end

function InstanceVariable:fromDatatype(value,type)
	if type == "json" then
		self:set(fromJSON(value))
	else
		self:set(value)
	end
end
