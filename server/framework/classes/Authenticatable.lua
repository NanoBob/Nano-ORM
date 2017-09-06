Authenticatable = inherit(DbClass,"Authenticatable")
Authenticatable.tableName = "authenticatable"

function Authenticatable:onInherit(newClass)
	newClass:string("password")
end



function Authenticatable:setAuthenticationkey(key)
	if self.isClass then
		self.authenticationkey = key
		return
	end
	self.class.authenticationkey = key
end

function Authenticatable:authenticate(authenticationKey,password,callback)
	self.authenticationPass = password
	self:select():where(self.authenticationkey,authenticationkey):first(self.handleAuthentication.bind(self,password,callback))
end

function Authenticatable:handleAuthentication(password,callback,authenticatable)
	if authenticatable == false then
		callback(false)
	end
end

function Authenticatable:hash(password)
	return passwordHash(password,"bcrypt")
end