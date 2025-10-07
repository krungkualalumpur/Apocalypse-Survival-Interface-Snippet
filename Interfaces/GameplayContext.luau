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
type GameContext = {
	TeamWinnerResultIsActive: boolean,
}
--constants
--remotes
--variables
local e = React.createElement
--references
local player = Players.LocalPlayer
--local functions
local function createDefaultContext(): GameContext
	return {
		TeamWinnerResultIsActive = false,
	}
end

local function useEventConnection<T...>(event: RBXScriptSignal<T...>, callback: (T...) -> (), dependencies: { any })
	local cachedCallback = React.useMemo(function()
		return callback
	end, dependencies)

	React.useEffect(function()
		local connection = event:Connect(cachedCallback)

		return function()
			connection:Disconnect()
		end
	end, { event, cachedCallback } :: { unknown })
end

--class
local context: React.Context<GameContext> = React.createContext(createDefaultContext())

function provider(props: React.ElementProps<any>)
	local teamWinnerResultIsActive, setTeamWinnerResultIsActive = React.useState(false)

	local value: GameContext = {
		TeamWinnerResultIsActive = teamWinnerResultIsActive,
	}

	useEventConnection(workspace:GetAttributeChangedSignal("TeamWinnerResultIsActive"), function()
		local isActive = workspace:GetAttribute("TeamWinnerResultIsActive") :: never or false
		setTeamWinnerResultIsActive(isActive)
	end, {})
	-- React.useEffect(function()
	-- 	local camera = workspace.CurrentCamera

	-- 	local function update()

	-- 	end

	-- 	update()
	-- 	local conn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(update)

	-- 	return function()
	-- 		conn:Disconnect()
	-- 	end
	-- end, {})

	-- React.useEffect(function()
	-- 	local t = tick()

	-- 	local conn = RunService.RenderStepped:Connect(function()
	-- 		if tick() - t > 2 then
	-- 			t = tick()

	-- 			if not RunService:IsRunning() then
	-- 				setDevice("Mobile")
	-- 			else
	-- 				setDevice(InputHandler.getClientPlatform())
	-- 			end
	-- 		end
	-- 	end)

	-- 	return function()
	-- 		conn:Disconnect()
	-- 	end
	-- end, {})

	return e(context.Provider, { value = value }, props.children)
end

return {
	provider = provider,
	context = context,
}
