PlayerManager = inherit(Singleton,"PlayerManager")

function PlayerManager:constructor()
	self.players = {}
	for _,playerElement in pairs(getElementsByType("player")) do
		self:addPlayer(playerElement)
	end
	addEventHandler("onPlayerJoin",getRootElement(),self.playerJoined.bind(self))
	addEventHandler("onPlayerQuit",getRootElement(),self.playerLeft.bind(self))
end

function PlayerManager:playerJoined()
	self:addPlayer(source)
end

function PlayerManager:playerLeft()
	self:removePlayer(source)
end

function PlayerManager:addPlayer(playerElement)
	local player = Player:select():where("name",getPlayerName(playerElement)):get(self.registerPlayerCallback.bind(self,playerElement))
end

function PlayerManager:removePlayer(playerElement)
	local player = self.players[playerElement]
	player:destroy()
	self.players[playerElement] = nil
end

function PlayerManager:registerPlayerCallback(targetPlayer,players)
	if #players == 0 then
		local player = Player:new(getPlayerName(targetPlayer))
		player:save(self.newPlayerCallback.bind(self,player))
	else
		self.players[targetPlayer] = players[1]	
	end
end

function PlayerManager:newPlayerCallback(targetPlayer,id)
	self.players[targetPlayer.element] = targetPlayer
end

