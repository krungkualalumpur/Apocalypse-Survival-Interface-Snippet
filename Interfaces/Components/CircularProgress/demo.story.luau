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
local function circleFrame(props: { Radius: number })
	local progress, setProgress = React.useBinding(0.2)

	return e(interface, {
		Radius = props.Radius,
		Progress = progress,
	})
end
--class
return function(container: CoreGui)
	local root = ReactRoblox.createRoot(container)
	root:render(e(DeviceContext.provider, nil, e(circleFrame, { Radius = 16 })))
	return function()
		root:unmount()
	end
end
