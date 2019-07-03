require "lib/my"
require "lib/timers"
require "lib/end_screen"
require "lib/data"
require "lib/notifications"
require "lib/popup"
require "game_mode"
require "titan_spawner"


function do_precache(elements, handle)
	for _, e in ipairs(elements) do
		handle(e)
	end
end


function Precache(context)

	local items = {

	}

	local models = {

	}

	local particles = {

	}

	local soundevents = {

	}

	local units = {

	}



	do_precache(items, 
		function(e) 
			PrecacheItemByNameSync(e, context) 
		end
	)

	do_precache(models, 
		function(e) 
			PrecacheModel(e, context)
		end
	)

	do_precache(particles, 
		function(e) 
			PrecacheResource("particle", e, context)
		end
	)

	do_precache(soundevents, 
		function(e) 
			PrecacheResource("soundfile", e, context)
		end
	)

	do_precache(units, 
		function(e) 
			PrecacheUnitByNameSync(e, context)
		end
	)
end


function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
