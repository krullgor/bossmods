-- 
-- Broodlord Mandokir v1.0
--

LVBM.AddOns.Mandokir = { 
	["Name"] = "Broodlord Mandokir",
	["Abbreviation1"] = "Mandokir", 
	["Version"] = "1.0",
	["Author"] = "La Vendetta|Nitram",
	["Description"] = LVBM_MANDOKIR_INFO,
	["Instance"] = LVBM_ZG,
	["GUITab"] = LVBMGUI_TAB_20PL,
	["Options"] = {  
		["Enabled"] = true,
		["Announce"] = false,
		["Wisper"] = false,
		["SetIcon"] = true,
	},
	["DropdownMenu"] = {
		[1] = {
			["variable"] = "LVBM.AddOns.Mandokir.Options.Whisper",
			["text"] = LVBM_MANDOKIR_WHISPER_INFO,
			["func"] = function() LVBM.AddOns.Mandokir.Options.Whisper = not LVBM.AddOns.Mandokir.Options.Whisper; end,
		},
		[2] = {
			["variable"] = "LVBM.AddOns.Mandokir.Options.SetIcon",
			["text"] = LVBM_MANDOKIR_SETICON_INFO,
			["func"] = function() LVBM.AddOns.Mandokir.Options.SetIcon = not LVBM.AddOns.Mandokir.Options.SetIcon; end,
		},
	},
	["Sort"] = 4,
	["Events"] = {
		["CHAT_MSG_MONSTER_YELL"] = true,
		["CHAT_MSG_COMBAT_HOSTILE_DEATH"] = true,
	},	
	["OnCombatEnd"] = function()
		LVBM.EndStatusBarTimer("Cleave");
		LVBM.EndStatusBarTimer("Whirlwind");
		LVBM.EndStatusBarTimer("Watch Player");
		LVBM.UnSchedule("LVBM.AddOns.Mandokir.OnEvent");
	end,
	["OnEvent"] = function(event, arg1)
		if ( event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" ) then
			if string.find(arg1, "Mandokir") then
				LVBM.EndStatusBarTimer("Cleave");
				LVBM.EndStatusBarTimer("Whirlwind");
				LVBM.EndStatusBarTimer("Watch Player");
				LVBM.UnSchedule("LVBM.AddOns.Mandokir.OnEvent");
			end
		end
		
		if ( event == "WarnWatch" ) then
				LVBM.Announce(string.format(LVBM_MANDOKIR_WARN_WATCH, arg1));
				
		elseif ( event == "WarnCleave" ) then
				LVBM.Announce(string.format(LVBM_MANDOKIR_WARN_CLEAVE, arg1));
		elseif ( event == "Cleave" ) then
			LVBM.StartStatusBarTimer(7, "Cleave");
			LVBM.Schedule(2, "LVBM.AddOns.Mandokir.OnEvent", "WarnCleave", 5);
			LVBM.Schedule(7, "LVBM.AddOns.Mandokir.OnEvent", "Cleave", 5);
			
		elseif ( event == "WarnWhirlwind" ) then
				LVBM.Announce(string.format(LVBM_MANDOKIR_WARN_WHIRLWIND, arg1));
		elseif ( event == "Whirlwind" ) then
			LVBM.StartStatusBarTimer(18, "Whirlwind");
			LVBM.Schedule(13, "LVBM.AddOns.Mandokir.OnEvent", "WarnWhirlwind", 5);
			LVBM.Schedule(18, "LVBM.AddOns.Mandokir.OnEvent", "Whirlwind", 5);
			
		elseif ( event == "CHAT_MSG_MONSTER_YELL" ) then
			if arg1 == LVBM_MANDOKIR_AGGRO then
				LVBM.StartStatusBarTimer(33, "Watch Player");
				LVBM.Schedule(27, "LVBM.AddOns.Mandokir.OnEvent", "WarnWatch", 5);
				LVBM.StartStatusBarTimer(7, "Cleave");
				LVBM.Schedule(2, "LVBM.AddOns.Mandokir.OnEvent", "WarnCleave", 5);
				LVBM.Schedule(7, "LVBM.AddOns.Mandokir.OnEvent", "Cleave", 5);
				LVBM.StartStatusBarTimer(20, "Whirlwind");
				LVBM.Schedule(15, "LVBM.AddOns.Mandokir.OnEvent", "WarnWhirlwind", 5);
				LVBM.Schedule(20, "LVBM.AddOns.Mandokir.OnEvent", "Whirlwind", 5);
			end
		end
		
		if ( event == "CHAT_MSG_MONSTER_YELL" and string.find(arg1, LVBM_MANDOKIR_WATCH_EXPR) ) then
		
			LVBM.StartStatusBarTimer(26, "Watch Player");
			LVBM.Schedule(21, "LVBM.AddOns.Mandokir.OnEvent", "WarnWatch", 5);
			
			local _, _, sArg1 = string.find(arg1, LVBM_MANDOKIR_WATCH_EXPR);
			if ( sArg1 ) then
				if ( sArg1 == UnitName("player") ) then
					LVBM.AddSpecialWarning(LVBM_MANDOKIR_SELFWARN);
					LVBM.PlaySound("alarmbuzzer.ogg");
					sArg1 = UnitName("player");

				else
					if LVBM.AddOns.Mandokir.Options.Whisper then
						LVBM.SendHiddenWhisper(LVBM_MANDOKIR_WHISPER_TEXT, sArg1);
					end
				end

				if LVBM.AddOns.Mandokir.Options.SetIcon then
					local targetID;
					for i = 1, GetNumRaidMembers() do
						if UnitName("raid"..i) == sArg1 then
							targetID = i;
							break;
						end
					end
					if targetID and LVBM.Rank >= 1 then
						if GetRaidTargetIndex("raid"..targetID) ~= 8 then
							SetRaidTargetIcon("raid"..targetID, 8);
						end
					end	
				end
				LVBM.Announce(string.format(LVBM_MANDOKIR_WATCH_ANNOUNCE, sArg1));
			end
		end
	end,		
};
