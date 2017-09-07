Authenticatable = inherit(DbClass,"Authenticatable")
Authenticatable.tableName = "authenticatable"
Authenticatable.authenticationKey = "id"

function Authenticatable:onInherit(newClass)
	newClass:string("password")
end

function Authenticatable:setAuthenticationkey(key)
	if self.isClass then
		self.authenticationKey = key
		return
	end
	self.class.authenticationKey = key
end

function Authenticatable:authenticate(authenticationKey,password,callback)
	self.authenticationPass = password
	passwordVerify(password,self.password,self.handlePasswordVerification.bind(self,callback))
end

function Authenticatable:handlePasswordVerification(callback,verified)
	callback(verified)
end

function Authenticatable:setPassword(password)
	self.password = self:hash(password)
end

function Authenticatable:hash(password)
	return passwordHash(password,"bcrypt",{})
end