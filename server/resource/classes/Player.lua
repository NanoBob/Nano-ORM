Player = inherit(DbClass,"Player")
Player.tableName = "player"

Player:string("name")
Player:int("model")
Player:position()
Player:rotation()

function Player:dataConstructor(success)
	if success then
		self:linkElement()
	else
		self.name = nil
		self:destroy()
	end
end

function Player:newConstructor(name)
	self.name = name
	self:linkElement()
end

function Player:destructor()
	if self.name then
		self.name = getPlayerName(self.element)
		self.x, self.y, self.z = getElementPosition(self.element)
		self.rx, self.ry, self.rz = getElementRotation(self.element)
		self.model = getElementModel(self.element)
		self:save()
	end
end

function Player:linkElement()
	self.element = getPlayerFromName(self.name)
end
