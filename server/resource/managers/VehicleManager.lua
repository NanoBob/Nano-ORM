VehicleManager = inherit(Singleton,"VehicleManager")

function VehicleManager:constructor()
	self.vehicles = {}

	-- local clover = Vehicle(542,3,3,3,0,0,0)
	-- clover:save(--[[self.newVehicleSaved.bind(self)]])

	Vehicle:select():where("ownerID", nil):get(function(data)
		for _, instance in pairs(data) do
			for key, value in pairs(instance) do
				print(key .. " : " .. tostring(value))
			end
		end
	end)
end