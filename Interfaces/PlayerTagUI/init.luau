--!strict
--services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local LeaderstatsUtil = require("@shd/LeaderstatsUtil")
local DeviceContext = require("@clt/Interfaces/DeviceContext")
--types
--constants
local TITLE_TEXT_SIZE = 20
local DESC_TEXT_SIZE = 15
--remotes
--variables
local e = React.createElement
--references
--local functions
--class
return function(props: {
	PlayerId: number,
})
	local deviceContext = React.useContext(DeviceContext.context)

	local scale, setScale = React.useBinding(1)
	local playerName, setPlayerName = React.useState("PlayerName")
	local winPoints, setWinPoints = React.useState(0)

	React.useEffect(function()
		local camera = workspace.CurrentCamera
		local player = Players:GetPlayerByUserId(props.PlayerId)

		local conn = RunService.PostSimulation:Connect(function()
			local char = if player then player.Character else nil
			if char and char.PrimaryPart then
				local magn = 6 / (camera.CFrame.Position - char.PrimaryPart.Position).Magnitude
				setScale(magn)
			end
		end)

		if player then
			setPlayerName(player.Name)
		end

		return function()
			conn:Disconnect()
		end
	end, {})

	React.useEffect(function()
		local conn
		local player = Players:GetPlayerByUserId(props.PlayerId)

		local leaderstats = if player then player:WaitForChild("leaderstats") else nil

		local totalPointsValue = if leaderstats then leaderstats:WaitForChild("TotalPoints") :: IntValue else nil

		if totalPointsValue then
			local function update()
				local leaderstatsData = LeaderstatsUtil.getPlayerLeaderstats(player)
				setWinPoints(leaderstatsData.TotalPoints)
			end

			update()
			conn = totalPointsValue.Changed:Connect(update)
		end

		return function()
			if conn then
				conn:Disconnect()
			end
		end
	end, {})

	local out = e("Frame", {
		BackgroundTransparency = 0.9,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = scale:map(function(num: number)
			return UDim2.new(0, 200 * num * deviceContext.ScreenScale, 0, 56 * num * deviceContext.ScreenScale)
		end),
		BackgroundColor3 = Color3.new(0, 0, 0),
	}, {
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0, 50),
		}),
		UIListLayout = e("UIListLayout", {
			Padding = scale:map(function(num: number)
				return UDim.new(0, 5 * num * deviceContext.ScreenScale)
			end),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		TitleLabel = e("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,

			Size = scale:map(function(num: number)
				return UDim2.new(0, 200 * num * deviceContext.ScreenScale, 0, 30 * num * deviceContext.ScreenScale)
			end),
			Font = Enum.Font.ArimoBold,
			Text = playerName,
			TextColor3 = Color3.new(0.972549, 0.945098, 0.192157),
			TextSize = scale:map(function(num: number)
				return TITLE_TEXT_SIZE * num * deviceContext.ScreenScale
			end),
			TextStrokeTransparency = 0.8,
		}),
		DescLabel = e("TextLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Font = Enum.Font.Arimo,
			Size = scale:map(function(num: number)
				return UDim2.new(0, 200 * num * deviceContext.ScreenScale, 0, 20 * num * deviceContext.ScreenScale)
			end),
			Text = `{tostring(winPoints)} pts`,
			TextColor3 = Color3.new(0.85, 0.85, 0.85),
			TextSize = scale:map(function(num: number)
				return DESC_TEXT_SIZE * num * deviceContext.ScreenScale
			end),
			TextStrokeTransparency = 0.85,
		}),
	})
	return out
end
