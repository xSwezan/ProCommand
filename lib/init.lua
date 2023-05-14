local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Types = require(script.Types)
local Registered = require(script.Registered)
local VerifyArguments = require(script.Util.VerifyArguments)
local RegisterDefaultTypes = require(script.Util.RegisterDefaultTypes)
local CheckServer = require(script.Util.CheckServer)
local shift = require(script.Util.shift)
local SplitString = require(script.Util.SplitString)
local RemoveSemicolon = require(script.Util.RemoveSemicolon)
local RemoveCommandString = require(script.Util.RemoveCommandString)

if (RunService:IsClient()) then
	return require(script.Client)
end

local RegisteredUpdated: RemoteEvent = Instance.new("RemoteEvent")
RegisteredUpdated.Name = "RegisteredUpdated"
RegisteredUpdated.Parent = script

Players.PlayerAdded:Connect(function(Player: Player)
	RegisteredUpdated:FireClient(Player, Registered.Commands, Registered.Types)
end)

local ProCommand = {
	Registered = Registered;
}

function ProCommand.newType(Info: Types.TypeInfo)
	CheckServer("You can only create new types on the Server!")

	Registered.Types[Info.Name] = Info

	RegisteredUpdated:FireAllClients(Registered.Commands, Registered.Types)
end

function ProCommand.newCommand(Info: Types.CommandInfo)
	CheckServer("You can only create new commands on the Server!")

	VerifyArguments(Info.Arguments)
	Registered.Commands[Info.Name] = Info

	RegisteredUpdated:FireAllClients(Registered.Commands, Registered.Types)
end

function ProCommand.run(Executor: Player, CommandString: string)
	CheckServer("You can only run commands on the Server!")

	print(CommandString)
	local RawArguments: {string} = SplitString(RemoveCommandString(CommandString))
	print(RawArguments)

	local Commands = {}

	local function GetCommand()
		local CommandName: string, RemovedSemicolon: boolean = RemoveSemicolon(shift(RawArguments))
		-- local CommandName: string = RemoveCommandString(CommandName)
		warn(CommandName)
		if not (CommandName) then return end
		if not (Registered.Commands[CommandName]) then return end

		local CommandArguments = {}

		if (RemovedSemicolon) then -- Command escaped with semicolon doesn't have Arguments
			table.insert(Commands,{
				Name = CommandName,
				Arguments = {},
			})

			GetCommand()
		else
			local IsSemicolon = false

			repeat
				local CurrentArgument: string = shift(RawArguments)
	
				IsSemicolon = ((CurrentArgument or ""):match("^(.-);$") ~= nil)
				if (IsSemicolon) then
					local RemovedSemicolon = CurrentArgument:gsub("^(.-);$", "%1", 1)
					CurrentArgument = RemovedSemicolon
				end
	
				local ShouldBreak: boolean = (CurrentArgument == nil) or (IsSemicolon)
				if (CurrentArgument) then
					table.insert(CommandArguments, CurrentArgument)
				end
			until ShouldBreak

			table.insert(Commands,{
				Name = CommandName,
				Arguments = CommandArguments,
			})

			if (IsSemicolon) then
				GetCommand()
			end
		end
	end

	GetCommand()

	print("Commands", Commands)

	for Index, Command: {Name: string, Arguments: {}} in ipairs(Commands) do
		local ConvertedArguments: {any} = {}

		local CommandInfo: Types.CommandInfo = Registered.Commands[Command.Name]
		if not (CommandInfo) then continue end

		local ShouldBreak = false

		for Index: number, Argument: {string} in ipairs(CommandInfo.Arguments) do
			if not (Command.Arguments[Index]) then continue end
			local ArgumentValue: string = Command.Arguments[Index]

			print(ArgumentValue)

			local TypeName: string = Argument[1]
			if not (type(TypeName) == "string") then continue end

			print(TypeName)

			local Type: Types.TypeInfo = Registered.Types[TypeName]
			if not (Type) then continue end

			print(Type)

			local FinalValue: any = if (type(Type.Convert) == "function") then Type.Convert(Executor, ArgumentValue) else ArgumentValue

			if (type(Type.Validate) == "function") then
				local Success: boolean, CanProceed: boolean? = pcall(Type.Validate, Executor, FinalValue)
				if (Success ~= true) then
					ShouldBreak = true
					break
				end
				if (CanProceed ~= true) then ShouldBreak = true break end
			end

			table.insert(ConvertedArguments, FinalValue)
		end

		if (ShouldBreak) then break end

		if (type(CommandInfo.Run) == "function") then
			CommandInfo.Run(Executor, unpack(ConvertedArguments))
		end
	end
end

RegisterDefaultTypes(ProCommand)

return ProCommand