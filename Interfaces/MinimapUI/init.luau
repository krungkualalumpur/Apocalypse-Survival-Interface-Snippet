--!strict
--services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local GameConfig = require("@shd/GameConfig")
local TornadoUtil = require("@shd/TornadoUtil")
local RoundUtil = require("@shd/RoundUtil")

local DeviceContext = require("@clt/Interfaces/DeviceContext")
--types
type MarkingInfo = {
	Position: Vector3,
	Name: string,
	IconId: number?,
	IconColor: Color3?,
}
--constants
local TEXT_COLOR = Color3.new(1, 1, 1)
local SMALL_TEXT_SIZE = 7
local TEXT_SIZE = 16

local ARROW_SIZE = 15

local TORNADO_INSTANCE_NAME = "TornadoPart"
--remotes
--variables
local e = React.createElement
--references
local player = Players.LocalPlayer

local build = workspace:WaitForChild("Build")
--local functions
local function getRoundMap()
	return build:FindFirstChild("RoundMap")
end
-- local function getCalculatedForce(tornadoInstance: Instance, dist: number)
-- 	local tornadoData = TornadoData.getTornadoData(tornadoInstance)

-- 	return ((tornadoData.TornadoForce * 2000000) / (dist ^ 2))
-- end
local function getCalculatedRadiusByForce(tornadoPart: BasePart)
	local tornadoData = TornadoUtil.getTornadoData(tornadoPart)

	return math.sqrt(75 * tornadoData.Strength / GameConfig.MINIMUM_WIND_RAGDOLL_FORCE)
end

local function createMarkingInfo(position: Vector3, name: string): MarkingInfo
	return {
		Position = position,
		Name = name,
	}
end

local function markingFrame(props: {
	Name: string,
	Position: Vector2,
	ContainerSize: Vector2,
	ContainerPosition: Vector2,
	Visible: boolean,
})
	local deviceContext = React.useContext(DeviceContext.context)
	local scale = deviceContext.ScreenScale * 1

	return e("Frame", {
		Visible = props.Visible,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Position = UDim2.fromOffset(props.Position.X, props.Position.Y),
		Size = UDim2.new(0, 5, 0, 5),
	}, {
		UICorner = e("UICorner"),

		TextLabel = e("TextLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 10 * scale, 0, 10 * scale),
			Position = UDim2.new(0, 0, 0, -10),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = props.Name,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0.8,
			TextSize = SMALL_TEXT_SIZE * scale,
			TextXAlignment = Enum.TextXAlignment.Center,
		}),
	})
end

local function dynamicMarkingFrame(props: {
	Name: string,
	Position: Vector3,
	ContainerSize: Vector2,
	ContainerPosition: Vector2,
	ViewportCamera: Camera?,
})
	local pos, setPos = React.useState(Vector2.new())
	local visible, setVisible = React.useState(true)

	React.useEffect(function()
		local camera = props.ViewportCamera
		local conn1 = RunService.Heartbeat:Connect(function()
			if camera then
				local viewportSize = camera.ViewportSize

				local v3, isInScreen = camera:WorldToScreenPoint(props.Position)

				local min, max = Vector2.new(), Vector2.new() + props.ContainerSize

				setPos(
					Vector2.new(
						math.clamp(v3.X * (props.ContainerSize.X / viewportSize.X), min.X, max.X),
						math.clamp(v3.Y * (props.ContainerSize.Y / viewportSize.Y), min.Y, max.Y)
					)
				)
				-- setPos(Vector2.new(min.X, min.Y))
				setVisible(isInScreen)
			else
				setPos(Vector2.new())
				setVisible(false)
			end
			-- setScreenSize(camera.ViewportSize)
		end)
		return function()
			conn1:Disconnect()
		end
	end, { props.ContainerPosition, props.ContainerSize, props.ViewportCamera } :: { any })

	return e(markingFrame, {
		Name = props.Name,
		Position = Vector2.new(pos.X, pos.Y),
		ContainerSize = props.ContainerSize,
		ContainerPosition = props.ContainerPosition,
		Visible = visible,
	})
end

local function markingFramesFragment(props: {
	Markings: { MarkingInfo },
	ContainerSize: Vector2,
	ContainerPosition: Vector2,
	ViewportCamera: Camera?,
})
	local markingsFrame: { [string]: React.ReactNode } = {}

	for _, info in pairs(props.Markings) do
		markingsFrame[info.Name] = e(dynamicMarkingFrame, {
			Name = info.Name,
			Position = info.Position,
			ContainerSize = props.ContainerSize,
			ContainerPosition = props.ContainerPosition,
			ViewportCamera = props.ViewportCamera,
		})
	end

	return e(React.Fragment, nil, markingsFrame)
