local Fusion = require(script.Parent.Parent.Parent.Parent.Fusion)

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
	[string]: any?,
}

return function(props: Props)
	return Hydrate(e("TextLabel")({
		Name = "Label",

		Size = UDim2.new(),
		AutomaticSize = Enum.AutomaticSize.XY;

		Position = UDim2.fromScale(.5, .5),
		AnchorPoint = Vector2.new(.5, 0),

		BackgroundTransparency = 1,
		BorderSizePixel = 0,

		TextColor3 = Color3.fromRGB(255, 255, 255),
		FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json"),
		TextSize = 60,
		RichText = true;
	}))(props)
end