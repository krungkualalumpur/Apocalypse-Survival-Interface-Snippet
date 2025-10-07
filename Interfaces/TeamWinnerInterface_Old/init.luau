--!strict
--services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local SoundUtil = require("@shd/SoundUtil")
local TeamUtil = require("@shd/TeamUtil")
local RoundUtil = require("@shd/RoundUtil")

local GameConfig = require("@shd/GameConfig")
local ReactTweenUtil = require("@shd/ReactTweenUtil")

local DeviceContext = require("@clt/Interfaces/DeviceContext")
local GameplayContext = require("@clt/Interfaces/GameplayContext")
local Components = require("@clt/Interfaces/Components")

local Confetti = require("@clt/Interfaces/Components/Confetti")
--types
--constants
local REAL_POINT_DISPLAY_DELAY = 5
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

local function getPlayerListFrame(props)
	local image, setImage = React.useState("")
	local plrName, setPlrName = React.useState("")

	React.useEffect(function()
		local thread = task.defer(function()
			local s1, image = pcall(
				Players.GetUserThumbnailAsync,
				Players,
				props.PlrId,
				Enum.ThumbnailType.AvatarBust,
				Enum.ThumbnailSize.Size420x420
			)
			local s2, plrName = pcall(Players.GetNameFromUserIdAsync, Players, props.PlrId)

			if s1 then
				setImage(image)
			end
			if s2 then
				setPlrName(plrName)
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, {})
	-- print(image, plrName)

	return e(Components.ListComponent, {
		HasImage = true,
		Translucent = true,
		Text = plrName,
		Color = if player.UserId == props.PlrId then Color3.new(0.270588, 0.705882, 0.305882) else nil,
		ImageId = image,
		native = {
			LayoutOrder = if player.UserId == props.PlrId then 0 else 1,
			-- GroupTransparency = ReactTweenUtil.tweenNumber(1, 0, 0.25),
		},
	}) :: React.ReactNode
end

local function getPlayersList(playersId: { number })
	local lists = {}

	for _, plrId in pairs(playersId) do
		lists[plrId] = e(getPlayerListFrame, {
			PlrId = plrId,
		})
	end
	return e(React.Fragment, nil, lists)
end

local function getData(default: boolean?)
	local redTeam = TeamUtil.getPlayersInTeam("Red")
	local blueTeam = TeamUtil.getPlayersInTeam("Blue")

	local redTeamIds, blueTeamIds =
		if RunService:IsRunning()
			then {}
			else {
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
			}, if RunService:IsRunning()
			then {}
			else {
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
				math.random(100000, 9999999),
			}

	local redWinPoint, blueWinPoint
	if RunService:IsRunning() then
		redWinPoint, blueWinPoint = 0, 0
	else
		redWinPoint, blueWinPoint = 500, 150 --0, 0
	end
	local roundTime = math.max(GameConfig.ROUND_TIME - RoundUtil.getRoundTimeElapsed(), 0)

	if not default then
		for _, plr in pairs(redTeam) do
			local _points = getPoints(plr)
			redWinPoint += _points
		end
		for _, plr in pairs(blueTeam) do
			local _points = getPoints(plr)
			blueWinPoint += _points
		end

		for _, plr in pairs(redTeam) do
			table.insert(redTeamIds, plr.UserId)
		end
		for _, plr in pairs(blueTeam) do
			table.insert(blueTeamIds, plr.UserId)
		end
	end

	return {
		Blue = {
			WinPoint = blueWinPoint,
			Players = blueTeamIds,
		},
		Time = roundTime,
		Red = {
			WinPoint = redWinPoint,
			Players = redTeamIds,
		},
	}
end

local function deepCopy(tbl: { [any]: any })
	local t = {}
	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			t[k] = if type(v) == "table" then deepCopy(v) else v
		end
	end
	return t
end
--class

return function(props: {})
	local visible, setVisible = React.useState(not RunService:IsRunning())

	-- local groupTransparency = if visible then 0 else 1
	local groupTransparency =
		ReactTweenUtil.tweenNumber(if visible then 1 else 0, if visible then 0 else 1, 0.25, { visible })
	local previousData, setPreviousData = React.useState(getData())

	local onStart, setOnStart = React.useState(true)

	local winAnnouncementVisible, setWinAnnouncementVisible = React.useState(false)

	local deviceContext = React.useContext(DeviceContext.context)
	local gameplayContext = React.useContext(GameplayContext.context)

	local data, setData = React.useState({ --testing only
		Blue = {
			WinPoint = 0,
			Players = if RunService:IsRunning()
				then {}
				else {
					-- testing only
					math.random(100000, 9999999),
					math.random(100000, 9999999),
					math.random(100000, 9999999),
					math.random(100000, 9999999),
					math.random(100000, 9999999),
					math.random(100000, 9999999),
					math.random(100000, 9999999),
					math.random(100000, 9999999),
				},
		},

		Time = 0,

		Red = {
			WinPoint = 0,
			Players = if RunService:IsRunning()
				then {}
				else {
					-- testing only
					math.random(100000, 9999999),
					math.random(100000, 9999999),
					math.random(100000, 9999999),
					math.random(100000, 9999999),
					math.random(100000, 9999999),
					math.random(100000, 9999999),
				},
		},
	})

	local redPlayersList, setRedPlayersList = React.useState(e(React.Fragment, nil))
	local bluePlayersList, setBluePlayersList = React.useState(e(React.Fragment, nil))

	local redTeamPtText = ReactTweenUtil.tweenNumber(previousData.Red.WinPoint, data.Red.WinPoint, 0.7, { data })
	local blueTeamPtText = ReactTweenUtil.tweenNumber(previousData.Blue.WinPoint, data.Blue.WinPoint, 0.7, { data })

	React.useEffect(function()
		if visible then
			setOnStart(false)
		end

		if RunService:IsRunning() then
			workspace:SetAttribute("TeamWinnerResultIsActive", visible)
		end
	end, { visible })

	local getLocalTeamWins = React.useCallback(function()
		return if TeamUtil.getPlayerTeam(player) == "Blue"
			then data.Blue.WinPoint > data.Red.WinPoint
			elseif TeamUtil.getPlayerTeam(player) == "Red" then data.Red.WinPoint > data.Blue.WinPoint
			else false
	end, { data })

	React.useEffect(function()
		local function update()
			local roundIsActive = RoundUtil.getRoundIsActive()
			local playerTeam = TeamUtil.getPlayerTeam(player)

			local _data = getData()

			local isVisible = if RunService:IsRunning()
				then (if #_data.Blue.Players + #_data.Red.Players > 0
						and (playerTeam == "Blue" or playerTeam == "Red")
					then not roundIsActive
					else false)
				else true

			setVisible(isVisible)
		end

		update()
		local conn1 = workspace:GetAttributeChangedSignal("RoundIsActive"):Connect(update)

		return function()
			conn1:Disconnect()
			-- task.cancel(thread)
		end
	end, {})

	React.useEffect(function()
		local thread

		if visible then
			local _data = getData()

			setPreviousData(getData(true))
			setData(deepCopy(_data))

			setBluePlayersList(e(getPlayersList, _data.Blue.Players))
			setRedPlayersList(e(getPlayersList, _data.Red.Players))

			thread = task.defer(function()
				-- local localTeamWins = getLocalTeamWins()
				local _newData = deepCopy(_data)
				task.wait(REAL_POINT_DISPLAY_DELAY)

				local smallestWinPoint = math.min(_newData.Blue.WinPoint, _newData.Red.WinPoint)

				setPreviousData(deepCopy(_data))

				_newData.Blue.WinPoint -= smallestWinPoint
				_newData.Red.WinPoint -= smallestWinPoint

				setData(deepCopy(_newData))

				task.wait(2.5)
				SoundUtil.playLocalSound(GameConfig.SOUND_DATA.SOUND_IDS.WHOOSH_SOUND, 0.4)
				setWinAnnouncementVisible(true)

				task.wait(4)
				setWinAnnouncementVisible(false)
				setVisible(false)
			end)
		end

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { visible })

	local doneFrame = e("Frame", {
		ZIndex = 5,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = ReactTweenUtil.tweenPos(
			if winAnnouncementVisible then UDim2.fromScale(0, 1) else UDim2.fromScale(0, if onStart then 1 else 0),
			if winAnnouncementVisible then UDim2.fromScale(0, 0) else UDim2.fromScale(0, 1),
			1,
			{ winAnnouncementVisible }
		),
	}, {
		MainFrame = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		}, {
			UIListLayout = e("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			Content = e("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 450, 0, 250),
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
				TitleLabel = e("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(450, 145),
					RichText = true,
					Font = Enum.Font.Gotham,
					Text = if data.Blue.WinPoint == data.Red.WinPoint
						then `It's a tie!`
						else `<b>{if data.Blue.WinPoint > data.Red.WinPoint then "Blue" else "Red"} team wins!</b>`,
					TextColor3 = if data.Blue.WinPoint == data.Red.WinPoint
						then Color3.new(0.8, 0.8, 0.8)
						elseif data.Blue.WinPoint > data.Red.WinPoint then Color3.new(0, 0, 1)
						else Color3.new(1, 0, 0),
					TextStrokeTransparency = 0.75,
					TextSize = 20,
				}),
				DescLabel = e("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(450, 95),
					Font = Enum.Font.Gotham,
					Text = `by {math.abs(data.Blue.WinPoint - data.Red.WinPoint)} points`,
					TextColor3 = Color3.fromRGB(215, 215, 215),
					TextStrokeTransparency = 0.9,
					TextSize = 15,
				}),
			}),
		}),

		ConfettiFrame = if winAnnouncementVisible and getLocalTeamWins() then e(Confetti, {}) else nil,
	})

	local out = e("Frame", {
		-- Visible = visible, -- workaround this
		BackgroundTransparency = groupTransparency,
		Size = UDim2.fromScale(1, 1),
		-- Position = ReactTweenUtil.tweenPos(
		-- 	if visible then UDim2.new(0, 0, 1, 0) else UDim2.new(),
		-- 	if visible then UDim2.new() else UDim2.new(0, 0, 1, 0),
		-- 	0.5,
		-- 	{ visible }
		-- ), -- if visible then  else
	}, {

		UIGradient = e("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
			}),
			Rotation = -90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.22950822114944458),
				NumberSequenceKeypoint.new(0.23133236169815063, 0.2950819730758667),
				NumberSequenceKeypoint.new(0.46852123737335205, 0.41530054807662964),
				NumberSequenceKeypoint.new(0.7496339678764343, 0.6502732038497925),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}, {}),

		DoneFrame = doneFrame,
		Content = e("CanvasGroup", {
			BackgroundTransparency = 1,
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			GroupTransparency = groupTransparency,
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0.05, 0),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}, {}),

			Header = e("Frame", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0.15, 0),
			}, {
				TitleLabel = e("TextLabel", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Font = Enum.Font.GothamBold,
					Text = "TEAM RESULT",
					TextColor3 = Color3.new(1, 1, 1),
					TextSize = 35 * deviceContext.ScreenScale,
					TextStrokeTransparency = 0.8500000238418579,
				}, {}),
			}),
			Content = e("Frame", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Position = UDim2.new(0.040353089570999146, 0, 0.2056603729724884, 0),
				Size = UDim2.new(0, 729 * deviceContext.ScreenScale, 0.6036585569381714, 0),
			}, {
				UIListLayout = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
				}, {}),
				BlueTeamFrame = e("Frame", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0.5085279941558838, 0, 0, 0),
					Size = UDim2.new(0.4879518747329712, 0, 1, 0),
				}, {
					UIListLayout = e("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Bottom,
						Padding = UDim.new(0, 15),
					}, {}),
					TitleFrame = e("Frame", {
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0.12564103305339813, 0),
					}, {
						TitleLabel = e("TextLabel", {
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.new(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.new(-0.008433672599494457, 0, 0.08039578795433044, 0),
							Size = UDim2.new(1, 0, 1, 0),
							Font = Enum.Font.Gotham,

							Text = "Blue Team",
							TextColor3 = Color3.new(1, 1, 1),
							TextSize = 25 * deviceContext.ScreenScale,
							TextStrokeTransparency = 0.8500000238418579,
						}, {}),
					}),
					Content = e("ScrollingFrame", {
						Visible = visible,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0.8358974456787109, 0),
						CanvasSize = UDim2.new(0, 0, 0, 0),
						ScrollBarImageColor3 = Color3.fromRGB(50, 50, 100),
						ScrollBarThickness = 5,

						-- AutomaticCanvasSize = Enum.AutomaticSize.Y,
					}, {
						UIListLayout = e("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
							[React.Event.Changed] = function(uiListLayout: UIListLayout)
								local absoluteContentSize = uiListLayout.AbsoluteContentSize
								local scrollingFrame = uiListLayout.Parent :: ScrollingFrame?

								if scrollingFrame then
									scrollingFrame.CanvasSize =
										UDim2.new(0, absoluteContentSize.X, 0, absoluteContentSize.Y)
								end
							end,
						}, {}),

						bluePlayersList,
					}),
				}),
				RedTeamFrame = e("Frame", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.new(0.4879518747329712, 0, 1, 0),
				}, {
					UIListLayout = e("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
					}, {}),
					TitleFrame = e("Frame", {
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0.12564103305339813, 0),
					}, {
						TitleLabel = e("TextLabel", {
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.new(0, 0, 0),
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 1, 0),
							Font = Enum.Font.Gotham,

							Text = "Red Team",
							TextColor3 = Color3.new(1, 1, 1),
							TextSize = 25 * deviceContext.ScreenScale,
							TextStrokeTransparency = 0.8500000238418579,
						}, {}),
					}),
					Content = e("ScrollingFrame", {
						Visible = visible,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0.8358974456787109, 0),
						CanvasSize = UDim2.new(0, 0, 0, 0),
						ScrollBarImageColor3 = Color3.fromRGB(50, 50, 100),
						ScrollBarThickness = 5,
						-- AutomaticCanvasSize = Enum.AutomaticSize.Y,
					}, {
						UIListLayout = e("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
							[React.Event.Changed] = function(uiListLayout: UIListLayout)
								local absoluteContentSize = uiListLayout.AbsoluteContentSize
								local scrollingFrame = uiListLayout.Parent :: ScrollingFrame?

								if scrollingFrame then
									scrollingFrame.CanvasSize =
										UDim2.new(0, absoluteContentSize.X, 0, absoluteContentSize.Y)
								end
							end,
						}, {}),

						redPlayersList,
					}),
				}),
			}),

			Footer = e("Frame", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0.05, 0),
			}, {
				UIListLayout = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
				}, {}),
				RedTeam = e("TextLabel", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Position = UDim2.new(0.06052963435649872, 0, 0, 0),
					Size = UDim2.new(0, 364, 0.8420000076293945, 0),
					Font = Enum.Font.GothamBold,

					Text = redTeamPtText:map(function(value)
						local _val = value
						local str = math.round(value) .. " pt"
						return str
					end),
					TextColor3 = ReactTweenUtil.tweenColor3(
						Color3.new(0.7, 0.7, 0.7),
						if data.Blue.WinPoint < data.Red.WinPoint
							then Color3.new(0, 1, 0)
							else Color3.new(0.95, 0.95, 0.95),
						0.75,
						{ visible }
					),
					TextSize = ReactTweenUtil.tweenNumber(
						30 * deviceContext.ScreenScale,
						if getLocalTeamWins() and TeamUtil.getPlayerTeam(player) == "Red"
							then 35 * deviceContext.ScreenScale
							else 30 * deviceContext.ScreenScale,
						1,
						{ winAnnouncementVisible }
					), --35,
					TextStrokeTransparency = 0.85,
				}, {}),
				BlueTeam = e("TextLabel", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Position = UDim2.new(0.52, 0, 0.19, 0),
					Size = UDim2.new(0, 364 * deviceContext.ScreenScale, 0.84, 0),
					Font = Enum.Font.GothamBold,

					Text = blueTeamPtText:map(function(value)
						local _val = value
						local str = math.round(value) .. " pt"
						return str
					end),
					TextColor3 = ReactTweenUtil.tweenColor3(
						Color3.new(0.7, 0.7, 0.7),
						if data.Blue.WinPoint > data.Red.WinPoint
							then Color3.new(0, 1, 0)
							else Color3.new(0.95, 0.95, 0.95),
						0.75,
						{ visible }
					),
					TextSize = ReactTweenUtil.tweenNumber(
						30 * deviceContext.ScreenScale,
						if getLocalTeamWins() and TeamUtil.getPlayerTeam(player) == "Blue"
							then 35 * deviceContext.ScreenScale
							else 30 * deviceContext.ScreenScale,
						1,
						{ winAnnouncementVisible }
					), --35,
					TextStrokeTransparency = 0.85,
				}, {}),

				TweenBugPatchFrame = e("TextLabel", {
					Size = UDim2.new(),
					Text = blueTeamPtText:map(function(value) -- can be from blue or from red...
						return value
					end),
					TextTransparency = 1,
				}),
			}),
			Line = e("Frame", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 3,
				Size = ReactTweenUtil.tweenPos(
					if visible then UDim2.new(0, 0, 0, 1) else UDim2.new(1, 0, 0, 1),
					if visible then UDim2.new(1, 0, 0, 1) else UDim2.new(0, 0, 0, 1),
					0.7,
					{ visible }
				),
			}, {}),
		}),
	})

	return out
end
