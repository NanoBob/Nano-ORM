DbClassManager = inherit(Singleton,"DbClassManager")

function DbClassManager:constructor()
	self.instances = {}
end

function DbClassManager:destructor()
	for instance,_ in pairs(self.instances) do
		instance:destroy()
	end
end

function DbClassManager:addInstance(instance)
	self.instances[instance] = true
end

function DbClassManager:removeInstance(instance)
	self.instances[instance] = nil
end