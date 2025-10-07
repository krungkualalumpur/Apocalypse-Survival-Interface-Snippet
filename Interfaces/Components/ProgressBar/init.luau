--!strict
--services
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local JoinUtil = require("@shd/JoinUtil")
--types
--constants
--remotes
--variables
local e = React.createElement
--references
--local functions
--class
return function(props: { Ratio: number, Length: number?, Thickness: number?, Color: Color3?, native: { [any]: any }? })
	local length = props.Length or 150
	local thickness = props.Thickness or 20
	local out = e(
		"Frame",
		JoinUtil({
			Size = UDim2.fromOffset(length, thickness),
			BackgroundColor3 = Color3.new(1, 1, 1),
		}, props.native),
		{
			UICorner = e("UICorner", {}),
			UIStroke = e("UIStroke", {
				Color = Color3.new(1, 1, 1),
				Thickness = 2,
			}),
			ContentBar = e("Frame", {
				BackgroundColor3 = props.Color or Color3.new(0.043137, 0.788235, 0.078431),
				Size = UDim2.fromScale(props.Ratio, 1),
			}, {
				UICorner = e("UICorner", {}),
			}),
		}
	)
	return out
end
