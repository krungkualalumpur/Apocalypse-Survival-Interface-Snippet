--!strict
--services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local GameConfig = require("@shd/GameConfig")
local ReactTweenUtil = require("@shd/ReactTweenUtil")
local DeviceContext = require("@clt/Interfaces/DeviceContext")
local RoundUtil = require("@shd/RoundUtil")

local CircularProgress = require("@clt/Interfaces/Components/CircularProgress")
--types
--constants
local FORCE_FIELD_TIMEOUT_TIME = 15

local TEXT_SIZE = 14
local TITLE_TEXT_SIZE = 10
local PADDING_SIZE = UDim.new(0, 10)
--remotes
--variables
--references
local player = Players.LocalPlayer

local e = React.createElement
--local functions
--class
return function()
	local deviceContext = React.useContext(DeviceContext.context)

	local screenScale = deviceContext.ScreenScale

	local paddingSize = UDim.new(PADDING_SIZE.Scale * screenScale, PADDING_SIZE.Offset * screenScale)

	local visible, setVisible = React.useState(true)
	local onStart, setOnStart = React.useState(true)
	local timeLeft, setTimeLeft = React.useBinding(20)

	React.useEffect(function()
		local function update()
			local roundIsAboutToEnd = (GameConfig.ROUND_TIME - RoundUtil.getRoundTimeElapsed())
				< FORCE_FIELD_TIMEOUT_TIME
			local _timeLeft = GameConfig.ROUND_TIME - RoundUtil.getRoundTimeElapsed()

			setTimeLeft(_timeLeft)

			setVisible(
				if RunService:IsRunning()
					then (if not RoundUtil.getIntermissionIsActive()
							and RoundUtil.getRoundIsActive()
							and not RoundUtil.getPlayerIsInRound(player)
							and roundIsAboutToEnd
						then true
						else false)
					else true
			)
		end

		update()

		local conn = workspace:GetAttributeChangedSignal("RoundTime"):Connect(update)

		return function()
			conn:Disconnect()
		end
	end, {})

	-- React.useEffect(function()
	-- 	local conn = RunService.Heartbeat:Connect(function()
	-- 		if RunService:IsRunning() then
	-- 			local _timeLeft = GameConfig.ROUND_TIME - RoundUtil.getRoundTimeElapsed()
	-- 			setTimeLeft(_timeLeft)

	-- 			setVisible(
	-- 				not RoundUtil.getIntermissionIsActive()
	-- 					and RoundUtil.getRoundIsActive()
	-- 					and not RoundUtil.getPlayerIsInRound(player)
	-- 					and _timeLeft < FORCE_FIELD_TIMEOUT_TIME
	-- 			)
	-- 		end
	-- 	end)
	-- 	return function()
	-- 		conn:Disconnect()
	-- 	end
	-- end, {})

	React.useEffect(function()
		if visible then
			setOnStart(false)
		end
	end, { visible })

	local out = e("Frame", {
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Position = ReactTweenUtil.tweenPos(
			if visible then UDim2.new(0, 0, -1, 0) else (if onStart then UDim2.new(0, 0, -1, 0) else UDim2.new()),
			if visible then UDim2.new() else UDim2.new(0, 0, -1, 0),
			1,
			{ visible, onStart }
		),
		Size = UDim2.fromScale(1, 1),
	}, {
		UIPadding = e("UIPadding", {
			PaddingTop = UDim.new(paddingSize.Scale, (60 + 25) * deviceContext.ScreenScale + paddingSize.Offset),
			PaddingBottom = paddingSize,
			PaddingLeft = paddingSize,
			PaddingRight = paddingSize,
		}),
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
		}),
		UIGradient = e("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.75),
				NumberSequenceKeypoint.new(0.5, 1),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
		Frame = e("Frame", {
			-- Visible = visible,
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			Size = UDim2.fromOffset(160 * deviceContext.ScreenScale, 50 * deviceContext.ScreenScale),
		}, {
			UICorner = e("UICorner"),
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(paddingSize.Scale * 0.5, paddingSize.Offset * 0.5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			DescDisplay = e("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(
					115 * deviceContext.ScreenScale - paddingSize.Offset,
					50 * deviceContext.ScreenScale
				),
			}, {
				UIPadding = e("UIPadding", {
					PaddingTop = paddingSize,
					PaddingBottom = paddingSize,
					PaddingLeft = paddingSize,
					PaddingRight = paddingSize,
				}),
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
				TitleLabel = e("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(
						95 * deviceContext.ScreenScale - paddingSize.Offset,
						15 * deviceContext.ScreenScale
					),
					TextSize = TITLE_TEXT_SIZE * deviceContext.ScreenScale,
					Text = "Round Time Left:",
					TextColor3 = Color3.fromRGB(255, 255, 255),
				}),
				TimerLabel = e("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(
						95 * deviceContext.ScreenScale - paddingSize.Offset,
						(50 - 15) * deviceContext.ScreenScale
					),
					TextSize = TEXT_SIZE * deviceContext.ScreenScale,
					RichText = true,
					Text = timeLeft:map(function(num: number)
						return ("<b>%02d:%02d</b>"):format(math.abs(num / 60), num % 60)
					end),
					TextColor3 = Color3.fromRGB(255, 255, 255),
				}),
			}),

			ProgressFrame = e("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(45 * deviceContext.ScreenScale, 45 * deviceContext.ScreenScale),
			}, {
				CircularFrame = e(CircularProgress, {
					Radius = 20 * deviceContext.ScreenScale,
					Progress = timeLeft:map(function(num: number)
						return (num / FORCE_FIELD_TIMEOUT_TIME)
					end),
				}),
			}),
		}),
	})
	return out
end
