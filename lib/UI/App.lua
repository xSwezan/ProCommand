local Fusion = require(script.Parent.Parent.Parent.Fusion)
local Padding = require(script.Parent.Components.Padding)
local CommandLine = require(script.Parent.CommandLine)

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

export type Props = {
	
}

return function(props: Props)
	local CommandLine = CommandLine{}

	return e("ScreenGui"){
		Name = "ProCommand";
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
	
		[Children] = {
			Padding{};
			CommandLine;
		};
	}
end