--!strict
--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
local InputHandler = require("@pkg/InputHandler")
--modules
local DeviceContext = require("@clt/Interfaces/DeviceContext")
local join = require("@shd/JoinUtil")
--types
--constants
local SMALL_TEXT_SIZE = 12
local TEXT_SIZE = 25

local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
--remotes
--variables
local e = React.createElement
--references
local Player = Players.LocalPlayer
--local functions

local function optionButton(props: {
	imageId: number,
	layoutOrder: number,
	scale: number,
	onClick: () -> (),
	contentNatives: { [any]: any }?,
	coverNatives: { [any]: any }?,
})
	local contentYOffset, setContentYOffset = React.useState(-5)

	local content = e(
		"ImageButton",
		join({
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromRGB(65, 65, 65),
			Size = UDim2.fromOffset(props.scale, props.scale),
			Position = UDim2.fromOffset(0, contentYOffset),
			Image = `rbxassetid://{props.imageId}`,
			[React.Event.Activated] = props.onClick,
			[React.Event.MouseEnter] = function()
				setContentYOffset(-4)
			end,
			[React.Event.MouseLeave] = function()
				setContentYOffset(-5)
			end,
		}, props.contentNatives),
		e("UICorner")
	)

	local out = e(
		"Frame",
		join({
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			Size = UDim2.fromOffset(props.scale, props.scale),
		}, props.coverNatives),
		{
			Content = content,
			UICorner = e("UICorner"),
		}
	)

	return out
end

local function textButton(props: {
	text: string,
	layoutOrder: number,
	scale: number,
	textScale: number,
	onClick: () -> (),
	contentNatives: { [any]: any }?,
	coverNatives: { [any]: any }?,
})
	local contentYOffset, setContentYOffset = React.useState(-5)

	local content = e(
		"TextButton",
		join({
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromRGB(65, 65, 65),
			Size = UDim2.fromOffset(props.scale, props.scale),
			TextSize = props.textScale,
			Position = UDim2.fromOffset(0, contentYOffset),
			Text = props.text,
			TextColor3 = TEXT_COLOR,
			[React.Event.MouseButton1Click] = props.onClick,
			[React.Event.MouseEnter] = function()
				setContentYOffset(-4)
			end,
			[React.Event.MouseLeave] = function()
				setContentYOffset(-5)
			end,
		}, props.contentNatives),
		e("UICorner")
	)

	local out = e(
		"Frame",
		join({
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			Size = UDim2.fromOffset(props.scale, props.scale),
		}, props.coverNatives),
		{
			Content = content,
			UICorner = e("UICorner"),
		}
	)

	return out
end

