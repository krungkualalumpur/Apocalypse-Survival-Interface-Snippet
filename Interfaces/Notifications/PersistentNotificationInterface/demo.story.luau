--!strict
--services
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local interface = require(script.Parent)
local DeviceContext = require("@clt/Interfaces/DeviceContext")
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

	root:render(e(DeviceContext.provider, nil, {
		e(interface, {
			TitleText = "Titlesss",
			DescText = "Description aaaaaaaaaaaaaaaaa bbbbbbbbbbbbbb ccccc ddddddddd",
			Severity = 1,
		}),
	}))

	return function()
		root:unmount()
	end
end
