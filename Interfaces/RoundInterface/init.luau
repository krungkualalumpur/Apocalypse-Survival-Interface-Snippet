--!strict
--services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
local MathUtil = require("@pkg/MathUtil")
local InputHandler = require("@pkg/InputHandler")
--modules
local TeamUtil = require("@shd/TeamUtil")
local RoundUtil = require("@shd/RoundUtil")
local ReactTweenUtil = require("@shd/ReactTweenUtil")
local LeaderstatsUtil = require("@shd/LeaderstatsUtil")
local GameConfig = require("@shd/GameConfig")

local CsvUtil = require("@shd/CsvUtil")

local CharacterUtil = require("@shd/CharacterUtil")

local Abbreviate = require("@shd/Abbreviate")

local DeviceContext = require("@clt/Interfaces/DeviceContext")
local Button = require("@clt/Interfaces/Components/Button")
local ProgressBar = require("@clt/Interfaces/Components/ProgressBar")
--types
type Data = {
	Blue: {
		WinPoint: number,
	},
	Time: number,
	Red: {
		WinPoint: number,
	},
}
--constants
local TEXT_SIZE = 18
local SMALL_TEXT_SIZE = 10

local PADDING_SIZE_OFFSET = 15
--remotes
--variables
local e = React.createElement
--references
local player = Players.LocalPlayer
--local functions
function getLeaderstats(plr: Player)
	local leaderstats = assert(plr:FindFirstChild("leaderstats"), "No leaderstats folder found")
	return leaderstats
end
local function getPoints(plr: Player)
	local leaderstats = getLeaderstats(plr)
	local pointsValue = assert(leaderstats:FindFirstChild("Points") :: IntValue, "Points not available")
	return pointsValue.Value
end

