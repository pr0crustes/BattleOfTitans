require "lib/timers"
require "lib/notifications"
require "internal/constants"
require "internal/my"
require "internal/end_screen"
require "internal/popup"
require "internal/cheats"
require "internal/chat_handler"
require "internal/shop_handler"
require "internal/bshop"
require "ai/ai_core"
require "mercenary_spawner"
require "creep_spawner"
require "titan_spawner"
require "game_mode"


function do_precache(elements, handle)
	for _, e in ipairs(elements) do
		handle(e)
	end
end


function Precache(context)

	local items = {

	}

	local models = {
		"models/props_gameplay/morokai_orb.vmdl",
	}

	local particles = {
		"particles/units/heroes/hero_medusa/medusa_base_attack.vpcf",
	}

	local soundevents = {

	}

	local units = {
		"mercenary_frost_splash_orb",
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
