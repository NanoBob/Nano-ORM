Core = inherit(Singleton,"Core")

function Core:constructor()
	self.managers = {}
	--local clover = Vehicle(542,3,0,3,0,0,0)
	--clover:save()

	Vehicle:select():where("x",3):where("id",">",4):limit(1):get()

	playerManager = PlayerManager:new()
	self:addManager(playerManager)
end

function Core:addManager(manager)
	self.managers[#self.managers + 1] = manager
end

function Core:destructor()
	for _,manager in pairs(self.managers) do
		manager:destroy()
	end
end