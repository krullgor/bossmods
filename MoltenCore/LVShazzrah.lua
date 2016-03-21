LVBM.AddOns.Shazzrah = { 
	["Name"] = LVBM_SHAZZRAH_NAME,
	["Abbreviation1"] = "Shazz", 
	["Version"] = "1.1",
	["Author"] = "La Vendetta|Nitram",
	["Description"] = LVBM_SHAZZRAH_INFO,
	["Instance"] = LVBM_MC,
	["GUITab"] = LVBMGUI_TAB_MC,
	["Sort"] = 6,
	["Options"] = {  
		["Enabled"] = true,
		["Announce"] = false,
	},
	["Curse"] = false,
	["InCombat"] = false,
	["Events"] = {
		["CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS"] = true,
		["CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE"] = true,
		["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"] = true,
		["CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"] = true,
	},	
	["OnCombatStart"] = function(delay)
		LVBM.AddOns.Shazzrah.InCombat = true;
		LVBM.Schedule(25 - delay, "LVBM.AddOns.Shazzrah.OnEvent", "TeleportWarning", 5);
		LVBM.Schedule(30 - delay, "LVBM.AddOns.Shazzrah.OnEvent", "TeleportWarning", 0);
		LVBM.StartStatusBarTimer(30 - delay, "Teleport");
	end,
	["OnCombatEnd"] = function()
		LVBM.AddOns.Shazzrah.InCombat = false;
	end,
	["OnEvent"] = function(event, arg1)
		if ( event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS" ) then
			if ( arg1 == LVBM_SHAZZRAH_DEADEN_MAGIC ) then
				LVBM.Announce(LVBM_SHAZZRAH_DEADEN_WARN);
			end
		elseif ( event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" ) then
			if ( string.find(arg1, LVBM_SHAZZRAH_CURSE_REGEXP) ) and not LVBM.AddOns.Shazzrah.Curse then
				LVBM.AddOns.Shazzrah.Curse = true;
				LVBM.Announce(LVBM_SHAZZRAH_CURSE_WARNING);
				LVBM.Schedule(15, "LVBM.AddOns.Lucifron.OnEvent", "CurseWarning", 5);
				LVBM.EndStatusBarTimer("Curse");
				LVBM.StartStatusBarTimer(20, "Curse");
			end
		elseif ( event == "CurseWarning" ) then
			if arg1 then
				LVBM.Announce(string.format(LVBM_SHAZZRAH_CURSE_SOON_WARNING, arg1));
				LVBM.AddOns.Shazzrah.Curse = false;
			end
		elseif ( event == "TeleportWarning" and LVBM.AddOns.Shazzrah.InCombat ) then
				if ( arg1 == 0 ) then
					LVBM.Schedule(40, "LVBM.AddOns.Shazzrah.OnEvent", "TeleportWarning", 5);
					LVBM.StartStatusBarTimer(45, "Teleport");
				else
					LVBM.Announce(string.format(LVBM_SHAZZRAH_TELEPORT_WARNING, arg1));
					PlaySoundFile("Interface\\AddOns\\La_Vendetta_Boss_Mods\\Sounds\\alarmbuzzer.ogg", "Master");
				end
		end
	end,		
};
