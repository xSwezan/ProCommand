local Fusion = require(script.Parent.Parent.Parent.Fusion)
local Padding = require(script.Parent.Components.Padding)
local Corner = require(script.Parent.Components.Corner)
local FusionTypes = require(script.Parent.FusionTypes)

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
	Position: UDim2?;

	OutAbsoluteSize: FusionTypes.Value<Vector2>?;

	Visible: FusionTypes.CanBeState<boolean>?;
}

return function(props: Props)
	return e("Frame"){
		Name = "Widget";

		Size = UDim2.fromOffset(20,20);

		Position = props.Position;
		AnchorPoint = Vector2.new(.5,1);
		
		AutomaticSize = Enum.AutomaticSize.XY;
		BackgroundColor3 = Color3.fromRGB(25,27,29);
		BackgroundTransparency = .3;

		Visible = props.Visible;

		[Out("AbsoluteSize")] = props.OutAbsoluteSize;
	
		[Children] = {
			Padding{
				Padding = UDim.new(0,10);
			};
			Corner{};
			e("UIListLayout"){
				SortOrder = Enum.SortOrder.LayoutOrder;
			};
			props[Children];
		};
	}
end