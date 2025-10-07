--!strict
--services
--packages
local React = require("@pkg/React")
--modules
local GameConfig = require("@shd/GameConfig")
local ReactTweenUtil = require("@shd/ReactTweenUtil")
local DeviceContext = require("@clt/Interfaces/DeviceContext")

local Button = require("@clt/Interfaces/Components/Button")
--types
--constants
local NOTIF_TIME = 3

local LARGE_TEXT_SIZE = 18
local TEXT_SIZE = 11
--remotes
--variables
local e = React.createElement
--references
--local functions

--class
return function(props: {
	TitleText: string,
	DescText: string,
	ImageId: number,

	OnAgree: () -> (),
	OnDisagree: (() -> ())?,
})
	local size, setSize = React.useBinding(Vector2.new(339, 79))

	local deviceContext = React.useContext(DeviceContext.context)

	local visible, setVisible = React.useState(true)
	-- React.useEffect(function()
	-- 	local thread = task.delay(NOTIF_TIME, function()
	-- 		setVisible(false)
	-- 	end)
	-- 	return function()
	-- 		task.cancel(thread)
	-- 	end
	-- end, {})

	local content = e("Frame", {
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		UIPadding = e("UIPadding", {
			PaddingTop = UDim.new(0, 15 * deviceContext.ScreenScale),
			PaddingBottom = UDim.new(0, 60 * deviceContext.ScreenScale),
		}),
		UIListLayout = e("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
		}),
		UIGradient = e("UIGradient", {
			Rotation = -90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.4),
				NumberSequenceKeypoint.new(1, 0.7),
			}),
		}),
		Frame = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 500 * deviceContext.ScreenScale, 0, 250 * deviceContext.ScreenScale),
			BackgroundColor3 = Color3.new(0, 0, 0),
		}, {
			Frame = e("Frame", {
				BackgroundTransparency = 0.5,
				Size = UDim2.new(0, 500 * deviceContext.ScreenScale, 0, 250 * deviceContext.ScreenScale),
				Position = ReactTweenUtil.tweenPos(
					if visible then UDim2.new(0, 0, 1, 0) else UDim2.new(),
					if visible then UDim2.new() else UDim2.new(0, 0, 1, 0),
					1,
					{ visible }
				),
				BackgroundColor3 = Color3.new(0, 0, 0),
			}, {
				UIPadding = e("UIPadding", {
					PaddingTop = UDim.new(0, 5 * deviceContext.ScreenScale),
					PaddingBottom = UDim.new(0, 5 * deviceContext.ScreenScale),
				}),
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 10 * deviceContext.ScreenScale),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
				}),
				UICorner = e("UICorner"),
				UIStroke = e("UIStroke"),

				TitleFrame = e("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 450 * deviceContext.ScreenScale, 0, 65 * deviceContext.ScreenScale),
				}, {
					UIListLayout = e("UIListLayout", {
						Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					IconFrame = e("ImageLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 45 * deviceContext.ScreenScale, 0, 45 * deviceContext.ScreenScale),
						Image = "rbxassetid://" .. (props.ImageId or GameConfig.ASSET_DATA.IMAGE_IDS.WARNING_ICON_ID),
					}),

					TitleFrame = e("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, (450 - 70) * deviceContext.ScreenScale, 0, 60 * deviceContext.ScreenScale),
						RichText = true,

						Text = props.TitleText,
						TextSize = LARGE_TEXT_SIZE * deviceContext.ScreenScale,
						TextWrapped = true,
						TextColor3 = Color3.new(1, 1, 1),
						TextXAlignment = Enum.TextXAlignment.Left,
					}),
				}),
				DescFrame = e("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 450 * deviceContext.ScreenScale, 0, 115 * deviceContext.ScreenScale),
				}, {
					UIListLayout = e("UIListLayout", {
						Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
					DescText = e("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 450 * deviceContext.ScreenScale, 0, 115 * deviceContext.ScreenScale),
						TextColor3 = Color3.new(1, 1, 1),
						RichText = true,

						Text = props.DescText,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextSize = TEXT_SIZE * deviceContext.ScreenScale,
					}),
				}),
				OptionsFrame = e("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 450 * deviceContext.ScreenScale, 0, 45 * deviceContext.ScreenScale),
				}, {
					UIListLayout = e("UIListLayout", {
						Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
					OKButton = e(Button, {
						Scale = 1 * deviceContext.ScreenScale,
						Visible = visible,
						Color = Color3.new(0.2, 0.6, 0.2),
						Text = "OK",
						Activated = function()
							props.OnAgree()

							setVisible(false)
						end,
						native = {
							Visible = visible,
							LayoutOrder = 1,
						},
					}),
					CancelButton = if props.OnDisagree
						then e(Button, {
							Scale = 1 * deviceContext.ScreenScale,
							Color = Color3.new(0.6, 0.2, 0.2),
							Text = "Cancel",
							Activated = function()
								if props.OnDisagree then
									props.OnDisagree()
								end

								setVisible(false)
							end,
							native = {
								Visible = visible,
								LayoutOrder = 2,
							},
						})
						else nil,
				}),
			}),
		}),
	})

	local out = e("CanvasGroup", {
		BackgroundTransparency = 1,

		GroupTransparency = ReactTweenUtil.tweenNumber(
			if visible then 1 else 0,
			if visible then 0 else 1,
			0.5,
			{ visible }
		),
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		Content = content,
	})

	return out
end
