local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local App = require(script.Parent.UI.App)
local Registered = require(script.Parent.Registered)

local Player: Player = Players.LocalPlayer

if not (RunService:IsClient()) then return end

local RegisteredUpdated: RemoteEvent = script.Parent:WaitForChild("RegisteredUpdated")
RegisteredUpdated.OnClientEvent:Connect(function(Commands: {}, Types: {})
	print("Updated!", Commands, Types)
	Registered.Commands = Commands
	Registered.Types = Types
end)

local Client = {}

local Gui = App{}
Gui.Parent = Player:WaitForChild("PlayerGui")

return Client