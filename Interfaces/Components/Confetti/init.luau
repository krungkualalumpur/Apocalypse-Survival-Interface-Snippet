--!strict
--services
local RunService = game:GetService("RunService")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
local MathUtil = require("@pkg/MathUtil")
--modules

local DeviceContext = require("@clt/Interfaces/DeviceContext")
--types
--constants
local GRAVITY = -9.8
--remotes
--variables
local e = React.createElement
--references
--local functions
local function createParticle()
	local deviceContext = React.useContext(DeviceContext.context)
	local camera = workspace.CurrentCamera

	local pos, setPos = React.useState(UDim2.fromOffset(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y * 0.5))
	local color, setColor = React.useState(Color3.fromRGB(100, 100, 100))
	local rotation, setRotation = React.useState(0)
	local size, setSize = React.useState(UDim2.fromOffset(0, 0))
	local visible, setVisible = React.useState(true)

	local function rdFn(n1: number, n2: number)
		return MathUtil.lerp(n1, n2, math.random())
	end

	React.useEffect(function()
		-- setPos(UDim2.fromOffset(rdFn(0, camera.ViewportSize.X), rdFn(0, camera.ViewportSize.Y)))
		local _pos = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y * 0.5)
		local _sizeRad = Vector2.new(
			(math.random() - 0.5) * 2 * (2 * math.pi),
			(math.random() - 0.5) * 2 * (2 * math.pi)
		) * deviceContext.ScreenScale

		local velocity = Vector2.new(rdFn(-8, 7), rdFn(3, 12)) * deviceContext.ScreenScale

		local _rotation, rotSpeed = rdFn(-180, 180), rdFn(-200, 200)
		local _3dRotationSpeed = rdFn(0, 10)

		local scale = rdFn(1, 2)

		local thread = task.spawn(function()
			repeat
				local dt = task.wait()
				_pos -= velocity

				velocity += Vector2.new(0, GRAVITY * dt)
				_rotation += dt * rotSpeed

				_sizeRad += Vector2.new(dt * _3dRotationSpeed, dt * _3dRotationSpeed)

				setPos(UDim2.fromOffset(_pos.X, _pos.Y))
				setRotation(_rotation)
				setSize(UDim2.fromOffset(math.sin(_sizeRad.X) * 5 * scale, 15 * scale))
			until _pos.Y > camera.ViewportSize.Y
			setVisible(false)
		end)

		setColor(Color3.fromRGB(rdFn(100, 255), rdFn(100, 255), rdFn(100, 255)))

		return function()
			task.cancel(thread)
		end
	end, {})

	local out = e("Frame", {
		Visible = visible,
		BackgroundColor3 = color,
		Position = pos,
		Rotation = rotation,
		Size = size,
		BorderSizePixel = 0,
	})

	return out
end
--class
return function(props: {})
	local particles, setParticles = React.useState({})

	React.useEffect(function()
		local _particles = {}
		for i = 1, 20 do
			table.insert(_particles, e(DeviceContext.provider, nil, { e(createParticle) }))
		end
		setParticles(_particles)
		return function() end
	end, {})

	local out = e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		e(React.Fragment, nil, particles),
	})
	return out
end
