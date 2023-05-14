local Patterns = require(script.Parent.Patterns)
local FixStringNumber = require(script.Parent.FixStringNumber)
return function(ProCommand)
	ProCommand.newType{
		Name = "string";
		Convert = function(Executor: Player, Text: string): string
			return Text
		end;
		Get = function(Executor: Player): {string}?
			
		end;
	}
	ProCommand.newType{
		Name = "number";
		Convert = function(Executor: Player, Text: string): number
			return tonumber(Text)
		end;
		Get = function(Executor: Player, Text: string): {string}?
			if (tonumber(Text)) then return end

			return {"0"}
		end;
		Validate = function(Executor: Player, Value: any): boolean
			return (type(Value) == "number")
		end;
	}
	ProCommand.newType{
		Name = "boolean";
		Convert = function(Executor: Player, Text: string): boolean
			if (Text == "true") then
				return true
			elseif (Text == "false") then
				return false
			end
		end;
		Get = function(Executor: Player, Text: string): {string}?
			return {"true", "false"}
		end;
		Validate = function(Executor: Player, Value: any): boolean
			return (type(Value) == "boolean")
		end;
	}
	ProCommand.newType{
		Name = "Vector3";
		Convert = function(Executor: Player, Text: string): Vector3?
			local X, Y, Z = Text:gsub(" ", ""):match(`^({Patterns.Number}),({Patterns.Number}),({Patterns.Number})$`)
			if not (X) or not (Y) or not (Z) then return end

			return Vector3.new(tonumber(X), tonumber(Y), tonumber(Z))
		end;
		Get = function(Executor: Player, Text: string): {string}
			local X, Y, Z = Text:gsub(" ", ""):match(`^({Patterns.Number}),({Patterns.Number}),({Patterns.Number})$`)
	
			X = tonumber(FixStringNumber(X or "")) or 0
			Y = tonumber(FixStringNumber(Y or "")) or 0
			Z = tonumber(FixStringNumber(Z or "")) or 0
	
			return {`{X},{Y},{Z}`}
		end;
		Validate = function(Executor: Player, Value: Vector3?): boolean
			return (typeof(Value) == "Vector3")
		end;
	}
	ProCommand.newType{
		Name = "Command";
		Convert = function(Executor: Player, Text: string): Vector3?
			print(`Convert: "{Text}" -> "{Text:gsub("^|?(.-)|?$", "|%1|", 1)}"`)
			return Text:gsub("^|?(.-)|?$", "|%1|", 1)
		end;
		Get = function(Executor: Player, Text: string): {string}
			
		end;
		Validate = function(Executor: Player, Text: string): boolean
			print(`Validate: "{Text}" = {(Text:match("^|(.-)|$") ~= nil)}`)
			return (Text:match("^|(.-)|$") ~= nil)
		end;
	}
end