return function(Arguments: {}, CurrentIndex: number)
	for Index: number = #Arguments, 1, -1 do
		if (Index >= CurrentIndex) then continue end

		local Argument = Arguments[Index]

		if ((Argument.Text or ""):match(";$")) then
			local LastArgument = Arguments[Index + 1]
			if not (LastArgument) then continue end

			return (Index + 1)
		end
	end

	return 1
end