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
		OnUp = function(onHold: boolean)
			print("Up")
		end,
		OnDown = function(onHold: boolean)
			print("Down")
		end,

		OnFront = function(onHold: boolean)
			print("Front")
		end,
		OnBack = function(onHold: boolean)
			print("Back")
		end,
		OnLeft = function(onHold: boolean)
			print("Left")
		end,
		OnRight = function(onHold: boolean)
			print("Right")
		end,
	}))
	return function()
		root:unmount()
	end
end
