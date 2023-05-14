return function(str, pattern)
	local LastIndex = 0
	
	return function()
		local Result = {string.find(str, pattern, LastIndex + 1)}
		LastIndex = Result[2]
		return Result[1], Result[2], select(3, unpack(Result))
	end
end
