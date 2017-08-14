FrameworkCore = inherit(Singleton)

function FrameworkCore:constructor()
	outputDebugString("New framework core")
	self.database = Database:new()
end