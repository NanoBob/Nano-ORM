VehicleManager = inherit(Singleton,"VehicleManager")

function VehicleManager:constructor()
	self.vehicles = {}

	--local clover = Vehicle(542,3,0,3,0,0,0)
	--clover:save(self.newVehicleSaved.bind(self))

	Vehicle:all(self.vehiclesLoaded.bind(self))
end

function VehicleManager:destructor()
	for _,vehicle in pairs(self.vehicles) do
		vehicle:destroy()
	end
end

function VehicleManager:newVehicleSaved(vehicle,id)
	self:addVehicle(vehicle)
end

function VehicleManager:vehiclesLoaded(vehicles)
	for _,vehicle in pairs(vehicles) do
		self:addVehicle(vehicle)
	end
end

function VehicleManager:addVehicle(vehicle)
	self.vehicles[vehicle.element] = vehicle
end

function VehicleManager:removeVehicle(vehicle)
	vehicle:destroy()
	self.vehicles[vehicle.element] = nil
end