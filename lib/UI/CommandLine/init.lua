local TextService = game:GetService("TextService")
local Fusion = require(script.Parent.Parent.Parent.Fusion)
local Corner = require(script.Parent.Components.Corner)
local Label = require(script.Parent.Components.Label)
local Padding = require(script.Parent.Components.Padding)
local ArgumentWidget = require(script.ArgumentWidget)
local SplitString = require(script.Parent.Parent.Util.SplitString)
local FusionTypes = require(script.Parent.FusionTypes)
local Registered = require(script.Parent.Parent.Registered)
local HasSemicolon = require(script.Parent.Parent.Util.HasSemicolon)
local IsCommandString = require(script.Parent.Parent.Util.IsCommandString)
local GetCurrentCommandIndex = require(script.Parent.Parent.Util.GetCurrentCommandIndex)
local GetCurrentArgumentIndex = require(script.Parent.Parent.Util.GetCurrentArgumentIndex)
local LevenshteinDistance = require(script.Parent.Parent.Util.LevenshteinDistance)
local Types = require(script.Parent.Parent.Types)

local e = Fusion.New
local Children = Fusion.Children
local Cleanup = Fusion.Cleanup
local Hydrate = Fusion.Hydrate
local Out = Fusion.Out
local Ref = Fusion.Ref
local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local OnChange = Fusion.OnChange
local Computed = Fusion.Computed
local Observer = Fusion.Observer
local Tween = Fusion.Tween
local Spring = Fusion.Spring
local ForPairs = Fusion.ForPairs
local ForKeys = Fusion.ForKeys
local ForValues = Fusion.ForValues

local Camera: Camera = workspace.CurrentCamera

export type Props = {
	
}

