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
	root:render(e(
		DeviceContext.provider,
		nil,
		e(interface, {
			MapName = "City",
			MapDesc = "Lorem ipsum dolor sit amet, consectetur adipiscing elit... Etiam fringilla ultrices ante, ac volutpat nisl aliquam et. Sed mauris urna, malesuada eget feugiat eu, pulvinar in mauris. Nam blandit nisi quam, ac porta ex finibus eget. Nullam luctus urna urna, non dapibus quam pretium at. Maecenas nec odio semper, sollicitudin justo aliquet, varius turpis. Curabitur mollis mi vitae nulla venenatis tempor. Donec a dapibus felis, eget pellentesque ligula.",
		})
	))
	return function()
		root:unmount()
	end
end
