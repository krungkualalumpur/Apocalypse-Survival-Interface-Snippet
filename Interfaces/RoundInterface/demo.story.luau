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
		-- data = {
		-- 	Red = {
		-- 		WinPoint = 1,
		-- 	},
		-- 	Time = 100,
		-- 	Blue = {
		-- 		WinPoint = 1,
		-- 		Time = 100,
		-- 	},
		-- },

		ReturnToLobby = function()
			print("return to lobby")
		end,
		OnSprint = function()
			print("On Sprint")
		end,
	}))

	return function()
		root:unmount()
	end
end
