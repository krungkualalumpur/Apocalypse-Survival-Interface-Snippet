--!strict
--services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local GameConfig = require("@shd/GameConfig")

local RoundUtil = require("@shd/RoundUtil")
local ReactTweenUtil = require("@shd/ReactTweenUtil")

local DeviceContext = require("@clt/Interfaces/DeviceContext")
local GameplayContext = require("@clt/Interfaces/GameplayContext")
--types
--constants

local TEXT_SIZE = 14
local LARGE_TEXT_SIZE = 16

--remotes
--variables
local e = React.createElement
--references
local player = Players.LocalPlayer
--local functions
--class
return function()
	local visible, setVisible = React.useState(false)

	local onStart, setOnStart = React.useState(true)

	local intermissionTime, setIntermissionTime = React.useState(60)

	local deviceContext = React.useContext(DeviceContext.context)
	local gameplayContext = React.useContext(GameplayContext.context)

	React.useEffect(function()
		local function update()
			local isActive = (not RunService:IsRunning() or RoundUtil.getIntermissionIsActive())
				and not gameplayContext.TeamWinnerResultIsActive

			if isActive then
				setVisible(true)
				setOnStart(false)
			else
				setVisible(false)
			end
		end

		update()
		local conn = workspace:GetAttributeChangedSignal("IntermissionIsActive"):Connect(update)

		return function()
			conn:Disconnect()
		end
	end, { gameplayContext.TeamWinnerResultIsActive })

	React.useEffect(function()
		local conn = workspace:GetAttributeChangedSignal("IntermissionTime"):Connect(function()
			local intermissionTime = RoundUtil.getIntermissionTimeElapsed()
			setIntermissionTime(GameConfig.LOBBY_INTERMISSION_TIME - intermissionTime)
		end)
		return function()
			conn:Disconnect()
		end
	end, {})

	return e("CanvasGroup", {
		BackgroundTransparency = 1,
		GroupTransparency = ReactTweenUtil.tweenNumber(
			if visible then 1 else (if onStart then 1 else 0),
			if visible then 0 else 1,
			0.5,
			{ visible, onStart }
		),
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		UIListLayout = e("UIListLayout", {
			Padding = UDim.new(0, 25 * deviceContext.ScreenScale),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),
		Frame = e("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(0.66, 0.78, 0),
			Size = UDim2.new(0, 300 * deviceContext.ScreenScale, 0, 65 * deviceContext.ScreenScale),
		}, {
			UIGradient = e("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.75),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0, 25 * deviceContext.ScreenScale),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			TextLabel = e("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150 * deviceContext.ScreenScale, 0, 65 * deviceContext.ScreenScale),
				RichText = true,
				Text = (`<font size = "7">INTERMISSION TIME:</font> \n<b>%02d:%02d</b>`):format(
					math.abs(intermissionTime / 60),
					math.abs(intermissionTime) % 60
				),
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = LARGE_TEXT_SIZE * deviceContext.ScreenScale,
				TextStrokeTransparency = 0.8,
			}),
		}),
	})
end
