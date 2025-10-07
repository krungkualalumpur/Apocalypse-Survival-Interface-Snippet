--!strict
--services
local RunService = game:GetService("RunService")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local GameConfig = require("@shd/GameConfig")
local SoundUtil = require("@shd/SoundUtil")

local DeviceContext = require("@clt/Interfaces/DeviceContext")
local ReactTweenUtil = require("@shd/ReactTweenUtil")
--types
--constants
local TEXT_SIZE = 18
local BIG_TEXT_SIZE = 35

local TWEEN_TIME = 0.75
--remotes
--variables
--references
local e = React.createElement
--local functions
--class
return function(props: {
	CurrentPoint: number,
	PointDelta: number,
	Text: string?,
})
	local deviceContext = React.useContext(DeviceContext.context)

	local visible, setVisible = React.useState(false)
	local effectVisible, setEffectVisible = React.useState(false)

	local onStart, setOnStart = React.useState(true)

	local pointDisplay, setPointDisplay = React.useState(props.CurrentPoint - props.PointDelta)

	local absPos, setAbsPos = React.useState(Vector2.new())

	local isPositiveIncrement = math.sign(props.PointDelta) >= 0

	React.useEffect(function()
		local thread
		local points = props.CurrentPoint

		setVisible(true)
		setEffectVisible(false)

		-- if RunService:IsRunning() then
		-- 	SoundUtil.playLocalSound(GameConfig.SOUND_DATA.SOUND_IDS.WHOOSH_SOUND)
		-- end

		thread = task.delay(TWEEN_TIME, function()
			setOnStart(false)
			setPointDisplay(points)
			setEffectVisible(true)

			if RunService:IsRunning() then
				if props.PointDelta > 0 then
					SoundUtil.playLocalSound(GameConfig.SOUND_DATA.SOUND_IDS.SUCCESS_SOUND_ID)
				elseif props.PointDelta < 0 then
					SoundUtil.playLocalSound(GameConfig.SOUND_DATA.SOUND_IDS.SEVERE_NOTIFICATION_SOUND_ID)
				end
			end
			task.wait(1.6)
			setVisible(false)
		end)

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { props.CurrentPoint } :: { unknown })

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
		Content = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			UIListLayout = e("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 5),
			}),
			Frame = e("Frame", {
				BackgroundTransparency = 0,
				BackgroundColor3 = if isPositiveIncrement
					then Color3.new(0.25, 0.6, 0.25)
					else Color3.new(0.85, 0.25, 0.25),
				Size = UDim2.new(1, 0, 0, 200 * deviceContext.ScreenScale),
				BorderSizePixel = 0,
			}, {
				UIGradient = e("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.5, 0.75),
						NumberSequenceKeypoint.new(1, 1),
					}),
				}),
				UIListLayout = e("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, 5),
				}),
				HeaderLabel = e("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 500 * deviceContext.ScreenScale, 0, 50 * deviceContext.ScreenScale),
					Text = `{props.Text or ""} You now have`,
					TextColor3 = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.75,
					TextSize = TEXT_SIZE * deviceContext.ScreenScale,
				}),
				ContentLabel = e("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 500 * deviceContext.ScreenScale, 0, 95 * deviceContext.ScreenScale),
					Text = tostring(math.max(0, pointDisplay)),
					TextColor3 = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.5,
					TextTransparency = ReactTweenUtil.tweenNumber(
						if onStart then 0 else 1,
						0,
						0.5,
						{ props.CurrentPoint }
					),
					TextSize = ReactTweenUtil.tweenNumber(
						BIG_TEXT_SIZE * deviceContext.ScreenScale * (if onStart then 1 else 2),
						BIG_TEXT_SIZE * deviceContext.ScreenScale,
						0.5,
						{ pointDisplay, onStart } :: { unknown }
					),
					[React.Event.Changed] = function(self: TextLabel)
						setAbsPos(self.AbsolutePosition + self.AbsoluteSize * 0.5)
					end,
				}),
				FooterLabel = e("TextLabel", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 500 * deviceContext.ScreenScale, 0, 50 * deviceContext.ScreenScale),
					Text = "points",
					TextColor3 = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.75,
					TextSize = TEXT_SIZE * deviceContext.ScreenScale,
				}),
			}),
		}),

		FlyingFrame = e("Frame", {
			BackgroundTransparency = 1,
			Position = ReactTweenUtil.tweenPos(
				if effectVisible then UDim2.new(0, absPos.X, 0, absPos.Y) else UDim2.new(0, 0, 0, 0),
				if effectVisible then UDim2.new(0, absPos.X, 0, absPos.Y - 50) else UDim2.new(0, 0, 0, 0),
				1,
				{ effectVisible },
				false
			),
			Size = UDim2.fromOffset(50 * deviceContext.ScreenScale, 50 * deviceContext.ScreenScale),
		}, {
			UIListLayout = e("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 5),
			}),
			TextLabel = e("TextLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(50 * deviceContext.ScreenScale, 50 * deviceContext.ScreenScale),
				Text = `{if math.sign(props.PointDelta) >= 0 then "+" else "-"}{tostring(props.PointDelta)}`,
				TextSize = TEXT_SIZE * deviceContext.ScreenScale,
				TextColor3 = if isPositiveIncrement
					then Color3.new(0.160784, 0.733333, 0.141176)
					else Color3.new(0.78, 0.2, 0.2),
				TextStrokeTransparency = 0.75,
				TextStrokeColor3 = Color3.new(1, 1, 1),
				TextTransparency = ReactTweenUtil.tweenNumber(
					if effectVisible then 0 else 1,
					if effectVisible then 1 else 1,
					1,
					{ effectVisible },
					false
				),
			}),
		}),
	})
	return out
end
