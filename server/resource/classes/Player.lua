Player = inherit(Authenticatable,"Player")
Player.tableName = "player"

Player:string("name")
Player:int("model")
Player:position()
Player:rotation()

function Player:dataConstructor(success)
	if success then
		self:linkElement()
	else
		outputServerLog("NO PLAYER MEN")
		self:destroy()
	end
end

function Player:newConstructor(name)
	self.name = name
	self:linkElement()
end

function Player:destructor()
	if self.element then
		self.name = getPlayerName(self.element)
		self.x, self.y, self.z = getElementPosition(self.element)
		self.rx, self.ry, self.rz = getElementRotation(self.element)
		self.model = getElementModel(self.element)
		self:save()
	end
end

function Player:linkElement()
	self.element = getPlayerFromName(self.name)
	setCameraTarget(self.element,self.element)
	fadeCamera(self.element,true)
	spawnPlayer(self.element,self.x or 0,self.y or 0,self.z or 3,self.rz or 0,self.model or 7)
end
