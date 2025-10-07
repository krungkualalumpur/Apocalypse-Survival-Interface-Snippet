--!strict
--services
local RunService = game:GetService("RunService")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local InterfaceUtil = require("@shd/InterfaceUtil")

local DeviceContext = require("@clt/Interfaces/DeviceContext")
local Button = require("@clt/Interfaces/Components/Button")
--types
--constants
--remotes
--variables
local e = React.createElement
--references
--local functions
--class
return function(props: {
	OnFeedbackSend: (msg: string) -> (boolean, string?),
	OnExit: () -> (),
})
	local deviceContext = React.useContext(DeviceContext.context)

	local feedbackText, setFeedbackText = React.useState("")
	local visible, setVisible = React.useState(false)

	local scale = deviceContext.ScreenScale

	local textBoxRef = React.useRef(nil :: TextBox?)

	React.useEffect(function()
		local function update()
			local data = InterfaceUtil.getData()
			setVisible(if RunService:IsRunning() then data.FeedbackFrame else true)
		end

		update()
		local conn = workspace:GetAttributeChangedSignal("FeedbackFrame"):Connect(update)

		return function()
			conn:Disconnect()
		end
	end, {})

	local out = e("Frame", {
		Visible = visible,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		Content = e("Frame", {
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
			Size = UDim2.new(0, 500 * scale, 0, 285 * scale),
		}, {
			UICorner = e("UICorner"),

			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0, 15 * scale),
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),

			UIPadding = e("UIPadding", {
				PaddingLeft = UDim.new(0, 15 * scale),
				PaddingRight = UDim.new(0, 15 * scale),
			}),

			Header = e("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 500 * scale, 0, 65 * scale),
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 15 * scale),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
				TextLabel = e("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 450 * scale, 0, 65 * scale),
					Text = "Feedback",
					TextColor3 = Color3.new(1, 1, 1),
					TextSize = 16,
				}),
				CloseButton = e(Button, {
					Scale = 0.75 * scale,
					Text = "X",
					Activated = props.OnExit,
					native = {
						LayoutOrder = 2,
					},
				}),
			}),
			Content = e("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 480 * scale, 0, 125 * scale),
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 15 * scale),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
				TextLabel = e("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 480 * scale, 0, 25 * scale),
					Text = "Report bugs here, and what features you would like to add for the game?",
					TextColor3 = Color3.new(0.7, 0.7, 0.7),
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
				TextBox = e("TextBox", {
					LayoutOrder = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
					Size = UDim2.new(0, 470 * scale, 0, 100 * scale),
					TextColor3 = Color3.new(0.9, 0.9, 0.9),
					PlaceholderText = "Enter message...",
					PlaceholderColor3 = Color3.new(0.75, 0.75, 0.75),
					Text = "",
					[React.Event.Changed] = function(self: TextBox)
						setFeedbackText(self.Text)
					end,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					ref = textBoxRef,
				}),
			}),
			Footer = e("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 500 * scale, 0, 65 * scale),
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 15 * scale),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
				SendButton = e(Button, {
					-- Color = Color3.new(0, 1, 0),
					Scale = scale,
					Text = "Send Feedback to us",
					Activated = function()
						local s, e = props.OnFeedbackSend(feedbackText)
						if s then
							local textBox = textBoxRef.current
							if textBox then
								textBox.Text = ""
							end
						end
					end,
				}),
			}),
		}),
		UIListLayout = e("UIListLayout", {
			Padding = UDim.new(0, 15 * scale),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
	})
	return out
end
