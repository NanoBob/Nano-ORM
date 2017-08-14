Core = inherit(Singleton,"Core")

function Core:constructor()
	self.x = 5
	setTimer(self.testMethod.bind(self),1000,1,"hey")
	Vehicle:new(1)
	local clover = Vehicle:new(nil,542,3,0,3,0,0,0)
	clover:save()
end

function Core:testMethod(arg)
	outputServerLog(arg .. "," .. self.x)
end