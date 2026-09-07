if SERVER then
	resource.AddWorkshop("2840058127")
end

CreateConVar("c4_enhanced_mintimer", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The minimum timer C4 can be set to.", 0, 3599)
CreateConVar("c4_enhanced_maxtimer", 3599, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The maximum timer C4 can be set to.", 0, 3599)
CreateConVar("c4_enhanced_damage", 400, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How much damage C4 does when it explodes.")

CreateConVar("c4_enhanced_defusetimer", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How long it takes to defuse C4.", 0, 3599)

CreateConVar("c4_enhanced_use_map_triggers", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether C4 should trigger func_bomb_target outputs.", 0, 1)
CreateConVar("c4_enhanced_restrict_placement", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether C4 should only be placable in func_bomb_target areas.", 0, 1)
CreateConVar("c4_enhanced_free_placement", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether C4 can be placed on props and other entities.", 0, 1)
CreateConVar("c4_enhanced_ignore_world", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether C4 ignores the world when exploding, damaging people through terrain. Uses the CS:S explosion algorithm.", 0, 1)
