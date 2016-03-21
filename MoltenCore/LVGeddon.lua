LVBM.AddOns.Geddon = { 
	["Name"] = LVBM_BARON_NAME,
	["Abbreviation1"] = "Geddon", 
	["Version"] = "1.0",
	["Author"] = "La Vendetta|Nitram",
	["Description"] = LVBM_BARON_INFO,
	["Instance"] = LVBM_MC,
	["GUITab"] = LVBMGUI_TAB_MC,
	["Sort"] = 5,
	["Options"] = {  
		["Enabled"] = true,
		["Announce"] = false,
		["Whisper"] = false,
		["SetIcon"] = true,
	},
	["DropdownMenu"] = {
		[1] = {
			["variable"] = "LVBM.AddOns.Geddon.Options.Whisper",
			["text"] = LVBM_BARON_SEND_WHISPER,
			["func"] = function() LVBM.AddOns.Geddon.Options.Whisper = not LVBM.AddOns.Geddon.Options.Whisper; end,
		},
		[2] = {
			["variable"] = "LVBM.AddOns.Geddon.Options.SetIcon",
			["text"] = LVBM_BARON_SET_ICON,
			["func"] = function() LVBM.AddOns.Geddon.Options.SetIcon = not LVBM.AddOns.Geddon.Options.SetIcon; end,
		},
	},
	["Events"] = {
		["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"] = true,
		["CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE"] = true,
		["CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"] = true,
		["CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS"] = true,
	},	
	["OnCombatStart"] = function(delay)
		LVBM.Schedule(25 - delay, "LVBM.AddOns.Geddon.OnEvent", "InfernoWarning", 5);
		LVBM.Schedule(30 - delay, "LVBM.AddOns.Geddon.OnEvent", "Inferno");
		LVBM.StartStatusBarTimer(30 - delay, "Inferno in");
	end,
	["OnCombatEnd"] = function()
		if( LVBM.AddOns.Geddon.Options.SetIcon ) then
			LVBM.CleanUp();
		end
	end,
	["OnEvent"] = function(event, arg1) 
		if ( event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" or 
		     event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" or 
		     event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE" ) then
		     
			local Name, Type
			_, _, Name, Type = string.find(arg1, LVBM_BARON_BOMB_REGEXP);
			if ( Name and Type ) then
				if ( Name == LVBM_YOU and Type == LVBM_ARE ) then
					Name = UnitName("player");
					PlaySoundFile("Interface\\AddOns\\La_Vendetta_Boss_Mods\\Sounds\\alarmbuzzer.ogg", "Master");
					LVBM.AddSpecialWarning(LVBM_BARON_BOMB_WHISPER);					
				else
					if( LVBM.AddOns.Geddon.Options.Whisper ) then
						LVBM.SendHiddenWhisper(LVBM_BARON_BOMB_WHISPER, Name);
					end				
				end
				LVBM.Announce(string.format(LVBM_BARON_BOMB_WARNING, Name));
				if LVBM.AddOns.Geddon.Options.SetIcon then
					local targetID;
					for i = 1, GetNumRaidMembers() do
						if UnitName("raid"..i) == Name then
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
			end
		elseif ( event == "Inferno" ) then
			LVBM.Announce(LVBM_BARON_INFERNO_WARNING);
			LVBM.StartStatusBarTimer(8, "Inferno");
			LVBM.Schedule(8, "LVBM.AddOns.Geddon.OnEvent", "InfernoDone");
		elseif ( event == "InfernoWarning" ) then
			LVBM.Announce(string.format(LVBM_BARON_INFERNO_HEADSUP, arg1));
		elseif ( event == "InfernoDone" ) then
			LVBM.Schedule(17, "LVBM.AddOns.Geddon.OnEvent", "InfernoWarning", 5);
			LVBM.Schedule(22, "LVBM.AddOns.Geddon.OnEvent", "Inferno");
			LVBM.StartStatusBarTimer(22, "Inferno in");
		end
	end,		
};
