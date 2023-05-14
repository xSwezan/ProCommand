local FindAll = require(script.Parent.FindAll)

return function(String: string, Advanced: boolean?): {string} | {Text: string, Raw: string, Start: number, End: number}
	local Output: {string} = {}
	local Advanced: boolean = (Advanced == true)

	local InString = false
	local QuoteMark = ""
	local StringBuffer = ""
	local StringStart

	for Start: number, End: number, Match: string in FindAll(String, "([^ ]+)") do
		local OpeningStringMark = Match:match(`^(['"|])`)
		if (OpeningStringMark) and not (InString) then
			StringBuffer = ""
			QuoteMark = OpeningStringMark
			StringStart = Start
			InString = true
		end

		local ClosingStringMark = Match:gsub(";$", ""):match(`(['"|])$`)
		if (InString) then
			StringBuffer = if (StringBuffer == "") then Match else `{StringBuffer} {Match}`
			if (ClosingStringMark) and (ClosingStringMark == QuoteMark) then
				local Raw = StringBuffer
				local MatchOutput: string = StringBuffer:gsub(`^(['"])(.-)%1$`, "%2", 1)
				table.insert(Output, if (Advanced) then {
					Text = MatchOutput,
					Raw = Raw,
					Start = StringStart,
					End = End
				} else MatchOutput)
				InString = false
			end
			continue
		end
		
		table.insert(Output, if (Advanced) then {
			Text = Match,
			Raw = Match,
			Start = Start,
			End = End,
		} else Match)
	end

	-- Check if there is a space at the end
	if (String:match(" $")) then
		table.insert(Output, if (Advanced) then {
			Text = "",
			Raw = "",
			Start = #String,
			End = #String,
		} else "")
	end
	
	return Output
end