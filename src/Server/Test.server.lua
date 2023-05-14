local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ProCommand = require(ReplicatedStorage.lib)

ProCommand.newType{
	Name = "Player";
	Convert = function(Executor: Player, PlayerName: string): Player?
		if (type(PlayerName) ~= "string") then return end
		
		return if (PlayerName:lower() == "me") then Executor else Players:FindFirstChild(PlayerName)
	end;
	Get = function(Executor: Player): {string}
		local Output = {}
		
		for _, Player: Player in Players:GetPlayers() do
			table.insert(Output, Player.Name)
		end
		
		if (RunService:IsClient()) then
			table.insert(Output, 1, "me")
		end
		
		return Output
	end;
	Validate = function(Executor: Player, Value: any): boolean
		return Value:IsA("Player")
	end;
}

ProCommand.newType{
	Name = "CustomArgument";
	Convert = function(Executor: Player, PlayerName: string): Player?
		if (type(PlayerName) ~= "string") then return end
		
		return if (PlayerName:lower() == "me") then Executor else Players:FindFirstChild(PlayerName)
	end;
	Get = function(Executor: Player): {string}
		local Output = {}
		
		for _, Player: Player in Players:GetPlayers() do
			table.insert(Output, Player.Name)
		end
		
		if (RunService:IsClient()) then
			table.insert(Output, 1, "me")
		end
		
		return Output
	end;
	Validate = function(Executor: Player, Value: any): boolean
		return (type(Value) == "table") and (type(Value[1]) == "string")
	end;
}

ProCommand.newCommand{
	Name = "Kick";
	Arguments = {
		{"Player"};
		{"string", "Message"};
	};
	Run = function(Executor: Player, Player: Player, Message: string)
		Player:Kick(Message)
	end;
}

ProCommand.newCommand{
	Name = "Position";
	Arguments = {
		{"Player"};
		{"Vector3", "Position"};
	};
	Run = function(Executor: Player, Player: Player, Position: Vector3)
		local Character = Player.Character
		if not (Character) then return end

		Character:PivotTo(CFrame.new(Position))
	end;
}

ProCommand.newCommand{
	Name = "Sleep";
	Arguments = {
		{"number", "Seconds"};
	};
	Run = function(Executor: Player, Time: number)
		task.wait(Time)
	end;
}

ProCommand.newCommand{
	Name = "Loop";
	Arguments = {
		{"number", "Times"};
		{"Command", "Loop Command"};
	};
	Run = function(Executor: Player, Times: number, Command: string)
		for i = 1, Times do
			ProCommand.run(Executor, Command)
		end
	end;
}

ProCommand.newCommand{
	Name = "Alias";
	Arguments = {
		{"string", "Name"};
		{"Command", "Command"};
	};
	Run = function(Executor: Player, Name: string, Command: string)
		print(Name, Command)
		ProCommand.newCommand{
			Name = Name;
			Arguments = {};
			Run = function(Executor: Player)
				ProCommand.run(Executor, Command)
			end;
		}
	end;
}

print(ProCommand.Registered)

Players.PlayerAdded:Connect(function(Player: Player)
	Player.Chatted:Connect(function(Message: string)
		if not (Message:match("^/")) then return end

		Message = Message:gsub("/", "", 1)

		warn(Message)

		ProCommand.run(Player, Message)
	end)
end)