local function createDirectionButton(props: {
	Direction: "Up" | "Down" | "Front" | "Back" | "Left" | "Right",
	OnClickDown: () -> (),
	OnClickUp: () -> (),
	native: { [any]: any }?,
})
	local deviceContext = React.useContext(DeviceContext.context)

	local isClicked, setIsClicked = React.useState(false)
	local ref = React.useRef(nil :: Frame?)

	React.useEffect(function()
		local conn = UserInputService.InputEnded:Connect(function(input: InputObject, gpe)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				local mouse = Player:GetMouse()
				local mouseX, mouseY = mouse.X, mouse.Y

				local frame = assert(ref.current, "No frame detected")

				local mouseIsInsideButton = false

				if mouseX > frame.AbsolutePosition.X and mouseX < frame.AbsolutePosition.X + frame.AbsoluteSize.X then
					if
						mouseY > frame.AbsolutePosition.Y
						and mouseY < frame.AbsolutePosition.Y + frame.AbsoluteSize.Y
					then
						mouseIsInsideButton = true
					end
				end

				-- print(mouseIsInsideButton, " mouse inside!")
				if not mouseIsInsideButton and isClicked then
					-- print("----", isClicked)
					props.OnClickUp()
					setIsClicked(false)
				end
			end
		end)

		return function()
			conn:Disconnect()
		end
	end, { isClicked })

	return textButton({
		text = if props.Direction == "Up"
			then "↑"
			elseif props.Direction == "Down" then "↓"
			elseif props.Direction == "Front" then "↑"
			elseif props.Direction == "Back" then "↓"
			elseif props.Direction == "Left" then "←"
			elseif props.Direction == "Right" then "→"
			else "← ↑ → ↓",
		layoutOrder = 1,
		scale = 42 * deviceContext.ScreenScale,
		textScale = TEXT_SIZE * deviceContext.ScreenScale,
		onClick = function() end,
		contentNatives = {
			[React.Event.MouseButton1Down] = function()
				props.OnClickDown()

				setIsClicked(true)
			end,
			[React.Event.MouseButton1Up] = function()
				if isClicked then
					props.OnClickUp()
					setIsClicked(false)
				end
			end,
			BackgroundColor3 = if props.Direction == "Up" or props.Direction == "Down"
				then Color3.fromRGB(26, 146, 202)
				else Color3.fromRGB(107, 107, 107),
			ref = ref,
		},
		coverNatives = join(props.native, {
			BackgroundColor3 = if props.Direction == "Up" or props.Direction == "Down"
				then Color3.fromRGB(20, 113, 156)
				else Color3.fromRGB(77, 77, 77),
		}),
	})
	-- return e(
	-- 	"TextButton",
	-- 	join({
	-- 		BackgroundTransparency = if props.Direction == "Up" or props.Direction == "Down" then 0.5 else 0.75,
	-- 		BackgroundColor3 = if props.Direction == "Up" or props.Direction == "Down"
	-- 			then Color3.fromRGB(26, 146, 202)
	-- 			else Color3.fromRGB(107, 107, 107),
	-- 		Text = if props.Direction == "Up"
	-- 			then "↑"
	-- 			elseif props.Direction == "Down" then "↓"
	-- 			elseif props.Direction == "Front" then "↑"
	-- 			elseif props.Direction == "Back" then "↓"
	-- 			elseif props.Direction == "Left" then "←"
	-- 			elseif props.Direction == "Right" then "→"
	-- 			else "← ↑ → ↓",
	-- 		TextColor3 = TEXT_COLOR,
	-- 		TextSize = TEXT_SIZE,
	-- 		[React.Event.MouseButton1Down] = props.OnClickDown,
	-- 		[React.Event.MouseButton1Up] = props.OnClickUp,
	-- 	}, props.native),

	-- 	e("UICorner")
	-- )
	-- --join native
