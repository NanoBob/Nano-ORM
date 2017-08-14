InstanceVariable = inherit(Object)

function InstanceVariable:constructor(key,value)
	self.key = key
	self.value = value
	self.changed = false
end

function InstanceVariable:set(newValue)
	self.value = newValue
end

function InstanceVariable:get()
	return self.value
end