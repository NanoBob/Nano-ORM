FrameworkCore = inherit(Singleton,"FrameworkCore")

function FrameworkCore:constructor()
	self.managers = {}
	outputDebugString("New framework core")
	self.database = Database:new()

	dbClassManager = DbClassManager:new()
	self:addManager(dbClassManager)
end

function FrameworkCore:addManager(manager)
	self.managers[#self.managers + 1] = manager
end

function FrameworkCore:destructor()
	for _,manager in pairs(self.managers) do
		manager:destroy()
	end
end