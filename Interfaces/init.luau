--!strict
--services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
--packages
local Maid = require("@pkg/Maid")
local NetworkUtil = require("@pkg/NetworkUtil")
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local RoundUtil = require("@shd/RoundUtil")
local InterfaceUtil = require("@shd/InterfaceUtil")
local LeaderstatsUtil = require("@shd/LeaderstatsUtil")

local DeviceContext = require("@clt/Interfaces/DeviceContext")
local NotificationManager = require("@clt/NotificationManager")

local RoundInterface = require("@clt/Interfaces/RoundInterface")
local TeamWinnerInterface = require("@clt/Interfaces/TeamWinnerInterface")
local VehicleInterface = require("@clt/Interfaces/VehicleInterface")
local DefaultNotificationInterface = require("@clt/Interfaces/Notifications/DefaultNotificationInterface")
local GlobalNotificationInterface = require("@clt/Interfaces/Notifications/GlobalNotificationInterface")
local MinimapUI = require("@clt/Interfaces/MinimapUI")
local LeaderboardInterface = require("@clt/Interfaces/LeaderboardInterface")
local HelicopterControlInterface = require("@clt/Interfaces/HelicopterControlInterface")
local SideMainInterface = require("@clt/Interfaces/SideMainInterface")
local FeedbackInterface = require("@clt/Interfaces/FeedbackInterface")
--types
type Maid = Maid.Maid

type MarkingInfo = {
	Position: Vector3,
	Name: string,
	IconId: number?,
	IconColor: Color3?,
}
--constants
--remotes
local ON_FEEDBACK_SENDING = "OnFeedbackSending"
--variables
local e = React.createElement
--references
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local build = workspace:WaitForChild("Build")
--local functions
local function modelIsHumanoid(model: Model)
	return if model:FindFirstChildWhichIsA("Humanoid") then true else false
end
local function createMarkingInfo(pos: Vector3, name: string, iconId: number?, iconColor: Color3?): MarkingInfo
	return {
		Position = pos,
		Name = name,
		IconId = iconId,
		IconColor = iconColor,
	}
end
--class
local interfaces = {}

local sideMainInterfaceRoot = ReactRoblox.createRoot(Instance.new("Folder"))

local feedbackInterfaceRoot = ReactRoblox.createRoot(Instance.new("Folder"))
local minimapRoot = ReactRoblox.createRoot(Instance.new("Folder"))

interfaces.RoundInterface = RoundInterface
interfaces.TeamWinnerInterface = TeamWinnerInterface
interfaces.VehicleInterface = VehicleInterface
interfaces.DefaultNotificationInterface = DefaultNotificationInterface
interfaces.GlobalNotificationInterface = GlobalNotificationInterface
interfaces.LeaderboardInterface = LeaderboardInterface
interfaces.HelicopterControlInterface = HelicopterControlInterface

function minimap(props: {})
	local markingsInfo, setMarkingsInfo = React.useState({})

	React.useEffect(function()
		local conn1 = player:GetAttributeChangedSignal("WalkieTalkieIsActive"):Connect(function()
			local walkieTalkieIsActive = RoundUtil.getPlrWalkieTalkieIsActive(player)

			local NPCsFolder = if walkieTalkieIsActive then build:FindFirstChild("NPCs") else nil

			local markingsInfo = {}

			if NPCsFolder then
				for k, v in pairs(NPCsFolder:GetChildren()) do
					if v:IsA("Model") and modelIsHumanoid(v) then
						local survivorCf, survivorSize = v:GetBoundingBox()
						table.insert(markingsInfo, createMarkingInfo(survivorCf.Position, `Survivor{k}`))
					end
				end
			end

			setMarkingsInfo(markingsInfo)
			-- if walkieTalkieIsActive then
			-- 	setMarkingsInfo(markingsInfo)
			-- else
			-- 	setMarkingsInfo({})
			-- end
		end)

		return function()
			conn1:Disconnect()
		end
	end, {})

	return e(DeviceContext.provider, {}, { e(MinimapUI, {
		MarkingsInfo = markingsInfo,
	}) })
end

-- local function pointAddedEventInterface()
-- 	local currentPoint, setCurrentPoint = React.useState(0)
-- 	local previousPoint, setPreviousPoint = React.useState(0)

-- 	React.useEffect(function()
-- 		local conn  = RunService.Heartbeat:Connect(function()
-- 			local leaderstatsData = LeaderstatsUtil.getPlayerLeaderstats(player)
-- 			setCurrentPoint(leaderstatsData.Points)
-- 		end)
-- 		return function()
-- 			conn:Disconnect()
-- 		end
-- 	end, {})

-- 	return e(PointAddedEventInterface, {
-- 		CurrentPoint = 4,
-- 		PointDelta = 2,
-- 	})
-- end

function interfaces.init(maid: Maid)
	local container = Instance.new("ScreenGui")
	container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	container.IgnoreGuiInset = true
	container.ResetOnSpawn = false
	container.Parent = playerGui

	InterfaceUtil.setData(InterfaceUtil.createData(false))

	sideMainInterfaceRoot:render(ReactRoblox.createPortal(
		e(
			DeviceContext.provider,
			nil,
			e(SideMainInterface, {
				OnFeedbackToggle = function()
					local data = InterfaceUtil.getData()
					data.FeedbackFrame = not data.FeedbackFrame
					InterfaceUtil.setData(data)
				end,
			})
		),
		container
	))

	feedbackInterfaceRoot:render(ReactRoblox.createPortal(
		e(
			DeviceContext.provider,
			nil,
			e(FeedbackInterface, {
				OnFeedbackSend = function(msg: string)
					if msg:match("[^%s]") then
						local s: boolean, e: string? = NetworkUtil.invokeServer(ON_FEEDBACK_SENDING, msg)
						if s then
							local data = InterfaceUtil.getData()
							data.FeedbackFrame = false
							InterfaceUtil.setData(data)

							NotificationManager.notify(
								"Feedback Sent",
								"Thank you for giving us your feedback to make the game better."
							)
						elseif not s and e then
							NotificationManager.notify("Error!", e, nil, 1)
						end
						return s, e
					else
						NotificationManager.notify("Error!", "Please send an appropriate feedback.", nil, 2)
						return false, "Need to have letters"
					end
				end,
				OnExit = function()
					local data = InterfaceUtil.getData()
					data.FeedbackFrame = false
					InterfaceUtil.setData(data)
				end,
			})
		),
		container
	))

	--minimap
	minimapRoot:render(ReactRoblox.createPortal(e(minimap, {}), container))
end

return interfaces
