debug.setmetatable(print,{

	__index = function(self,key)
		if key == "bind" then
			return function(...)
				local args = {...}
				return function(...)
					for _,value in ipairs({...}) do
						args[#args+1] = value
					end
					self(unpack(args))
				end
			end
		else
			error("Attempt to index a function value with a not supported key (" .. key .. ")")	
		end
	end,

})