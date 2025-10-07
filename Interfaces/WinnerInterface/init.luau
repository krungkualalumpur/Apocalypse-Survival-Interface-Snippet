--!strict
--services
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local ReactTweenUtil = require("@shd/ReactTweenUtil")
--types
--constants
--remotes
--variables
local e = React.createElement
--references
--local functions
--class
return function(props)
	local tweenSpeed = 0.25

	local visible, setVisible = React.useState(true)

	--test only
	React.useEffect(function()
		-- task.delay(2, function()
		-- 	setVisible(false)
		-- end)
	end, {})
	--

	local out = e("Frame", {
		BackgroundColor3 = Color3.new(0.21176472306251526, 0.21176472306251526, 0.21176472306251526),
		BackgroundTransparency = ReactTweenUtil.tweenNumber(
			if visible then 1 else 0,
			if visible then 0 else 1,
			tweenSpeed,
			{ visible }
		),
		BorderColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		UIGradient = e("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0.4156862795352936, 0.4156862795352936, 0.4156862795352936)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Rotation = -90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.21875),
				NumberSequenceKeypoint.new(0.14713217318058014, 0.22499996423721313),
				NumberSequenceKeypoint.new(0.3478803038597107, 0.34375),
				NumberSequenceKeypoint.new(0.6359102725982666, 0.831250011920929),
				NumberSequenceKeypoint.new(0.8379052877426147, 1),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}, {}),
		PlayerListFrame = e("CanvasGroup", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			GroupTransparency = ReactTweenUtil.tweenNumber(
				if visible then 1 else 0,
				if visible then 0 else 1,
				tweenSpeed,
				{ visible }
			),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			Position = ReactTweenUtil.tweenPos(
				if visible then UDim2.new(0.5, 0, 1, 0) else UDim2.new(0.5, 0, 0.5, 0),
				if visible then UDim2.new(0.5, 0, 0.5, 0) else UDim2.new(0.5, 0, 1, 0),
				tweenSpeed,
				{ visible }
			),
			Size = UDim2.new(0, 483, 0, 329),
		}, {
			PageFrame = e("Frame", {
				Size = UDim2.new(0, 483, 0, 329),
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0, 5),
				}, {}),
				UIStroke = e("UIStroke", {
					Color = Color3.new(0.1764705926179886, 0.1764705926179886, 0.1764705926179886),
					Thickness = 1.4,
				}, {}),
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5),
				}, {}),
				UIGradient = e("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(
							0,
							Color3.new(0.04313725605607033, 0.04313725605607033, 0.3019607961177826)
						),
						ColorSequenceKeypoint.new(
							1,
							Color3.new(0.09803921729326248, 0.09803921729326248, 0.5411764979362488)
						),
					}),
					Rotation = -90,
				}, {}),
				Header = e("Frame", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 483, 0, 42),
				}, {
					TitleText = e("TextLabel", {
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Position = UDim2.new(0.02380952425301075, 0, 0.1190476194024086, 0),
						Size = UDim2.new(0, 432, 0, 32),
						FontFace = Font.new(
							"rbxasset://fonts/families/SourceSansPro.json",
							Enum.FontWeight.Bold,
							Enum.FontStyle.Normal
						),
						Text = "PLAYER LIST",
						TextColor3 = Color3.new(1, 1, 1),
						TextSize = 22,
					}, {}),
					UIListLayout = e("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 5),
					}, {}),
					CloseButton = e("TextButton", {
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = 2,
						Size = UDim2.new(0, 23, 0, 29),
						FontFace = Font.new(
							"rbxasset://fonts/families/SourceSansPro.json",
							Enum.FontWeight.Bold,
							Enum.FontStyle.Normal
						),
						Text = "X",
						TextColor3 = Color3.new(1, 1, 1),
						TextSize = 22,
						[React.Event.Activated] = function()
							setVisible(false)
						end,
					}, {}),
				}),
				Content = e("Frame", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Size = UDim2.new(0, 483, 0, 282),
				}, {
					ScrollingContentFrame = e("ScrollingFrame", {
						Active = true,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = 2,
						Size = UDim2.new(0, 483, 0, 282),
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(0, 0, 0, 0),
						ScrollBarImageColor3 = Color3.new(0.3294117748737335, 0.35686275362968445, 0.7215686440467834),
						ScrollingDirection = Enum.ScrollingDirection.Y,
					}, {
						UICorner = e("UICorner", {
							CornerRadius = UDim.new(0, 5),
						}, {}),
						UIListLayout = e("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 12),
						}, {}),
						UIPadding = e("UIPadding", {
							PaddingBottom = UDim.new(0, 15),
							PaddingTop = UDim.new(0, 15),
						}, {}),
						Frame = e("Frame", {
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.new(0, 0, 0),
							BorderSizePixel = 0,
							Size = UDim2.new(0, 460, 0, 37),
						}, {
							PlayerName = e("TextLabel", {
								BackgroundColor3 = Color3.new(
									0.3294117748737335,
									0.35686275362968445,
									0.7215686440467834
								),
								BorderColor3 = Color3.new(0, 0, 0),
								BorderSizePixel = 0,
								LayoutOrder = 2,
								Position = UDim2.new(0.11195649206638336, 0, 0, 0),
								Size = UDim2.new(0, 408, 0, 37),
								FontFace = Font.new(
									"rbxasset://fonts/families/SourceSansPro.json",
									Enum.FontWeight.Regular,
									Enum.FontStyle.Normal
								),
								Text = "aryoseno11",
								TextColor3 = Color3.new(0.8313726186752319, 0.8313726186752319, 0.8313726186752319),
								TextSize = 18,
							}, {
								UICorner = e("UICorner", {
									CornerRadius = UDim.new(0, 4),
								}, {}),
							}),
							UIListLayout = e("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = UDim.new(0, 12),
							}, {}),
							AvatarLabel = e("ImageLabel", {
								BackgroundColor3 = Color3.new(
									0.7843137979507446,
									0.7843137979507446,
									0.7843137979507446
								),
								BorderColor3 = Color3.new(0, 0, 0),
								BorderSizePixel = 0,
								LayoutOrder = 1,
								Size = UDim2.new(0, 37, 0, 37),
							}, {
								UICorner = e("UICorner", {
									CornerRadius = UDim.new(0, 4),
								}, {}),
							}),
						}),
					}),
				}),
			}),
		}),
	})
	return out
end
