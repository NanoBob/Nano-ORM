debug.setmetatable(function() end,{

	__index = function(self,key)
		if key == "bind" then
			return function(...)
				local args = {...}
				return function()
					self(unpack(args))
				end
			end
		else
			error("Attempt to index a function value with a not supported key (" .. key .. ")")	
		end
	end,

})