local Fusion = require(script.Parent.Parent.Parent.Parent.Fusion)
local Widget = require(script.Parent.Parent.Widget)
local Label = require(script.Parent.Parent.Components.Label)
local FusionTypes = require(script.Parent.Parent.FusionTypes)
local get = require(script.Parent.Parent.Parent.Util.get)

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
	Type: FusionTypes.CanBeState<string>;
	Name: FusionTypes.CanBeState<string>?;
	Description: FusionTypes.CanBeState<string>?;

	Position: FusionTypes.CanBeState<UDim2>?;

	OutAbsoluteSize: FusionTypes.Value<Vector2>?;

	Visible: FusionTypes.CanBeState<boolean>?;
}

return function(props: Props)
	return Widget{
		Position = props.Position;

		Visible = props.Visible;

		OutAbsoluteSize = props.OutAbsoluteSize;

		[Children] = {
			if not (props.Description) then nil else Label{
				Name = "Description";

				AutomaticSize = Enum.AutomaticSize.XY;

				Text = props.Description;
				TextColor3 = Color3.fromRGB(208,208,208);
				TextSize = 17;
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");

				LayoutOrder = 1;

				Visible = Computed(function()
					return ((get(props.Description) or "") ~= "")
				end);
			};
			e("Frame"){
				Name = "Type";

				Size = UDim2.new();

				AutomaticSize = Enum.AutomaticSize.XY;

				BackgroundTransparency = 1;
	
				[Children] = {
					e("UIListLayout"){
						Padding = UDim.new(0,5);
						FillDirection = Enum.FillDirection.Horizontal;
						SortOrder = Enum.SortOrder.LayoutOrder;
						VerticalAlignment = Enum.VerticalAlignment.Center;
					};
					Label{
						Name = "Name";

						Text = Computed(function()
							local Name: string = get(props.Name) or ""
							local Type: string = get(props.Type) or ""

							return if (Name == "") then Type else Name
						end);
						TextColor3 = Color3.fromRGB(255,255,255);
						TextSize = 20;
						FontFace = Font.new(
							"rbxasset://fonts/families/SourceSansPro.json",
							Enum.FontWeight.Bold
						);
					};
					Label{
						Name = "Type";

						Text = props.Type;
						TextColor3 = Color3.fromRGB(200,200,200);
						TextSize = 15;
						FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");

						LayoutOrder = 1;
					};
				};
			};
		};
	}
end