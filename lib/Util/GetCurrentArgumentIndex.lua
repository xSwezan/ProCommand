local SplitString = require(script.Parent.SplitString)
local IsCommandString = require(script.Parent.IsCommandString)
local HasSemicolon = require(script.Parent.HasSemicolon)

type Argument = {Text: string, Start: number, End: number}

local function GetCurrentArgumentIndex(Arguments: {Argument}, Position: number, Offset: number?): (number, {Argument}, number)
	Offset = Offset or 0

	local function IsBetween(Min: number, Max: number)
		return (Position >= Min) and (Position <= Max)
	end

	for Index: number, Argument: Argument in ipairs(Arguments) do
		local Start: number = (Argument.Start + Offset)
		local End: number = (Argument.End + Offset) + 1

		if (HasSemicolon(Argument.Text)) then
			End -= 1
		end

		if (IsCommandString(Argument.Text)) and (IsBetween(Start + 1, End - 1)) then
			local SplitCommandString: {string} = SplitString(Argument.Text:gsub("^|(.-)|$", "%1", 1), true)
			return GetCurrentArgumentIndex(SplitCommandString, Position, (Offset + Argument.Start))
		elseif (IsBetween(Start, End)) then
			return Index, Arguments, Offset
		end
	end
end

return GetCurrentArgumentIndex