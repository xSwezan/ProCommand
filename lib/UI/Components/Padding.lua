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
	PaddingTop: UDim?;
	PaddingBottom: UDim?;
	PaddingRight: UDim?;
	PaddingLeft: UDim?;

	Padding: UDim?;
}

return function(props: Props)
	return e("UIPadding"){
		PaddingTop = props.Padding or props.PaddingTop or UDim.new(0,5);
		PaddingBottom = props.Padding or props.PaddingBottom or UDim.new(0,5);
		PaddingRight = props.Padding or props.PaddingRight or UDim.new(0,5);
		PaddingLeft = props.Padding or props.PaddingLeft or UDim.new(0,5);
	}
end