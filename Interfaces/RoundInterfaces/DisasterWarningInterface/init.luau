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
--types
--constants
local TWEEN_SPEED = 0.15
local SMALL_TEXT_SIZE = 10
local MEDIUM_TEXT_SIZE = 15
local BIG_TEXT_SIZE = 40

local FORCE_FIELD_TIMEOUT_TIME = 15

local BUTTON_SIZE = 35
--remotes
--variables
local e = React.createElement
--references
local player = Players.LocalPlayer
--local functions
--class
return function(props: {})
	local deviceContext = React.useContext(DeviceContext.context)
	local currentDisasters, setCurrentDisasters = React.useState({})
	local visible, setVisible = React.useState(not RunService:IsRunning())
	local onStart, setOnStart = React.useState(true)

	local disastersStr = ""

	React.useEffect(function()
		-- local disasters = CsvUtil.readCsv(workspace:GetAttribute("Disasters"))
		local function updateDisasters()
			local disastersRaw = workspace:GetAttribute("Disasters")
			local disasters = if disastersRaw then CsvUtil.readCsv(disastersRaw) else {}

			local elapsedRoundTime = RoundUtil.getRoundTimeElapsed()
			setCurrentDisasters(disasters)

			-- local character = player.Character

			if
				#disasters > 0
				and RoundUtil.getPlayerIsInRound(player)
				and elapsedRoundTime > FORCE_FIELD_TIMEOUT_TIME
				-- and (not character or (character and not character:FindFirstChildWhichIsA("ForceField")))
			then
				setVisible(true)
			end
		end

		updateDisasters()
		local conn = workspace:GetAttributeChangedSignal("Disasters"):Connect(updateDisasters)

		return function()
			conn:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if visible then
			setOnStart(false)
		end

		local thread = task.spawn(function()
			if visible then
				SoundUtil.playLocalSound(GameConfig.SOUND_DATA.SOUND_IDS.THUD_SOUND)
				task.wait(5)
				setVisible(false)
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, { visible })

	for k, v: string in pairs(currentDisasters) do
		disastersStr = disastersStr
			.. (if k > 1
				then ", "
				elseif k - 1 == #currentDisasters then (if #currentDisasters == 2 then ` and ` else ` and, `)
				else "")
			.. v
	end

	return e("CanvasGroup", {
		ZIndex = 4,
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
			BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
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
				DescFrame = e("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.new(0.5, 0.2, 0.2),
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(1, 0, 0, 85 * deviceContext.ScreenScale),
				}, {
					UIGradient = e("UIGradient", {
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 1),
							NumberSequenceKeypoint.new(0.5, 0),
							NumberSequenceKeypoint.new(1, 1),
						}),
					}),
					TextLabel = e("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.new(1, 0, 0, 85 * deviceContext.ScreenScale),
						TextColor3 = Color3.new(1, 1, 1),
						RichText = true,
						Text = `INCOMING {if #currentDisasters > 1 then "DOUBLE" else ""} DISASTER\n<b>{disastersStr:upper()}</b>`,
						TextStrokeTransparency = 0.6,
						TextSize = MEDIUM_TEXT_SIZE * deviceContext.ScreenScale,
					}),
				}),
			}),
		}),
	})
end