--class
return function(props: {
	ReturnToLobby: () -> (),
	OnSprint: () -> (),
})
	-- local t = React.useState(props.data)
	local currentDisasterHasTsunami = false
	local disastersStr = ""

	local deviceContext = React.useContext(DeviceContext.context)

	local data, setData = React.useState({
		Points = 0,

		Time = 0,
	})
	local visible, setVisible = React.useState(false)
	local sprinting, setSprinting = React.useState(false)
	local currentDisasters, setCurrentDisasters = React.useState({})
	local returnToLobbyVisible, setReturnToLobbyVisible = React.useState(true)

	local newsReportDescs, setNewsReportDescs = React.useState({})

	local newsReportDesc, setNewsReportDesc = React.useState("")

	local staminaRatio, setStaminaRatio = React.useState(0)

	local size, setSize = React.useBinding(Vector2.new(40, 75))

	local transparencyTimeSequence = if visible
		then ReactTweenUtil.tweenNumber(0.99, 0.01, 0.65, { visible })
		else ReactTweenUtil.tweenNumber(0.01, 0.99, 0.65, { visible })

	React.useEffect(function()
		local t1 = 0

		local conn1 = RunService.Heartbeat:Connect(function()
			if tick() - t1 > 0.1 then
				t1 = tick()

				local roundTime = math.max(GameConfig.ROUND_TIME - RoundUtil.getRoundTimeElapsed(), 0)

				if RunService:IsRunning() then
					local leaderstats = LeaderstatsUtil.getPlayerLeaderstats(player)

					setData({

						Time = roundTime,
						Points = leaderstats.Points,
					})
				end
			end
		end)

		return function()
			conn1:Disconnect()
		end
	end, {})

	React.useEffect(function()
		local conn1 = RunService.Heartbeat:Connect(function()
			local isVisibleAttribute = RoundUtil.getRoundIsActive() or not RunService:IsRunning()

			setVisible(
				if RoundUtil.getPlayerIsInRound(player)
					then isVisibleAttribute
					elseif not RunService:IsRunning() then true
					else false
			)
		end)

		return function()
			conn1:Disconnect()
		end
	end, {})

	React.useEffect(function()
		local function update()
			local team: TeamUtil.TeamName? = TeamUtil.getPlayerTeam(player)

			setReturnToLobbyVisible(team ~= "Neutral")
		end

		update()
		local conn = player:GetPropertyChangedSignal("Team"):Connect(update)
		return function()
			conn:Disconnect()
		end
	end, {})

	React.useEffect(function()
		local conn = RunService.Heartbeat:Connect(function()
			local char = player.Character
			if char then
				local charState = CharacterUtil.getCharacterState(char)
				setSprinting(charState.IsSprinting)
				setStaminaRatio(charState.Stamina / 100)
			end
		end)
		return function()
			conn:Disconnect()
		end
	end, {})

	React.useEffect(function()
		-- local disasters = CsvUtil.readCsv(workspace:GetAttribute("Disasters"))
		local function updateDisasters()
			local disastersRaw = workspace:GetAttribute("Disasters")
			local disasters = if disastersRaw then CsvUtil.readCsv(disastersRaw) else {}
			setCurrentDisasters(disasters)
		end

		updateDisasters()
		workspace:GetAttributeChangedSignal("Disasters"):Connect(updateDisasters)

		return function() end
	end, {})

	React.useEffect(function()
		local t = 0
		local descIndex = 1

		local db = false

		local conn = RunService.Heartbeat:Connect(function()
			if tick() - t > 10 and not db then
				db = true
				t = tick()

				local index = ((descIndex - 1) % #newsReportDescs) + 1
				local _text = newsReportDescs[index] or ""

				for i = 1, #_text do
					setNewsReportDesc(_text:sub(1, i))
					task.wait()
				end

				-- print("kalo cek ", #newsReportDescs, index)
				descIndex += 1

				t = tick()
				db = false
			end
		end)

		return function()
			conn:Disconnect()
		end
	end, { deviceContext.ScreenScale, newsReportDescs } :: { any })

	React.useEffect(function()
		setNewsReportDescs({
			[1] = if #currentDisasters > 1
				then `Multiple Disasters detected, seek shelter {if currentDisasterHasTsunami
					then `\nand go to higher ground`
					else ""} immediately.`
				elseif #currentDisasters == 1 then `Disaster detected, {if currentDisasterHasTsunami
					then `seek higher ground \nimmediately.`
					else `seek shelter immediately.`}`
				else "You are safe, no need to panic.",
			[2] = "Civilians are advised to save survivors that are encountered.",
		})
		return
	end, { currentDisasters })

	for k, v: string in pairs(currentDisasters) do
		disastersStr = disastersStr .. (if k > 1 then ", " else "") .. v

		if v:lower():find("tsunami") then
			currentDisasterHasTsunami = true
		end
	end

	local content = e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {

		-- UIPadding = e("UIPadding", {
		-- 	PaddingTop = UDim.new(0, 15),
		-- 	PaddingBottom = UDim.new(0, 15),
		-- 	PaddingLeft = UDim.new(0, 15),
		-- 	PaddingRight = UDim.new(0, 15),
		-- }),
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),
		Header = e("Frame", {
			AutomaticSize = Enum.AutomaticSize.X,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(170 * deviceContext.ScreenScale, 75 * deviceContext.ScreenScale),
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			SprintButton = if InputHandler.getClientPlatform() == "Mobile" or RunService:IsStudio()
				then e(Button, {
					Scale = deviceContext.ScreenScale,
					Color = if sprinting then Color3.new(0.65, 0.7, 0) else Color3.new(0, 0.5, 0.25),
					Text = if deviceContext.ScreenScale >= 1 then (if sprinting then "Walk" else "Sprint") else nil,
					Image = GameConfig.ASSET_DATA.IMAGE_IDS.SPRINTING_ID,
					Activated = function()
						props.OnSprint()
					end,
					native = {
						LayoutOrder = 1,
						Visible = returnToLobbyVisible,
					},
				})
				else nil,
			Frame = e("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = size:map(function(v2: Vector2)
					return UDim2.fromOffset(v2.X, v2.Y)
				end),
			}, {
				BackgroundFrame = e("Frame", {
					AutomaticSize = Enum.AutomaticSize.X,
					BorderSizePixel = 0,
					Size = size:map(function(v2: Vector2)
						return UDim2.fromOffset(v2.X, v2.Y)
					end),
				}, {
					UIListLayout = e("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),

					UIGradient = e("UIGradient", {
						Color = ColorSequence.new(Color3.new(0.121569, 0.180392, 0.505882)),
						Transparency = transparencyTimeSequence:map(function(transparencyTime: number)
							return NumberSequence.new({
								NumberSequenceKeypoint.new(0, 1),
								NumberSequenceKeypoint.new(transparencyTime, 1),
								NumberSequenceKeypoint.new(1, 0.5),
							})
						end),
						Rotation = -90,
					}),
				}),

				FrameLabel = e("Frame", {
					AutomaticSize = Enum.AutomaticSize.X,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(40 * deviceContext.ScreenScale, 75 * deviceContext.ScreenScale),
					[React.Event.Changed] = function(frameLabel: Frame)
						setSize(frameLabel.AbsoluteSize)
					end,
				}, {
					UIPadding = e("UIPadding", {

						PaddingLeft = UDim.new(0, PADDING_SIZE_OFFSET),
						PaddingRight = UDim.new(0, PADDING_SIZE_OFFSET),
					}),
					UIListLayout = e("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),

					TextLabel = e("TextLabel", {
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(170 * deviceContext.ScreenScale, 75 * deviceContext.ScreenScale),
						TextColor3 = Color3.new(1, 1, 1),
						RichText = true,
						Font = Enum.Font.Gotham,
						Text = `YOUR SURVIVAL POINTS : <b>{Abbreviate(data.Points)}</b>\nTime Left: {string.format(
							"<b>%02d:%02d</b>",
							math.abs((GameConfig.ROUND_TIME - RoundUtil.getRoundTimeElapsed()) / 60),
							math.abs((GameConfig.ROUND_TIME - RoundUtil.getRoundTimeElapsed()) % 60)
						)}`,
						TextSize = TEXT_SIZE * deviceContext.ScreenScale,
						TextTransparency = ReactTweenUtil.tweenNumber(
							if visible then 1 else 0,
							if visible then 0 else 1,
							1
						),
						TextStrokeTransparency = 0.9,
					}),
				}),
			}),

			ReturnToLobbyButton = if RunService:IsStudio()
				then e(Button, {
					Scale = deviceContext.ScreenScale,
					Color = Color3.new(1, 0, 0),
					Text = if deviceContext.ScreenScale >= 1 then "Return to Lobby" else nil,
					Image = GameConfig.ASSET_DATA.IMAGE_IDS.EXIT_ICON_ID,
					Activated = function()
						props.ReturnToLobby()
					end,
					native = {
						LayoutOrder = 3,
						Visible = returnToLobbyVisible,
					},
				})
				else nil,
		}),
		WeatherReportFrame = e("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(170 * deviceContext.ScreenScale, 35 * deviceContext.ScreenScale),
			AutomaticSize = Enum.AutomaticSize.X,
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			TextLabel = e("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(170 * deviceContext.ScreenScale, 35 * deviceContext.ScreenScale),
				AutomaticSize = Enum.AutomaticSize.X,
				RichText = true,
				TextColor3 = Color3.new(0.9, 0.9, 0.9),
				Text = `<b><font size = "{math.round(12 * deviceContext.ScreenScale)}"><stroke color="#00A2FF" joins="miter" thickness="1" transparency="0.5"><font color= "#FFFFFF">Disaster Report News:</font></stroke></font></b> {newsReportDesc}\nDisaster: <b>{disastersStr:upper()}</b>`,
				TextSize = SMALL_TEXT_SIZE * deviceContext.ScreenScale,
			}),
		}),
		-- Frame = e("Frame", {
		-- 	LayoutOrder = 2,
		-- 	BackgroundTransparency = 1,
		-- 	Size = UDim2.new(1, 0, 0, 450 * deviceContext.ScreenScale),
		-- }, {
		-- 	UIListLayout = e("UIListLayout", {
		-- 		VerticalAlignment = Enum.VerticalAlignment.Top,
		-- 		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		-- 	}),
		-- 	Frame = e("Frame", {
		-- 		BackgroundTransparency = 1,
		-- 		Size = UDim2.new(1, 0, 0, 450 * deviceContext.ScreenScale),
		-- 	}),
		-- }),
	})
	return e("Frame", {
		BackgroundTransparency = 1,
		Visible = visible,
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		HeaderContent = content,
		BodyContent = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 250, 1, 0),
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
			}),
			UIPadding = e("UIPadding", {
				PaddingTop = UDim.new(0, 15),
				PaddingBottom = UDim.new(0, 15),
				PaddingLeft = UDim.new(0, 15),
				PaddingRight = UDim.new(0, 15),
			}),
			StaminaBar = e("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
				}),
				TextLabel = e("TextLabel", {
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(50 * deviceContext.ScreenScale, 50 * deviceContext.ScreenScale),
					TextColor3 = Color3.new(1, 1, 1),
					RichText = true,
					Font = Enum.Font.Gotham,
					Text = `Stamina`,
					TextSize = TEXT_SIZE * deviceContext.ScreenScale,

					TextStrokeTransparency = 0.9,
				}),
				ProgressBar = e(ProgressBar, {
					Length = 170 * deviceContext.ScreenScale,
					Thickness = 10 * deviceContext.ScreenScale,
					Scale = deviceContext.ScreenScale,
					Ratio = staminaRatio,
					Color = Color3.new(1 - staminaRatio, staminaRatio, 0),
					native = {
						LayoutOrder = 2,
					},
				}),
			}), --e(ProgressBar,)
		}),
	})
end
