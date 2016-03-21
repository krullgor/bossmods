LVBM.AddOns.Razorgore = {
	["Name"] = LVBM_RG_NAME,
	["Abbreviation1"] = "rg",
	["Abbreviation2"] = "razor",
	["Version"] = "1.0",
	["Author"] = "Ike",
	["Description"] = LVBM_RG_DESCRIPTION,
	["Instance"] = LVBM_BWL,
	["GUITab"] = LVBMGUI_TAB_BWL,
	["Sort"] = 1,
	["Options"] = {
		["Enabled"] = true,
		["Announce"] = false,
	},
	["ConflagTimer"] = 10,
	["ConflagCooldown"] = 0,
	["Events"] = {
		--["CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"] = true,
		["CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"] = true,
		["CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"] = true,
	},
	["OnCombatStart"] = function(delay)
		LVBM.StartStatusBarTimer(35 - delay, "Add Spawn");
	end,
	["OnEvent"] = function(event, arg1)
		if event == "FireballVolleyWarning" then
			LVBM.Announce(string.format(LVBM_RG_FIREBALL_VOLLEY_WARNING, 5));
		elseif event == "ConflagrationWarning" then
			LVBM.PlayTimer(LVBM.AddOns.Razorgore.ConflagTimer);
			LVBM.AddOns.Razorgore.ConflagTimer = LVBM.AddOns.Razorgore.ConflagTimer - 1;
			if LVBM.AddOns.Razorgore.ConflagTimer > 0 then
				LVBM.Schedule(1, "LVBM.AddOns.Razorgore.OnEvent", "ConflagrationWarning", LVBM.AddOns.Razorgore.ConflagTimer);
			end
		elseif event == "ConflagCooldown" then
			LVBM.AddOns.Razorgore.ConflagCooldown = 0;
		elseif string.find(arg1, LVBM_RG_FIREBALL_VOLLEY) then
			LVBM.StartStatusBarTimer(10, "Fireball Volley");
			LVBM.Schedule(5, "LVBM.AddOns.Razorgore.OnEvent", "FireballVolleyWarning", 5);
		elseif string.find(arg1, LVBM_RG_CONFLAGRATION) and LVBM.AddOns.Razorgore.ConflagCooldown == 0 then
			LVBM.AddOns.Razorgore.ConflagCooldown = 12;
			LVBM.StartStatusBarTimer(13, "Conflagration");
			LVBM.Schedule(2, "LVBM.AddOns.Razorgore.OnEvent", "ConflagrationWarning", 10);
			LVBM.Schedule(10, "LVBM.AddOns.Razorgore.OnEvent", "ConflagCooldown", 0);
			LVBM.AddOns.Razorgore.ConflagTimer = 10;
		end
	end,
};
