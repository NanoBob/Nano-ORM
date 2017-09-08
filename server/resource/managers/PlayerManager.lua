PlayerManager = inherit(Singleton,"PlayerManager")

function PlayerManager:constructor()
	self.players = {}
	for _,playerElement in pairs(getElementsByType("player")) do
		self:addPlayer(playerElement)
	end
	addEventHandler("onPlayerJoin",getRootElement(),self.playerJoined.bind(self))
	addEventHandler("onPlayerQuit",getRootElement(),self.playerLeft.bind(self))

	addCommandHandler("_register",self.register.bind(self))
	addCommandHandler("_login",self.login.bind(self))
end

function PlayerManager:playerJoined()
	self:addPlayer(source)
end

function PlayerManager:playerLeft()
	self:removePlayer(source)
end

function PlayerManager:addPlayer(playerElement)
	-- Player:select():where("name",getPlayerName(playerElement)):get(self.registerPlayerCallback.bind(self,playerElement))
end

function PlayerManager:removePlayer(playerElement)
	local player = self.players[playerElement]
	if not player then 
		return 
	end
	player:destroy()
	self.players[playerElement] = nil
end

function PlayerManager:register(source,_,username,password)
	Player:select():where("username",username):first(self.handleRegister.bind(self,source,username,password)) 
end

function PlayerManager:handleRegister(source,username,password,instance)
	if instance then
		outputChatBox("An account with this username already exists.")
	else
		local player = Player:new(username,password,source)
	end
end

function PlayerManager:login(source,_,username,password)
	AuthenticatablesManager:authenticate(Player,username,password,self.handleLogin.bind(self,source))
end

function PlayerManager:handleLogin(player,authenticated,instance)
	if authenticated then
		instance:linkElement(player)
	elseif instance then
		instance:destroy()
	end
end