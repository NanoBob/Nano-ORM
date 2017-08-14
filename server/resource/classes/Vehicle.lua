Vehicle = inherit(DbClass)

Vehicle.tableName = "vehicle"
Vehicle:int("x")
Vehicle:int("y")
Vehicle:int("z")

function Vehicle:constructor()

end

function Vehicle:dataConstructor()
	
end