return function(String: string): string
	return String:gsub("^(|?)(.-)%1$", "%2", 1)
end