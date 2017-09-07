AuthenticatablesManager = inherit(Singleton,"AuthenticatablesManager")

function AuthenticatablesManager:constructor()
	
end
function AuthenticatablesManager:authenticate(targetClass,authenticationKey,password,callback)
	targetClass:select():where(targetClass.authenticationKey,authenticationKey):first(self.handleAuthentication.bind(self,password,callback))
end

function AuthenticatablesManager:handleAuthentication(password,callback,authenticatable)
	if authenticatable == false then
		return callback(false)
	end
	passwordVerify(password,authenticatable.password,self.handlePasswordVerification.bind(self,callback,authenticatable))
end

function AuthenticatablesManager:handlePasswordVerification(callback,authenticatable,verified)
	callback(verified,authenticatable)
end