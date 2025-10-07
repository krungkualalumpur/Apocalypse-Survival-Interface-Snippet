--!strict
--services
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local ReactTweenUtil = require("@shd/ReactTweenUtil")
local JoinUtil = require("@shd/JoinUtil")
--types
--constants
local TRANSLUCENT_TRANSPARENCY = 0.35
--remotes
--variables
local e = React.createElement
--references
--local functions
--class
return function(
	props: {
		HasImage: boolean,
		Translucent: boolean,
		Text: string,
		Color: Color3?,
		ImageId: string?,
		Length: number?,
		native: { [any]: any }?,
	},
	children: { [any]: any }
)
	local length = props.Length or 250
	local out = e(
		"CanvasGroup",
		JoinUtil({
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.new(0, length, 0, 37),
		}, props.native),
		{
			UIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 12),
			}, {}),

			TextLabel = e("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = if props.Translucent then TRANSLUCENT_TRANSPARENCY else 0,
				BackgroundColor3 = props.Color or Color3.new(0.33, 0.36, 0.72),
				Position = UDim2.new(0.11195649206638336, 0, 0, 0),
				Size = UDim2.new(0, if props.HasImage then length - 52 else length, 0, 37),
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, {}),

				UIGradient = if props.Translucent
					then e("UIGradient", {
						Rotation = 90,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
							ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5)),
						}),
					})
					else nil,

				TextLabel = e("TextLabel", {
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.new(0, if props.HasImage then length - 52 else length, 0, 37),
					Font = Enum.Font.Gotham,

					Text = props.Text,
					TextColor3 = Color3.new(0.8313726186752319, 0.8313726186752319, 0.8313726186752319),
					TextSize = 18,
				}, {}),
			}),

			ImageFrame = e("Frame", {
				BackgroundColor3 = Color3.new(0.913725, 0.913725, 0.913725),
				Visible = props.HasImage,

				BackgroundTransparency = if props.Translucent then 0.25 else 0,

				LayoutOrder = 1,
				Size = UDim2.new(0, 37, 0, 37),
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, {}),
				UIGradient = if props.Translucent
					then e("UIGradient", {
						Rotation = 90,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
							ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5)),
						}),
					})
					else nil,

				ImageLabel = e("ImageLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(0, 37, 0, 37),
					Image = props.ImageId or "",
				}, {}),
			}),
		}
	)
	return out
end