return function(props: Props)
	local Text = Value("Teleport xSwezan 50,50,50")
	local SplitText: FusionTypes.StateObject<{{Text: string, Start: number, End: number}}> = Computed(function()
		return SplitString(Text:get() or "", true)
	end)
	local TextParams: GetTextBoundsParams = Instance.new("GetTextBoundsParams")
	TextParams.Font = Font.new("rbxasset://fonts/families/Inconsolata.json")
	TextParams.Size = 20

	local CursorPosition = Value(1)
	local Focused = Value(false)

	local Error = Value(false)

	-- local CurrentArgument: FusionTypes.Value<{string}?> = Value()
	-- local CurrentArgument: FusionTypes.Value<{string}?> = Computed(function()
	-- 	local Split = SplitText:get()

	-- 	local Index, NewSplit = GetCurrentArgumentIndex(Split, CursorPosition:get())
	-- 	if not (Index) or not (NewSplit) then return end

	-- 	warn(Index, NewSplit)

	-- 	return NewSplit[Index]
	-- end)

	local CurrentCommandArgument: FusionTypes.Value<{string}?> = Computed(function()
		local Split = SplitText:get()
		if not (Split) then return end

		local CurrentArgumentIndex: number, Split: {} = GetCurrentArgumentIndex(Split, CursorPosition:get())
		if not (CurrentArgumentIndex) then return end
		if not (Split) then return end
		if not (Split[CurrentArgumentIndex]) then return end

		local CommandIndex: number = GetCurrentCommandIndex(Split, CurrentArgumentIndex)
		if not (CommandIndex) then return end

		local CommandObject = Registered.Commands[Split[CommandIndex].Text or ""]
		if not (CommandObject) then return end

		return (CommandObject.Arguments or {})[CurrentArgumentIndex - CommandIndex]
	end)

	local CurrentCommand: FusionTypes.StateObject<{Command: {}?, ArgumentIndex: number}> = Computed(function()
		local Split = SplitText:get()
		if not (Split) then return end

		local CurrentArgumentIndex: number, Split: {} = GetCurrentArgumentIndex(Split, CursorPosition:get())
		if not (CurrentArgumentIndex) then return end
		if not (Split) then return end
		if not (Split[CurrentArgumentIndex]) then return end

		local CommandIndex: number = GetCurrentCommandIndex(Split, CurrentArgumentIndex)
		if not (CommandIndex) then return end
		if not (Split[CommandIndex]) then return end

		local Name: string = string.lower(Split[CommandIndex].Text or "")
		for ThisName: string, Command in Registered.Commands do
			if (string.lower(ThisName) ~= Name) then continue end

			return Command
		end
	end)

	local CurrentAutocomplete = Computed(function()
		local Split = SplitText:get()
		if not (Split) then return end

		local CurrentArgumentIndex: number, Split: {} = GetCurrentArgumentIndex(Split, CursorPosition:get())
		if not (CurrentArgumentIndex) then return end
		if not (Split) then return end

		local RawArgument = Split[CurrentArgumentIndex]
		if not (RawArgument) then return end

		local AutocompletePool = {}

		local CommandIndex: number = GetCurrentCommandIndex(Split, CurrentArgumentIndex)
		local CommandObject: Types.CommandInfo = Registered.Commands[(Split[CommandIndex or 0] or {}).Text or ""]
		if (CommandIndex == CurrentArgumentIndex) then
			AutocompletePool = Registered.Commands
		elseif (CommandObject) then
			local ArgumentType: Types.TypeInfo = Registered.Types[CommandObject.Arguments[CurrentArgumentIndex - 1][1]]
			warn(ArgumentType)
			AutocompletePool = ArgumentType:Get(Split[CurrentArgumentIndex].Text)
		end

		print("RawArgument:", RawArgument)

		-- Get Autocompletes
		local Autocompletes: {[number]: {number & string}} = {}
		
		local RawText: string = string.lower(RawArgument.Raw)
		for Name: string, Entry: {Name: string} in AutocompletePool do
			local Distance: number = LevenshteinDistance(RawText, string.lower(Entry.Name))
			if (Distance >= #Entry.Name) then continue end

			table.insert(Autocompletes, {Distance, Name})
		end

		table.sort(Autocompletes,function(a, b)
			return (a[1] > b[1])
		end)

		-- Get closest Autocomplete
		local RawAutocomplete = Autocompletes[1]
		if not (RawAutocomplete) then return end

		local Autocomplete = AutocompletePool[RawAutocomplete]
		if not (Autocomplete) then return end

		local Text = Autocomplete.Text
		Text = `{string.rep(" ", Autocomplete.Start)}{Text}`

		return Text
	end)

	local TextBoxAbsolutePosition = Value(Vector2.new())
	local ArgumentWidgetAbsoluteSize = Value(Vector2.new())

	local ArgumentWidgetPosition = Spring(Computed(function()
		local AP: Vector2 = TextBoxAbsolutePosition:get() or Vector2.new()
		local WidgetAS: Vector2 = ArgumentWidgetAbsoluteSize:get() or Vector2.new()
		local CP: number = CursorPosition:get() or -1
		local End: number = -1

		local CurrentArgumentIndex: number, Split: {}, Offset: number = GetCurrentArgumentIndex(SplitText:get() or {}, CP)
		if (CurrentArgumentIndex) and (Split) then
			End = ((Split[CurrentArgumentIndex] or {}).End or End) + Offset
		end

		local Text: string = (Text:get() or ""):sub(0, End)

		TextParams.Text = Text
		local Bounds: Vector2 = TextService:GetTextBoundsAsync(TextParams)

		local FinalPosition: Vector2 = (AP + Vector2.new(Bounds.X, -15))

		return UDim2.fromOffset(math.clamp(FinalPosition.X, (WidgetAS.X * .5), Camera.ViewportSize.X - 10 - (WidgetAS.X * .5)), FinalPosition.Y)
	end),25,1)

	local CurrentArg = ArgumentWidget{
		Type = Computed(function()
			local Argument = CurrentCommandArgument:get() or {}
			return Argument[1] or ""
		end);
		Name = Computed(function()
			local Argument = CurrentCommandArgument:get() or {}
			return Argument[2] or ""
		end);
		Description = Computed(function()
			local Argument = CurrentCommandArgument:get() or {}
			return Argument[3] or ""
		end);

		Position = ArgumentWidgetPosition;

		Visible = Computed(function()
			return
			(CurrentCommandArgument:get() ~= nil) and
			(Focused:get())
		end);

		OutAbsoluteSize = ArgumentWidgetAbsoluteSize;
	}

	return {
		CurrentArg;
		e("Frame"){
			Name = "CommandLine";
			Size = UDim2.new(1,0,0,40);

			Position = UDim2.fromScale(0,1);
			AnchorPoint = Vector2.new(0,1);
			
			BackgroundColor3 = Color3.fromRGB(25,27,29);
			BackgroundTransparency = .3;
		
			[Children] = {
				Corner{};
				Label{
					Name = "Label";

					Size = UDim2.fromOffset(30,30);

					Position = UDim2.new(0,15,.5,0);
					AnchorPoint = Vector2.new(.5,.5);

					Text = "$";
					TextColor3 = Color3.fromRGB(0,170,255);
					TextSize = 25;
					-- FontWeight = Enum.FontWeight.Bold;
				};
				Label{
					Name = "DEBUG";

					Size = UDim2.new(1,-30,0,30);
					AutomaticSize = Enum.AutomaticSize.None;

					Position = UDim2.fromScale(1,.5) - UDim2.fromOffset(0,15);
					AnchorPoint = Vector2.new(1,.5);

					Text = Computed(function()
						local CurrentPosition = CursorPosition:get() or -1

						local Output = ""
						
						for i = 1, #((Text:get() or "").." ") do
							local Color = if (CurrentPosition == i) then "#00ff00" elseif (i % 2 == 1) then "#FFFFFF" else "#000000"
							Output = `{Output}<font color='{Color}'>{("%2i"):format(i)}</font>`
						end

						return Output
					end);
					TextSize = TextParams.Size * .5;
					TextXAlignment = Enum.TextXAlignment.Left;
					FontFace = TextParams.Font;
					-- FontWeight = Enum.FontWeight.Bold;
				};
				Padding{};
				e("TextBox"){
					Name = "CommandInput";

					Size = UDim2.new(1,-30,0,30);

					Position = UDim2.fromScale(1,.5);
					AnchorPoint = Vector2.new(1,.5);

					BackgroundTransparency = 1;

					FontFace = TextParams.Font;
					Text = Text;
					TextColor3 = Spring(Computed(function()
						return if (Error:get()) then
							Color3.fromRGB(255,0,0)
						else
							Color3.fromRGB(255,255,255)
					end),25,2);
					TextSize = TextParams.Size;
					TextXAlignment = Enum.TextXAlignment.Left;

					CursorPosition = -1;
					ClearTextOnFocus = false;

					ZIndex = 2;

					[OnEvent("Focused")] = function()
						Focused:set(true)
					end;
					[OnEvent("FocusLost")] = function()
						Focused:set(false)
					end;

					[Out("AbsolutePosition")] = TextBoxAbsolutePosition;
					[Out("CursorPosition")] = CursorPosition;
					[Out("Text")] = Text;
				};
				e("TextLabel"){
					Name = "AutoComplete";

					Size = UDim2.new(1,-30,0,30);

					Position = UDim2.fromScale(1,.5);
					AnchorPoint = Vector2.new(1,.5);

					BackgroundTransparency = 1;

					FontFace = TextParams.Font;
					Text = Computed(function()
						return CurrentAutocomplete:get() or ""
					end);
					TextColor3 = Color3.fromRGB(100,100,100);
					TextSize = TextParams.Size;
					TextXAlignment = Enum.TextXAlignment.Left;
				};
			};
		}
	}
end