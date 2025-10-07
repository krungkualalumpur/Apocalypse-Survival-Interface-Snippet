--!strict
--services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
local player = Players.LocalPlayer
--local functions
--class

return function(container: CoreGui)
	local root = ReactRoblox.createRoot(container)

	root:render(e(interface, {
		Ratio = 0.5,
		OnSliderClickDown = function() end,
		OnSliderClickUp = function() end,
		OnRatioSet = function(number)
			print(number, " : ratio")
		end,
	}))

	return function()
		root:unmount()
	end
end
