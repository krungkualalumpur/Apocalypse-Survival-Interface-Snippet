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
--references
--local functions
--class
return function(target)
	local root = ReactRoblox.createRoot(target)
	root:render(React.createElement(interface, {
		MarkingsInfo = {
			{
				Name = "Test",
				Position = Vector3.new(100, 0, -10),
			},
		},
	}))
	return function()
		root:unmount()
	end
end
