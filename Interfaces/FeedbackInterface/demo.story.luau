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
		OnFeedbackSend = function(str)
			print(str, " : feedback sent")
			return true
		end,
		OnExit = function()
			print("Exit...")
		end,
	}))
	return function()
		root:unmount()
	end
end
