local RunService = game:GetService("RunService")

return function(Text)
	assert(RunService:IsServer(),Text)
end