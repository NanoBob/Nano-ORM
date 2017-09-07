local main = {}
addEventHandler("onResourceStart",getResourceRootElement(),function()
	if FrameworkCore then
		main.frameworkCore = FrameworkCore:new()
	end
	if Core then
		main.core = Core:new()
	end
	outputServerLog("STARTING RESOURCE")

	addEventHandler("onResourceStop",getResourceRootElement(),function()
		if main.frameworkCore then
			main.frameworkCore:destroy()
		end
		if main.core then
			main.core:destroy()
		end
	end,true,"high+9999")
end,true,"high+9999")


