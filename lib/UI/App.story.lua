return function(target)
	local App = require(script.Parent.App){
		
	}
	App.Parent = target

	return function()
		App:Destroy()
	end
end