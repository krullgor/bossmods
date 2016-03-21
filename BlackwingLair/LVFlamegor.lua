LVBM.AddOns.Flamegor = {
	["Name"] = LVBM_FLAMEGOR_NAME,
	["Version"] = "1.0",
	["Author"] = "Tandanu",
	["Description"] = LVBM_FLAMEGOR_DESCRIPTION,
	["Instance"] = LVBM_BWL,
	["GUITab"] = LVBMGUI_TAB_BWL,
	["Sort"] = 6,
	["Options"] = {
		["Enabled"] = true,
		["Announce"] = false,
		["Frenzy"] = true,
	},
	["DropdownMenu"] = {
		[1] = {
			["variable"] = "LVBM.AddOns.Flamegor.Options.Frenzy",
			["text"] = LVBM_FLAMEGOR_ANNOUNCE_FRENZY,
			["func"] = function() LVBM.AddOns.Flamegor.Options.Frenzy = not LVBM.AddOns.Flamegor.Options.Frenzy; end,
		},
	},
	["Events"] = {
		["CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"] = true,
		["CHAT_MSG_MONSTER_EMOTE"] = true,
	},
	["OnCombatStart"] = function(delay)
		LVBM.StartStatusBarTimer(35 - delay, "Wing Buffet");
		LVBM.Schedule(32 - delay, "LVBM.AddOns.Flamegor.OnEvent", "WingBuffetWarning", 3);
		LVBM.Schedule(30 - delay, "LVBM.AddOns.Flamegor.OnEvent", "WingBuffetTimer", 5);
	end,
	["OnEvent"] = function(event, arg1)
		if event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE" then
			if arg1 == LVBM_FLAMEGOR_WING_BUFFET then
				LVBM.Announce(string.format(LVBM_WING_BUFFET_WARNING, 1))
				LVBM.StartStatusBarTimer(1, "Wing Buffet Cast");
				LVBM.Schedule(27, "LVBM.AddOns.Flamegor.OnEvent", "WingBuffetWarning", 3);
				LVBM.Schedule(1, "LVBM.AddOns.Flamegor.OnEvent", "WingBuffetWarning", 29);
				LVBM.Schedule(25, "LVBM.AddOns.Flamegor.OnEvent", "WingBuffetTimer", 5);
			elseif arg1 == LVBM_FLAMEGOR_SHADOW_FLAME then
				LVBM.Announce(LVBM_SHADOW_FLAME_WARNING);
				LVBM.StartStatusBarTimer(2, "Shadow Flame Cast");
			end
		elseif event == "WingBuffetTimer" then
			if arg1 <= 0 then
				return;
			end
			
			LVBM.PlayTimer(arg1);
			LVBM.Schedule(1, "LVBM.AddOns.Flamegor.OnEvent", "WingBuffetTimer", arg1 - 1);
			
		elseif event == "WingBuffetWarning" then
			if arg1 == 3 then
				LVBM.Announce(string.format(LVBM_WING_BUFFET_WARNING, 3));
			elseif arg1 == 29 then
				LVBM.EndStatusBarTimer("Wing Buffet");
				LVBM.StartStatusBarTimer(29, "Wing Buffet");
			end
		elseif event == "CHAT_MSG_MONSTER_EMOTE" then
			if arg1 == LVBM_FLAMEGOR_FRENZY and arg2 == LVBM_FLAMEGOR_FLAMEGOR then
				LVBM.EndStatusBarTimer("Frenzy")
				LVBM.StartStatusBarTimer(9, "Frenzy");
				
				if LVBM.AddOns.Flamegor.Options.Frenzy then
					LVBM.Announce("*** Frenzy ***");
				end
			end
		end
	end,
};