end

--class
return function(props: { MarkingsInfo: {
	[number]: MarkingInfo,
} })
	local camOffset = CFrame.new(Vector3.new(0, 150, 320) * 0.5)

	local viewportPos, setViewportPos = React.useState(Vector2.new())

	local cameraInstance, setCameraInstance = React.useState(nil :: Camera?)

	local cameraCFrameBinding, setCameraCFrame = React.useBinding(CFrame.new())

	local tornadoInfo, setTornadoInfo = React.useBinding({
		CFrame = CFrame.new(),
		Size = Vector3.new(),
	})
	local tornadoInfo2, setTornadoInfo2 = React.useBinding({
		CFrame = CFrame.new(),
		Size = Vector3.new(),
	})

	local deviceContext = React.useContext(DeviceContext.context)
	local isInRound, setIsInRound = React.useState(false)

	local map, setMap = React.useState(getRoundMap())

	local worldModelRef = React.useRef(nil)
	local cameraRef = React.useRef(nil)
	local viewportFrameRef = React.useRef(nil)

	React.useEffect(function()
		local camera = workspace.CurrentCamera

		local conn = RunService.Stepped:Connect(function()
			local character = player.Character

			if character then
				local characterCf, characterSize = character:GetBoundingBox()
				local rotX, rotY, rotZ = camera.CFrame:ToEulerAnglesYXZ()
				setCameraCFrame(
					(
						(CFrame.new(characterCf.Position * Vector3.new(1, 0, 1)))
						* CFrame.fromEulerAnglesYXZ(-math.pi / 6, rotY, 0)
					)
				)
			end
		end)
		return function()
			conn:Disconnect()
		end
	end, {})

	React.useEffect(function()
		local t = tick()
		local conn = RunService.Stepped:Connect(function()
			if tick() - t > 2 then
				t = tick()

				do
					local tornadoInstance: BasePart?, tornadoInstance2: BasePart?
					-- local character = Player.Character

					local function tornadoHandle(inst: BasePart?)
						if inst then
							-- local tornadoData = TornadoData.getTornadoData(inst)

							local tornadoDistRad = getCalculatedRadiusByForce(inst)

							if inst == tornadoInstance then
								setTornadoInfo({
									CFrame = inst.CFrame,
									Size = Vector3.new(6, tornadoDistRad * 2, tornadoDistRad * 2),
								})
							elseif inst == tornadoInstance2 then
								setTornadoInfo2({
									CFrame = inst.CFrame,
									Size = Vector3.new(6, tornadoDistRad * 2, tornadoDistRad * 2),
								})
							end
						else
							if tornadoInstance == nil then
								setTornadoInfo({
									CFrame = CFrame.new(),
									Size = Vector3.new(0, 0, 0),
								})
							elseif tornadoInstance2 == nil then
								setTornadoInfo2({
									CFrame = CFrame.new(),
									Size = Vector3.new(0, 0, 0),
								})
							end
						end
					end

					for _, inst in pairs(TornadoUtil.getTornadoParts()) do
						if inst:IsA("BasePart") then
							if tornadoInstance == nil then
								tornadoInstance = inst
							else
								tornadoInstance2 = inst
							end
						end
					end

					tornadoHandle(tornadoInstance)
					tornadoHandle(tornadoInstance2)

					setIsInRound(RoundUtil.getPlayerIsInRound(player))
				end
			end
		end)
		return function()
			conn:Disconnect()
		end
	end, {})

	React.useEffect(function()
		local roundMap = getRoundMap()

		-- local conn1 = build.ChildAdded:Connect(function()
		-- 	setMap(roundMap)
		-- end)
		-- local conn2 = build.ChildRemoved:Connect(function()
		-- 	setMap(roundMap)
		-- end)

		local currentMapCloned = if roundMap and isInRound then Instance.new("Model") else nil

		if roundMap and currentMapCloned then
			for _, mapSegment in pairs(roundMap:GetDescendants()) do
				local instances = mapSegment:FindFirstChild("Instances")

				local buildings = if instances then instances:FindFirstChild("Buildings") else nil
				local paths = if instances then instances:FindFirstChild("Road") else nil

				local function createVisualPart(model: Model)
					local _cf, _size = model:GetBoundingBox()
					local p = Instance.new("Part")
					p.CFrame, p.Size = _cf, _size
					p.Transparency = 0.6
					p.Anchored, p.CanCollide = true, false

					return p
				end

				if buildings then
					for _, v in pairs(buildings:GetChildren()) do
						if v:IsA("Model") then
							local visualPart = createVisualPart(v)
							visualPart.Parent = currentMapCloned
						end
					end
				end
				if paths then
					for _, v in pairs(paths:GetDescendants()) do
						if v:IsA("BasePart") then
							local _cf, _size = v.CFrame, v.Size
							local minSizeDim = 2

							if _size.X > minSizeDim or _size.Y > minSizeDim or _size.Z > minSizeDim then
								local p = Instance.new("Part")
								p.CFrame, p.Size = _cf, _size
								p.Transparency = 0.6
								p.Anchored, p.CanCollide = true, false
								p.Parent = currentMapCloned
							end
						end
					end
				end
			end
			currentMapCloned.Parent = worldModelRef.current
		end

		return function()
			-- conn1:Disconnect()
			-- conn2:Disconnect()

			if currentMapCloned then
				currentMapCloned:Destroy()
			end
		end
	end, { isInRound })

	-- print("Is in round: ", isInRound)
	local out = e("Frame", {
		Visible = if not RunService:IsRunning() then true else isInRound,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, {

		Container = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		}, {
			UIPadding = e("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			UIListLayout = e("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			}),
			MapDisplay = e("ViewportFrame", {
				BackgroundTransparency = 0.85,
				CurrentCamera = cameraRef.current,
				Size = UDim2.fromOffset(150 * deviceContext.ScreenScale, 150 * deviceContext.ScreenScale),
				ref = viewportFrameRef,
				[React.Event.Changed] = function(self: ViewportFrame)
					setViewportPos(self.AbsolutePosition)
				end,
			}, {
				UICorner = e("UICorner", {}),
				UIStroke = e("UIStroke", {
					Color = TEXT_COLOR,
					Thickness = 0.75,
					Transparency = 0.65,
				}),

				Camera = e("Camera", {
					ref = cameraRef,
					CFrame = cameraCFrameBinding:map(function(value: CFrame)
						return value * camOffset
					end),
					[React.Event.Changed] = function(self)
						setCameraInstance(self)
					end,
				}),
				WorldModel = e("WorldModel", {
					ref = worldModelRef,
				}, {
					Arrow = e("Part", {
						CFrame = cameraCFrameBinding:map(function(_cf: CFrame)
							local char = player.Character

							local cf = if char then char:GetBoundingBox() else _cf
							local _, rotY, _ = cf:ToEulerAnglesYXZ()

							cf = CFrame.new(cf.Position) * CFrame.fromEulerAnglesYXZ(0, rotY, 0)

							return cf * CFrame.fromEulerAnglesYXZ(0, -math.pi / 2, 0)
						end),
						Color = Color3.fromRGB(50, 255, 0),
						Transparency = 0.2,
					}, {
						SpecialMesh = e("SpecialMesh", {
							MeshId = "rbxassetid://4752170935",
							Scale = Vector3.new(1.25 * ARROW_SIZE, 0.5 * ARROW_SIZE, 2 * ARROW_SIZE) * 0.5,
						}),
					}),

					TornadoVisualPart = e("Part", {
						Color = Color3.fromRGB(255, 0, 0),
						Transparency = 0.5,
						Shape = Enum.PartType.Cylinder,
						Size = tornadoInfo:map(function(value)
							return value.Size
						end),
						CFrame = tornadoInfo:map(function(value: { CFrame: CFrame, Size: Vector3 })
							return CFrame.new(value.CFrame.Position) * CFrame.fromEulerAnglesYXZ(0, 0, math.pi / 2)
						end),
					}),

					TornadoVisualPart2 = e("Part", {
						Color = Color3.fromRGB(255, 0, 0),
						Transparency = 0.5,
						Shape = Enum.PartType.Cylinder,
						Size = tornadoInfo2:map(function(value)
							return value.Size
						end),
						CFrame = tornadoInfo2:map(function(value: { CFrame: CFrame, Size: Vector3 })
							return CFrame.new(value.CFrame.Position) * CFrame.fromEulerAnglesYXZ(0, 0, math.pi / 2)
						end),
					}),
				}),
				e(markingFramesFragment, {
					ContainerPosition = Vector2.new(viewportPos.X, viewportPos.Y),
					--Vector2.new(), --Vector2.new(150 * deviceContext.ScreenScale, 150 * deviceContext.ScreenScale),
					ContainerSize = Vector2.new(150 * deviceContext.ScreenScale, 150 * deviceContext.ScreenScale),
					Markings = props.MarkingsInfo,
					ViewportCamera = cameraInstance :: any,
				}),
			}),
		}),
	})

	return out
end
