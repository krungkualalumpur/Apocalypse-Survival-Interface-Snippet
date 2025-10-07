--!strict
--services
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local interface = require(script.Parent)
--types
--constants
--remotes
--variables
local e = React.createElement
--references
--local functions
--class
return function(container: CoreGui)
	local root = ReactRoblox.createRoot(container)

	root:render(e(interface, {
		ControlCallbacks = {
			MoveForward = function()
				print("Move forward")
			end,
			MoveBack = function() end,
			TurnLeft = function() end,
			TurnRight = function() end,
			StopTurn = function() end,
			Stop = function() end,
		},
		LightCallbacks = {
			OnHeadLight = function() end,
			OnSignalLeft = function() end,
			OnSignalRight = function() end,
			OnHazardLight = function() end,
			OnCarHorn = function()
				print("Beep beep")
			end,
		},
	}))

	return function()
		root:unmount()
	end
end