end
--class
return function(props: {
	OnUp: (onHold: boolean) -> (),
	OnDown: (onHold: boolean) -> (),

	OnFront: (onHold: boolean) -> (),
	OnBack: (onHold: boolean) -> (),
	OnLeft: (onHold: boolean) -> (),
	OnRight: (onHold: boolean) -> (),
})
	local deviceContext = React.useContext(DeviceContext.context)

	local out = e(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		},
		{
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			Header = e("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0.1),
			}),

			Content = e("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0.8),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					FillDirection = Enum.FillDirection.Horizontal,
				}),
				Buffer = if InputHandler.getClientPlatform() ~= "Mobile" --or not RunService:IsRunning()
					then e("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(60 * deviceContext.ScreenScale, 0),
					})
					else nil,

				ControlFrame = if InputHandler.getClientPlatform() == "Mobile" --or not RunService:IsRunning()
					then e(
						"Frame",
						{
							BackgroundTransparency = 1,
							Size = UDim2.fromOffset(250 * deviceContext.ScreenScale, 180 * deviceContext.ScreenScale),
						},
						{
							UIListLayout = e("UIListLayout", {
								Padding = UDim.new(0, 25),
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Right,
								SortOrder = Enum.SortOrder.LayoutOrder,
							}),

							DirectionFrame = e("Frame", {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								Size = UDim2.new(0, 240 * deviceContext.ScreenScale, 1, 0),
							}, {
								LeftButton = createDirectionButton({
									Direction = "Left",
									OnClickDown = function()
										props.OnLeft(true)
									end,
									OnClickUp = function()
										props.OnLeft(false)
									end,
									native = {
										Position = UDim2.fromOffset(
											50 * deviceContext.ScreenScale,
											60 * deviceContext.ScreenScale
										),
									},
								}),
								RightButton = createDirectionButton({
									Direction = "Right",
									OnClickDown = function()
										props.OnRight(true)
									end,
									OnClickUp = function()
										props.OnRight(false)
									end,
									native = {
										Position = UDim2.fromOffset(
											190 * deviceContext.ScreenScale,
											60 * deviceContext.ScreenScale
										),
									},
								}),

								FrontButton = createDirectionButton({
									Direction = "Front",
									OnClickDown = function()
										props.OnFront(true)
									end,
									OnClickUp = function()
										props.OnFront(false)
									end,
									native = {
										Position = UDim2.fromOffset(120 * deviceContext.ScreenScale, 0),
									},
								}),
								BackButton = createDirectionButton({
									Direction = "Back",
									OnClickDown = function()
										props.OnBack(true)
									end,
									OnClickUp = function()
										props.OnBack(false)
									end,
									native = {
										Position = UDim2.fromOffset(
											120 * deviceContext.ScreenScale,
											60 * deviceContext.ScreenScale
										),
									},
								}),
							}),
							ElevationFrame = e("Frame", {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								Size = UDim2.new(0, 60 * deviceContext.ScreenScale, 1, 0),
							}, {
								UpButton = createDirectionButton({
									Direction = "Up",
									OnClickDown = function()
										props.OnUp(true)
									end,
									OnClickUp = function()
										props.OnUp(false)
									end,
									native = {
										Position = UDim2.fromOffset(0, 0),
									},
								}),
								DownButton = createDirectionButton({
									Direction = "Down",
									OnClickDown = function()
										props.OnDown(true)
									end,
									OnClickUp = function()
										props.OnDown(false)
									end,
									native = {
										Position = UDim2.fromOffset(0, 60 * deviceContext.ScreenScale),
									},
								}),
							}),

							BufferFrame = e("Frame", {
								LayoutOrder = 3,
								BackgroundTransparency = 1,
								Size = UDim2.new(0, 160 * deviceContext.ScreenScale, 0, 0),
							}),
						} :: { React.ReactNode }
					)
					else e("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
					}, {
						UIPadding = e("UIPadding", {
							PaddingLeft = UDim.new(0, 25),
							PaddingRight = UDim.new(0, 25),
						}),
						UIListLayout = e("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							VerticalAlignment = Enum.VerticalAlignment.Bottom,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
						}),

						InstructionText = e("TextLabel", {
							BackgroundTransparency = 1,
							Size = UDim2.fromOffset(400 * deviceContext.ScreenScale, 400 * deviceContext.ScreenScale),
							Text = `<b>HELICOPTER CONTROL</b> \n\n{if deviceContext.Device == "Keyboard"
								then "W"
								else "Y"} - Forward\n{if deviceContext.Device == "Keyboard" then "S" else "A"} - Backward\n{if deviceContext.Device
									== "Keyboard"
								then "A"
								else "X"} - Left\n{if deviceContext.Device == "Keyboard" then "D" else "B"} - Right\n{if deviceContext.Device
									== "Keyboard"
								then "Q"
								else "R1"} - Down\n{if deviceContext.Device == "Keyboard" then "E" else "R2"} - Up`,
							TextSize = SMALL_TEXT_SIZE,
							RichText = true,
							TextColor3 = TEXT_COLOR,
							TextXAlignment = Enum.TextXAlignment.Right,
						}),
					}),
			}),

			Footer = e("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0.1),
			}),
		} :: { React.ReactNode }
	)
	return out
end
