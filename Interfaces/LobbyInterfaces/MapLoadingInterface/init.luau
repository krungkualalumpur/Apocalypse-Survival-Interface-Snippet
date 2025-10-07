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
local SoundUtil = require("@shd/SoundUtil")
local CsvUtil = require("@shd/CsvUtil")
local RoundUtil = require("@shd/RoundUtil")

local DeviceContext = require("@clt/Interfaces/DeviceContext")
local GameplayContext = require("@clt/Interfaces/GameplayContext")
local CircularProgress = require("@clt/Interfaces/Components/CircularProgress")
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
local player = Players.LocalPlayer
--local functions
local function loadingCircle(props: {
	Scale: number,
})
	local rotation, setRotation = React.useState(0)

	React.useEffect(function()
		local r = 0

		local conn = RunService.RenderStepped:Connect(function(dt: number)
			r += dt * 100
			setRotation(r)

			-- setRotation(rotation + dt*15)  -- wierd...
			-- print(rotation)
		end)
		return function()
			conn:Disconnect()
		end
	end, {})

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(props.Scale * 60, props.Scale * 60),
	}, {

		LoadingLabel = e("ImageLabel", {
			BackgroundTransparency = 1,
			Rotation = rotation,
			Size = UDim2.fromOffset(props.Scale * 60, props.Scale * 60),
			Image = "rbxassetid://82285050019288",
		}),
	})
end
--class
return function(props: {
	MapName: string,
})
	local deviceContext = React.useContext(DeviceContext.context)
	local gameplayContext = React.useContext(GameplayContext.context)

	local visible, setVisible = React.useState(not RunService:IsRunning())
	local onStart, setOnStart = React.useState(true)

	local textTransparency, setTextTransparency = React.useState(0)

	React.useEffect(function()
		local function update()
			local mapIsLoading = workspace:GetAttribute("LoadingRoundMap") :: never? or false

			setVisible(
				if RunService:IsRunning() then mapIsLoading and not gameplayContext.TeamWinnerResultIsActive else true
			)
			if mapIsLoading then
				setOnStart(false)
			end
		end

		update()
		local conn1 = workspace:GetAttributeChangedSignal("LoadingRoundMap"):Connect(update)
		return function()
			conn1:Disconnect()
		end
	end, { gameplayContext.TeamWinnerResultIsActive })

	React.useEffect(function()
		local i = 0
		local conn = RunService.Heartbeat:Connect(function(dt: number)
			i = (i + dt * math.pi * 1.2) % (2 * math.pi)
			local deg = math.cos(i)
			setTextTransparency(deg * 0.5 + 0.5)
		end)
		return function()
			conn:Disconnect()
		end
	end, {})

	return e("CanvasGroup", {
		ZIndex = 3,
		BackgroundTransparency = 1,
		GroupTransparency = ReactTweenUtil.tweenNumber(
			if visible then 1 else if onStart then 1 else 0,
			if visible then 0 else 1,
			1,
			{ visible, onStart }
		),
		BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		Content = e("Frame", {
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			UIGradient = e("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0.3),
				}),
			}),
			Content = e("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(1, 0, 1, 0),
			}, {
				UIPadding = e("UIPadding", {
					PaddingBottom = UDim.new(0, 45 * deviceContext.ScreenScale),
				}),
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					FillDirection = Enum.FillDirection.Vertical,
				}),
				Footer = e("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.new(0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(1, 0, 0, 100),
				}, {

					UIListLayout = e("UIListLayout", {
						Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
					}),
					TextLabel = e("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.new(0, 25 * deviceContext.ScreenScale, 0, 85 * deviceContext.ScreenScale),
						TextColor3 = Color3.new(1, 1, 1),
						RichText = true,
						Text = `<i><font size = "{15 * math.round(deviceContext.ScreenScale)}">LOADING</font></i> <font color="rgb(190,190,190)"><b>{props.MapName:upper()} MAP</b></font>`,
						-- TextStrokeTransparency = 0.6,
						TextTransparency = textTransparency,
						TextSize = MEDIUM_TEXT_SIZE * deviceContext.ScreenScale,
					}),
					LoadingFrame = e(loadingCircle, { Scale = 0.75 * deviceContext.ScreenScale }),
				}),
			}),
		}),
	})
end
