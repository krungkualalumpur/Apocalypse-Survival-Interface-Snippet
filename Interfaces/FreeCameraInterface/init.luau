--!strict
--services
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local Button = require("@clt/Interfaces/Components/Button")
local DeviceContext = require("@clt/Interfaces/DeviceContext")
--types
--constants
--remotes
--variables
--references
local e = React.createElement
--local functions
--class
return function(
	props: {
		Orientation: {
			OnLookUp: () -> (),
			OnLookDown: () -> (),
			OnLookLeft: () -> (),
			OnLookRight: () -> (),

			-- OnLookUpStop: () -> (),
			-- OnLookDownStop: () -> (),
			-- OnLookLeftStop: () -> (),
			-- OnLookRightStop: () -> (),
		},

		Position: {
			OnMoveFront: () -> (),
			OnMoveBack: () -> (),
			OnMoveLeft: () -> (),
			OnMoveRight: () -> (),
			OnMoveUp: () -> (),
			OnMoveDown: () -> (),
			-- OnMoveUpStop: () -> (),
			-- OnMoveDownStop: () -> (),
			-- OnMoveLeftStop: () -> (),
			-- OnMoveRightStop: () -> (),
		},
	}
)
	local deviceContext = React.useContext(DeviceContext.context)

	local content = e("Frame", {
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
			Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
		}),
		PositionHeightControlFrame = e("Frame", {
			LayoutOrder = 1,
			BackgroundColor3 = Color3.new(0.5, 0.6, 0.6),
			Size = UDim2.new(0, 50 * deviceContext.ScreenScale, 0, 150 * deviceContext.ScreenScale),
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0, 100),
			}),

			UIListLayout = e("UIListLayout", {
				-- Padding = UDim.new(0, 15 * deviceContext.ScreenScale),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),

			UpButton = e(Button, {
				Text = "▲",
				Activated = function() end,
				Color = Color3.new(0.2, 0.7, 0.2),

				native = {
					LayoutOrder = 1,
					[React.Event.MouseButton1Down] = function()
						props.Position.OnMoveUp()
					end,
				},
			}),

			Buffer = e("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 60, 0, 60),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				Image = e("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 35, 0, 35),
					Image = `rbxassetid://{8159018546}`,
				}),
			}),

			DownButton = e(Button, {
				Text = "▼",
				Activated = function() end,
				Color = Color3.new(0.2, 0.7, 0.2),
				native = {
					LayoutOrder = 3,
					[React.Event.MouseButton1Down] = function()
						props.Position.OnMoveDown()
					end,
				},
			}),
		}),

		PositionControlFrame = e("Frame", {
			LayoutOrder = 2,
			BackgroundColor3 = Color3.new(0.6, 0.5, 0.6),
			Size = UDim2.new(0, 150 * deviceContext.ScreenScale, 0, 150 * deviceContext.ScreenScale),
		}, {

			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0, 100),
			}),

			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			UpperThird = e("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150 * deviceContext.ScreenScale, 0, 150 * deviceContext.ScreenScale / 3),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				UpButton = e(Button, {
					Text = "▲",
					Color = Color3.new(0.7, 0.2, 0.7),
					Activated = function() end,
					native = {
						LayoutOrder = 1,
						[React.Event.MouseButton1Down] = function()
							props.Position.OnMoveFront()
						end,
					},
				}),
			}),
			MiddleThird = e("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150 * deviceContext.ScreenScale, 0, 150 * deviceContext.ScreenScale / 3),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				LeftButton = e(Button, {
					Text = "◀",
					Color = Color3.new(0.7, 0.2, 0.7),
					Activated = function() end,
					native = {
						LayoutOrder = 1,
						[React.Event.MouseButton1Down] = function()
							props.Position.OnMoveLeft()
						end,
					},
				}),
				Buffer = e("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 75, 0, 75),
				}, {
					UIListLayout = e("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),
					Image = e("ImageLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 50, 0, 50),
						Image = `rbxassetid://{345081302}`,
					}),
				}),
				RightButton = e(Button, {
					Text = "▶",
					Color = Color3.new(0.7, 0.2, 0.7),
					Activated = function() end,
					native = {
						LayoutOrder = 3,
						[React.Event.MouseButton1Down] = function()
							props.Position.OnMoveRight()
						end,
					},
				}),
			}),
			LowerThird = e("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150 * deviceContext.ScreenScale, 0, 150 * deviceContext.ScreenScale / 3),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				DownButton = e(Button, {
					Text = "▼",
					Color = Color3.new(0.7, 0.2, 0.7),
					Activated = function() end,
					native = {
						LayoutOrder = 1,
						[React.Event.MouseButton1Down] = function()
							props.Position.OnMoveBack()
						end,
					},
				}),
			}),
		}),
		OrientationControlFrame = e("Frame", {
			LayoutOrder = 3,
			Size = UDim2.new(0, 150 * deviceContext.ScreenScale, 0, 150 * deviceContext.ScreenScale),
		}, {

			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0, 100),
			}),

			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			UpperThird = e("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150 * deviceContext.ScreenScale, 0, 150 * deviceContext.ScreenScale / 3),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				UpButton = e(Button, {
					Text = "▲",
					Activated = function() end,
					native = {
						LayoutOrder = 1,
						[React.Event.MouseButton1Down] = function()
							props.Orientation.OnLookUp()
						end,
					},
				}),
			}),
			MiddleThird = e("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150 * deviceContext.ScreenScale, 0, 150 * deviceContext.ScreenScale / 3),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				LeftButton = e(Button, {
					Text = "◀",
					Activated = function() end,
					native = {
						LayoutOrder = 1,
						[React.Event.MouseButton1Down] = function()
							props.Orientation.OnLookLeft()
						end,
					},
				}),
				Buffer = e("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 75, 0, 75),
				}, {
					UIListLayout = e("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),
					Image = e("ImageLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 50, 0, 50),
						Image = `rbxassetid://{134539162713658}`,
					}),
				}),
				RightButton = e(Button, {
					Text = "▶",
					Activated = function() end,
					native = {
						LayoutOrder = 3,
						[React.Event.MouseButton1Down] = function()
							props.Orientation.OnLookRight()
						end,
					},
				}),
			}),
			LowerThird = e("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150 * deviceContext.ScreenScale, 0, 150 * deviceContext.ScreenScale / 3),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				DownButton = e(Button, {
					Text = "▼",
					Activated = props.Orientation.OnLookDown,
					native = {
						LayoutOrder = 1,
						[React.Event.MouseButton1Down] = function()
							props.Orientation.OnLookDown()
						end,
					},
				}),
			}),
		}),
	})

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		ContentFrame = content,
	})
end
