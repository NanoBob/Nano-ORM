Vehicle = inherit(DbClass)

Vehicle.tableName = "vehicle"

Vehicle:int("model")
Vehicle:float("x")
Vehicle:float("y")
Vehicle:float("z")
Vehicle:float("rx")
Vehicle:float("ry")
Vehicle:float("rz")

function Vehicle:constructor(id,model,x,y,z,rx,ry,rz)

end

function Vehicle:dataConstructor(success)
	if success then

	else

	end
end

function Vehicle:createElement()
	self.element = createVehicle(self.model,self.x,self.y,self.z,self.rx,self.ry,self.rz)
end
