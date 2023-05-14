return function(String: string)
	return if (String:match("[%-%.]$")) then `{String}0` else String
end