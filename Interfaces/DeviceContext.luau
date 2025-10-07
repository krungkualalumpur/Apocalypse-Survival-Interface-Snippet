--!strict
--services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
local InputHandler = require("@pkg/InputHandler")
--modules
--types
export type PlatformType = "Keyboard" | "Mobile" | "Console"
export type DeviceContext = {
	ScreenScale: number,
	Device: PlatformType,
}
--constants
--remotes
--variables
local e = React.createElement
--references
--local functions
local function createDefaultContext(): DeviceContext
	return {
		ScreenScale = 1,
		Device = "Keyboard",
	}
end
--class
local context: React.Context<DeviceContext> = React.createContext(createDefaultContext())

function provider(props: React.ElementProps<any>)
	local screenScale, setScreenScale = React.useState(1)
	local device, setDevice = React.useState(InputHandler.getClientPlatform())

	local value: DeviceContext = {
		ScreenScale = screenScale,
		Device = device,
	}

	React.useEffect(function()
		local camera = workspace.CurrentCamera

		local function update()
			if camera.ViewportSize.X < 800 and camera.ViewportSize.Y < 500 then
				setScreenScale(0.7)
			elseif camera.ViewportSize.X < 1280 and camera.ViewportSize.Y < 720 then
				setScreenScale(1)
			else
				setScreenScale(1.4)
			end
		end

		update()
		local conn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(update)

		return function()
			conn:Disconnect()
		end
	end, {})

	React.useEffect(function()
		local t = tick()

		local conn = RunService.RenderStepped:Connect(function()
			if tick() - t > 2 then
				t = tick()

				if not RunService:IsRunning() then
					setDevice("Mobile")
				else
					setDevice(InputHandler.getClientPlatform())
				end
			end
		end)

		return function()
			conn:Disconnect()
		end
	end, {})

	return e(context.Provider, { value = value }, props.children)
end

return {
	provider = provider,
	context = context,
}
