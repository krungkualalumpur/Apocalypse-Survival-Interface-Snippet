--!strict
--services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
--types
--constants
--remotes
--variables
local e = React.createElement
--references
--local functions
function rotateV2(v2: Vector2, rdDelta: number)
	return Vector2.new(
		v2.X * math.cos(rdDelta) - v2.Y * math.sin(rdDelta),
		v2.X * math.sin(rdDelta) + v2.Y * math.cos(rdDelta)
	)
end
--class
return function(props: {
	Radius: number,
	Progress: React.Binding<number>,
})
	local circle = {}

	local _q = 32
	for i = 1, _q do
		local rad = 2 * math.pi * (i / _q)
		local radius = props.Radius
		local _width = 0.2 * props.Radius
		local relativeAbsPos = Vector2.new(0, radius * 0.5)
		local relativeAbsSize = Vector2.new(_width, radius)

		local absPos = rotateV2(relativeAbsPos, rad + math.pi)
		table.insert(
			circle,
			e("Frame", {
				BorderSizePixel = 0,
				Rotation = math.deg(rad),
				BackgroundColor3 = Color3.fromRGB(210, 210, 210),
				Visible = props.Progress:map(function(num: number)
					return if num > i / _q then true else false
				end),
				Position = UDim2.fromOffset(
					(props.Radius * 2) * 0.5 + absPos.X - _width * 0.5,
					(props.Radius * 2) * 0.5 + absPos.Y - radius * 0.5
				),
				Size = UDim2.fromOffset(relativeAbsSize.X, relativeAbsSize.Y),
			})
		)
	end

	local out = e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(props.Radius * 2, props.Radius * 2),
	}, { e(React.Fragment, nil, circle) })
	return out
end
