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
		Orientation = {
			OnLookUp = function()
				print("look up?")
			end,
			OnLookDown = function()
				print("look down?")
			end,
			OnLookLeft = function() end,
			OnLookRight = function() end,

			-- OnLookUpStop: () -> (),
			-- OnLookDownStop: () -> (),
			-- OnLookLeftStop: () -> (),
			-- OnLookRightStop: () -> (),
		},
		Position = {
			OnMoveFront = function() end,
			OnMoveBack = function() end,
			OnMoveLeft = function() end,
			OnMoveRight = function() end,
			OnMoveUp = function() end,
			OnMoveDown = function()
				print("Noite?")
			end,
			-- OnMoveUpStop: () -> (),
			-- OnMoveDownStop: () -> (),
			-- OnMoveLeftStop: () -> (),
			-- OnMoveRightStop: () -> (),
		},
	}))
	return function()
		root:unmount()
	end
end
