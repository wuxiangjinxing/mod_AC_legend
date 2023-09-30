::modAccessoryCompanions <- {
	ID = "mod_AC",
	Name = "Accessory Companions",
	Version = "1.30.30",
	TameChance = 3,
	MinimumLevelToBePlayerControlled = 11,
	PlayerCompanionsStrength = 0,
	EnemyACchanceMult = 10,
	ACPartyStrengthMultiplier = 10,
	ACOnlyPartyStrengthMultiplier = 10,
	scaledCondition = false,
	isEnableEnemyAC = true,
	isEnableTamingEnemyAC = false
}

::mods_registerMod(::modAccessoryCompanions.ID, ::modAccessoryCompanions.Version, ::modAccessoryCompanions.Name);
::mods_queue(::modAccessoryCompanions.ID, "mod_legends,>mod_nggh_magic_concept,>mod_legends_PTR,!mod_world_editor_legends,>Chirutiru_balance,>mod_Chirutiru_enemies,>zChirutiru_equipment", function()
{
	::modAccessoryCompanions.Mod <- ::MSU.Class.Mod(::modAccessoryCompanions.ID, ::modAccessoryCompanions.Version, ::modAccessoryCompanions.Name);
    ::modAccessoryCompanions.Mod.Debug.setFlag("debug", true)
	
	local page = ::modAccessoryCompanions.Mod.ModSettings.addPage("General");
	local settingTameChance = page.addRangeSetting("TameChance", 3, 1, 100, 1.0, "Taming chance", "General chance of taming companion");
	local settingMinimumLevelToBePlayerControlled = page.addRangeSetting("MinimumLevelToBePlayerControlled", 11, 1, 99, 1.0, "Minimum Level To Be Player Controlled", "Minimum level of companion when in becomes player controllable");
	local settingEnemyACchanceMult = page.addRangeSetting("EnemyACchanceMultiplier", 40, 0, 40, 1.0, "Enemy AC Chance Multiplier divided by 10", "Enemy AC Chance Multiplier divided by 10");
	local settingACPartyStrengthMultiplier = page.addRangeSetting("ACpartyStrengthMultiplier", 10, 0, 100, 1.0, "Multiplier for AC Party Strength addition divided by 10", "Multiplier for AC Party Strength addition divided by 10");
	local settingIsEnableEnemyAC = page.addBooleanSetting("EnableEnemyAC", true, "Enable Enemy AC", "When checked some enemy humans have their companions with them in battle.");
	local settingIsEnableTamingEnemyAC = page.addBooleanSetting("isEnableTamingEnemyAC", false, "Enable Taming Enemy AC", "When checked enemy companions can be tamed.");
	local settingACOnlyPartyStrengthMultiplier = page.addRangeSetting("ACOnlypartyStrengthMultiplier", 10, 0, 100, 1.0, "Multiplier for party strength of enemy AC divided by 10", "Multiplier for party strength of enemy AC divided by 10");
	
	
	
	settingIsEnableTamingEnemyAC.addCallback(function(_value) { ::modAccessoryCompanions.isEnableTamingEnemyAC = _value; });
	settingIsEnableEnemyAC.addCallback(function(_value) { ::modAccessoryCompanions.isEnableEnemyAC = _value; });
	settingTameChance.addCallback(function(_value) { ::modAccessoryCompanions.TameChance = _value; });
	settingMinimumLevelToBePlayerControlled.addCallback(function(_value) { ::modAccessoryCompanions.MinimumLevelToBePlayerControlled = _value; });
	settingEnemyACchanceMult.addCallback(function(_value) { ::modAccessoryCompanions.EnemyACchanceMult = _value; });
	settingACPartyStrengthMultiplier.addCallback(function(_value) { ::modAccessoryCompanions.ACPartyStrengthMultiplier = _value; });
	settingACOnlyPartyStrengthMultiplier.addCallback(function(_value) { ::modAccessoryCompanions.ACOnlyPartyStrengthMultiplier = _value; });
	
	///// make companions heal their wounds at the same time as brothers heal theirs
	::mods_hookNewObjectOnce("states/world/asset_manager", function(o)
	{
		local update = o.update;
		o.update = function(_worldState)
		{
			if (this.World.getTime().Hours != this.m.LastHourUpdated && this.m.IsConsumingAssets)
			{
				local roster = this.World.getPlayerRoster().getAll();
				foreach(bro in roster)
				{
					local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					if (acc != null && "setType" in acc)
					{
						if (acc.getType() != null && acc.m.Wounds > 0)
						{
							acc.m.Wounds = this.Math.max(0, this.Math.floor(acc.m.Wounds - 2));
						}
					}
				}

				local stash = this.World.Assets.getStash().getItems();
				foreach(item in stash)
				{
					if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "setType" in item)
					{
						if (item.getType() != null && item.m.Wounds > 0)
						{
							item.m.Wounds = this.Math.max(0, this.Math.floor(item.m.Wounds - 2));
						}
					}
				}
			}

			update(_worldState);
		}
	});

	///// give players the ability to tame beasts
	::mods_hookExactClass("entity/tactical/player", function(o)
	{
		local onInit = ::mods_getMember(o, "onInit");
		o.onInit = function()
		{
			onInit();
			if (this.m.IsControlledByPlayer && !this.getSkills().hasSkill("actives.companions_tame"))
				this.m.Skills.add(this.new("scripts/companions/player/companions_tame"));
		}
	});

	if (::mods_getRegisteredMod("mod_nggh_magic_concept") != null)
	{
		::mods_hookBaseClass("entity/tactical/player", function(o)
		{
			if ("onInit" in o)
			{
				local onInit = ::mods_getMember(o, "onInit");
				o.onInit = function()
				{
					onInit();
					if (this.m.IsControlledByPlayer && "Mount" in this.m && !this.getSkills().hasSkill("actives.companions_tame"))
						this.m.Skills.add(this.new("scripts/companions/player/companions_tame"));
				}
			}
		});
	}
	
	::mods_hookExactClass("states/tactical_state", function ( o )
	{	
		local onInit = o.onInit;
		o.onInit = function ()
		{
			::modAccessoryCompanions.scaledCondition = false;
			if(this.World.State.getPlayer() != null)
			{
				local companyStrength = this.World.State.getPlayer().getStrength();
				
				local company = this.World.getPlayerRoster().getAll();
				if (company.len() > this.World.Assets.getBrothersScaleMax())
				{
					company.sort(this.onLevelCompare);
				}
	
				local count = 0;
				local companionsStrength = 0;
				foreach( i, bro in company )
				{
					if (i >= this.World.Assets.getBrothersScaleMax())
					{
						break;
					}
					
					local companion = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					if (companion != null && "setType" in companion)
					{
						local mult = 1.0;
						if (companion.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
							mult = 2.0;
						
						if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 9)
						{
							companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 22.0) * this.pow(companion.m.Level, 0.17) * mult;
						}
						else if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 5)
						{
							companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 10.0) * this.pow(companion.m.Level, 0.17) * mult;
						}
						else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 9)
						{
							companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 60.0) * this.pow(companion.m.Level, 0.17) * mult;
						}
						else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 5)
						{
							companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 25.0) * this.pow(companion.m.Level, 0.17) * mult;
						}
						else 
						{
							companionsStrength += count + this.Const.Companions.Library[companion.getType()].PartyStrength * this.pow(companion.m.Level, 0.17) * mult;
						}
						count++;
					}
					
					local companions;
					if (bro.getSkills().hasSkill("perk.legend_packleader"))
					{
						companions = bro.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag);
					
						if (companions != null)
						{
							foreach (j, c in companions)
							{
								local companion = c;
								if (companion != null && "setType" in companion)
								{
									local mult = 0.75;
									if (companion.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
										mult = 1.5;
									
									if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 9)
									{
										companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 22.0) * this.pow(companion.m.Level, 0.17) * mult;
									}
									else if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 5)
									{
										companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 10.0) * this.pow(companion.m.Level, 0.17) * mult;
									}
									else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 9)
									{
										companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 60.0) * this.pow(companion.m.Level, 0.17) * mult;
									}
									else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 5)
									{
										companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 25.0) * this.pow(companion.m.Level, 0.17) * mult;
									}
									else 
									{
										companionsStrength += count + this.Const.Companions.Library[companion.getType()].PartyStrength * this.pow(companion.m.Level, 0.17) * mult;
									}
									count++;
								}
							}
						}
					}
				}
				
				::modAccessoryCompanions.PlayerCompanionsStrength = companionsStrength;
				local pureCompanyStrength = companyStrength - ::modAccessoryCompanions.PlayerCompanionsStrength;
				::modAccessoryCompanions.PlayerCompanionsStrength =  (::modAccessoryCompanions.PlayerCompanionsStrength + pureCompanyStrength * this.Math.rand(0, 5) * 0.01) * ::modAccessoryCompanions.ACOnlyPartyStrengthMultiplier * 0.1;
				if ((25.0 + this.Math.min(companyStrength, 3000.0) * 0.0167) * ::modAccessoryCompanions.EnemyACchanceMult * 0.1  > this.Math.rand(1, 100))  //start from 25% at 0 PS and end at 75% at 3000 PS
				{
					::modAccessoryCompanions.scaledCondition = true;
				}
			}
			
			onInit();
		}
	});

	///// necromancers have a chance to drop the Tome of Reanimation when killed, webknecht eggs have a chance to drop a webknecht companion when killed
	///// Doing this in a different way
	::mods_hookExactClass("entity/tactical/enemies/necromancer", function(o)
	{
		local makeMiniboss = ::mods_getMember(o, "makeMiniboss");
		o.makeMiniboss = function()
		{
			makeMiniboss();
			local loot = this.new("scripts/items/accessory/wardog_item");
			loot.setType(this.Const.Companions.TypeList.TomeReanimation);
			loot.updateCompanion();
			this.m.Items.equip(loot);
		}
		
		local onDeath = ::mods_getMember(o, "onDeath");
		o.onDeath = function(_killer, _skill, _tile, _fatalityType)
		{
			onDeath(_killer, _skill, _tile, _fatalityType);
			if ((this.m.Type == this.Const.EntityType.Necromancer) && (_killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals))
			{
				if (this.Math.rand(1, 100) == 1)
				{
					local loot = this.new("scripts/items/accessory/wardog_item");
					loot.setType(this.Const.Companions.TypeList.TomeReanimation);
					loot.updateCompanion();
					loot.drop(_tile);
				}
			}
		}
	});
	
	::mods_hookExactClass("entity/tactical/humans/barbarian_chosen", function(o)
	{
		local makeMiniboss = ::mods_getMember(o, "makeMiniboss");
		o.makeMiniboss = function()
		{
			makeMiniboss();
			local loot = this.new("scripts/items/accessory/wardog_item");
			loot.setType(this.Const.Companions.TypeList.Whitewolf);
			loot.giverandXP();
			loot.updateCompanion();
			this.m.Items.equip(loot);
		}
	});	
	
	::mods_hookDescendants("entity/tactical/human", function(o)
	{	
			if ("assignRandomEquipment" in o)
			{
				local assignRandomEquipment = o.assignRandomEquipment;
				o.assignRandomEquipment <- function()
				{
					if (("State" in this.Tactical) && this.Tactical.State != null && this.Tactical.State.getStrategicProperties() != null && !this.Tactical.State.getStrategicProperties().IsArenaMode)
					{
						if (::modAccessoryCompanions.isEnableEnemyAC && ::modAccessoryCompanions.scaledCondition && this.getFaction() > this.Const.Faction.PlayerAnimals && ::modAccessoryCompanions.PlayerCompanionsStrength > 0 && !this.isAlliedWithPlayer())
						{
							local tierRoll = this.Math.rand(1, 100);			
							local rollType = 0;
							
							if (tierRoll > this.Math.min(80, 33.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.002)))
							{
								rollType = this.Math.rand(0,8);  				//doggos
								if (rollType == 7)
									rollType = 22;
								if (rollType == 8)
									rollType = 23;
							}
							else if (tierRoll > this.Math.min(60, 16.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.004)))
								rollType = this.Math.rand(0,3) * 2 + 7; 		// 7,9,11,13  - direwolf + spider + nacho
							else if (tierRoll > this.Math.min(40, 6.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.003)))
								rollType = this.Math.rand(0,3) * 2 + 8;			// 8,10,12,14  - frenzy + alp + snake
							else if (tierRoll > this.Math.min(10, 1.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.006)))
							{
								rollType = this.Math.rand(15,20);
								while (rollType == 19)							// big ones
								{
									rollType = 21;
								}
							}
							else 
								rollType = this.Math.rand(26,32);				// legendary
			
							local loot = this.new("scripts/items/accessory/wardog_item");
							loot.setType(rollType);
							loot.giverandXP();
							loot.updateCompanion();
						
							local lootStr = 0;
							if (loot.getType() == this.Const.Companions.TypeList.Nacho && loot.m.Level >= 9)
							{
								lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 22.0) * this.pow(loot.m.Level, 0.17);
							}
							else if (loot.getType() == this.Const.Companions.TypeList.Nacho && loot.m.Level >= 5)
							{
								lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 10.0) * this.pow(loot.m.Level, 0.17);
							}
							else if (loot.getType() == this.Const.Companions.TypeList.SkinGhoul && loot.m.Level >= 9)
							{
								lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 60.0) * this.pow(loot.m.Level, 0.17);
							}
							else if (loot.getType() == this.Const.Companions.TypeList.SkinGhoul && loot.m.Level >= 5)
							{
								lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 25.0) * this.pow(loot.m.Level, 0.17);
							}
							else
							{
								lootStr = this.Const.Companions.Library[loot.getType()].PartyStrength * this.pow(loot.m.Level, 0.17);
							}
							
							if (loot.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
								lootStr *= 2;
						
							if(::modAccessoryCompanions.PlayerCompanionsStrength - lootStr > 0)
							{
								::modAccessoryCompanions.PlayerCompanionsStrength = ::modAccessoryCompanions.PlayerCompanionsStrength - lootStr;
								this.m.Items.equip(loot);
							}
						}
					}
					assignRandomEquipment();
					
				}
			}
			else
			{
				o.assignRandomEquipment <- function()
				{
					if (("State" in this.Tactical) && this.Tactical.State && this.Tactical.State.getStrategicProperties() != null && !this.Tactical.State.getStrategicProperties().IsArenaMode)
					{
						if (::modAccessoryCompanions.isEnableEnemyAC && ::modAccessoryCompanions.scaledCondition && this.getFaction() > this.Const.Faction.PlayerAnimals && ::modAccessoryCompanions.PlayerCompanionsStrength > 0 && !this.isAlliedWithPlayer())
						{
							local tierRoll = this.Math.rand(1, 100);			
							local rollType = 0;
							
							if (tierRoll > this.Math.min(80, 33.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.002)))
							{
								rollType = this.Math.rand(0,8);  				//doggos
								if (rollType == 7)
									rollType = 22;
								if (rollType == 8)
									rollType = 23;
							}
							else if (tierRoll > this.Math.min(60, 16.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.004)))
								rollType = this.Math.rand(0,3) * 2 + 7; 		// 7,9,11,13  - direwolf + spider + nacho
							else if (tierRoll > this.Math.min(40, 6.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.003)))
								rollType = this.Math.rand(0,3) * 2 + 8;			// 8,10,12,14  - frenzy + alp + snake
							else if (tierRoll > this.Math.min(10, 1.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.006)))
							{
								rollType = this.Math.rand(15,20);
								while (rollType == 19)							// big ones
								{
									rollType = 21;
								}
							}
							else 
								rollType = this.Math.rand(26,32);				// legendary
			
							local loot = this.new("scripts/items/accessory/wardog_item");
							loot.setType(rollType);
							loot.giverandXP();
							loot.updateCompanion();
						
							local lootStr = 0;
							if (loot.getType() == this.Const.Companions.TypeList.Nacho && loot.m.Level >= 9)
							{
								lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 22.0) * this.pow(loot.m.Level, 0.17);
							}
							else if (loot.getType() == this.Const.Companions.TypeList.Nacho && loot.m.Level >= 5)
							{
								lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 10.0) * this.pow(loot.m.Level, 0.17);
							}
							else if (loot.getType() == this.Const.Companions.TypeList.SkinGhoul && loot.m.Level >= 9)
							{
								lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 60.0) * this.pow(loot.m.Level, 0.17);
							}
							else if (loot.getType() == this.Const.Companions.TypeList.SkinGhoul && loot.m.Level >= 5)
							{
								lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 25.0) * this.pow(loot.m.Level, 0.17);
							}
							else
							{
								lootStr = this.Const.Companions.Library[loot.getType()].PartyStrength * this.pow(loot.m.Level, 0.17);
							}
							
							if (loot.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
								lootStr *= 2;
						
							if (::modAccessoryCompanions.PlayerCompanionsStrength - lootStr > 0)
							{
								::modAccessoryCompanions.PlayerCompanionsStrength = ::modAccessoryCompanions.PlayerCompanionsStrength - lootStr;
							this.m.Items.equip(loot);
							}
						}
					}
					this.actor.assignRandomEquipment();
				}
			}
	});	
	
	///// give companions experience when the player kills something
	::mods_hookExactClass("entity/tactical/player", function(o)
	{
		local onActorKilled = o.onActorKilled;
		o.onActorKilled = function(_actor, _tile, _skill)
		{
			onActorKilled(_actor, _tile, _skill);
			local XPkiller = this.Math.floor(_actor.getXPValue() * this.Const.XP.XPForKillerPct);
			local XPgroup = _actor.getXPValue() * (1.0 - this.Const.XP.XPForKillerPct);
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
			foreach(bro in brothers)
			{
				local cAcc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
				if (cAcc != null && "setType" in cAcc)
				{
					if (cAcc.getType() != null)
						cAcc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
				}
			}

			local kAcc = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
			if (kAcc != null && "setType" in kAcc)
			{
				if (kAcc.getType() != null)
					kAcc.addXP(XPkiller);
			}
		}
	});

	local undead = [
		"enemies/zombie",
		"skeleton"
	]
	
	///// make reanimated zombies and skeletons grant the company experience when they kill something
	foreach(ud in undead)
	{	
		::mods_hookBaseClass("entity/tactical/" + ud, function(o)
		{
			if ("onActorKilled" in o)
			{
				local onActorKilled = o.onActorKilled;
				o.onActorKilled <- function(_actor, _tile, _skill)
				{
					if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
					{
						local XPgroup = _actor.getXPValue();
						local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
						foreach( bro in brothers )
						{
							bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
	
							local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
							if (acc != null && "setType" in acc)
							{
								if (acc.getType() != null)
									acc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
							}
						}
					}
					onActorKilled(_actor, _tile, _skill);
				}
			}
			else
			{
				o.onActorKilled <- function(_actor, _tile, _skill)
				{
					if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
					{
						local XPgroup = _actor.getXPValue();
						local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
						foreach( bro in brothers )
						{
							bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
	
							local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
							if (acc != null && "setType" in acc)
							{
								if (acc.getType() != null)
									acc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
							}
						}
					}
					this.actor.onActorKilled(_actor, _tile, _skill);
				}
			}
		});
	}

	///// equipped companions add to player party strength
	::mods_hookExactClass("entity/world/player_party", function(o)
	{	
		local updateStrength = o.updateStrength;
		o.updateStrength = function(_addACStrength = true)
		{
			updateStrength();
			
			if (_addACStrength)
			{
				local companionsStrength = 0.0;
				if(this.World.State.getPlayer() != null)
				{
					
					local company = this.World.getPlayerRoster().getAll();
					if (company.len() > this.World.Assets.getBrothersScaleMax())
					{
						company.sort(this.onLevelCompare);
					}
		
					local count = 0;
					foreach( i, bro in company )
					{
						if (i >= this.World.Assets.getBrothersScaleMax())
						{
							break;
						}
						
						local companion = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
						if (companion != null && "setType" in companion)
						{
							local mult = 1.0;
							if (companion.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
								mult = 2.0;
							
							if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 9)
							{
								companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 22.0) * this.pow(companion.m.Level, 0.17) * mult;
							}
							else if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 5)
							{
								companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 10.0) * this.pow(companion.m.Level, 0.17) * mult;
							}
							else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 9)
							{
								companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 60.0) * this.pow(companion.m.Level, 0.17) * mult;
							}
							else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 5)
							{
								companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 25.0) * this.pow(companion.m.Level, 0.17) * mult;
							}
							else 
							{
								companionsStrength += count + this.Const.Companions.Library[companion.getType()].PartyStrength * this.pow(companion.m.Level, 0.17) * mult;
							}
							count++;
						}
						
						local companions;
						if (bro.getSkills().hasSkill("perk.legend_packleader"))
						{
							companions = bro.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag);
						
							if (companions != null)
							{
								foreach (j, c in companions)
								{
									local companion = c;
									if (companion != null && "setType" in companion)
									{
										local mult = 0.75;
										if (companion.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
											mult = 1.5;
										
										if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 9)
										{
											companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 22.0) * this.pow(companion.m.Level, 0.17) * mult;
										}
										else if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 5)
										{
											companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 10.0) * this.pow(companion.m.Level, 0.17) * mult;
										}
										else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 9)
										{
											companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 60.0) * this.pow(companion.m.Level, 0.17) * mult;
										}
										else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 5)
										{
											companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 25.0) * this.pow(companion.m.Level, 0.17) * mult;
										}
										else 
										{
											companionsStrength += count + this.Const.Companions.Library[companion.getType()].PartyStrength * this.pow(companion.m.Level, 0.17) * mult;
										}
										count++;
									}
								}
							}
						}
					}
					
					companionsStrength = companionsStrength * ::modAccessoryCompanions.ACPartyStrengthMultiplier * 0.1;
				}
				
				this.m.Strength += companionsStrength;
			}
		}
		
		o.getStrength <- function()
		{
			this.updateStrength();
			return this.m.Strength;
		}			
	});

	///// wardogs and warhounds retain their name, variant, level, XP, attributes and quirks after an armor upgrade
	::mods_hookExactClass("items/misc/wardog_armor_upgrade_item", function(o)
	{
		o.onUse = function(_actor, _item = null)
		{
			local dog = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) : _item;
			if (dog == null || !("setType" in dog))
			{
				return false;
			}

			local new_dog;
			switch (dog.getType()) 
			{
			    case this.Const.Companions.TypeList.Wardog:
			        new_dog = this.new("scripts/items/accessory/armored_wardog_item");
					new_dog.setType(this.Const.Companions.TypeList.WardogArmor);
			        break;

			    case this.Const.Companions.TypeList.Warhound:
			       	new_dog = this.new("scripts/items/accessory/armored_warhound_item");
					new_dog.setType(this.Const.Companions.TypeList.WarhoundArmor);
			        break;

			    case this.Const.Companions.TypeList.Warwolf:
			       	new_dog = this.new("scripts/items/accessory/armored_wolf_item");
					new_dog.setType(this.Const.Companions.TypeList.WarwolfArmor);
			        break;
			
			    default:
			    	return false;
			}

			new_dog.setName(dog.getName());
			new_dog.setVariant(dog.getVariant());
			new_dog.setLevel(dog.getLevel());
			new_dog.setXP(dog.getXP());
			new_dog.setWounds(dog.getWounds());
			new_dog.setAttributes(dog.getAttributes());
			new_dog.setQuirks(dog.getQuirks());
			new_dog.setEntity(dog.getEntity());
			new_dog.updateCompanion();
			_actor.getItems().unequip(dog);
			_actor.getItems().equip(new_dog);
			this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
			return true;
		}
	});

	///// wardogs and warhounds retain their name, variant, level, XP, attributes and quirks after an armor upgrade
	::mods_hookExactClass("items/misc/wardog_heavy_armor_upgrade_item", function(o)
	{
		o.onUse = function(_actor, _item = null)
		{
			local dog = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) : _item;
			if (dog == null || !("setType" in dog))
			{
				return false;
			}

			local new_dog;
			switch (dog.getType()) 
			{
			    case this.Const.Companions.TypeList.Wardog:
			    case this.Const.Companions.TypeList.WardogArmor:
			        new_dog = this.new("scripts/items/accessory/heavily_armored_wardog_item");
					new_dog.setType(this.Const.Companions.TypeList.WardogArmorHeavy);
			        break;

			    case this.Const.Companions.TypeList.Warhound:
			    case this.Const.Companions.TypeList.WarhoundArmor:
			       	new_dog = this.new("scripts/items/accessory/heavily_armored_warhound_item");
					new_dog.setType(this.Const.Companions.TypeList.WarhoundArmorHeavy);
			        break;

			    case this.Const.Companions.TypeList.Warwolf:
			    case this.Const.Companions.TypeList.WarwolfArmor:
			       	new_dog = this.new("scripts/items/accessory/heavily_armored_wolf_item");
					new_dog.setType(this.Const.Companions.TypeList.WarwolfArmorHeavy);
			        break;
			
			    default:
			    	return false;
			}

			new_dog.setName(dog.getName());
			new_dog.setVariant(dog.getVariant());
			new_dog.setLevel(dog.getLevel());
			new_dog.setXP(dog.getXP());
			new_dog.setWounds(dog.getWounds());
			new_dog.setAttributes(dog.getAttributes());
			new_dog.setQuirks(dog.getQuirks());
			new_dog.setEntity(dog.getEntity());
			new_dog.updateCompanion();
			_actor.getItems().unequip(dog);
			_actor.getItems().equip(new_dog);
			this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
			return true;
		}
	});
	
	///// make the feast ability to be targeted
	::mods_hookExactClass("skills/actives/gruesome_feast", function(o){
		local create = o.create;
		o.create = function()
		{
			create();
			this.m.IsTargeted = true;
		}
		
		local onVerifyTarget = o.onVerifyTarget;
		o.onVerifyTarget = function(_originTile, _targetTile )
		{
			if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			{
				return false;
			}

			if (!_originTile.IsCorpseSpawned)
			{
				return false;
			}

			if (!_originTile.Properties.get("Corpse").IsConsumable)
			{
				return false;
			}

			return true;
		}
	});
	
	///// make nacho's swallow skill available on non-miniboss, non-huge targets made from flesh
	::mods_hookExactClass("skills/actives/swallow_whole_skill", function(o)
	{
		local onVerifyTarget = o.onVerifyTarget;
		o.onVerifyTarget = function(_originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		
		local entities = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

		if (entities.len() == 1)
		{
			return false;
		}
		
		local hostilesNum = this.Tactical.Entities.getHostilesNum();
		
		if (hostilesNum == 1)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target == null)
		{
			return false;
		}

		//if (target.getFlags().has("IsSummoned"))
		//{
		//	return false;
		//}
		
		//if ((target.getFaction() != this.Const.Faction.Player) && (this.getContainer().getActor().getFaction() != this.Const.Faction.PlayerAnimals))
		//{
		//	return false;
		//}
		
		local ET = _targetTile.getEntity().getType();
		local ETC = this.Const.EntityType;

		if (ET == ETC.Kraken || ET == ETC.KrakenTentacle)
		{
			return false;
		}
		if (ET == ETC.SkeletonLich || ET == ETC.SkeletonLichMirrorImage || ET == ETC.SkeletonPhylactery || ET == ETC.FlyingSkull)
		{
			return false;
		}
		if (ET == ETC.BarbarianMadman || ET == ETC.TricksterGod)
		{
			return false;
		}
		if (ET == ETC.ZombieBoss)
		{
			return false;
		}
		if (ET == ETC.SkeletonBoss || ET == ETC.SkeletonHeavy || ET == ETC.SkeletonLight || ET == ETC.SkeletonMedium || ET == ETC.SkeletonPriest)
		{
			return false;
		}
		if (ET == ETC.OrcWarlord)
		{
			return false;
		}
		if (ET == ETC.BarbarianChosen)
		{
			return false;
		}
		if (ET == ETC.Lindwurm)
		{
			return false;
		}
		if (ET == ETC.Mortar)
		{
			return false;
		}
		if (ET == ETC.GreenskinCatapult)
		{
			return false;
		}
		if (ET == ETC.Schrat)
		{
			return false;
		}
		if (ET == ETC.LegendOrcBehemoth)
		{
			return false;
		}
		if (ET == ETC.LegendStollwurm)
		{
			return false;
		}
		if (ET == ETC.LegendRockUnhold)
		{
			return false;
		}
		if (ET == ETC.LegendGreenwoodSchrat)
		{
			return false;
		}
		if (ET == ETC.LegendVampireLord || ET == ETC.Vampire)
		{
			return false;
		}
		if (ET == ETC.BanditWarlord)
		{
			return false;
		}
		if (ET == ETC.LegendMummyQueen || ET == ETC.LegendMummyPriest || ET == ETC.LegendMummyMedium || ET == ETC.LegendMummyLight || ET == ETC.LegendMummyHeavy)
		{
			return false;
		}
		if (ET == ETC.LegendOrcElite)
		{
			return false;
		}
		if (ET == ETC.LegendWhiteDirewolf)
		{
			return false;
		}
		if (ET == ETC.LegendSkinGhoul || ET == ETC.Ghoul)
		{
			return false;
		}
		if (ET == ETC.LegendRedbackSpider)
		{
			return false;
		}
		if (ET == ETC.LegendBanshee || ET == ETC.Ghost || ET == ETC.LegendDemonHound)
		{
			return false;
		}
		if (ET == ETC.SandGolem)
		{
			return false;
		}
		
		if(target.m.IsMiniboss)
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile) && !_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab;
	}
	
	o.onUse = function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || this.knockToTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " devours " + this.Const.UI.getColorizedEntityName(target));
		}

		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		skills.removeByID("effects.legend_vala_chant_disharmony_effect");
		skills.removeByID("effects.legend_vala_chant_fury_effect");
		skills.removeByID("effects.legend_vala_chant_senses_effect");
		skills.removeByID("effects.legend_vala_currently_chanting");
		skills.removeByID("effects.legend_vala_in_trance");

		if (target.getMoraleState() != this.Const.MoraleState.Ignore)
		{
			target.setMoraleState(this.Const.MoraleState.Breaking);
		}

		this.Tactical.getTemporaryRoster().add(target);
		this.Tactical.TurnSequenceBar.removeEntity(target);
		this.m.SwallowedEntity = target;
		this.m.SwallowedEntity.getFlags().set("Devoured", true);
		this.m.SwallowedEntity.setHitpoints(this.Math.max(5, this.m.SwallowedEntity.getHitpoints() - this.Math.rand(10, 20)));
		target.removeFromMap();
		_user.getSprite("body").setBrush("bust_ghoul_body_04");
		_user.getSprite("injury").setBrush("bust_ghoul_04_injured");
		_user.getSprite("head").setBrush("bust_ghoul_04_head_0" + _user.m.Head);
		_user.m.Sound[this.Const.Sound.ActorEvent.Death] = _user.m.Sound[this.Const.Sound.ActorEvent.Other2];
		local effect = this.new("scripts/skills/effects/swallowed_whole_effect");
		effect.setName(target.getName());
		_user.getSkills().add(effect);

		if (this.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
		}

		return true;
	}
	});
	
	///// make skin nacho's swallow skill available on non-miniboss, non-huge targets made from flesh
	::mods_hookExactClass("skills/actives/legend_skin_ghoul_swallow_whole_skill", function(o)
	{
		local onVerifyTarget = o.onVerifyTarget;
		o.onVerifyTarget = function(_originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		
		local entities = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

		if (entities.len() == 1)
		{
			return false;
		}
		
		local hostilesNum = this.Tactical.Entities.getHostilesNum();
		
		if (hostilesNum == 1)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target == null)
		{
			return false;
		}

		//if (target.getFlags().has("IsSummoned"))
		//{
		//	return false;
		//}
		
		local ET = _targetTile.getEntity().getType();
		local ETC = this.Const.EntityType;

		if (ET == ETC.Kraken || ET == ETC.KrakenTentacle)
		{
			return false;
		}
		if (ET == ETC.SkeletonLich || ET == ETC.SkeletonLichMirrorImage || ET == ETC.SkeletonPhylactery || ET == ETC.FlyingSkull)
		{
			return false;
		}
		if (ET == ETC.BarbarianMadman || ET == ETC.TricksterGod)
		{
			return false;
		}
		if (ET == ETC.ZombieBoss)
		{
			return false;
		}
		if (ET == ETC.SkeletonBoss || ET == ETC.SkeletonHeavy || ET == ETC.SkeletonLight || ET == ETC.SkeletonMedium || ET == ETC.SkeletonPriest)
		{
			return false;
		}
		if (ET == ETC.OrcWarlord)
		{
			return false;
		}
		if (ET == ETC.BarbarianChosen)
		{
			return false;
		}
		if (ET == ETC.Lindwurm)
		{
			return false;
		}
		if (ET == ETC.Mortar)
		{
			return false;
		}
		if (ET == ETC.GreenskinCatapult)
		{
			return false;
		}
		if (ET == ETC.Schrat)
		{
			return false;
		}
		if (ET == ETC.LegendOrcBehemoth)
		{
			return false;
		}
		if (ET == ETC.LegendStollwurm)
		{
			return false;
		}
		if (ET == ETC.LegendRockUnhold)
		{
			return false;
		}
		if (ET == ETC.LegendGreenwoodSchrat)
		{
			return false;
		}
		if (ET == ETC.LegendVampireLord || ET == ETC.Vampire)
		{
			return false;
		}
		if (ET == ETC.BanditWarlord)
		{
			return false;
		}
		if (ET == ETC.LegendMummyQueen || ET == ETC.LegendMummyPriest || ET == ETC.LegendMummyMedium || ET == ETC.LegendMummyLight || ET == ETC.LegendMummyHeavy)
		{
			return false;
		}
		if (ET == ETC.LegendOrcElite)
		{
			return false;
		}
		if (ET == ETC.LegendWhiteDirewolf)
		{
			return false;
		}
		if (ET == ETC.LegendSkinGhoul || ET == ETC.Ghoul)
		{
			return false;
		}
		if (ET == ETC.LegendRedbackSpider)
		{
			return false;
		}
		if (ET == ETC.LegendBanshee || ET == ETC.Ghost || ET == ETC.LegendDemonHound)
		{
			return false;
		}
		if (ET == ETC.SandGolem)
		{
			return false;
		}
		
		if(target.m.IsMiniboss)
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile) && !_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab;
	}
	
	o.onUse = function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || this.knockToTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " devours " + this.Const.UI.getColorizedEntityName(target));
		}

		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		skills.removeByID("effects.legend_vala_chant_disharmony_effect");
		skills.removeByID("effects.legend_vala_chant_fury_effect");
		skills.removeByID("effects.legend_vala_chant_senses_effect");
		skills.removeByID("effects.legend_vala_currently_chanting");
		skills.removeByID("effects.legend_vala_in_trance");

		if (target.getMoraleState() != this.Const.MoraleState.Ignore)
		{
			target.setMoraleState(this.Const.MoraleState.Breaking);
		}

		this.Tactical.getTemporaryRoster().add(target);
		this.Tactical.TurnSequenceBar.removeEntity(target);
		this.m.SwallowedEntity = target;
		this.m.SwallowedEntity.getFlags().set("Devoured", true);
		this.m.SwallowedEntity.setHitpoints(this.Math.max(5, this.m.SwallowedEntity.getHitpoints() - this.Math.rand(10, 20)));
		target.removeFromMap();
		_user.getSprite("body").setBrush("bust_ghoulskin_body_04");
		_user.getSprite("injury").setBrush("bust_ghoul_04_injured");
		_user.getSprite("head").setBrush("bust_ghoulskin_04_head_0" + _user.m.Head);
		_user.m.Sound[this.Const.Sound.ActorEvent.Death] = _user.m.Sound[this.Const.Sound.ActorEvent.Other2];
		local effect = this.new("scripts/skills/effects/swallowed_whole_effect");
		effect.setName(target.getName());
		_user.getSkills().add(effect);

		if (this.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
		}

		return true;
	}
	
	});

	///// all the good stuff
	local mod_AC_foundation = function(o)
	{
		if ("setEntity" in o)
		{
			o.m.Skill <- null;
			o.m.Entity <- null;
			o.m.Script <- null;
			o.m.ArmorScript <- null;
			o.m.UnleashSounds <- null;
			o.m.InventorySounds <- null;
			o.m.Type <- null;
			o.m.Level <- 1;
			o.m.XP <- 0;
			o.m.Wounds <- 0;
			o.m.Quirks <- [];
			o.m.Attributes <- {	Hitpoints = 0,
								Stamina = 0,
								Bravery = 0,
								Initiative = 0,
								MeleeSkill = 0,
								RangedSkill = 0,
								MeleeDefense = 0,
								RangedDefense = 0	};

			o.create <- function()
			{
				this.accessory.create();
				this.m.SlotType = this.Const.ItemSlot.Accessory;
				this.m.IsDroppedAsLoot = true;
				this.m.IsAllowedInBag = false;
				this.m.ShowOnCharacter = false;
				this.m.IsChangeableInBattle = false;

				if (this.isKindOf(this, "wardog_item"))
				{
					this.m.ID = "accessory.wardog";
					this.setType(this.Const.Companions.TypeList.Wardog);
				}
				if (this.isKindOf(this, "armored_wardog_item"))
				{
					this.m.ID = "accessory.armored_wardog";
					this.setType(this.Const.Companions.TypeList.WardogArmor);
				}
				if (this.isKindOf(this, "heavily_armored_wardog_item"))
				{
					this.m.ID = "accessory.heavily_armored_wardog";
					this.setType(this.Const.Companions.TypeList.WardogArmorHeavy);
				}
				if (this.isKindOf(this, "warhound_item"))
				{
					this.m.ID = "accessory.warhound";
					this.setType(this.Const.Companions.TypeList.Warhound);
				}
				if (this.isKindOf(this, "armored_warhound_item"))
				{
					this.m.ID = "accessory.armored_warhound";
					this.setType(this.Const.Companions.TypeList.WarhoundArmor);
				}
				if (this.isKindOf(this, "heavily_armored_warhound_item"))
				{
					this.m.ID = "accessory.heavily_armored_warhound";
					this.setType(this.Const.Companions.TypeList.WarhoundArmorHeavy);
				}
				if (this.isKindOf(this, "wolf_item"))
				{
					this.m.ID = "accessory.warwolf";
					this.setType(this.Const.Companions.TypeList.Warwolf);
				}
				if (this.isKindOf(this, "legend_warbear_item"))
				{
					this.m.ID = "accessory.legend_warbear";
					this.setType(this.Const.Companions.TypeList.Warbear);
				}
				if (this.isKindOf(this, "legend_white_wolf_item"))
				{
					this.m.ID = "accessory.legend_white_warwolf";
					this.setType(this.Const.Companions.TypeList.Whitewolf);
				}
				if (this.isKindOf(this, "direwolf_item"))
				{
					this.m.ID = "accessory.direwolf";
					this.setType(this.Const.Companions.TypeList.Direwolf);
				}
				if (this.isKindOf(this, "demonhound_item"))
				{
					this.m.ID = "accessory.demonhound";
					this.setType(this.Const.Companions.TypeList.DemonHound);
				}
			}

			o.getType <- function()
			{
				return this.m.Type;
			}

			o.setType <- function(_t)
			{
				this.m.Type = _t;
				this.m.Name = this.Const.Companions.Library[this.m.Type].Name();
				this.m.Variant = this.Const.Companions.Library[this.m.Type].Variant();
				this.m.Attributes.Hitpoints = this.Const.Companions.Library[this.m.Type].BasicAttributes.Hitpoints;
				this.m.Attributes.Stamina = this.Const.Companions.Library[this.m.Type].BasicAttributes.Stamina;
				this.m.Attributes.Bravery = this.Const.Companions.Library[this.m.Type].BasicAttributes.Bravery;
				this.m.Attributes.Initiative = this.Const.Companions.Library[this.m.Type].BasicAttributes.Initiative;
				this.m.Attributes.MeleeSkill = this.Const.Companions.Library[this.m.Type].BasicAttributes.MeleeSkill;
				this.m.Attributes.RangedSkill = this.Const.Companions.Library[this.m.Type].BasicAttributes.RangedSkill;
				this.m.Attributes.MeleeDefense = this.Const.Companions.Library[this.m.Type].BasicAttributes.MeleeDefense;
				this.m.Attributes.RangedDefense = this.Const.Companions.Library[this.m.Type].BasicAttributes.RangedDefense;
				this.m.Quirks = [];
				
				if (this.m.Type >= this.Const.Companions.TypeList.Wardog && this.m.Type <= this.Const.Companions.TypeList.Warwolf)
				{
					this.m.Quirks = ["scripts/skills/perks/perk_pathfinder","scripts/skills/perks/perk_steel_brow"];
				}
				else if (this.m.Type == this.Const.Companions.TypeList.WarwolfArmor && this.m.Type == this.Const.Companions.TypeList.WarwolfArmorHeavy)
				{
					this.m.Quirks = ["scripts/skills/perks/perk_pathfinder","scripts/skills/perks/perk_steel_brow"];
				}
				else if (this.m.Type == this.Const.Companions.TypeList.Warbear)
				{
					this.m.Quirks = ["scripts/skills/perks/perk_pathfinder","scripts/skills/perks/perk_hold_out","scripts/skills/perks/perk_berserk"];
					if("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
					{
						this.m.Quirks.extend(["scripts/skills/perks/perk_legend_battleheart","scripts/skills/perks/perk_last_stand"])
					}
				}
				else if (this.m.Type == this.Const.Companions.TypeList.Whitewolf)
				{
					this.m.Quirks = [
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_steel_brow",
						"scripts/skills/perks/perk_rotation",
						"scripts/skills/perks/perk_footwork",
						"scripts/skills/perks/perk_recover",
						"scripts/skills/perks/perk_coup_de_grace",
						"scripts/skills/perks/perk_berserk",
						"scripts/skills/perks/perk_nimble",
						"scripts/skills/perks/perk_overwhelm",						
					];
					/*
					if (this.m.Name == "White Wolf Queen")
					{
						this.m.Quirks.push("scripts/skills/perks/perk_inspire");
						this.m.Quirks.push("scripts/skills/racial/champion_racial");											
					}
					*/
				}
				else if (this.m.Type == this.Const.Companions.TypeList.Horse)
				{
					this.m.Quirks = ["scripts/skills/perks/perk_legend_horse_movement","scripts/skills/perks/perk_horse_charge","scripts/skills/perks/perk_legend_horse_pirouette"];
				}
				this.updateCompanion();
			}

			o.updateVariant <- function()
			{
			}

			o.updateCompanion <- function()
			{
				this.m.ID = this.Const.Companions.Library[this.m.Type].ID;
				this.m.Description = this.Const.Companions.Library[this.m.Type].Description;
				this.m.Value = this.Math.floor(this.Const.Companions.Library[this.m.Type].Value + ((this.m.Level - 1.00) * (this.Const.Companions.Library[this.m.Type].Value / 65.00)));
				this.m.Script = this.Const.Companions.Library[this.m.Type].Script;
				this.m.ArmorScript = this.Const.Companions.Library[this.m.Type].ArmorScript;
				this.m.UnleashSounds = this.Const.Companions.Library[this.m.Type].UnleashSounds;
				this.m.InventorySounds = this.Const.Companions.Library[this.m.Type].InventorySounds;
				this.setEntity(this.m.Entity);
				
								
				if ((this.m.Type == this.Const.Companions.TypeList.SkinGhoul) && this.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
					this.m.Name = "Luftwaffle The Goodest";
				
				/*
				this.logInfo("this.m.Script = " + this.m.Script);
			
				if (this.m.Script != null)
				{
					local entityOnSpawn = this.new(this.m.Script);
					entityOnSpawn.onInit();
					
					local entityOnSpawnPerks = entityOnSpawn.getSkills().query(this.Const.SkillType.Perk);
					
					this.logInfo("entityOnSpawnPerks = " + entityOnSpawnPerks.len());
					
					foreach(perk in entityOnSpawnPerks)
					{
						this.logInfo("perk = " + perk.getName());
						local quirk = "";
						foreach( i, v in this.getroottable().Const.Perks.PerkDefObjects )
						{
							if (perk.getID() == v.ID)
							{
								quirk = v.Script;
								break;
							}
						}
						if (quirk != "" && this.m.Quirks.find(quirk) == null)
						{
							this.m.Quirks.push(quirk);
						}			
					}
				}
				*/
				
			}

			o.getEntity <- function()
			{
				return this.m.Entity;
			}

			o.setEntity <- function(_e)
			{
				this.m.Entity = _e;

				if (this.m.Entity == null)
				{
					this.m.Icon = this.Const.Companions.Library[this.m.Type].IconLeashed(this.m.Variant);
				}
				else
				{
					this.m.Icon = this.Const.Companions.Library[this.m.Type].IconUnleashed;
				}
			}

			o.getName <- function()
			{
				if (this.m.Entity == null)
				{
					return this.m.Name;
				}
				else
				{
//					return this.Const.Companions.Library[this.m.Type].NameUnleashed + " (" + this.m.Name + ")";
					return this.m.Name + "\'s Collar";
				}
			}

			o.setName <- function(_n)
			{
				this.m.Name = _n;
			}

			o.getDescription <- function()
			{
				if (this.m.Entity == null)
				{
					return this.m.Description;
				}
				else
				{
					return this.Const.Companions.Library[this.m.Type].DescriptionUnleashed;
				}
			}

			o.getScript <- function()
			{
				return this.m.Script;
			}

			o.getArmorScript <- function()
			{
				return this.m.ArmorScript;
			}

			o.playInventorySound <- function(_eventType)
			{
				this.Sound.play(this.m.InventorySounds[this.Math.rand(0, this.m.InventorySounds.len() - 1)], this.Const.Sound.Volume.Inventory);
			}

			o.isUnleashed <- function()
			{
				return this.m.Entity != null;
			}

			o.getTooltip <- function()
			{
				local xpMax = this.m.XP;
				if (this.m.Level < this.Const.LevelXP.len())
					xpMax = this.Const.LevelXP[this.m.Level] - this.Const.LevelXP[this.m.Level - 1];

				local xpText = "MAX LEVEL";
				if (this.m.Level < this.Const.LevelXP.len())
					xpText = this.m.XP + " / " + this.Const.LevelXP[this.m.Level];

				local woundsCalc = (100 - this.m.Wounds);
				if (this.m.Entity != null)
					woundsCalc = this.Math.floor(this.m.Entity.getHitpointsPct() * 100.0);

				local nameText = this.getName();
				local levelText = "Level " + this.m.Level;
				if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation)
				{
					nameText += " ([color=" + (woundsCalc >= 50 ? this.Const.UI.Color.PositiveValue : this.Const.UI.Color.NegativeValue) + "]" + woundsCalc + "%[/color])";
				}

				local result = [
					{
						id = 1,
						type = "title",
						text = nameText
					},
					{
						id = 2,
						type = "description",
						text = this.getDescription()
					},
					{
						id = 3,
						type = "text",
						text = this.getValueString()
					},
					{
						id = 4,
						type = "text",
						text = "Worn in Accessory Slot"
					},
					{
						id = 5,
						type = "text",
						text = "Usable in Combat"
					},
					{
						id = 6,
						type = "text",
						text = levelText
					},
					{
						id = 7,
						type = "progressbar",
						icon = "ui/icons/xp_received.png",
						value = this.m.XP - this.Const.LevelXP[this.m.Level - 1],
						valueMax = xpMax,
						text = xpText,
						style = "armor-body-slim"
					}
				];

				local aHit = this.m.Attributes.Hitpoints;
				local aFat = this.m.Attributes.Stamina;
				local aRes = this.m.Attributes.Bravery;
				local aIni = this.m.Attributes.Initiative;
				local aMS = this.m.Attributes.MeleeSkill;
				local aRS = this.m.Attributes.RangedSkill;
				local aMD = this.m.Attributes.MeleeDefense;
				local aRD = this.m.Attributes.RangedDefense;

				local bufferHealth;
				local bufferStamina;
				local bufferBravery;
				local bufferInitiative;

				if (aHit < 10 || aFat < 10 || aRes < 10 || aIni < 10)
				{
					bufferHealth = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
					bufferStamina = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
					bufferBravery = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
					bufferInitiative = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				}
				else
				{
					bufferHealth = "&nbsp;&nbsp;&nbsp;";
					bufferStamina = "&nbsp;&nbsp;&nbsp;";
					bufferBravery = "&nbsp;&nbsp;&nbsp;";
					bufferInitiative = "&nbsp;&nbsp;&nbsp;";

					if (aHit < 100 && aFat < 100 && aRes < 100 && aIni < 100)
					{
						bufferHealth += "&nbsp;&nbsp;";
						bufferStamina += "&nbsp;&nbsp;";
						bufferBravery += "&nbsp;&nbsp;";
						bufferInitiative += "&nbsp;&nbsp;";
					}
				}

				if (aHit < 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
				else if (aHit >= 10)
				{
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";

					if (aHit >= 100)
					{
						bufferStamina += "&nbsp;&nbsp;";
						bufferBravery += "&nbsp;&nbsp;";
						bufferInitiative += "&nbsp;&nbsp;";

						if (aHit >= 1000)
						{
							bufferStamina += "&nbsp;&nbsp;";
							bufferBravery += "&nbsp;&nbsp;";
							bufferInitiative += "&nbsp;&nbsp;";
						}
					}
				}
				if (aFat < 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
				else if (aFat >= 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";

					if (aFat >= 100)
					{
						bufferHealth += "&nbsp;&nbsp;";
						bufferBravery += "&nbsp;&nbsp;";
						bufferInitiative += "&nbsp;&nbsp;";
					}
				}
				if (aRes < 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
				else if (aRes >= 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";

					if (aRes >= 100)
					{
						bufferHealth += "&nbsp;&nbsp;";
						bufferStamina += "&nbsp;&nbsp;";
						bufferInitiative += "&nbsp;&nbsp;";
					}
				}
				if (aIni < 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
				else if (aIni >= 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";

					if (aIni >= 100)
					{
						bufferHealth += "&nbsp;&nbsp;";
						bufferStamina += "&nbsp;&nbsp;";
						bufferBravery += "&nbsp;&nbsp;";
					}
				}

				local attribs = [
					{
						id = 8,
						type = "text",
						text = this.m.Type == this.Const.Companions.TypeList.TomeReanimation ? "The power of this incantation:" : "This individual\'s base attributes:"
					},
					{
						id = 9,
						type = "text",
						text = "[img]gfx/ui/icons/health_ac.png[/img] " + aHit + bufferHealth + "[img]gfx/ui/icons/melee_skill_ac.png[/img] " + aMS + ""
					},
					{
						id = 10,
						type = "text",
						text = "[img]gfx/ui/icons/fatigue_ac.png[/img] " + aFat + bufferStamina + "[img]gfx/ui/icons/ranged_skill_ac.png[/img] " + aRS + ""
					},
					{
						id = 11,
						type = "text",
						text = "[img]gfx/ui/icons/bravery_ac.png[/img] " + aRes + bufferBravery + "[img]gfx/ui/icons/melee_defense_ac.png[/img] " + aMD + ""
					},
					{
						id = 12,
						type = "text",
						text = "[img]gfx/ui/icons/initiative_ac.png[/img] " + aIni + bufferInitiative + "[img]gfx/ui/icons/ranged_defense_ac.png[/img] " + aRD + ""
					}
				];
				result.extend(attribs);

				local quirkString = "";
				local knownQuirks = [];
				if (this.m.Quirks.len() != 0)
				{
					foreach(i, quirk in this.m.Quirks)
					{
						local getQuirk = this.new(quirk);
						knownQuirks.push(getQuirk.m.Name);
					}
			
					knownQuirks.sort();
					foreach(i, quirk in knownQuirks)
					{
						quirkString += quirk;

						if (i < this.m.Quirks.len() - 1)
						{
							quirkString += ", ";
						}
					}
				}

				if (this.m.Quirks.len() != 0)
				{
					result.push({
						id = 13,
						type = "text",
						text = this.m.Type == this.Const.Companions.TypeList.TomeReanimation ? "And its additional effects:" : "And the quirks it possesses:"
					});

					result.push({
						id = 14,
						type = "text",
						icon = "ui/icons/perks.png",
						text = quirkString
					});
				}

				if (this.getIconLarge() != null)
				{
					result.push({
						id = 15,
						type = "image",
						image = this.getIconLarge(),
						isLarge = true
					});
				}
				else
				{
					result.push({
						id = 15,
						type = "image",
						image = this.getIcon()
					});
				}

				return result;
			}

			o.onEquip <- function()
			{
				this.accessory.onEquip();
				local unleash = this.new(this.Const.Companions.Library[this.m.Type].Unleash.Script);
				unleash.setItem(this);
				unleash.applyCompanionModification();
				this.m.Skill = this.WeakTableRef(unleash);
				this.addSkill(unleash);
				local leash = this.new(this.Const.Companions.Library[this.m.Type].Leash.Script);
				if ("setItem" in leash)
				{
					leash.setItem(this);
					leash.applyCompanionModification();
				}
				this.addSkill(leash);
				if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation && this.getContainer().getActor() != null && this.getContainer().getActor().getFaction() != this.Const.Faction.Player)
					this.m.IsDroppedAsLoot = false;
			}

			o.onCombatFinished <- function()
			{
				if (this.m.Entity != null)
				{
					this.m.Wounds = this.Math.floor((1.0 - this.m.Entity.getHitpointsPct()) * 100.0);
				
				
					local target_perks = this.m.Entity.getSkills().query(this.Const.SkillType.Perk);
					foreach(perk in target_perks)
					{
						local quirk = "";
						foreach( i, v in this.getroottable().Const.Perks.PerkDefObjects )
						{
							if (perk.getID() == v.ID)
							{
								quirk = v.Script;
								break;
							}
						}
						if (quirk != "" && this.m.Quirks.find(quirk) == null)
						{
							this.m.Quirks.push(quirk);
						}			
					}
				}
				

				this.setEntity(null);
			}

			o.onActorDied <- function(_onTile)
			{
				if (this.m.Type != null && !this.isUnleashed() && _onTile != null && this.getScript() != null && this.Const.Companions.Library[this.m.Type].Unleash.onActorDied)
				{
					local entity = this.Tactical.spawnEntity(this.getScript(), _onTile.Coords.X, _onTile.Coords.Y);
					entity.setItem(this);
					entity.setName(this.getName());
					entity.setVariant(this.getVariant());
					entity.setFaction(this.getContainer().getActor().getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : this.getContainer().getActor().getActorFactionForAC());
					entity.applyCompanionScaling();
					entity.m.IsSummoned = true;
					this.setEntity(entity);
					
					/*
					this.logInfo("isInitialized ="  + entity.isInitialized());
					this.logInfo("getFaction ="  + entity.getFaction() + "this.getContainer().getActor().getFaction =" + this.getContainer().getActor().getFaction());
					this.logInfo("getType ="  + entity.getType());
					this.logInfo("getAIAgent ="  + entity.getAIAgent());
					this.logInfo("isPlacedOnMap ="  + entity.isPlacedOnMap());
					*/

					if (this.getArmorScript() != null)
					{
						local item = this.new(this.getArmorScript());
						entity.getItems().equip(item);
					}

					if (!this.World.getTime().IsDaytime)
					{
						entity.getSkills().add(this.new("scripts/skills/special/night_effect"));
					}

					local healthPercentage = (100.0 - this.m.Wounds) / 100.0;
					entity.setHitpoints(this.Math.max(1, this.Math.floor(healthPercentage * entity.m.Hitpoints)));
					entity.setDirty(true);
					this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
					entity.onTurnEnd();
				}
			}

			o.isAmountShown <- function()
			{
				return true;
			}

			o.getAmountString <- function()
			{
				return "Level " + this.m.Level;
			}

			o.getXPToNextLevelPercentage <- function()
			{
				if (this.m.Level >= this.Const.LevelXP.len())
					return "MAX";

				local tnl = this.Math.floor(((this.m.XP - this.Const.LevelXP[this.m.Level - 1]) / (this.Const.LevelXP[this.m.Level] - this.Const.LevelXP[this.m.Level - 1])) * 100);

				if (tnl > 99)
					tnl = 99;

				return "" + tnl + "%";
			}

			o.addXP <- function(_xp)
			{
				if (this.m.Level >= this.Const.LevelXP.len())
				{
					return;
				}

				_xp = _xp * this.Const.Combat.GlobalXPMult;

				if (this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && !this.getContainer().getActor().isNull() && this.getContainer().getActor().m.Type == this.Const.EntityType.Player && this.m.Type != this.Const.Companions.TypeList.TomeReanimation)
				{
					local actor = this.getContainer().getActor();
					foreach(beastmaster in this.Const.Companions.BeastMasters)
					{
						if (actor.getSkills().hasSkill(beastmaster[0]))
						{
							_xp = _xp * (1 + beastmaster[1] * (10 + actor.getLevel()));
						}
					}
				}

				if (this.m.Level >= this.Const.XP.MaxLevelWithPerkpoints)
				{
					_xp = _xp * this.Const.Combat.GlobalXPVeteranLevelMult;
				}

				if (this.m.XP + _xp >= this.Const.LevelXP[this.Const.LevelXP.len() - 1])
				{
					this.m.XP = this.Const.LevelXP[this.Const.LevelXP.len() - 1];
					this.updateLevel();
					return;
				}

				this.m.XP += this.Math.floor(_xp);
				this.updateLevel();
			}
			
			o.wearArmor <- function()
			{
				if ( this.m.Type == this.Const.Companions.TypeList.TomeReanimation )
				{
					return true;
				}
				if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor)
				{
					return (this.m.Variant >= 4);
				}
				return false;
			}
			
			o.hasHeavyArmor <- function()
			{
				if (this.m.Type == this.Const.Companions.TypeList.Noodle || 
					this.m.Type == this.Const.Companions.TypeList.Stollwurm || 
					this.m.Type == this.Const.Companions.TypeList.WhiteDirewolf || 
					this.m.Type == this.Const.Companions.TypeList.RedbackSpider || 
					this.m.Type == this.Const.Companions.TypeList.Whitewolf || 
					this.m.Type == this.Const.Companions.TypeList.TomeReanimation )
				{
					return true;
				}
				if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor)
				{
					return (this.m.Variant == 5);
				}
				return false;
			}
			
			 o.DamageType <- function()
			//0: None, 1: Cut, 2: Pierce, 3: Blunt, 4: Cut + Pierce
			{
				if (this.m.Type < this.Const.Companions.TypeList.Direwolf)
				{
					return 1;
				}
				else if (this.m.Type >= this.Const.Companions.TypeList.Direwolf && this.m.Type <= this.Const.Companions.TypeList.HyenaFrenzied)
				{
					return 4;
				}
				else if (this.m.Type == this.Const.Companions.TypeList.RedbackSpider || this.m.Type == this.Const.Companions.TypeList.Spider)
				{
					return 4;
				}
				else if (this.m.Type == this.Const.Companions.TypeList.Snake || this.m.Type == this.Const.Companions.TypeList.Schrat || this.m.Type == this.Const.Companions.TypeList.GreenwoodSchrat)
				{
					return 2;
				}
				else if (this.m.Type == this.Const.Companions.TypeList.Nacho || this.m.Type == this.Const.Companions.TypeList.Noodle || this.m.Type == this.Const.Companions.TypeList.Stollwurm || this.m.Type == this.Const.Companions.TypeList.SkinGhoul)
				{
					return 1;
				}
				else if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor || this.m.Type == this.Const.Companions.TypeList.RockUnhold || this.m.Type == this.Const.Companions.TypeList.Horse)
				{
					return 3;
				}
				else if (this.m.Type >= this.Const.Companions.TypeList.Warbear && this.m.Type <= this.Const.Companions.TypeList.WarwolfArmorHeavy)
				{
					return 1;
				}
				else
				{
					return 0;
				}
			}

			o.updateLevel <- function()
			{
				local applyAttributeBonus = function(attribute)
				{
					local attributeMin = this.Const.AttributesLevelUp[attribute].Min;
					local attributeMax = this.Const.AttributesLevelUp[attribute].Max;
					local attributeValue = this.m.Level <= this.Const.XP.MaxLevelWithPerkpoints ? this.Math.rand(attributeMin, attributeMax) : 1;
					switch (attribute)
					{
						case 0:
							this.m.Attributes.Hitpoints += attributeValue;
							break;
						case 1:
							this.m.Attributes.Bravery += attributeValue;
							break;
						case 2:
							this.m.Attributes.Stamina += attributeValue;
							break;
						case 3:
							this.m.Attributes.Initiative += attributeValue;
							break;
						case 4:
							this.m.Attributes.MeleeSkill += attributeValue;
							break;
						case 5:
							this.m.Attributes.RangedSkill += attributeValue;
							break;
						case 6:
							this.m.Attributes.MeleeDefense += attributeValue;
							break;
						case 7:
							this.m.Attributes.RangedDefense += attributeValue;
							break;
					}
				}

				local availableQuirks = this.Const.Companions.AttainableQuirks;
				if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation && this.m.Type != this.Const.Companions.TypeList.DemonHound)
				{
					availableQuirks.extend(this.Const.Companions.AttainableQuirksBeasts);
				}
				if (this.m.Type != this.Const.Companions.TypeList.Alp)
				{
					availableQuirks.extend(this.Const.Companions.AttainableQuirksPhysical);
				}
				if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor || this.m.Type == this.Const.Companions.TypeList.Schrat || this.m.Type == this.Const.Companions.TypeList.Warbear)
				{
					availableQuirks.extend([
						"scripts/skills/perks/perk_bloody_harvest",
						"scripts/skills/perks/perk_legend_forceful_swing"
						]);
				}
				if (this.m.Type != this.Const.Companions.TypeList.Noodle)
				{
					availableQuirks.push("scripts/skills/perks/perk_lone_wolf");
				}				
				if ( this.wearArmor() )
				{
					availableQuirks.extend([
						"scripts/skills/perks/perk_legend_full_force",
						"scripts/skills/perks/perk_legend_lithe"
						]);
				}				
				if ( this.hasHeavyArmor() )
				{
					availableQuirks.push("scripts/skills/perks/perk_battle_forged");
				}
				if (this.m.Level >= this.Const.XP.MaxLevelWithPerkpoints)
				{
					availableQuirks.extend(this.Const.Companions.AttainableQuirksActive);
					if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation && this.m.Type != this.Const.Companions.TypeList.DemonHound)
					{
						availableQuirks.push("scripts/skills/actives/recover_skill");
					}
					if (this.m.Type != this.Const.Companions.TypeList.Alp)
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_debilitate",
							"scripts/skills/perks/perk_legend_prepare_bleed",
							"scripts/skills/perks/perk_legend_prepare_graze",
							"scripts/skills/perks/perk_legend_smackdown"
						]);
						if (this.m.Type != this.Const.Companions.TypeList.Unhold && this.m.Type != this.Const.Companions.TypeList.UnholdArmor )
						{
							availableQuirks.extend([
								"scripts/skills/perks/perk_legend_evasion",
								"scripts/skills/perks/perk_legend_leap",
								"scripts/skills/perks/perk_sprint"
							]);							
						}
					}
				}
				if ((this.m.Level == 7) || (this.m.Level - 1) % 5 == 0)
				{
					//if (this.Math.rand(1, 100) < 5)
					availableQuirks.push("scripts/skills/racial/champion_racial");
				}
				if (::mods_getRegisteredMod("mod_legends_PTR") != null)
				{
					availableQuirks.extend(this.Const.Companions.AttainableQuirksPTR);
					if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation && this.m.Type != this.Const.Companions.TypeList.DemonHound)
					{
						availableQuirks.extend(this.Const.Companions.AttainableQuirksBeastsPTR);
					}
					if (this.m.Type != this.Const.Companions.TypeList.Alp)
					{
						availableQuirks.extend(this.Const.Companions.AttainableQuirksPhysicalPTR);
						if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation && this.m.Type != this.Const.Companions.TypeList.DemonHound)
						{
							availableQuirks.push("scripts/skills/perks/perk_ptr_utilitarian");
						}						
					}
					if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor || this.m.Type == this.Const.Companions.TypeList.Schrat || this.m.Type == this.Const.Companions.TypeList.Warbear )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_ptr_bloody_harvest",
							"scripts/skills/perks/perk_ptr_sweeping_strikes"
							]);
					}
					local dT = this.DamageType();
					if (dT == 1 || dT == 4)
					{
						availableQuirks.push("scripts/skills/perks/perk_ptr_dismemberment");
						availableQuirks.push("scripts/skills/perks/perk_ptr_deep_cuts");
					}
					else if (dT == 2)
					{
						availableQuirks.push("scripts/skills/perks/perk_ptr_pointy_end");
						availableQuirks.push("scripts/skills/perks/perk_ptr_through_the_gaps");
					}
					else if (dT == 3)
					{
						availableQuirks.push("scripts/skills/perks/perk_ptr_rattle");
						availableQuirks.push("scripts/skills/perks/perk_ptr_dent_armor");
						availableQuirks.push("scripts/skills/perks/perk_ptr_dismantle");
						availableQuirks.push("scripts/skills/perks/perk_ptr_deep_impact");
						availableQuirks.push("scripts/skills/perks/perk_ptr_internal_hemorrhage");
					}

					if (this.m.Type == this.Const.Companions.TypeList.Noodle || this.m.Type == this.Const.Companions.TypeList.Stollwurm)
					{
						availableQuirks.push("scripts/skills/perks/perk_ptr_leverage");
					}					
					if ( this.hasHeavyArmor() )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_ptr_man_of_steel",
							"scripts/skills/perks/perk_ptr_personal_armor"
							]);
						if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation)
						{
							availableQuirks.push("scripts/skills/perks/perk_ptr_bulwark");
						}
					}				
				}
								
				while (this.m.Level < this.Const.LevelXP.len() && this.m.XP >= this.Const.LevelXP[this.m.Level])
				{
					++this.m.Level;
					this.updateCompanion();
					if (::mods_getRegisteredMod("mod_8skills") != null)
					{
						for ( local i = 0 ; i < 8 ; ++i )
						{
							applyAttributeBonus(i);
						}						
					}
					else
					{
						local attributeArray = [0, 1, 2, 3, 4, 5, 6, 7]; // all attributes
						applyAttributeBonus(this.Const.Companions.Library[this.m.Type].PreferredAttribute);
						attributeArray.remove(this.Const.Companions.Library[this.m.Type].PreferredAttribute);
	
						local bonusesSpent = 1;
						while (bonusesSpent < 3)
						{
							local randomAttribute = this.Math.rand(0, attributeArray.len() - 1);
							applyAttributeBonus(attributeArray[randomAttribute]);
							attributeArray.remove(randomAttribute);
							++bonusesSpent;
						}						
					}

					if (this.m.Level <= this.Const.XP.MaxLevelWithPerkpoints || (this.m.Level - 1) % 5 == 0)
					{
						if (availableQuirks.len() > 0)
						{
							while (true)
							{
								local rng = this.Math.rand(0, availableQuirks.len() - 1);
								local quirk = availableQuirks[rng];
								if (this.m.Quirks.find(quirk) == null)
								{
									this.m.Quirks.push(quirk);
									break;
								}
							}
						}
					}
				}
			}

			o.giverandXP <- function()
			{
				local day = this.World.getTime().Days;
				if (day > 100)
				{
					day = 100;
				}
				
				if (day >= 10)
				{
					this.m.XP = this.Math.min(9000, this.Math.rand(0, day * day));
					this.updateLevel();
				}
			}

			o.getLevel <- function()
			{
				return this.m.Level;
			}

			o.setLevel <- function(_l)
			{
				this.m.Level = _l;
			}

			o.getXP <- function()
			{
				return this.m.XP;
			}

			o.setXP <- function(_xp)
			{
				this.m.XP = _xp;
			}

			o.getQuirks <- function()
			{
				return this.m.Quirks;
			}

			o.setQuirks <- function(_q)
			{
				this.m.Quirks = _q;
			}

			o.getAttributes <- function()
			{
				local attr =
				{
					Hitpoints = this.m.Attributes.Hitpoints,
					Stamina = this.m.Attributes.Stamina,
					Bravery = this.m.Attributes.Bravery,
					Initiative = this.m.Attributes.Initiative,
					MeleeSkill = this.m.Attributes.MeleeSkill,
					RangedSkill = this.m.Attributes.RangedSkill,
					MeleeDefense = this.m.Attributes.MeleeDefense,
					RangedDefense = this.m.Attributes.RangedDefense
				};

				return attr;
			}

			o.setAttributes <- function(_a)
			{
				this.m.Attributes.Hitpoints = _a.Hitpoints;
				this.m.Attributes.Stamina = _a.Stamina;
				this.m.Attributes.Bravery = _a.Bravery;
				this.m.Attributes.Initiative = _a.Initiative;
				this.m.Attributes.MeleeSkill = _a.MeleeSkill;
				this.m.Attributes.RangedSkill = _a.RangedSkill;
				this.m.Attributes.MeleeDefense = _a.MeleeDefense;
				this.m.Attributes.RangedDefense = _a.RangedDefense;
			}

			o.getWounds <- function()
			{
				return this.m.Wounds;
			}

			o.setWounds <- function(_w)
			{
				this.m.Wounds = _w;
			}

			o.onSerialize <- function(_out)
			{
				this.accessory.onSerialize(_out);
				_out.writeString(this.m.Name);
				_out.writeU32(this.m.Type);
				_out.writeU32(this.m.Level);
				_out.writeI32(this.m.XP);
				_out.writeI32(this.m.Wounds);
				
				_out.writeI16(this.m.Attributes.Hitpoints);
				_out.writeI16(this.m.Attributes.Stamina);
				_out.writeI16(this.m.Attributes.Bravery);
				_out.writeI16(this.m.Attributes.Initiative);
				_out.writeI16(this.m.Attributes.MeleeSkill);
				_out.writeI16(this.m.Attributes.RangedSkill);
				_out.writeI16(this.m.Attributes.MeleeDefense);
				_out.writeI16(this.m.Attributes.RangedDefense);
			
				_out.writeU16(this.m.Quirks.len());
			
				foreach ( quirk in this.m.Quirks )
				{
					local getQuirk = this.new(quirk);
					_out.writeI32(getQuirk.ClassNameHash);
				}
			}
			
			o.onDeserialize <- function(_in)
			{
				this.accessory.onDeserialize(_in);
				this.m.Name = _in.readString();
				this.m.Type = _in.readU32();
				this.m.Level = _in.readU32();
				this.m.XP = _in.readI32();
				this.m.Wounds = _in.readI32();
				
				this.m.Attributes.Hitpoints = _in.readI16();
				this.m.Attributes.Stamina = _in.readI16();
				this.m.Attributes.Bravery = _in.readI16();
				this.m.Attributes.Initiative = _in.readI16();
				this.m.Attributes.MeleeSkill = _in.readI16();
				this.m.Attributes.RangedSkill = _in.readI16();
				this.m.Attributes.MeleeDefense = _in.readI16();
				this.m.Attributes.RangedDefense = _in.readI16();
							
				local num = _in.readU16();
				this.m.Quirks = [];
			
				for ( local i = 0 ; i < num ; ++i )
				{
					local script = this.IO.scriptFilenameByHash(_in.readI32());
			
					if (script != null)
					{
						this.m.Quirks.push(script);
					}			
				}
			
				this.updateCompanion();
			}
		}
	}

	::mods_hookDescendants("items/accessory/accessory", mod_AC_foundation);
	
	::mods_hookExactClass("entity/tactical/actor", function(o) {
		
		o.m.ActorFactionForAC <- 0;
		
		o.getActorFactionForAC <- function ()
		{
			return this.m.ActorFactionForAC
		}
		local onDeath = o.onDeath;
		o.onDeath = function( _killer, _skill, _tile, _fatalityType )
		{
			this.m.ActorFactionForAC = this.getFaction();
			onDeath( _killer, _skill, _tile, _fatalityType );
		}
		
		o.isPlayerControlled = function()
		{
			return this.getFaction() <= this.Const.Faction.PlayerAnimals && this.m.IsControlledByPlayer;
		}
		
		local onResurrected = o.onResurrected;
		o.onResurrected = function ( _info)
		{
			onResurrected(_info);
			this.getFlags().add("IsSummoned");
		}
	});	
	
	if (::mods_getRegisteredMod("mod_legends_PTR") != null)
	{
	::mods_hookExactClass("entity/tactical/enemies/legend_rock_unhold", function(o) {
		local onInit = o.onInit;
		o.onInit = function()
		{
			onInit();
			this.m.Skills.removeByID("perk.ptr_survival_instinct");			
		}
	});
		
	::mods_hookExactClass("entity/tactical/enemies/unhold", function(o) {
		local onInit = o.onInit;
		o.onInit = function()
		{
			onInit();
			this.m.Skills.removeByID("perk.ptr_survival_instinct");			
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/unhold_bog", function(o) {
		local onInit = o.onInit;
		o.onInit = function()
		{
			onInit();
			this.m.Skills.removeByID("perk.ptr_survival_instinct");			
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/unhold_frost", function(o) {
		local onInit = o.onInit;
		o.onInit = function()
		{
			onInit();
			this.m.Skills.removeByID("perk.ptr_survival_instinct");			
		}
	});	
	}	
	
		::mods_hookExactClass("entity/tactical/enemies/ghoul", function ( o )
	{
		o.onAfterDeath = function ( _tile )
		{
			if (this.m.Size < 3)
			{
				return null;
			}

			local skill = this.getSkills().getSkillByID("actives.swallow_whole");

			if (skill.getSwallowedEntity() == null)
			{
				return null;
			}

			local e = skill.getSwallowedEntity();
			e.setIsAlive(true);
			this.Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
			e.getFlags().set("Devoured", false);
			
			if (!e.isPlayerControlled())
			{
				this.Tactical.getTemporaryRoster().remove(e);
			}
			this.Tactical.TurnSequenceBar.addEntity(e);

			if (e.hasSprite("dirt"))
			{
				local slime = e.getSprite("dirt");
				slime.setBrush("bust_slime");
				slime.setHorizontalFlipping(!e.isAlliedWithPlayer());
				slime.Visible = true;
			}

			return e;
		};
	});
	
	::mods_hookExactClass("entity/tactical/enemies/legend_skin_ghoul", function ( o )
	{
		o.onAfterDeath = function ( _tile )
		{
			if (this.m.Size < 3)
			{
				return null;
			}

			local skill = this.getSkills().getSkillByID("actives.legend_skin_ghoul_swallow_whole");

			if (skill.getSwallowedEntity() == null)
			{
				return null;
			}

			local e = skill.getSwallowedEntity();
			e.setIsAlive(true);
			this.Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
			e.getFlags().set("Devoured", false);
			
			if (!e.isPlayerControlled())
			{
				this.Tactical.getTemporaryRoster().remove(e);
			}
			this.Tactical.TurnSequenceBar.addEntity(e);

			if (e.hasSprite("dirt"))
			{
				local slime = e.getSprite("dirt");
				slime.setBrush("bust_slime");
				slime.setHorizontalFlipping(!e.isAlliedWithPlayer());
				slime.Visible = true;
			}

			return e;
		};
	});
	
	::mods_hookExactClass("entity/world/settlements/buildings/marketplace_oriental_building", function(o) {
		
	o.addACtoStash <- function( _list, _stash, _priceMult )
	{
		local rarityMult = this.getSettlement().getModifiers().RarityMult;

		local isTrader = this.World.Retinue.hasFollower("follower.trader");			

		foreach( i in _list )
		{
			local r = i.R;

			for( local num = 0; true;  )
			{
				local p = this.Math.rand(0, 100);
				local item;
				
				if (p < (100 - r) * rarityMult)
				//if (p >= r)
				{
					
					item = this.new("scripts/items/accessory/wardog_item");
					item.setType(i.S);			
					item.giverandXP();
					item.updateCompanion();
					
					local items = [
						item
					];

					foreach( it in items )
					{
						it.setPriceMult(i.P * _priceMult);
						_stash.add(it);
					}

					if (r != 0 || rarityMult < 1.0)
					{
						r = r + p;
					}
				}
				else
				{
					break;
				}
				
				num = ++num;
				num = num;

				if (num >= 2 || !isTrader && num >= 1)
				{
					break;
				}
			}
				
			for( local num = 0; true;  )
			{	
				local p = this.Math.rand(0, 1000);
				local item;
				
				if (p < (100 * rarityMult))
				{
					
					item = this.new("scripts/items/misc/lootbox_AC_item");
					
					local items = [
						item
					];

					foreach( it in items )
					{
						it.setPriceMult(1.33 * _priceMult);
						_stash.add(it);
					}

				}
				else
				{
					break;
				}

				num = ++num;
				num = num;

				if (num >= 2 || !isTrader && num >= 1)
				{
					break;
				}
			}
		}

		_stash.sort();
	}
		
		local onUpdateShopList = o.onUpdateShopList;
		o.onUpdateShopList = function()
		{
			onUpdateShopList();
			local list = [
			{
				R = 99,
				P = 1.0,
				S = this.Const.Companions.TypeList.Hyena
			},
			{
				R = 96,
				P = 1.0,
				S = this.Const.Companions.TypeList.WarhoundArmorHeavy
			},
			{
				R = 96,
				P = 1.0,
				S = this.Const.Companions.TypeList.WardogArmorHeavy
			},
			{
				R = 99,
				P = 1.0,
				S = this.Const.Companions.TypeList.Spider
			}
		];
			
			addACtoStash(list, this.m.Stash, 1.0);
		}
	});
	
	::mods_hookExactClass("entity/world/settlements/buildings/marketplace_building", function(o) {
		
	o.addACtoStash <- function( _list, _stash, _priceMult )
	{
		local rarityMult = this.getSettlement().getModifiers().RarityMult;

		local isTrader = this.World.Retinue.hasFollower("follower.trader");			

		foreach( i in _list )
		{
			local r = i.R;

			for( local num = 0; true;  )
			{
				local p = this.Math.rand(0, 100);
				local item;
				
				if (p < (100 - r) * rarityMult)
				//if (p >= r)
				{
					
					item = this.new("scripts/items/accessory/wardog_item");
					item.setType(i.S);			
					item.giverandXP();
					item.updateCompanion();
					
					local items = [
						item
					];

					foreach( it in items )
					{
						it.setPriceMult(i.P * _priceMult);
						_stash.add(it);
					}

					if (r != 0 || rarityMult < 1.0)
					{
						r = r + p;
					}
				}
				else
				{
					break;
				}
				
				num = ++num;
				num = num;

				if (num >= 2 || !isTrader && num >= 1)
				{
					break;
				}
			}
				
			for( local num = 0; true;  )
			{
				local p = this.Math.rand(0, 1000);
				local item;
				
				if (p < (50 * rarityMult))
				{
					
					item = this.new("scripts/items/misc/lootbox_AC_item");
					
					local items = [
						item
					];

					foreach( it in items )
					{
						it.setPriceMult(1.0 * _priceMult);
						_stash.add(it);
					}

				}
				else
				{
					break;
				}
				

				num = ++num;
				num = num;

				if (num >= 2 || !isTrader && num >= 1)
				{
					break;
				}
			}
		}

		_stash.sort();
	}	
		
		local onUpdateShopList = o.onUpdateShopList;
		o.onUpdateShopList = function()
		{
			onUpdateShopList();
			local list = [
			{
				R = 97,
				P = 1.0,
				S = this.Const.Companions.TypeList.WarwolfArmor
			},
			{
				R = 99,
				P = 1.0,
				S = this.Const.Companions.TypeList.Spider
			},
			{
				R = 95,
				P = 1.0,
				S = this.Const.Companions.TypeList.Warwolf
			},
			{
				R = 99,
				P = 1.0,
				S = this.Const.Companions.TypeList.Direwolf
			}
			];
			
			addACtoStash(list, this.m.Stash, 1.0);
		}
	});
	
	::mods_hookExactClass("entity/world/settlements/buildings/kennel_building", function(o) {
		
	o.addACtoStash <- function( _list, _stash, _priceMult )
	{
		local rarityMult = this.getSettlement().getModifiers().RarityMult;

		local isTrader = this.World.Retinue.hasFollower("follower.trader");			

		foreach( i in _list )
		{
			local r = i.R;

			for( local num = 0; true;  )
			{
				local p = this.Math.rand(0, 1000);
				local item;
				
				if (p < (1000 - r) * rarityMult)
				//if (p >= r)
				{
					
					item = this.new("scripts/items/accessory/wardog_item");
					item.setType(i.S);			
					item.giverandXP();
					item.updateCompanion();
					
					local items = [
						item
					];

					foreach( it in items )
					{
						it.setPriceMult(i.P * _priceMult);
						_stash.add(it);
					}

					if (r != 0 || rarityMult < 1.0)
					{
						r = r + p;
					}
				}
				else
				{
					break;
				}
				
				num = ++num;
				num = num;

				if (num >= 2 || !isTrader && num >= 1)
				{
					break;
				}
			}
				
			for( local num = 0; true;  )
			{
				local p = this.Math.rand(0, 1000);
				local item;
				
				if (p < (150 * rarityMult))
				{
					
					item = this.new("scripts/items/misc/lootbox_AC_item");
					
					local items = [
						item
					];

					foreach( it in items )
					{
						it.setPriceMult(1.67 * _priceMult);
						_stash.add(it);
					}
					
				}
				else
				{
					break;
				}
				

				num = ++num;
				num = num;

				if (num >= 2 || !isTrader && num >= 1)
				{
					break;
				}
			}
		}

		_stash.sort();
	}
		
		local onUpdateShopList = o.onUpdateShopList;
		o.onUpdateShopList = function()
		{
			onUpdateShopList();
			local list = [
			{
				R = 985,
				P = 1.0,
				S = this.Const.Companions.TypeList.DirewolfFrenzied
			},
			{
				R = 995,
				P = 1.0,
				S = this.Const.Companions.TypeList.Warbear
			},
			{
				R = 995,
				P = 1.0,
				S = this.Const.Companions.TypeList.Whitewolf
			},
			{
				R = 975,
				P = 1.0,
				S = this.Const.Companions.TypeList.WarwolfArmorHeavy
			}
			];
			
			addACtoStash(list, this.m.Stash, 1.0);
		}
	});
	
	::mods_hookExactClass("entity/world/settlements/buildings/alchemist_building", function(o) {
		
	o.addACtoStash <- function( _list, _stash, _priceMult)
	{
		local rarityMult = this.getSettlement().getModifiers().RarityMult;

		local isTrader = this.World.Retinue.hasFollower("follower.trader");			

		foreach( i in _list )
		{
			local r = i.R;

			for( local num = 0; true;  )
			{
				local p = this.Math.rand(0, 1000);
				local item;
				
				if (p < (1000 - r) * rarityMult)
				//if (p >= r)
				{
					
					item = this.new("scripts/items/accessory/wardog_item");
					item.setType(i.S);			
					item.giverandXP();
					item.updateCompanion();
					
					local items = [
						item
					];

					foreach( it in items )
					{
						it.setPriceMult(i.P * _priceMult);
						_stash.add(it);
					}

					if (r != 0 || rarityMult < 1.0)
					{
						r = r + p;
					}
				}
				else
				{
					break;
				}
				
				num = ++num;
				num = num;

				if (num >= 2 || !isTrader && num >= 1)
				{
					break;
				}
			}
				
			for( local num = 0; true;  )
			{
				local p = this.Math.rand(0, 1000);
				local item;
				
				if (p < (200 * rarityMult))
				{
					
					item = this.new("scripts/items/misc/lootbox_AC_item");
					
					local items = [
						item
					];

					foreach( it in items )
					{
						it.setPriceMult(2.0 * _priceMult);
						_stash.add(it);
					}
				}
				else
				{
					break;
				}
				

				num = ++num;
				num = num;

				if (num >= 2 || !isTrader && num >= 1)
				{
					break;
				}
			}
		}

		_stash.sort();
	}
		
		local onUpdateShopList = o.onUpdateShopList;
		o.onUpdateShopList = function()
		{
			onUpdateShopList();
			local list = [
			{
				R = 985,
				P = 1.0,
				S = this.Const.Companions.TypeList.Snake
			},
			{
				R = 980,
				P = 1.0,
				S = this.Const.Companions.TypeList.Nacho
			},
			{
				R = 995,
				P = 1.0,
				S = this.Const.Companions.TypeList.Alp
			},
			{
				R = 990,
				P = 1.0,
				S = this.Const.Companions.TypeList.HyenaFrenzied
			}
			];
			
			addACtoStash(list, this.m.Stash, 1.0);
		}
	});
	
	::mods_hookExactClass("entity/world/settlements/buildings/blackmarket_building", function(o) {
		
		o.addACtoStash <- function( _list, _stash, _priceMult )
		{
			local rarityMult = this.getSettlement().getModifiers().RarityMult;
	
			local isTrader = this.World.Retinue.hasFollower("follower.trader");			
	
			foreach( i in _list )
			{
				local r = i.R;
				local numRand = this.Math.rand(1, 2);
				local discount = 1.0;
				if (isTrader)
					discount = this.Math.rand(80, 100) * 0.01;
	
				for( local num = 0; true;  )
				{
					local p = this.Math.rand(0, 1000);
					local item;
					
					if (p < (1000 - r) * rarityMult)
					{
						
						item = this.new("scripts/items/misc/lootbox_AC_item");
						
						item.setPriceMult(i.P * _priceMult * discount);
						_stash.add(item);
					}
					else
					{
						break;
					}
	
					num = ++num;
					num = num;
	
					if (num >= numRand || !isTrader && num >= 1)
					{
						break;
					}
				}
			}
	
			_stash.sort();
		}
		
		local onUpdateShopList = o.onUpdateShopList;
		o.onUpdateShopList = function()
		{
			onUpdateShopList();
			
			local list = [
				{
					R = 0,
					P = 5.0
				},
				{
					R = 200,
					P = 4.5
				},
				{
					R = 400,
					P = 4.0
				},
				{
					R = 600,
					P = 3.5
				},
				{
					R = 800,
					P = 3.0
				}
				];
				
			addACtoStash(list, this.m.Stash, 1.0);
		}
	});
	
	::mods_hookExactClass("entity/world/location", function(o) {
	
	local onSpawned = o.onSpawned;
		o.onSpawned = function()
		{
			if (!this.isLocationType(this.Const.World.LocationType.Unique))
			{	
				local num = 0;
		
				for( local chance = this.m.Resources / 35.0; num < 2;  )
				{
					local r = this.Math.rand(1, 100);
		
					if (r <= chance)
					{
						chance = chance - r;
						num = ++num;
						num = num;
						
						this.m.Loot.add(this.new("scripts/items/misc/lootbox_AC_item"));
					}	
					else
					{
						break;
					}
				}
			}
			
			onSpawned();
		}
	});
	
	::mods_hookExactClass("skills/actives/legend_prayer_of_faith_skill", function(o) {
		
		o.onUse = function( _user, _targetTile )
		{
			local myTile = _user.getTile();
			local actors = this.Tactical.Entities.getAllInstancesAsArray();
	
			foreach( a in actors )
			{
				if (a.getID() == _user.getID())
				{
					continue;
				}
	
				if (myTile.getDistanceTo(a.getTile()) > 1)
				{
					continue;
				}
	
	
				if (a.isAlliedWith(_user))
				{
					if (!a.getBackground() != null && !a.getBackground().isBackgroundType(this.Const.BackgroundType.ConvertedCultist || this.Const.BackgroundType.Cultist))
					{
						local effect = this.new("scripts/skills/effects/legend_prayer_of_faith_effect");
						effect.m.Resolve = this.getContainer().getActor().getBravery();
						a.getSkills().add(effect);
					}
				}
	
				local skills = a.getSkills();
	
				if (skills.hasSkill("racial.skeleton") || skills.hasSkill("actives.zombie_bite") || skills.hasSkill("racial.vampire") || skills.hasSkill("racial.ghost"))
				{
					a.getSkills().add(this.new("scripts/skills/effects/legend_baffled_effect"));
				}
			}
	
			return true;
		}
	});
	
	::mods_hookExactClass("skills/actives/legend_prayer_of_life_skill", function(o) {
		
		o.onUse = function( _user, _targetTile )
		{
			local myTile = _user.getTile();
			local actors = this.Tactical.Entities.getAllInstancesAsArray();
	
			foreach( a in actors )
			{
				if (a.getID() == _user.getID())
				{
					continue;
				}
	
				if (myTile.getDistanceTo(a.getTile()) > 1)
				{
					continue;
				}
	
				if (a.isAlliedWith(_user))
				{
					if (!a.getBackground() != null && !a.getBackground().isBackgroundType(this.Const.BackgroundType.ConvertedCultist) && !a.getSkills().hasSkill("effects.legend_prayer_of_life"))
					{
						local effect = this.new("scripts/skills/effects/legend_prayer_of_life_effect");
						effect.m.Resolve = this.getContainer().getActor().getBravery();
						a.getSkills().add(effect);
					}
				}
	
				local skills = a.getSkills();
	
				if (skills.hasSkill("racial.skeleton") || skills.hasSkill("actives.zombie_bite") || skills.hasSkill("racial.vampire") || skills.hasSkill("racial.ghost"))
				{
					if (!skills.hasSkill("effects.disintegrating"))
					{
						skills.add(this.new("scripts/skills/effects/disintegrating_effect"));
					}
				}
			}
	
			return true;
		}
	});
	
	::mods_hookExactClass("skills/actives/legend_drums_of_life_skill", function(o) {
		
		o.onUse = function( _user, _targetTile )
		{
			local myTile = _user.getTile();
			local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());
	
			foreach( a in actors )
			{
				if (a.getID() == _user.getID())
				{
					continue;
				}
	
				if (myTile.getDistanceTo(a.getTile()) > 8)
				{
					continue;
				}
	
				if (a.isAlliedWith(_user))
				{
					a.getSkills().add(this.new("scripts/skills/effects/legend_drums_of_life_effect"));
				}
			}
	
			this.getContainer().add(this.new("scripts/skills/effects/legend_drums_of_life_effect"));
			return true;
		}
	});
	
	::mods_hookExactClass("skills/actives/legend_drums_of_war_skill", function(o) {
		
		o.onUse = function( _user, _targetTile )
		{
			local myTile = _user.getTile();
			local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());
	
			foreach( a in actors )
			{
				if (a.getID() == _user.getID())
				{
					continue;
				}
	
				if (a.getFatigue() == 0)
				{
					continue;
				}
	
				if (myTile.getDistanceTo(a.getTile()) > 8)
				{
					continue;
				}
	
				if (a.isAlliedWith(_user))
				{
					a.getSkills().add(this.new("scripts/skills/effects/legend_drums_of_war_effect"));
					this.spawnIcon(this.m.Overlay, a.getTile());
				}
			}
	
			this.getContainer().add(this.new("scripts/skills/effects/legend_drums_of_war_effect"));
			return true;
		}
	});
	
	if (::mods_getRegisteredMod("mod_nggh_magic_concept") != null)
	{
		::mods_hookExactClass("skills/actives/nightmare_skill", function(obj) {
	
			local ws_create = obj.create;
			obj.create = function()
			{
				ws_create();
				this.m.Description = "Infuses a terrible nightmare that can damage the mind of your target.";
				this.m.Icon = "skills/active_117.png";
				this.m.IconDisabled = "skills/active_117_sw.png";
				this.m.Overlay = "active_117";
				this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
				this.m.DirectDamageMult = 1.0;
				this.m.ActionPointCost = 4;
				this.m.FatigueCost = 10;
				this.m.MinRange = 1;
				this.m.MaxRange = 2;
				this.m.MaxLevelDifference = 4;
			};
			obj.getTooltip <- function()
			{
				local ret = this.getDefaultTooltip();
				ret.extend([
					{
						id = 7,
						type = "text",
						icon = "ui/icons/vision.png",
						text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
					},
					{
						id = 8,
						type = "text",
						icon = "ui/icons/special.png",
						text = "Damage is reduced by target\'s [color=" + ::Const.UI.Color.NegativeValue + "]Resolve[/color]"
					}
				]);
				
				return ret;
			};
			local ws_isUsable = obj.isUsable;
			obj.isUsable = function()
			{
				if (this.getContainer().getActor().isPlayerControlled())
				{
					return this.skill.isUsable();
				}
		
				return ws_isUsable();
			};
			obj.onVerifyTarget = function( _originTile, _targetTile )
			{
				if (!this.skill.onVerifyTarget(_originTile, _targetTile))
				{
					return false;
				}
				
				return _targetTile.getEntity().getSkills().getSkillByID("effects.sleeping") != null;
			};
		});
	}
	
	/*
	::mods_hookExactClass("skills/actives/alp_teleport_skill", function(obj) {
	
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			
			if(this.getContainer().getActor().isPlayerControlled())
				this.m.IsHidden = true;
		}
	
	});
	*/
	
	//allow player AC be affected by inspiring_presence_buff standing near bro who has perk
	if (::mods_getRegisteredMod("mod_legends_PTR") != null)
	{
		::mods_hookExactClass("skills/effects/ptr_inspiring_presence_buff_effect", function ( o )
		{
			o.onTurnStart <- function()
			{
				local actorHasAdjacentEnemy = function( _actor )
				{
					local adjacentEnemies = ::Tactical.Entities.getHostileActors(_actor.getFaction(), _actor.getTile(), 1);
					return adjacentEnemies.len() > 0;
				}
		
				local actor = this.getContainer().getActor();
				local allies = ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), 1);
				if (actor.getFaction() == this.Const.Faction.PlayerAnimals)
					allies.extend(::Tactical.Entities.getFactionActors(this.Const.Faction.Player, actor.getTile(), 1));
				local hasAdjacentEnemy = actorHasAdjacentEnemy(actor);
				local hasInspirer = false;
		
				foreach (ally in allies)
				{
					if (ally.getID() == actor.getID()) continue;
		
					if (!hasInspirer)
					{
						local inspiringPresence = ally.getSkills().getSkillByID("perk.inspiring_presence");
						if (inspiringPresence != null && inspiringPresence.isEnabled())
						{
							hasInspirer = true;
						}
					}
		
					if (!hasAdjacentEnemy && actorHasAdjacentEnemy(ally))
					{
						hasAdjacentEnemy = true;
					}
				}
		
				if (hasInspirer && hasAdjacentEnemy)
				{
					this.m.IsInEffect = true;
					this.m.IsStartingTurn = true;
					this.spawnIcon("ptr_inspiring_presence_buff_effect", actor.getTile());
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, actor.getPos());
				}
			}
		});
	}
	
	//No more bullshit 100% hit chance grab, if grab is failed, linebreaker will be used instead with moving target nearby if possible and without hp damage
	::mods_hookExactClass("skills/actives/fling_back_skill", function (o)
	{
		local create = o.create;
		o.create <- function()
		{
			create();
			this.m.IsUsingHitchance = true;
		}
		
		o.findTileToKnockBackToFromLineBreaker <- function( _userTile, _targetTile )
		{
			local dir = _userTile.getDirectionTo(_targetTile);
	
			if (_targetTile.hasNextTile(dir))
			{
				local knockToTile = _targetTile.getNextTile(dir);
	
				if (knockToTile.IsEmpty && this.Math.abs(knockToTile.Level - _userTile.Level) <= 1)
				{
					return knockToTile;
				}
			}
	
			local altdir = dir - 1 >= 0 ? dir - 1 : 5;
	
			if (_targetTile.hasNextTile(altdir))
			{
				local knockToTile = _targetTile.getNextTile(altdir);
	
				if (knockToTile.IsEmpty && this.Math.abs(knockToTile.Level - _userTile.Level) <= 1)
				{
					return knockToTile;
				}
			}
	
			altdir = dir + 1 <= 5 ? dir + 1 : 0;
	
			if (_targetTile.hasNextTile(altdir))
			{
				local knockToTile = _targetTile.getNextTile(altdir);
	
				if (knockToTile.IsEmpty && this.Math.abs(knockToTile.Level - _userTile.Level) <= 1)
				{
					return knockToTile;
				}
			}
	
			return null;
		}
		
		o.onUse = function( _user, _targetTile )
		{
			this.getContainer().setBusy(true);
			local tag = {
				Skill = this,
				User = _user,
				TargetTile = _targetTile
			};
	
			local roll = this.Math.rand(1, 100);
			local hitChance = this.Math.max(5, this.Math.min(95, _user.getCurrentProperties().getMeleeSkill() - _targetTile.getEntity().getCurrentProperties().getMeleeDefense()));
	
			if (roll <= hitChance)
			{
				if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
				{
					if (this.m.SoundOnUse.len() != 0)
					{
						this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], ::Const.Sound.Volume.Skill, _user.getPos());
					}
	
					this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.Delay, this.onPerformAttack.bindenv(this), tag);
	
					if (!_user.isPlayerControlled() && _targetTile.getEntity().isPlayerControlled())
					{
						_user.getTile().addVisibilityForFaction(::Const.Faction.Player);
					}
				}
				else
				{
					this.onPerformAttack(tag);
				}
			}
			else
			{
				if (!_targetTile.getEntity().isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetTile.getEntity()) + " dodges " + ::Const.UI.getColorizedEntityName(_user) + "'s grab, but gives away their position." + " (Chance: " + hitChance + ", Rolled: " + roll + ")");
				}
	
				local target = _targetTile.getEntity();
	
				if (this.m.SoundOnUse.len() != 0)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], ::Const.Sound.Volume.Skill, _user.getPos());
				}
	
				local knockToTile = this.findTileToKnockBackToFromLineBreaker(_user.getTile(), _targetTile);
	
				if (knockToTile == null)
				{
					return false;
				}
	
				this.applyFatigueDamage(target, 10);
	
				if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
				{
					return false;
				}
	
				local skills = target.getSkills();
				skills.removeByID("effects.shieldwall");
				skills.removeByID("effects.spearwall");
				skills.removeByID("effects.riposte");
	
				if (this.m.SoundOnHit.len() != 0)
				{
					this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], ::Const.Sound.Volume.Skill, _user.getPos());
				}
	
				target.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
				local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetTile.Level) - 1) * ::Const.Combat.FallingDamage;
	
				if (damage == 0)
				{
					this.Tactical.getNavigator().teleport(target, knockToTile, null, null, true);
				}
				else
				{
					local p = this.getContainer().getActor().getCurrentProperties();
					local tag = {
						Attacker = _user,
						Skill = this,
						HitInfo = clone ::Const.Tactical.HitInfo
					};
					tag.HitInfo.DamageRegular = damage;
					tag.HitInfo.DamageFatigue = ::Const.Combat.FatigueReceivedPerHit;
					tag.HitInfo.DamageDirect = 1.0;
					tag.HitInfo.BodyPart = ::Const.BodyPart.Body;
					tag.HitInfo.BodyDamageMult = 1.0;
					tag.HitInfo.FatalityChanceMult = 1.0;
					this.Tactical.getNavigator().teleport(target, knockToTile, this.onKnockedDown, tag, true);
				}
	
				local tag = {
					TargetTile = _targetTile,
					Actor = _user
				};
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 250, this.onFollow, tag);
			}
	
			return true;
		}
	});
	
});