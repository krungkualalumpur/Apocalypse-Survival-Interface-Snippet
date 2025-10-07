--!strict
--services
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local GameConfig = require("@shd/GameConfig")
local ReactTweenUtil = require("@shd/ReactTweenUtil")
local SoundUtil = require("@shd/SoundUtil")

local DeviceContext = require("@clt/Interfaces/DeviceContext")
--types
--constants
local TWEEN_SPEED = 0.15
local SMALL_TEXT_SIZE = 10
local MEDIUM_TEXT_SIZE = 15
local BIG_TEXT_SIZE = 40

local BUTTON_SIZE = 35
--remotes
--variables
local e = React.createElement
--references
--local functions
--class
return function(props: {
	SecondsLeft: number,
})
	local deviceContext = React.useContext(DeviceContext.context)

	return e("CanvasGroup", {
		BackgroundTransparency = 1,
		GroupTransparency = ReactTweenUtil.tweenNumber(1, 0, 1, {}),
		BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		Content = e("Frame", {
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			UIPadding = e("UIPadding", {
				PaddingBottom = UDim.new(0, 40),
			}),
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
			}),
			UIGradient = e("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.5, 0.75),
					NumberSequenceKeypoint.new(1, 0.75),
				}),
			}),
			Content = e("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 300 * deviceContext.ScreenScale, 0, 275 * deviceContext.ScreenScale),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					FillDirection = Enum.FillDirection.Vertical,
				}),
				DescFrame = e("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 300 * deviceContext.ScreenScale, 0, 75 * deviceContext.ScreenScale),
					TextColor3 = Color3.new(1, 1, 1),
					Text = "You are shielded until",
					TextStrokeTransparency = 0.6,
					TextSize = MEDIUM_TEXT_SIZE * deviceContext.ScreenScale,
				}),
				SecondsFrame = e("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					TextTransparency = ReactTweenUtil.tweenNumber(1, 0, 0.5, { props.SecondsLeft }, true),
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 300 * deviceContext.ScreenScale, 0, 75 * deviceContext.ScreenScale),
					TextColor3 = if props.SecondsLeft > 5 then Color3.new(1, 1, 1) else Color3.new(1, 0, 0),
					Text = tostring(props.SecondsLeft),
					TextStrokeTransparency = 0.6,
					TextSize = ReactTweenUtil.tweenNumber(
						if props.SecondsLeft <= 5
							then BIG_TEXT_SIZE * deviceContext.ScreenScale * 2
							else BIG_TEXT_SIZE * deviceContext.ScreenScale,
						BIG_TEXT_SIZE * deviceContext.ScreenScale,
						0.25,
						{ props.SecondsLeft }
					),
				}),
				SecondsTextLabel = e("TextLabel", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 300 * deviceContext.ScreenScale, 0, 100 * deviceContext.ScreenScale),
					Text = "seconds",
					TextColor3 = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.6,
					TextSize = MEDIUM_TEXT_SIZE * deviceContext.ScreenScale,
				}),
			}),
			Footer = e("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 300 * deviceContext.ScreenScale, 0, 100 * deviceContext.ScreenScale),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					FillDirection = Enum.FillDirection.Horizontal,
				}),

				SecondsTextLabel = e("TextLabel", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 300 * deviceContext.ScreenScale, 0, 100 * deviceContext.ScreenScale),
					RichText = true,
					Text = "<b>FIND SAFE SPOT IMMEDIATELY</b>",
					TextColor3 = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.6,
					TextSize = MEDIUM_TEXT_SIZE * deviceContext.ScreenScale,
				}),
			}),
		}),
	})
end
