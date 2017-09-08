Player = inherit(Authenticatable,"Player")
Player:setAuthenticationkey("username")

Player.tableName = "player"

Player:string("username")
Player:string("name")
Player:int("model")
Player:position()
Player:rotation()

function Player:dataConstructor(success)

end

function Player:newConstructor(username,password,element)
	self.username = username
	self:setPassword(password)
	self:linkElement(element)
end

function Player:destructor()
	if not isElement(self.element) then
		return
	end
	self.name = getPlayerName(self.element)
	self.x, self.y, self.z = getElementPosition(self.element)
	self.rx, self.ry, self.rz = getElementRotation(self.element)
	self.model = getElementModel(self.element)
	self:save()
end

function Player:linkElement(element)
	if not isElement(self.element) then
		return
	end
	self.element = element
	setCameraTarget(self.element,self.element)
	fadeCamera(self.element,true)
	spawnPlayer(self.element,self.x or 0,self.y or 0,self.z or 3,self.rz or 0,self.model or 7)
end
