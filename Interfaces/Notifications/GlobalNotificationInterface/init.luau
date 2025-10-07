--!strict
--services
--packages
local React = require("@pkg/React")
--modules
local ReactTweenUtil = require("@shd/ReactTweenUtil")
local DeviceContext = require("@clt/Interfaces/DeviceContext")

--types
--constants
local NOTIF_TIME = 3
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
	Severity: number?,
})
	local severity = props.Severity or 3

	local deviceContext = React.useContext(DeviceContext.context)

	local size, setSize = React.useBinding(Vector2.new(339 * deviceContext.ScreenScale, 79 * deviceContext.ScreenScale))

	local visible, setVisible = React.useState(true)
	React.useEffect(function()
		local thread = task.delay(NOTIF_TIME, function()
			setVisible(false)
		end)
		return function()
			task.cancel(thread)
		end
	end, {})

	local content = e("CanvasGroup", {
		BackgroundTransparency = 1,
		BorderColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 339 * deviceContext.ScreenScale, 0, 79 * deviceContext.ScreenScale),
		GroupTransparency = ReactTweenUtil.tweenNumber(
			if visible then 1 else 0,
			if visible then 0 else 1,
			0.5,
			{ visible }
		),
		Position = ReactTweenUtil.tweenPos(
			UDim2.fromScale(0, if visible then -1 else 0),
			UDim2.fromScale(0, if visible then 0 else -1),
			0.5,
			{ visible }
		),
	}, {

		Frame = e("Frame", {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 339 * deviceContext.ScreenScale, 0, 68 * deviceContext.ScreenScale),
			[React.Event.Changed] = function(self: Frame)
				setSize(self.AbsoluteSize)
			end,
		}, {
			UIGradient = e("UIGradient", {
				Color = if severity == 3
					then ColorSequence.new({
						ColorSequenceKeypoint.new(
							0,
							Color3.new(0.23529411852359772, 0.5960784554481506, 0.14509804546833038)
						),
						ColorSequenceKeypoint.new(
							0.4685908555984497,
							Color3.new(0.16470588743686676, 0.40392157435417175, 0.10196078568696976)
						),
						ColorSequenceKeypoint.new(
							1,
							Color3.new(0.07450980693101883, 0.18431372940540314, 0.0470588244497776)
						),
					})
					elseif severity == 2 then ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(0.596078, 0.564706, 0.145098)),
						ColorSequenceKeypoint.new(0.4685908555984497, Color3.new(0.403922, 0.384314, 0.101961)),
						ColorSequenceKeypoint.new(1, Color3.new(0.184314, 0.176471, 0.047059)),
					})
					else ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(0.596078, 0.145098, 0.145098)),
						ColorSequenceKeypoint.new(0.4685908555984497, Color3.new(0.403922, 0.101961, 0.101961)),
						ColorSequenceKeypoint.new(1, Color3.new(0.184314, 0.047059, 0.047059)),
					}),
				Rotation = -90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.5),
					NumberSequenceKeypoint.new(1, 0.5),
				}),
			}, {}),
			UIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10 * deviceContext.ScreenScale),
			}, {}),
			TextFrame = e("Frame", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 4,
				Position = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 252 * deviceContext.ScreenScale, 0, 70 * deviceContext.ScreenScale),
			}, {
				DescLabel = e("TextLabel", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 252 * deviceContext.ScreenScale, 0, 40 * deviceContext.ScreenScale),
					FontFace = Font.new(
						"rbxasset://fonts/families/SourceSansPro.json",
						Enum.FontWeight.Regular,
						Enum.FontStyle.Normal
					),
					RichText = true,
					Text = props.DescText,
					TextColor3 = Color3.new(0.8549020290374756, 0.8549020290374756, 0.8549020290374756),
					TextSize = 15 * deviceContext.ScreenScale,
					TextXAlignment = Enum.TextXAlignment.Left,
				}, {}),
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
				}, {}),
				TitleLabel = e("TextLabel", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 252 * deviceContext.ScreenScale, 0, 30 * deviceContext.ScreenScale),
					FontFace = Font.new(
						"rbxasset://fonts/families/SourceSansPro.json",
						Enum.FontWeight.Regular,
						Enum.FontStyle.Normal
					),
					RichText = true,
					Text = props.TitleText,
					TextColor3 = if severity == 3
						then Color3.new(0.46666669845581055, 1, 0.501960813999176)
						elseif severity == 2 then Color3.new(0.992157, 1, 0.466667)
						else Color3.new(1, 0.466667, 0.466667),
					TextSize = 25 * deviceContext.ScreenScale,
					TextStrokeTransparency = 0.75,
					TextXAlignment = Enum.TextXAlignment.Left,
				}, {}),
			}),
			IconFrame = e("Frame", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 3,
				Size = UDim2.new(0, 68 * deviceContext.ScreenScale, 0, 68 * deviceContext.ScreenScale),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
				}, {}),
				ImageLabel = e("ImageLabel", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 68 * deviceContext.ScreenScale, 0, 68 * deviceContext.ScreenScale),
					Image = `rbxassetid://{props.ImageId}`,
					ImageColor3 = if severity == 3
						then Color3.new(0.5098039507865906, 0.9058824181556702, 0.6000000238418579)
						elseif severity == 2 then Color3.new(0.898039, 0.905882, 0.509804)
						else Color3.new(0.905882, 0.509804, 0.509804),
				}, {}),

				LineEffectFrame = e("Frame", {
					BackgroundColor3 = if severity == 3
						then Color3.new(0.16862745583057404, 0.7372549176216125, 0.16078431904315948)
						elseif severity == 2 then Color3.new(0.737255, 0.72549, 0.160784)
						else Color3.new(0.737255, 0.160784, 0.160784),
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = size:map(function(val: Vector2)
						return UDim2.new(0, val.X, 0, 2)
					end),
				}, {}),
			}),
		}),
		UICorner = e("UICorner", {}, {}),
		UIPadding = e("UIPadding", {
			PaddingBottom = UDim.new(0, 4 * deviceContext.ScreenScale),
			PaddingLeft = UDim.new(0, 4 * deviceContext.ScreenScale),
			PaddingRight = UDim.new(0, 4 * deviceContext.ScreenScale),
			PaddingTop = UDim.new(0, 4 * deviceContext.ScreenScale),
		}, {}),

		UIListLayout = e("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5 * deviceContext.ScreenScale),
		}, {}),
	})

	local out = e("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 339 * deviceContext.ScreenScale, 0, 79 * deviceContext.ScreenScale),
	}, content)

	return out
end
