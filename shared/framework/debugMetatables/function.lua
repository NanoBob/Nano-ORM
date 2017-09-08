-- bind function to alllow functiosn to be bound to instances
debug.setmetatable(print,{

	__index = function(self,key)
		if key == "bind" then
			return function(...)
				local args = {...}
				return function(...)
					local newArgs = {}
					for _,value in ipairs(args) do
						newArgs[#newArgs+1] = value
					end
					for _,value in ipairs({...}) do
						newArgs[#newArgs+1] = value
					end
					self(unpack(newArgs))
				end
			end
		else
			error("Attempt to index a function value with a not supported key (" .. key .. ")")	
		end
	end,

})