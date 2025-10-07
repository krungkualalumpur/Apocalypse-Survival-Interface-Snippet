--!strict
--services
local RunService = game:GetService("RunService")
--packages
local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")
--modules
local GameConfig = require("@shd/GameConfig")
local InputHandler = require("@pkg/InputHandler")

local DeviceContext = require("@clt/Interfaces/DeviceContext")

local Button = require("@clt/Interfaces/Components/Button")
--types
--constants
--remotes
--variables
local e = React.createElement
--references
--local functions
--class
return function(props: {
	ControlCallbacks: {
		MoveForward: () -> (),
		MoveBack: () -> (),
		TurnLeft: () -> (),
		TurnRight: () -> (),
		StopTurn: () -> (),
		Stop: () -> (),
	},
	LightCallbacks: {
		OnHeadLight: () -> (),
		OnSignalLeft: () -> (),
		OnSignalRight: () -> (),
		OnHazardLight: () -> (),
		OnCarHorn: () -> (),
	},
})
	local onMoveForward, onMoveBack, onTurnLeft, onTurnRight, onStopTurn, onStop =
		React.useCallback(props.ControlCallbacks.MoveForward, {}),
		React.useCallback(props.ControlCallbacks.MoveBack, {}),
		React.useCallback(props.ControlCallbacks.TurnLeft, {}),
		React.useCallback(props.ControlCallbacks.TurnRight, {}),
		React.useCallback(props.ControlCallbacks.StopTurn, {}),
		React.useCallback(props.ControlCallbacks.Stop, {})

	local onHeadLight, onSignalLeft, onSignalRight, onHazardLight, onCarHorn =
		React.useCallback(props.LightCallbacks.OnHeadLight, {}),
		React.useCallback(props.LightCallbacks.OnSignalLeft, {}),
		React.useCallback(props.LightCallbacks.OnSignalRight, {}),
		React.useCallback(props.LightCallbacks.OnHazardLight, {}),
		React.useCallback(props.LightCallbacks.OnCarHorn, {})

	local deviceContext = React.useContext(DeviceContext.context)

	local out = e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		LightsFrame = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		}, {
			UIPadding = e("UIPadding", {
				PaddingTop = UDim.new(0, 10 * deviceContext.ScreenScale),
				PaddingBottom = UDim.new(0, 10 * deviceContext.ScreenScale),
			}),
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),
			SpaceFrame = e("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(250 * deviceContext.ScreenScale, 80 * deviceContext.ScreenScale),
			}),
			Frame = e("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(250 * deviceContext.ScreenScale, 75 * deviceContext.ScreenScale),
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10 * deviceContext.ScreenScale),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				LightButton = e(Button, {
					Image = GameConfig.ASSET_DATA.IMAGE_IDS.CAR_LIGHT_ICON_ID,
					Activated = onHeadLight,
					Scale = 1 * deviceContext.ScreenScale,
					native = {
						LayoutOrder = 1,
					},
				}),
				LeftButton = e(Button, {
					Color = Color3.new(1, 0.8, 0),
					Image = GameConfig.ASSET_DATA.IMAGE_IDS.LEFT_SIGNAL_ICON_ID,
					Activated = onSignalLeft,
					Scale = 1 * deviceContext.ScreenScale,
					native = {
						LayoutOrder = 2,
					},
				}),
				RightButton = e(Button, {
					Color = Color3.new(1, 0.8, 0),
					Image = GameConfig.ASSET_DATA.IMAGE_IDS.RIGHT_SIGNAL_ICON_ID,
					Activated = onSignalRight,
					Scale = 1 * deviceContext.ScreenScale,
					native = {
						LayoutOrder = 3,
					},
				}),
				HazardButton = e(Button, {
					Color = Color3.new(1, 0.552941, 0.552941),
					Image = GameConfig.ASSET_DATA.IMAGE_IDS.HAZARD_SIGNAL_ICON_ID,
					Activated = onHazardLight,
					Scale = 1 * deviceContext.ScreenScale,
					native = {
						LayoutOrder = 4,
					},
				}),
				CarHornButton = e(Button, {
					Image = GameConfig.ASSET_DATA.IMAGE_IDS.VEHICLE_HORN_ICON_ID,
					Activated = onCarHorn,
					Scale = 1 * deviceContext.ScreenScale,
					native = {
						LayoutOrder = 5,
					},
				}),
			}),
		}),

		ControlFrame = if (not RunService:IsStudio() and InputHandler.getClientPlatform() == "Mobile")
				or (RunService:IsStudio())
			then e("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
			}, {
				UIPadding = e("UIPadding", {
					PaddingTop = UDim.new(0, 10 * deviceContext.ScreenScale),
					PaddingBottom = UDim.new(0, 10 * deviceContext.ScreenScale),
					PaddingLeft = UDim.new(0, 10 * deviceContext.ScreenScale),
					PaddingRight = UDim.new(0, 10 * deviceContext.ScreenScale),
				}),
				UIListLayout = e("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
				}),
				Frame = e("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(230 * deviceContext.ScreenScale, 230 * deviceContext.ScreenScale),
				}, {

					LeftButton = e(Button, {
						Text = "←",
						Scale = 2 * deviceContext.ScreenScale,
						Activated = function() end,
						native = {
							Position = UDim2.fromOffset(0, 160 * 0.5 * deviceContext.ScreenScale),
							[React.Event.MouseButton1Down] = onTurnLeft,
							[React.Event.MouseButton1Up] = onStopTurn,
						},
					}),
					RightButton = e(Button, {
						Text = "→",
						Scale = 2 * deviceContext.ScreenScale,
						Activated = function() end,
						native = {
							Position = UDim2.fromOffset(
								160 * deviceContext.ScreenScale,
								160 * 0.5 * deviceContext.ScreenScale
							),
							[React.Event.MouseButton1Down] = onTurnRight,
							[React.Event.MouseButton1Up] = onStopTurn,
						},
					}),
					UpButton = e(Button, {
						Text = "↑",
						Scale = 2 * deviceContext.ScreenScale,
						Activated = function() end,
						native = {
							Position = UDim2.fromOffset(160 * 0.5 * deviceContext.ScreenScale, 0),
							[React.Event.MouseButton1Down] = onMoveForward,
							[React.Event.MouseButton1Up] = onStop,
						},
					}),
					DownButton = e(Button, {
						Text = "↓",
						Scale = 2 * deviceContext.ScreenScale,
						Activated = function() end,
						native = {
							Position = UDim2.fromOffset(
								160 * 0.5 * deviceContext.ScreenScale,
								160 * deviceContext.ScreenScale
							),
							[React.Event.MouseButton1Down] = onMoveBack,
							[React.Event.MouseButton1Up] = onStop,
						},
					}),
				}),
			})
			else nil,
	})

	return out
end
