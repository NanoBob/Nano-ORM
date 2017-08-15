VehicleManager = inherit(Singleton,"VehicleManager")

function VehicleManager:constructor()
	self.vehicles = {}

	--local clover = Vehicle(542,3,0,3,0,0,0)
	--clover:save(self.newVehicleSaved.bind(self))

	Vehicle:all()
end