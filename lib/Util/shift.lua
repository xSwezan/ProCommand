return function(Table: table): table
	local Output = Table[1]
	
	table.remove(Table, 1)

	return Output
end