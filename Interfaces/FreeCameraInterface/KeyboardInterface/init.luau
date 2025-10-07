--!strict
--services
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local DeviceContext = require("@clt/Interfaces/DeviceContext")
--types
--constants
--remotes
--variables
--references
local e = React.createElement
--local functions
--class
return function()
	local deviceContext = React.useContext(DeviceContext.context)

	local function createLayoutOrderSeq()
		local layoutOrder = 0
		return function()
			layoutOrder += 1
			return layoutOrder
		end
	end

	local getLayoutOrder = createLayoutOrderSeq()
	local getContentLayoutOrder = createLayoutOrderSeq()

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		UIPadding = e("UIPadding", {
			PaddingTop = UDim.new(0, 10 * deviceContext.ScreenScale),
			PaddingBottom = UDim.new(0, 10 * deviceContext.ScreenScale),
			PaddingLeft = UDim.new(0, 10 * deviceContext.ScreenScale),
			PaddingRight = UDim.new(0, 10 * deviceContext.ScreenScale),
		}),
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
		}),
		SideFrame = e("Frame", {
			Size = UDim2.new(0, 150, 0, 250),
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
			}),
			Title = e("TextLabel", {
				LayoutOrder = getLayoutOrder(),
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150, 0, 25),
				RichText = true,
				Text = "<b>CONTROLS</b>",
			}),
			Buffer = e("Frame", {
				LayoutOrder = getLayoutOrder(),
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150, 0, 15),
			}),
			Content = e("Frame", {
				LayoutOrder = getLayoutOrder(),
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150, 0, 150),
			}, {
				UIPadding = e("UIPadding", {
					PaddingTop = UDim.new(0, 10 * deviceContext.ScreenScale),
					PaddingBottom = UDim.new(0, 10 * deviceContext.ScreenScale),
					PaddingLeft = UDim.new(0, 10 * deviceContext.ScreenScale),
					PaddingRight = UDim.new(0, 10 * deviceContext.ScreenScale),
				}),
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
				}),
				Control1 = e("TextLabel", {
					LayoutOrder = getContentLayoutOrder(),
					Size = UDim2.new(0, 130, 0, 25),
					Text = "Forward - W",
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
				Control2 = e("TextLabel", {
					LayoutOrder = getContentLayoutOrder(),
					Size = UDim2.new(0, 130, 0, 25),
					Text = "Backward - S",
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
				Control3 = e("TextLabel", {
					LayoutOrder = getContentLayoutOrder(),
					Size = UDim2.new(0, 130, 0, 25),
					Text = "Left - S",
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
				Control4 = e("TextLabel", {
					LayoutOrder = getContentLayoutOrder(),
					Size = UDim2.new(0, 130, 0, 25),
					Text = "Right - D",
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
				Control5 = e("TextLabel", {
					LayoutOrder = getContentLayoutOrder(),
					Size = UDim2.new(0, 130, 0, 25),
					Text = "Down - Q",
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
				Control6 = e("TextLabel", {
					LayoutOrder = getContentLayoutOrder(),
					Size = UDim2.new(0, 130, 0, 25),
					Text = "Up - E",
					TextXAlignment = Enum.TextXAlignment.Left,
				}),

				Control7 = e("TextLabel", {
					LayoutOrder = getContentLayoutOrder(),
					Size = UDim2.new(0, 130, 0, 25),
					Text = "Look Around - Right Click",
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
			}),
		}),
	})
end
