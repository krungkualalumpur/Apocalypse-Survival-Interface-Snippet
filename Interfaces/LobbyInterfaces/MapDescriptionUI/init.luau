--!strict
--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local ReactTweenUtil = require("@shd/ReactTweenUtil")
-- local CharacterUtil = require("@shd/CharacterUtil")
local DeviceContext = require("@clt/Interfaces/DeviceContext")
--types
--constants
local TEXT_SIZE = 15
local SMALL_TEXT_SIZE = 10

local PADDING_SIZE = UDim.new(0, 15)
--remotes
--variables
local e = React.createElement
--references
local Player = Players.LocalPlayer
local Maps = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("MapChunks")
local BuildingAssets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("MapInstances")
--local functions
-- local function getMapFolder()
-- 	return workspace:WaitForChild("Map")
-- end
-- local function getCurrentMap()
-- 	return getMapFolder():GetChildren()[1]
-- end
local function mapIsLoading()
	-- local map = getCurrentMap()
	-- return if map then (map:GetAttribute("IsLoading") or false) else false
	return workspace:GetAttribute("LoadingRoundMap") :: boolean? or false
end
--class
return function(props: {
	MapName: string?,
	MapDesc: string?,
})
	local deviceContext = React.useContext(DeviceContext.context)

	local onStart, setOnStart = React.useState(true)

	local roundIsLoading, setRoundIsLoading = React.useState(false)
	local isVisible, setIsVisible = React.useState(true)
	local cframe, setCFrame = React.useState(CFrame.new())

	local worldModelRef = React.useRef(nil :: WorldModel?)
	local cameraRef = React.useRef(nil :: Camera?)

	-- local mapModel, setMapModel = React.useState(nil :: Model?)
	local scaleOffset = 0.8

	local camera = e("Camera", {
		CFrame = cframe,
		ref = cameraRef,
	})

	React.useEffect(function()
		local _model
		local function init()
			local mapFolder = if props.MapName then Maps:FindFirstChild(props.MapName) else nil
			local instancesFolder = if props.MapName then BuildingAssets:FindFirstChild(props.MapName) else nil

			local worldModel
			repeat
				worldModel = worldModelRef.current
			until worldModel ~= nil

			if mapFolder then
				local mapModel = mapFolder:GetChildren()[1]
				setIsVisible(true)

				if mapModel and mapModel:IsA("Model") then
					_model = mapModel:Clone()
					_model.Parent = worldModelRef.current

					local cf, size = _model:GetBoundingBox()

					local deg = 0
					for _, spawnPart in pairs(_model:WaitForChild("Spawns"):WaitForChild("Buildings"):GetChildren()) do
						local shape: string = spawnPart:GetAttribute("Shape") :: never
						local instancesByShapeFolder = if instancesFolder
							then instancesFolder:FindFirstChild(shape)
							else nil
						if instancesByShapeFolder then
							local instance = instancesByShapeFolder:GetChildren()[math.random(
								1,
								#instancesByShapeFolder:GetChildren()
							)]
							if instance:IsA("Model") then
								local spawnedAsset = instance:Clone()
								local _cf, _size = spawnPart.CFrame, spawnedAsset:GetExtentsSize()
								spawnedAsset:PivotTo(
									_cf
										* CFrame.new(0, _size.Y * 0.5, 0)
										* (spawnedAsset:GetBoundingBox():Inverse() * spawnedAsset.WorldPivot)
								)
								spawnedAsset.Parent = _model
							end
						end
					end

					while true do
						local dt = task.wait()

						deg += dt * math.pi / 8
						setCFrame(CFrame.lookAt(cf.Position + CFrame.Angles(0, deg, 0) * size * 0.75, cf.Position))
					end
				end
			else
				setIsVisible(false)
			end

			return
		end

		local thread = task.spawn(init)

		return function()
			task.cancel(thread)
			if _model then
				_model:Destroy()
			end
		end
	end, { props.MapName })

	React.useEffect(function()
		if isVisible then
			setOnStart(false)
		end
	end, { isVisible })

	React.useEffect(function()
		local conn = RunService.RenderStepped:Connect(function()
			-- local char = Player.Character
			-- if char then
			setRoundIsLoading(mapIsLoading())
			-- end
		end)
		return function()
			conn:Disconnect()
		end
	end, {})

	local out = e("Frame", {
		BackgroundTransparency = 0,
		-- Visible = roundIsLoading:map(function(bool: boolean)
		-- 	return not bool
		-- end),
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = ReactTweenUtil.tweenPos(
			UDim2.fromScale(if isVisible and not roundIsLoading then -1 else (if onStart then -1 else 0), 0),
			UDim2.fromScale(if isVisible and not roundIsLoading then 0 else -1, 0),
			0.5,
			{ isVisible, roundIsLoading }
		),
	}, {
		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 10 * deviceContext.ScreenScale),
			PaddingRight = UDim.new(0, 10 * deviceContext.ScreenScale),
		}),
		UIListLayout = e("UIListLayout", {
			Padding = PADDING_SIZE,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		UIGradient = e("UIGradient", {
			Rotation = 0,
			Color = ColorSequence.new(Color3.new(0.25, 0.25, 0.25)),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.5),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
		Content = e("Frame", {
			BackgroundTransparency = ReactTweenUtil.tweenNumber(
				if isVisible then 1 else (if onStart then 1 else 0.5),
				if isVisible then 0.5 else 1,
				0.5,
				{ isVisible }
			),
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromOffset(
				270 * deviceContext.ScreenScale * scaleOffset,
				350 * deviceContext.ScreenScale * scaleOffset
			),
		}, {
			UIPadding = e("UIPadding", {
				PaddingTop = PADDING_SIZE,
				PaddingBottom = PADDING_SIZE,
			}),
			UIListLayout = e("UIListLayout", {
				Padding = PADDING_SIZE,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0, 15),
			}),

			Header = e("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(
					220 * deviceContext.ScreenScale * scaleOffset,
					10 * deviceContext.ScreenScale * scaleOffset
				),
			}, {
				UIListLayout = e("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
				}),
				-- TextButton = e("TextButton", {
				-- 	BackgroundTransparency = 1,
				-- 	Size = UDim2.fromOffset(
				-- 		10 * deviceContext.ScreenScale * scaleOffset,
				-- 		10 * deviceContext.ScreenScale * scaleOffset
				-- 	),
				-- 	TextSize = 10 * deviceContext.ScreenScale * scaleOffset,
				-- 	Text = "X",
				-- 	TextColor3 = Color3.fromRGB(255, 255, 255),
				-- 	[React.Event.Activated] = function()
				-- 		setIsVisible(false)
				-- 	end,
				-- }),
			}),

			Title = e("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(
					220 * deviceContext.ScreenScale * scaleOffset,
					50 * deviceContext.ScreenScale * scaleOffset
				),
				RichText = true,
				Text = `<font size = "{math.round(SMALL_TEXT_SIZE * deviceContext.ScreenScale * scaleOffset)}">You now vote for:</font> \n<b>{props.MapName}</b>`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = TEXT_SIZE * deviceContext.ScreenScale * scaleOffset,
				TextTransparency = ReactTweenUtil.tweenNumber(
					if isVisible then 1 else 0,
					if isVisible then 0 else 1,
					0.5,
					{ isVisible }
				),
				TextStrokeTransparency = ReactTweenUtil.tweenNumber(
					if isVisible then 1 else 0.85,
					if isVisible then 0.85 else 1,
					0.5,
					{ isVisible }
				),
			}),

			ViewportFrame = e("ViewportFrame", {
				LayoutOrder = 3,
				Size = UDim2.fromOffset(
					220 * deviceContext.ScreenScale * scaleOffset,
					150 * deviceContext.ScreenScale * scaleOffset
				),
				BackgroundTransparency = ReactTweenUtil.tweenNumber(
					if isVisible then 1 else 0,
					if isVisible then 0 else 1,
					0.5,
					{ isVisible }
				),
				BackgroundColor3 = Color3.fromRGB(52, 126, 236),
				CurrentCamera = cameraRef.current,
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(0, 15),
				}),
				Camera = camera,
				WorldModel = e("WorldModel", {
					ref = worldModelRef,
				}, {}),
			}),

			DescText = e("TextLabel", {
				LayoutOrder = 4,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(
					220 * deviceContext.ScreenScale * scaleOffset,
					75 * deviceContext.ScreenScale * scaleOffset
				),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = props.MapDesc,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = SMALL_TEXT_SIZE * deviceContext.ScreenScale * scaleOffset,
				TextTransparency = ReactTweenUtil.tweenNumber(
					if isVisible then 1 else 0,
					if isVisible then 0 else 1,
					0.5,
					{ isVisible }
				),
				TextStrokeTransparency = ReactTweenUtil.tweenNumber(
					if isVisible then 1 else 0.85,
					if isVisible then 0.85 else 1,
					0.5,
					{ isVisible }
				),
				TextWrapped = true,
			}),
		}),
	})
	return out
end
