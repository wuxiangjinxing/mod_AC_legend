::modAccessoryCompanions <- {
	ID = "mod_AC",
	Name = "Accessory Companions Legends (Rotu)",
	Version = "2.0.0",
	TameChance = 30,
	MinimumLevelToBePlayerControlled = 11,
	PlayerCompanionsStrength = 0,
	EnemyACchanceMult = 10,
	ACPartyStrengthMultiplier = 10,
	ACOnlyPartyStrengthMultiplier = 10,
	scaledCondition = false,
	isEnableEnemyAC = true,
	isEnableTamingEnemyAC = true,
	ACTameAP = 6,
	ACTameFat = 30
}

::modAccessoryCompanions.HooksMod <- ::Hooks.register(::modAccessoryCompanions.ID, ::modAccessoryCompanions.Version, ::modAccessoryCompanions.Name);
::modAccessoryCompanions.HooksMod.require("mod_msu >= 1.2.6", "mod_legends>= 18.1.0", "mod_modern_hooks>= 0.4.10");
::modAccessoryCompanions.HooksMod.queue(">mod_legends",">mod_nggh_magic_concept",">mod_legends_PTR",">mod_world_editor_legends",">Chirutiru_balance",">mod_Chirutiru_enemies",">zChirutiru_equipment", function()
{
	::modAccessoryCompanions.Mod <- ::MSU.Class.Mod(::modAccessoryCompanions.ID, ::modAccessoryCompanions.Version, ::modAccessoryCompanions.Name);
    ::modAccessoryCompanions.Mod.Debug.setFlag("debug", true)
	
	local page = ::modAccessoryCompanions.Mod.ModSettings.addPage("General");
	local settingTameChance = page.addRangeSetting("TameChance", 5, 1, 100, 1.0, "Taming chance", "General chance of taming companion");
	local settingMinimumLevelToBePlayerControlled = page.addRangeSetting("MinimumLevelToBePlayerControlled", 11, 1, 99, 1.0, "Minimum Level To Be Player Controlled", "Minimum level of companion when in becomes player controllable");
	local settingEnemyACchanceMult = page.addRangeSetting("EnemyACchanceMultiplier", 10, 0, 40, 1.0, "Enemy AC Chance Multiplier divided by 10", "Enemy AC Chance Multiplier divided by 10");
	local settingACPartyStrengthMultiplier = page.addRangeSetting("ACpartyStrengthMultiplier", 10, 0, 100, 1.0, "Multiplier for AC Party Strength addition divided by 10", "Multiplier for AC Party Strength addition divided by 10");
	local settingIsEnableEnemyAC = page.addBooleanSetting("EnableEnemyAC", false, "Enable Enemy AC", "When checked some enemy humans have their companions with them in battle.");
	local settingIsEnableTamingEnemyAC = page.addBooleanSetting("isEnableTamingEnemyAC", false, "Enable Taming Enemy AC", "When checked enemy companions can be tamed.");
	local settingACOnlyPartyStrengthMultiplier = page.addRangeSetting("ACOnlypartyStrengthMultiplier", 10, 0, 100, 1.0, "Multiplier for party strength of enemy AC divided by 10", "Multiplier for party strength of enemy AC divided by 10");
	local settingACTameAP = page.addRangeSetting("skill_tame_ap", 6, 1, 9, 1, "AP cost of Tame skill");
	local settingACTameFat = page.addRangeSetting("skill_tame_fat", 30, 1, 50, 1, "Fatigue cost of Tame skill");
	
	settingIsEnableTamingEnemyAC.addCallback(function(_value) { ::modAccessoryCompanions.isEnableTamingEnemyAC = _value; });
	settingIsEnableEnemyAC.addCallback(function(_value) { ::modAccessoryCompanions.isEnableEnemyAC = _value; });
	settingTameChance.addCallback(function(_value) { ::modAccessoryCompanions.TameChance = _value; });
	settingMinimumLevelToBePlayerControlled.addCallback(function(_value) { ::modAccessoryCompanions.MinimumLevelToBePlayerControlled = _value; });
	settingEnemyACchanceMult.addCallback(function(_value) { ::modAccessoryCompanions.EnemyACchanceMult = _value; });
	settingACPartyStrengthMultiplier.addCallback(function(_value) { ::modAccessoryCompanions.ACPartyStrengthMultiplier = _value; });
	settingACOnlyPartyStrengthMultiplier.addCallback(function(_value) { ::modAccessoryCompanions.ACOnlyPartyStrengthMultiplier = _value; });
	settingACTameAP.addCallback(function(_value) { ::modAccessoryCompanions.ACTameAP = _value; });
	settingACTameFat.addCallback(function(_value) { ::modAccessoryCompanions.ACTameFat = _value; });

	if (!("Is_MC_Exist" in this.getroottable())) ::Is_MC_Exist <- ::mods_getRegisteredMod("mod_nggh_magic_concept") != null;
	if (!("Is_PTR_Exist" in this.getroottable())) ::Is_PTR_Exist <- ::mods_getRegisteredMod("mod_legends_PTR") != null;
	
	// load hook files
	::include("ac_hooks/load.nut");
}, ::Hooks.QueueBucket.Normal);