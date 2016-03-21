LVBM.AddOns.Lucifron = { 
	["Name"] = LVBM_LUCIFRON_NAME,
	["Abbreviation1"] = "Luci", 
	["Version"] = "1.0",
	["Author"] = "La Vendetta|Nitram",
	["Description"] = LVBM_LUCIFRON_INFO,
	["Instance"] = LVBM_MC,
	["GUITab"] = LVBMGUI_TAB_MC,
	["Sort"] = 1,
	["Options"] = {  
		["Enabled"] = true,
		["Announce"] = false,
	},
	["Events"] = {
		["CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE"] = true,
		["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"] = true,
		["CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"] = true,
	},	
	["OnCombatStart"] = function(delay)
		LVBM.Schedule(5 - delay, "LVBM.AddOns.Lucifron.OnEvent", "DoomWarning", 5);
		LVBM.StartStatusBarTimer(10 - delay, "Impending Doom");
		LVBM.Schedule(15 - delay, "LVBM.AddOns.Lucifron.OnEvent", "CurseWarning", 0);
		LVBM.StartStatusBarTimer(20 - delay, "Curse");
	end,
	["OnEvent"] = function(event, arg1)
		if ( event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" ) then
			if ( string.find(arg1, LVBM_LUCIFRON_CURSE_REGEXP) or string.find(arg1, LVBM_LUCIFRON_CURSE_REGEXP_YOU) ) then
				LVBM.Schedule(15, "LVBM.AddOns.Lucifron.OnEvent", "CurseWarning", 5);
				LVBM.StartStatusBarTimer(20, "Curse");
			elseif ( string.find(arg1, LVBM_LUCIFRON_DOOM_REGEXP) or string.find(arg1, LVBM_LUCIFRON_DOOM_REGEXP_YOU) ) then
				LVBM.Schedule(10, "LVBM.AddOns.Lucifron.OnEvent", "DoomWarning", 5);
				LVBM.StartStatusBarTimer(15, "Impending Doom");
			end
		elseif (event == "CurseWarning") then
			if arg1 then
				LVBM.Announce(string.format(LVBM_LUCIFRON_CURSE_SOON_WARNING, arg1));
			end
		elseif (event == "DoomWarning") then
			if arg1 then
				LVBM.Announce(string.format(LVBM_LUCIFRON_DOOM_SOON_WARNING, arg1));
			end
		end
	end,		
};
