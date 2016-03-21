LVBM.AddOns.Onyxia = { 
	["Name"] = "Onyxia",
	["Abbreviation1"] = "ony", 
	["Version"] = "1",
	["Author"] = "La Vendetta|Nitram",
	["Description"] = LVBM_ONYXIA_INFO,
	["Instance"] = LVBM_OTHER,
	["GUITab"] = LVBMGUI_TAB_OTHER,
	["Options"] = {  
		["Enabled"] = true,
		["Announce"] = false,
	},
	["Events"] = {
		["CHAT_MSG_MONSTER_EMOTE"] = true,
		["CHAT_MSG_MONSTER_YELL"] = true,
		["CHAT_MSG_RAID_BOSS_EMOTE"] = true,
		["CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE"] = true,
		["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"] = true,
		["CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"] = true,
	},
	["OnCombatEnd"] = function()
			LVBM.UnSchedule("LVBM.AddOns.Onyxia.OnEvent");
	end,
	["OnEvent"] = function(event, arg1) 
		if ( event == "CHAT_MSG_RAID_BOSS_EMOTE" ) then
			if( string.find(arg1, LVBM_ONYXIA_BREATH_EMOTE) ) then
				LVBM.Announce(LVBM_ONYXIA_BREATH_ANNOUNCE);
				PlaySoundFile("Interface\\AddOns\\La_Vendetta_Boss_Mods\\Sounds\\alarmbuzzer.ogg", "Master");
			end
		elseif ( event == "CHAT_MSG_MONSTER_YELL" ) then
			if (arg1 == LVBM_ONYXIA_PHASE1_YELL) then
				LVBM.UnSchedule("LVBM.AddOns.Onyxia.OnEvent");
			elseif (arg1 == LVBM_ONYXIA_PHASE2_YELL) then
				LVBM.Announce(LVBM_ONYXIA_PHASE2_ANNOUNCE);
			elseif (arg1 == LVBM_ONYXIA_PHASE3_YELL) then
				LVBM.Announce(LVBM_ONYXIA_PHASE3_ANNOUNCE);
				LVBM.StartStatusBarTimer(10, "Fear");
				LVBM.Schedule(5, "LVBM.AddOns.Onyxia.OnEvent", "FearWarning", 5);
			end
		elseif ( event == "FearWarning" ) then
			LVBM.Announce(string.format(LVBM_ONYXIA_FEAR_WARNING, arg1));
		elseif ( event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" ) then
			if arg1 ~= LVBM_ONYXIA_FEAR then
				return;
			end
			
			LVBM.UnSchedule("LVBM.AddOns.Onyxia.OnEvent");
			LVBM.StartStatusBarTimer(30, "Fear");
			LVBM.Schedule(25, "LVBM.AddOns.Onyxia.OnEvent", "FearWarning", 5);
			LVBM.Announce(LVBM_ONYXIA_FEAR_WARNING2);
		end
	end,		
};