PlayerManager = inherit(Singleton,"PlayerManager")

function PlayerManager:constructor()
	self.players = {}
	for _,playerElement in pairs(getElementsByType("player")) do
		self:registerPlayer(playerElement)
	end
end

function PlayerManager:destructor()
	for _,player in pairs(self.players) do
		player:destroy()
	end
end

function PlayerManager:registerPlayer(playerElement)
	local player = Player:select():where("name",getPlayerName(playerElement)):get(self.registerPlayerCallback.bind(self,playerElement))
end

function PlayerManager:registerPlayerCallback(targetPlayer,players)
	outputDebugString("PLAYER COUNT " .. #players)
	if #players == 0 then
		local player = Player:new(getPlayerName(targetPlayer))
		player:save(self.newPlayerCallback.bind(self,player))
	else
		self.players[players[1].id] = players[1]	
	end
end

function PlayerManager:newPlayerCallback(targetPlayer,id)
	outputServerLog("NEW CALLBACK " .. id)
	self.players[id] = targetPlayer
end

