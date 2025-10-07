--!strict
--services
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local GameConfig = require("@shd/GameConfig")
local ReactTweenUtil = require("@shd/ReactTweenUtil")

local JoinUtil = require("@shd/JoinUtil")
local SoundUtil = require("@shd/SoundUtil")
--types
--constants
local TWEEN_SPEED = 0.15
local SMALL_TEXT_SIZE = 10
local MEDIUM_TEXT_SIZE = 15

local BUTTON_SIZE = 35
--remotes
--variables
local e = React.createElement
--references
--local functions
--class
return function(props: {
	Text: string?,
	Image: number?,
	Color: Color3?,
	Scale: number?,
	Activated: () -> (),
	native: { [any]: any }?,
})
	local scale = props.Scale or 1

	local isHovered, setIsHovered = React.useState(false)

	local onStart, setOnStart = React.useState(true)

	React.useEffect(function()
		if isHovered then
			setOnStart(false)
		end

		return function() end
	end, { isHovered })

	local rawColor = (props.Color or Color3.new(0.7, 0.7, 0.7))

	local color = ReactTweenUtil.tweenColor3(
		if onStart
			then Color3.new(rawColor.R, rawColor.G, rawColor.B)
			elseif isHovered then Color3.new(rawColor.R, rawColor.G, rawColor.B)
			else Color3.new(
				rawColor.R - rawColor.R * 0.15,
				rawColor.G - rawColor.G * 0.15,
				rawColor.B - rawColor.B * 0.15
			),
		if isHovered
			then Color3.new(
				rawColor.R - rawColor.R * 0.15,
				rawColor.G - rawColor.G * 0.15,
				rawColor.B - rawColor.B * 0.15
			)
			else Color3.new(rawColor.R, rawColor.G, rawColor.B),
		TWEEN_SPEED,
		{ isHovered }
	)

	local out = e(
		"TextButton",
		JoinUtil({
			Position = UDim2.fromScale(0.5, 0.5),
			AutoButtonColor = false,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(BUTTON_SIZE * scale, BUTTON_SIZE * scale),
			Text = "",
			[React.Event.Activated] = function()
				SoundUtil.playLocalSound(GameConfig.SOUND_DATA.SOUND_IDS.ON_BUTTON_CLICK_SOUND, 1)
				props.Activated()
			end,
			[React.Event.MouseEnter] = function()
				setIsHovered(true)
			end,
			[React.Event.MouseLeave] = function()
				setIsHovered(false)
			end,
		}, props.native),
		{
			UIPadding = e("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			UICorner = e("UICorner"),

			UIGradient = e("UIGradient", {
				Rotation = -90,
				Color = color:map(function(color3: Color3)
					return ColorSequence.new(color3)
				end),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 0.5),
				}),
			}),

			UIStroke = e("UIStroke", {
				Color = Color3.new(0.380392, 0.380392, 0.380392),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 1,
			}),

			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			ImageLabel = e("ImageLabel", {
				BackgroundTransparency = 1,
				Visible = if props.Image ~= nil then true else false,
				Size = UDim2.fromOffset(BUTTON_SIZE * scale, BUTTON_SIZE * scale),
				AutomaticSize = Enum.AutomaticSize.X,
				Image = if props.Image ~= nil then `rbxassetid://{props.Image}` else "",
				ImageColor3 = Color3.new(1, 1, 1),
			}),

			TextLabel = e("TextLabel", {
				BackgroundTransparency = 1,
				Visible = if props.Text ~= nil then true else false,
				Size = UDim2.fromOffset(0, BUTTON_SIZE),
				AutomaticSize = Enum.AutomaticSize.X,
				Font = Enum.Font.Gotham,
				Text = props.Text,
				TextSize = MEDIUM_TEXT_SIZE * scale,
				TextColor3 = Color3.new(1, 1, 1),
			}),
		}
	)
	return out
end
