local Registered = require(script.Parent.Parent.Registered)

return function(Arguments: {{string}})
	for _, Argument: {string} in Arguments do
		local Name: string = Argument[1]
		if (Registered.Types[Name]) then continue end

		error(`Could not find a Type with the name: "{Name}"`)
	end
end