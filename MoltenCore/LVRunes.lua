LVBM.AddOns.Runes = { 
	["Name"] = LVBM_RUNES_NAME,
	["Abbreviation1"] = "Run",
	["Abbreviation1"] = "Ru",
	["Version"] = "1.0",
	["Author"] = "Torg",
	["Description"] = LVBM_RUNES_INFO,
	["Instance"] = LVBM_MC,
	["GUITab"] = LVBMGUI_TAB_MC,
	["Sort"] = 11,
	["Options"] = {  
		["Enabled"] = true,
		["Frame"] = false,
	},
	["Events"] = {
		["CHAT_MSG_MONSTER_YELL"] = true,
		["CHAT_MSG_ADDON"] = true,
	},
	["DropdownMenu"] = {
		[1] = {
			["variable"] = "LVBM.AddOns.Runes.Options.Frame",
			["text"] = LVBM_RUNES_SHOW_FRAME,
			["func"] = function() 
				LVBM_Gui_RunesFrame( LVBM.AddOns.Runes.Options.Frame );
			end,
		},
	
	},
	["OnEvent"] = function(event, arg1) 
		if ( event == "CHAT_MSG_MONSTER_YELL" ) then
			local _, _, arg1 = string.find(arg1, LVBM_DOWSED_RUNE_REGEXP);
			if ( arg1 ) then
				LVBM_Gui_UpdateRunesFrame(arg1);
			end
		elseif ( event == "CHAT_MSG_ADDON" ) then
			LVBM.AddOns.Runes.Options.Frame = false;
		end
	end,
};