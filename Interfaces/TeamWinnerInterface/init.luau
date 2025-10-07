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

local function getPlayerListFrame(props: { PlrId: number, LayoutOrder: number })
	local image, setImage = React.useState("")
	local plrName, setPlrName = React.useState("")

	local deviceContext = React.useContext(DeviceContext.context)

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
		Length = 400 * deviceContext.ScreenScale,
		native = {
			LayoutOrder = if player.UserId == props.PlrId then 0 else 1,
			-- GroupTransparency = ReactTweenUtil.tweenNumber(1, 0, 0.25),
		},
	}) :: React.ReactNode
end

local function getPlayerFrame(props: { PlrId: number, Points: number })
	local image, setImage = React.useState("")
	local plrName, setPlrName = React.useState("")

	local deviceContext = React.useContext(DeviceContext.context)

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

	return e("Frame", {
		LayoutOrder = -props.Points,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
	}, {
		UIListLayout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		PlayerList = e(Components.ListComponent, {
			HasImage = true,
			Translucent = true,
			Text = plrName,
			Color = if player.UserId == props.PlrId then Color3.new(0.270588, 0.705882, 0.305882) else nil,
			ImageId = image,
			Length = 440 * deviceContext.ScreenScale,
			native = {
				LayoutOrder = 1,
				-- GroupTransparency = ReactTweenUtil.tweenNumber(1, 0, 0.25),
			},
		}) :: React.ReactNode,
		PointsFrame = e("TextLabel", {
			BackgroundTransparency = 1,
			-- BackgroundColor3 = Color3.new(0.55, 0.55, 0.55),
			Size = UDim2.new(0, 38 * deviceContext.ScreenScale, 0, 38 * deviceContext.ScreenScale),
			Text = tostring(props.Points),
			TextSize = 14,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0.75,
		}, {
			UICorner = e("UICorner"),
		}),
	})
end
-- local function getPlayersList(playersId: { number })
-- 	local lists = {}

-- 	for _, plrId in pairs(playersId) do
-- 		lists[plrId] = e(getPlayerListFrame, {
-- 			PlrId = plrId,
-- 		})
-- 	end
-- 	return e(React.Fragment, nil, lists)
-- end

local function deepCopy(tbl: { [any]: any })
	local t = {}
	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			t[k] = if type(v) == "table" then deepCopy(v) else v
		end
	end
	return t
end

local function playerFrames(plrsId: {
	{
		PlrId: number,
		Points: number,
	}
})
	local fragments = {}

	for _, plrData in pairs(plrsId) do
		table.insert(
			fragments,
			e(getPlayerFrame, {
				PlrId = plrData.PlrId,
				Points = plrData.Points,
			})
		)
	end

	return e(React.Fragment, nil, fragments)
end
--class

return function(props: {
	PlayersData: { [number]: {
		PlrId: number,
		Points: number,
	} },
})
	local visible, setVisible = React.useState(true)

	-- local groupTransparency = if visible then 0 else 1
	local onStart, setOnStart = React.useState(true)

	local groupTransparency = ReactTweenUtil.tweenNumber(
		if visible then 1 else (if onStart then 1 else 0),
		if visible then 0 else 1,
		0.25,
		{ visible }
	)

	local deviceContext = React.useContext(DeviceContext.context)

	React.useEffect(function()
		local thread = task.delay(5, function()
			setVisible(false)
		end)

		return function()
			task.cancel(thread)
		end
	end, {})

	React.useEffect(function()
		if visible then
			setOnStart(false)
		end

		if RunService:IsRunning() then
			workspace:SetAttribute("TeamWinnerResultIsActive", visible)
		end
	end, { visible })

	return e("CanvasGroup", {
		BackgroundTransparency = 1,
		GroupTransparency = groupTransparency,
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		Content = e("Frame", {
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			UIGradient = e("UIGradient", {
				Rotation = -90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.25),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			Content = e("Frame", {
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
				Size = UDim2.new(0, 500 * deviceContext.ScreenScale, 0, 350 * deviceContext.ScreenScale),
			}, {

				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 5 * deviceContext.ScreenScale),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
				}),
				-- UICorner = e("UICorner", {}),
				Header = e("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 500 * deviceContext.ScreenScale, 0, 100 * deviceContext.ScreenScale),
					BackgroundColor3 = Color3.new(1, 1, 1),
				}, {
					UIListLayout = e("UIListLayout", {
						Padding = UDim.new(0, 5 * deviceContext.ScreenScale),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
					TextLabel = e("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 460 * deviceContext.ScreenScale, 0, 50 * deviceContext.ScreenScale),
						TextSize = 20,
						Text = "RESULT",
						TextStrokeTransparency = 0.75,
						TextColor3 = Color3.new(1, 1, 1),
					}),
					-- CloseButton = e(Components.Button, {
					-- 	Scale = deviceContext.ScreenScale * 0.85,
					-- 	Color = Color3.new(0.75, 0.25, 0.25),
					-- 	Text = "X",
					-- 	Activated = function() end,
					-- 	native = {
					-- 		LayoutOrder = 2,
					-- 	},
					-- }),
				}),
				Body = e("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 500 * deviceContext.ScreenScale, 0, 245 * deviceContext.ScreenScale),
					BackgroundColor3 = Color3.new(1, 1, 1),
				}, {
					UIPadding = e("UIPadding", {
						PaddingLeft = UDim.new(0, 10 * deviceContext.ScreenScale),
						PaddingRight = UDim.new(0, 10 * deviceContext.ScreenScale),
					}),
					UIListLayout = e("UIListLayout", {
						Padding = UDim.new(0, 5 * deviceContext.ScreenScale),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Top,
					}),
					ScrollingFrame = e("ScrollingFrame", {
						BackgroundTransparency = 1,
						Visible = visible,
						Size = UDim2.new(0, 480 * deviceContext.ScreenScale, 0, 225 * deviceContext.ScreenScale),
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(),
					}, {
						UIListLayout = e("UIListLayout", {
							Padding = UDim.new(0, 5 * deviceContext.ScreenScale),
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top,
						}),
						e(playerFrames, props.PlayersData),
						-- e(playerFrames, { {
						-- 	PlrId = 6048903818,
						-- 	Points = 10,
						-- } }),
						-- e(playerFrames, { {
						-- 	PlrId = 648903818,
						-- 	Points = 1,
						-- } }),
						-- -- e(getPlayerListFrame, {
						-- -- 	PlrId = 6048903818,
						-- -- }),
						-- -- e(getPlayerListFrame, {
						-- -- 	PlrId = 648903818,
						-- -- }),
						-- e(getPlayerFrame, {
						-- 	PlrId = 6048903818,
						-- 	Points = 1,
						-- }),
						-- e(getPlayerFrame, {
						-- 	PlrId = 648903818,
						-- 	Points = 0,
						-- }),
					}),
				}),
			}),
		}),

		ConfettiFrame = if props.PlayersData[1] and props.PlayersData[1].PlrId == player.UserId
			then e(Confetti, {})
			else nil,
	})
end
