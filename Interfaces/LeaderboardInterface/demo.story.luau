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
		LeaderboardTitle = "Leaderboard Display",
		Data = {
			{
				Rank = 1,
				UserId = 10008805,
				Score = 10000,
			},
			{
				Rank = 2,
				UserId = 1299900,
				Score = 250,
			},
			{
				Rank = 3,
				UserId = 12121210,
				Score = 100,
			},
			{
				Rank = 4,
				UserId = 121221210,
				Score = 100,
			},
			{
				Rank = 5,
				UserId = math.random(100000, 10000000),
				Score = 100,
			},
			{
				Rank = 6,
				UserId = math.random(100000, 10000000),
				Score = 100,
			},
			{
				Rank = 7,
				UserId = math.random(100000, 10000000),
				Score = 100,
			},
			{
				Rank = 8,
				UserId = math.random(100000, 10000000),
				Score = 100,
			},
			{
				Rank = 9,
				UserId = math.random(100000, 10000000),
				Score = 95,
			},
			{
				Rank = 10,
				UserId = math.random(100000, 10000000),
				Score = 93,
			},
			{
				Rank = 11,
				UserId = math.random(100000, 10000000),
				Score = 92,
			},
			{
				Rank = 12,
				UserId = math.random(100000, 10000000),
				Score = 90,
			},
		},
	}))
	return function()
		root:unmount()
	end
end
