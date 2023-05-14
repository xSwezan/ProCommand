return function(String: string): (string, boolean)
	local Output: string = String:gsub("^(.-);$", "%1", 1)

	return Output, (String ~= Output)
end