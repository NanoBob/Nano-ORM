Core = inherit(Singleton)

function Core:constructor()
	self.x = 5
	setTimer(self.testMethod.bind(self,"hey"),1000,1)
end

function Core:testMethod(arg)
	outputServerLog(arg .. "," .. self.x)
end