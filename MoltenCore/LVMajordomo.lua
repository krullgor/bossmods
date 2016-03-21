LVBM.AddOns.Majordomo = { 
	["Name"] = LVBM_DOMO_NAME,
	["Abbreviation1"] = "Majordomo", 
	["Abbreviation2"] = "Domo",
	["Version"] = "1.0",
	["Author"] = "La Vendetta|Nitram",
	["Description"] = LVBM_DOMO_INFO,
	["Instance"] = LVBM_MC,
	["GUITab"] = LVBMGUI_TAB_MC,
	["Sort"] = 9,
	["Options"] = {  
		["Enabled"] = true,
		["Announce"] = false,
	},
	["Shield"] = "",
	["IsShielding"] = false,
	["IsFading"] = false,
	["Events"] = {
		["CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS"] = true,
		["CHAT_MSG_SPELL_AURA_GONE_OTHER"] = true,
	},	
	["OnCombatStart"] = function(delay)
		LVBM.Schedule(10 - delay, "LVBM.AddOns.Majordomo.OnEvent", "ShieldWarning", LVBM_DOMO_DAMAGE_SHIELD);
		LVBM.Schedule(15 - delay, "LVBM.AddOns.Majordomo.OnEvent", "DamageReflect");
		LVBM.StartStatusBarTimer(15 - delay, "Damage reflect in");
	end,
	["OnEvent"] = function(event, arg1) 
		if ( event == "MagicReflect" ) then
			LVBM.AddOns.Majordomo.Shield = LVBM_DOMO_MAGIC_REFLECTION;
			LVBM.StartStatusBarTimer(10, "Magic reflection");
			
			LVBM.StartStatusBarTimer(15, "Damage reflect in");
			LVBM.Schedule(10, "LVBM.AddOns.Majordomo.OnEvent", "ShieldWarning", LVBM_DOMO_DAMAGE_SHIELD);
			LVBM.Schedule(15, "LVBM.AddOns.Majordomo.OnEvent", "DamageReflect");
		elseif ( event == "DamageReflect" ) then
			LVBM.AddOns.Majordomo.Shield = LVBM_DOMO_DAMAGE_SHIELD;
			LVBM.StartStatusBarTimer(10, "Damage reflection");
			
			LVBM.StartStatusBarTimer(15, "Magic reflect in");
			LVBM.Schedule(10, "LVBM.AddOns.Majordomo.OnEvent", "ShieldWarning", LVBM_DOMO_MAGIC_REFLECTION);
			LVBM.Schedule(15, "LVBM.AddOns.Majordomo.OnEvent", "MagicReflect");
		elseif ( event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" ) then
			if ( string.find(arg1, LVBM_DOMO_FADE_DAMAGE) or string.find(arg1, LVBM_DOMO_FADE_MAGIC) ) and not LVBM.AddOns.Majordomo.IsFading then
				LVBM.AddOns.Majordomo.IsFading = true;
				LVBM.Schedule(5, "LVBM.AddOns.Majordomo.OnEvent", "ResetFadingVar");
				LVBM.Announce(string.format(LVBM_DOMO_SHIELD_FADED, LVBM.AddOns.Majordomo.Shield));
			end
		elseif ( event == "ResetFadingVar" ) then
			LVBM.AddOns.Majordomo.IsFading = false;
		elseif ( event == "ShieldWarning" ) and ( type(arg1) == "string" ) then
			LVBM.AddOns.Majordomo.IsShielding = false;
			if ( arg1 == LVBM_DOMO_DAMAGE_SHIELD ) then
				LVBM.Announce(string.format(LVBM_DOMO_SHIELD_WARNING2, LVBM_DOMO_DAMAGE_SHIELD, 5));
			elseif ( arg1 == LVBM_DOMO_MAGIC_REFLECTION ) then
				LVBM.Announce(string.format(LVBM_DOMO_SHIELD_WARNING2, LVBM_DOMO_MAGIC_REFLECTION, 5));
			end
		end
	end,		
};
