--!strict
--services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local GameConfig = require("@shd/GameConfig")
local InterfaceUtil = require("@shd/InterfaceUtil")

local DeviceContext = require("@clt/Interfaces/DeviceContext")
local Button = require("@clt/Interfaces/Components/Button")
local MinimapUI = require("@clt/Interfaces/MinimapUI")
--types
--constants
--remotes
--variables
local e = React.createElement
--references
local player = Players.LocalPlayer
--local functions
--class
return function(props: {
	OnFeedbackToggle: () -> (),
})
	local feedbackVisible, setFeedbackVisible = React.useState(true)

	local deviceContext = React.useContext(DeviceContext.context)

	local scale = deviceContext.ScreenScale

	React.useEffect(function()
		local function update()
			if RunService:IsRunning() then
				local feedbackSent = player:GetAttribute("FeedbackSent") :: boolean
				setFeedbackVisible(if feedbackSent ~= nil then not feedbackSent else true)
			end
		end

		update()
		local conn = player:GetAttributeChangedSignal("FeedbackSent"):Connect(function()
			update()
		end)
		return function()
			conn:Disconnect()
		end
	end, {})

	local out = e("Frame", {
		ZIndex = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 250 * scale, 1, 0),
	}, {
		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 15 * scale),
			PaddingRight = UDim.new(0, 15 * scale),
		}),
		UIListLayout = e("UIListLayout", {
			Padding = UDim.new(0, 15 * scale),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		FeedbackButton = e(Button, {
			Scale = scale * 0.8,
			Image = GameConfig.ASSET_DATA.IMAGE_IDS.FEEDBACK_ICON_ID,
			Color = Color3.new(0, 0.25, 0.75),
			Text = if scale >= 1 then "Send a \nFeedback" else nil,
			Activated = props.OnFeedbackToggle,
			native = {
				Visible = feedbackVisible,
			},
		}),
	})
	return out
end
