

addEventHandler("onResourceStart",getRootElement(),function()
	if FrameworkCore then
		FrameworkCore:new()
	end
	if Core then
		Core:new()
	end
end)