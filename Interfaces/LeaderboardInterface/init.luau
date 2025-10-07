--!strict
--services
local Players = game:GetService("Players")
--packages
local Maid = require("@pkg/Maid")
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local ListComponent = require("@clt/Interfaces/Components/ListComponent")
local LeaderstatsUtil = require("@shd/LeaderstatsUtil")
local Abbreviate = require("@shd/Abbreviate")
--types
type PlayerData = {
	Rank: number,
	UserId: number,
	Score: number,
}
--constants
local SIZE = Vector2.new(750, 500)
local PADDING_SIZE = UDim.new(0, 10)

local TEXT_SIZE = 15
--remotes
--variables
local e = React.createElement
--references
--local functions
local function playerListFrame(props: PlayerData)
	local scoreFrameSize = 40
	local image, setImage = React.useState("")
	local username, setUsername = React.useState("")
	React.useEffect(function()
		local thread = task.spawn(function()
			local s1, image = pcall(
				Players.GetUserThumbnailAsync,
				Players,
				props.UserId,
				Enum.ThumbnailType.AvatarBust,
				Enum.ThumbnailSize.Size420x420
			)
			local s2, username = pcall(
				Players.GetNameFromUserIdAsync,
				Players,
				props.UserId,
				Enum.ThumbnailType.AvatarBust,
				Enum.ThumbnailSize.Size420x420
			)

			if s1 then
				setImage(image)
			end
			if s2 then
				setUsername(username)
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, {})

	local content = e(ListComponent, {
		ImageId = image,
		Text = username,
		Translucent = false,
		HasImage = true,
		Length = SIZE.X * 0.5 - PADDING_SIZE.Offset - scoreFrameSize,
		native = {
			LayoutOrder = 1,
		},
	})
	return e("Frame", {
		LayoutOrder = props.Rank,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(SIZE.X * 0.5 - PADDING_SIZE.Offset, 0),
	}, {
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		Content = content,
		ScoreFrame = e("TextLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 0,
			BackgroundColor3 = if props.Rank == 1
				then Color3.new(0.686275, 0.619608, 0.003922)
				elseif props.Rank == 2 then Color3.new(0.654902, 0.654902, 0.654902)
				elseif props.Rank == 3 then Color3.new(0.541176, 0.368627, 0)
				else Color3.new(0.501961, 0.501961, 0.501961),
			Size = UDim2.fromOffset(scoreFrameSize, scoreFrameSize),
			Font = if props.Rank == 1 then Enum.Font.GothamBold else Enum.Font.Gotham,
			Text = Abbreviate(props.Score),
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0.75,
			TextSize = TEXT_SIZE
				+ (if props.Rank == 1 then 5 elseif props.Rank == 2 then 3 elseif props.Rank == 3 then 1 else 0),
		}, {
			UICorner = e("UICorner"),
		}),
	})
end

local function getListFrames(data: {
	[number]: PlayerData,
})
	local lists = {}

	for _, leaderstatsData in pairs(data) do
		lists[leaderstatsData.UserId] = e(playerListFrame, leaderstatsData)
	end

	return e(React.Fragment, nil, lists)
end

local function splitToTwoPages(tbl: { [number]: any })
	local page1, page2 = {}, {}

	for k, v in pairs(tbl) do
		if k <= 8 then
			table.insert(page1, v)
		elseif k > 8 and k <= 8 * 2 then
			table.insert(page2, v)
		end
	end

	return page1, page2
end

--class
return function(props: {
	Data: {
		[number]: PlayerData,
	},
	LeaderboardTitle: string,
})
	local page1, page2 = splitToTwoPages(props.Data)

	local listFrames1, listFrames2 = e(getListFrames, page1), e(getListFrames, page2)

	local out = e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(SIZE.X, SIZE.Y),
	}, {
		UIListLayout = e("UIListLayout", {
			Padding = PADDING_SIZE,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		Header = e("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(SIZE.X, 50 - PADDING_SIZE.Offset * 0.5),
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = PADDING_SIZE,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
			}),
			TextLabel = e("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(SIZE.X, 50 - PADDING_SIZE.Offset * 0.5),
				Text = props.LeaderboardTitle:upper(),
				TextColor3 = Color3.new(1, 1, 1),
				TextStrokeTransparency = 0.8,
				TextSize = 20,
			}),
		}),

		SubHeader = e("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(SIZE.X, 50 - PADDING_SIZE.Offset * 0.5),
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = PADDING_SIZE,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			}),

			SubHeaderPage1 = e("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(SIZE.X * 0.5, 50 - PADDING_SIZE.Offset * 0.5),
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = PADDING_SIZE,
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
				}),
				PointsTitleLabel = e("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(SIZE.X * 0.5 * 0.5 - PADDING_SIZE.Offset, 50 - PADDING_SIZE.Offset * 0.5),
					Text = "Players",
					TextColor3 = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.8,
					TextSize = 10,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
				PlayerTitleLabel = e("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(SIZE.X * 0.5 * 0.5 - PADDING_SIZE.Offset, 50 - PADDING_SIZE.Offset * 0.5),
					Text = "Points",
					TextColor3 = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.8,
					TextSize = 10,
					TextXAlignment = Enum.TextXAlignment.Right,
				}),
			}),
			SubHeaderPage2 = e("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(SIZE.X * 0.5, 50 - PADDING_SIZE.Offset * 0.5),
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = PADDING_SIZE,
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
				}),
				PointsTitleLabel = e("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(SIZE.X * 0.5 * 0.5 - PADDING_SIZE.Offset, 50 - PADDING_SIZE.Offset * 0.5),
					Text = "Players",
					TextColor3 = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.8,
					TextSize = 10,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
				PlayerTitleLabel = e("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(SIZE.X * 0.5 * 0.5 - PADDING_SIZE.Offset, 50 - PADDING_SIZE.Offset * 0.5),
					Text = "Points",
					TextColor3 = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.8,
					TextSize = 10,
					TextXAlignment = Enum.TextXAlignment.Right,
				}),
			}),
		}),

		ContentFrame = e("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(SIZE.X, SIZE.Y - (50 - PADDING_SIZE.Offset * 0.5) * 2),
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = PADDING_SIZE,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
			}),
			Page1Frame = e("Frame", {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(),
				Size = UDim2.fromOffset(SIZE.X * 0.5, SIZE.Y - (50 - PADDING_SIZE.Offset * 0.5) * 2),
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = PADDING_SIZE,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				UIGradient = e("UIGradient", {
					Rotation = 180,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.9),
						NumberSequenceKeypoint.new(1, 1),
					}),
				}),

				listFrames1,
			}),
			Page2Frame = e("Frame", {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(),
				Size = UDim2.fromOffset(SIZE.X * 0.5, SIZE.Y - (50 - PADDING_SIZE.Offset * 0.5) * 2),
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = PADDING_SIZE,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				UIGradient = e("UIGradient", {
					Rotation = 0,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.9),
						NumberSequenceKeypoint.new(1, 1),
					}),
				}),

				listFrames2,
			}),
		}),
	})

	return out
end
