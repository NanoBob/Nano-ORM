Vehicle = inherit(DbClass)

Vehicle.tableName = "vehicle"

Vehicle:int("model")
Vehicle:float("x")
Vehicle:float("y")
Vehicle:float("z")
Vehicle:float("rx")
Vehicle:float("ry")
Vehicle:float("rz")

function Vehicle:dataConstructor(success)
	if success then
		self:createElement()
	else
		outputDebugString("Failed to load vehicle with id " .. self.id)
	end
end

function Vehicle:newConstructor(id,model,x,y,z,rx,ry,rz)
	self.model = model
	self.x, self.y, self.z = x, y, z
	self.rx, self.ry, self.rz = rx, ry, rz
	self:createElement()
end

function Vehicle:createElement()
	self.element = createVehicle(self.model,self.x,self.y,self.z,self.rx,self.ry,self.rz)
end
