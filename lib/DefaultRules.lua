return {
	{token = "WS", match = "[ \t]+"};
	--{token = "Comment", match = "//.*\n?"};
	{token = "Duration", match = "(%d+)([smhdwoy])"}; -- TEST
	{token = "String", match = `(["'])(.-)%1`, value = function(inp)
		return string.gsub(inp, `(["'])(.-)%1`, "%2")
	end};

	{token = "Identifier", match = "[a-zA-Z_][a-zA-Z%d_]*", type = function(inp)
		if (table.find({"true", "false"}, inp)) then
			return "Boolean"
		end
	end};
	{token = "Number", match = "%d(%.?)%d*"};
	{token = "Operator", match = "[:;<>/~%*%(%)\\%-=,{}%.#^%+%%]"};
	{token = "WS", match = "\n"};
	{token = "Exception", match = ".+", error = true}
}