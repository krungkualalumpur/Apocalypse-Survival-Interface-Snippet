--!strict
--services
local RunService = game:GetService("RunService")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
local MathUtil = require("@pkg/MathUtil")
--modules
local ReactTweenUtil = require("@shd/ReactTweenUtil")
local GameConfig = require("@shd/GameConfig")

local ProgressBar = require("@clt/Interfaces/Components/ProgressBar")
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
	OnPlay: () -> (),
})
	local ratio, setRatio = React.useState(0)

	local visible, setVisible = React.useState(true)
	local onStart, setOnStart = React.useState(true)
	local descText, setDescText = React.useState("")

	local bgColorInfluence, setBgColorInfluence = React.useState(Vector3.new())

	React.useEffect(function()
		local i = 0
		local conn1 = RunService.Heartbeat:Connect(function(dt)
			local c = 2 * math.pi
			i += 0.05 * dt
			setRatio(math.clamp(i, 0, 1))
			setBgColorInfluence(Vector3.new(math.cos(i * c) + 1, math.sin(i * c) + 1, math.cos(i * c * 0.5) + 1) * 0.5)
		end)

		return function()
			conn1:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if ratio >= 1 then
			setVisible(false)
			props.OnPlay()
		end
	end, { ratio })

	React.useEffect(function()
		local conn
		if visible then
			local t = 0
			local introIndex = 1

			local db = false
			conn = RunService.RenderStepped:Connect(function()
				if tick() - t > 3 and db == false then
					db = true

					local index = ((introIndex - 1) % #GameConfig.MISCS_DATA.LOADING_DESCS) + 1
					local _text = GameConfig.MISCS_DATA.LOADING_DESCS[index]

					-- t = tick()

					for i = 1, #_text do
						-- setDescText(GameConfig.MISCS_DATA.LOADING_DESCS[index])
						setDescText(_text:sub(1, i) .. "|")
						task.wait()
					end
					setDescText(_text)

					t = tick()

					introIndex += 1
					db = false
				end
			end)
		end
		return function()
			if conn then
				conn:Disconnect()
			end
		end
	end, { visible })

	React.useEffect(function()
		if visible then
			setOnStart(false)
		end
	end, { visible })

	return e("CanvasGroup", {
		ZIndex = 5,
		BackgroundTransparency = 1,
		GroupTransparency = ReactTweenUtil.tweenNumber(
			if visible then 1 else (if onStart then 1 else 0),
			if visible then 0 else 1,
			0.5,
			{ visible }
		),
		Size = UDim2.new(1, 0, 1, 0),
	}, {

		Content = e("Frame", {
			BackgroundTransparency = 0,
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			UIGradient = e("UIGradient", {
				Rotation = -90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(
						0,
						Color3.new(0.4 * bgColorInfluence.X, 0.4 * bgColorInfluence.Y, 0.4 * bgColorInfluence.Z)
					),
					ColorSequenceKeypoint.new(
						0.5,
						Color3.new(0.2 * bgColorInfluence.X, 0.2 * bgColorInfluence.Y, 0.2 * bgColorInfluence.Z)
					),
					ColorSequenceKeypoint.new(
						1,
						Color3.new(0.2 * bgColorInfluence.X, 0.2 * bgColorInfluence.Y, 0.2 * bgColorInfluence.Z)
					),
				}),
				Transparency = NumberSequence.new(0),
			}),
			UIPadding = e("UIPadding", {
				PaddingTop = UDim.new(0, 25),
				PaddingBottom = UDim.new(0, 25),
			}),
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0, 25),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			IconLabel = e("ImageLabel", {
				BackgroundTransparency = 1,
				-- BackgroundColor3 = Color3.new(1, 1, 1),
				Size = UDim2.new(0, 125, 0, 125),
				Image = `rbxassetid://73431878375532`,
			}, {
				UICorner = e("UICorner"),
			}),

			TextLabel = e("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 25, 0, 50),
				RichText = true,
				Text = "<b>APOCALYPSE SURVIVAL</b> [EARLY VERSION]",
				TextSize = 25,
				TextColor3 = Color3.new(1, 1, 1),
				TextStrokeTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
			}),
			Buffer = e("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 65),
			}),
			Button = e(Button, {
				Text = "Skip",
				Image = GameConfig.ASSET_DATA.IMAGE_IDS.SKIP_LOGO_ID,
				Activated = function()
					setVisible(false)
					props.OnPlay()
				end,
				native = {
					Visible = if visible then (if ratio > 0.5 then true else false) else false,
					LayoutOrder = 4,
				},
			}),
			DescLabel = e("TextLabel", {
				LayoutOrder = 5,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 50, 0, 50),
				RichText = true,
				Text = descText,
				TextSize = 14,
				TextColor3 = Color3.new(1, 1, 1),
				TextStrokeTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
			}),

			Frame = e("Frame", {
				LayoutOrder = 6,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 450, 0, 45),
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				TextLabel = e("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 450, 0, 25),
					Text = "Loading Asset",
					TextSize = 10,
					TextColor3 = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.85,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
				ProgressBar = e(ProgressBar, {
					Length = 450,
					Thickness = 10,
					Ratio = ratio,
					Color = Color3.new(0.2, 0.2, 0.2),
					native = {
						LayoutOrder = 2,
					},
				}),
			}),
		}),
	})
end
