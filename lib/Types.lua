local Types = {}

export type TypeInfo = {
	Name: string;

	Convert: (Executor: Player, Text: string) -> any;
	Get: (Executor: Player, Text: string) -> {string}?;
	Validate: (Executor: Player, Value: any) -> boolean?;
}

export type CommandInfo = {
	Name: string;
	Arguments: {string};

	Run: (Executor: Player, Arguments...) -> nil;
}

return Types