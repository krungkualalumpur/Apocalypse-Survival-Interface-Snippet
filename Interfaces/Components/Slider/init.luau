--!strict
--services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
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
local player = Players.LocalPlayer
--local functions
--class
return function(props: {
	Ratio: number,
	OnSliderClickDown: () -> (),
	OnSliderClickUp: () -> (),
	OnRatioSet: (number) -> (),
	Color: Color3?,
	Length: number?,
	Thickness: number?,
	native: { [any]: any }?,
})
	local length = props.Length or 150
	local thickness = props.Thickness or 12

	local isClicking, setIsClicking = React.useState(false)

	-- local isClicked, setIsClicked = React.useState(false)

	local sliderRef = React.useRef(nil :: any)

	React.useEffect(function()
		local conn1
		if isClicking then
			props.OnSliderClickDown()

			conn1 = RunService.Heartbeat:Connect(function()
				local mousePos = player:GetMouse()
				local sliderInst: Frame? = sliderRef.current
				local sliderSize = if sliderInst then sliderInst.AbsoluteSize else Vector2.new()
				local sliderPos = if sliderInst then sliderInst.AbsolutePosition else Vector2.new()

				props.OnRatioSet(math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1))

				if isClicking and not (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
					setIsClicking(false)
					props.OnSliderClickUp()
				end
			end)
		end
		return function()
			if conn1 then
				conn1:Disconnect()
			end
		end
	end, { isClicking } :: { any })

	-- React.useEffect(function()
	-- 	local conn1 = RunService.Heartbeat:Connect(function()
	-- 		if isClicking then
	-- 			local mousePos = player:GetMouse()
	-- 			local sliderInst: Frame? = sliderRef.current
	-- 			local sliderSize = if sliderInst then sliderInst.AbsoluteSize else Vector2.new()
	-- 			local sliderPos = if sliderInst then sliderInst.AbsolutePosition else Vector2.new()

	-- 			props.OnRatioSet(math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1))
	-- 		end
	-- 	end)
	-- 	return function()
	-- 		conn1:Disconnect()
	-- 	end
	-- end, { isClicking })

	local out = e(
		"Frame",
		JoinUtil({
			Size = UDim2.fromOffset(length, thickness),
			BackgroundColor3 = Color3.new(1, 1, 1),
			ref = sliderRef,
		}, props.native),
		{
			UICorner = e("UICorner", {}),
			UIStroke = e("UIStroke", {
				Color = Color3.new(1, 1, 1),
				Thickness = 2,
			}),
			ContentBar = e("Frame", {
				BackgroundColor3 = props.Color or Color3.new(0.4, 0.4, 0.4),
				Size = UDim2.fromScale(props.Ratio, 1),
			}, {
				UICorner = e("UICorner", {}),
			}),
			ButtonSlider = e("ImageButton", {
				ZIndex = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = props.Color or Color3.new(0.4, 0.4, 0.4),
				Position = UDim2.fromScale(props.Ratio, 0.5),
				Size = UDim2.fromOffset(8, thickness * 2.2),
				[React.Event.MouseButton1Down] = function()
					setIsClicking(true)
				end,
			}, {
				UICorner = e("UICorner"),
				UIStroke = e("UIStroke", {
					Thickness = 4,
					Color = Color3.new(1, 1, 1),
				}),
			}),
		}
	)
	return out
end
