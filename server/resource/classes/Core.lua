Core = inherit(Singleton,"Core")

function Core:constructor()
	self.managers = {}


	playerManager = PlayerManager:new()
	self:addManager(playerManager)
	vehicleManager = VehicleManager:new()
	self:addManager(vehicleManager)

end

function Core:addManager(manager)
	self.managers[#self.managers + 1] = manager
end

function Core:destructor()
	for _,manager in pairs(self.managers) do
		manager:destroy()
	end
end