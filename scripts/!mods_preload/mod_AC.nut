::mods_registerMod("mod_AC", 1.30, "Accessory Companions");
::mods_queue("mod_AC", "mod_legends,>mod_nggh_magic_concept,>mod_legends_PTR", function()
{
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

	local buildings = [
		"kennel_building",
		"alchemist_building",
		"arena_building"
	];
	
	foreach(building in buildings)
	{
		::mods_hookExactClass("entity/world/settlements/buildings/" + building, function(o) {
			local onUpdateDraftList = ::mods_getMember(o, "onUpdateDraftList");
			o.onUpdateDraftList = function(_list, _gender) {
				_list.push("companions_beastmaster_background");
				_list.push("companions_beastmaster_background");
				onUpdateDraftList(_list, _gender);
			}		
		});
	}	

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
	});
	
	::mods_hookExactClass("entity/tactical/humans/barbarian_chosen", function(o)
	{
		local makeMiniboss = ::mods_getMember(o, "makeMiniboss");
		o.makeMiniboss = function()
		{
			makeMiniboss();
			local loot = this.new("scripts/items/accessory/wardog_item");
			loot.setType(this.Const.Companions.TypeList.Whitewolf);
			loot.updateCompanion();
			this.m.Items.equip(loot);
		}
	});	

	///// give companions experience when the player kills something
	::mods_hookExactClass("entity/tactical/player", function(o)
	{
		if (!("mod_AC" in o))
		{
			o.mod_AC <- true;
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
		}
	});

	local undead = [
		"zombie",
		"skeleton"
	]
	
	///// make reanimated zombies and skeletons grant the company experience when they kill something
	foreach(ud in undead)
	{	
		::mods_hookBaseClass("entity/tactical/enemies/" + ud, function(o)
		{
			if (!("mod_AC" in o))
			{
				o.mod_AC <- true;
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
			}
		});
	}

	///// equipped companions add to player party strength
	::mods_hookExactClass("entity/world/player_party", function(o)
	{
		if (!("mod_AC" in o))
		{
			o.mod_AC <- true;
			local updateStrength = o.updateStrength;
			o.updateStrength = function()
			{
				updateStrength();
				local company = this.World.getPlayerRoster().getAll();
				if (company.len() > this.World.Assets.getBrothersScaleMax())
				{
					company.sort(this.onLevelCompare);
				}

				foreach( i, bro in company )
				{
					if (i >= this.World.Assets.getBrothersScaleMax())
					{
						break;
					}

					local companion = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					if (companion != null && "setType" in companion)
					{
						this.m.Strength += this.Math.round(companion.m.Level * (this.Const.Companions.Library[companion.getType()].PartyStrength / 8.25));
					}
				}
			}
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
					if (this.m.Name == "White Wolf Queen")
					{
						this.m.Quirks.push("scripts/skills/perks/perk_inspire");
						if (::mods_getRegisteredMod("mod_nggh_magic_concept") != null)
						{
							this.m.Quirks.push("scripts/skills/perks/perk_champion");					
						}						
					}
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
			}

			o.onCombatFinished <- function()
			{
				if (this.m.Entity != null)
				{
					this.m.Wounds = this.Math.floor((1.0 - this.m.Entity.getHitpointsPct()) * 100.0);
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
					entity.setFaction(this.Const.Faction.PlayerAnimals);
					entity.applyCompanionScaling();
					this.setEntity(entity);

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
					local beastmasters = [
						["background.companions_beastmaster", 0.015],
						["background.legend_commander_druid", 0.02],
						["background.legend_druid", 0.015],
						["background.legend_commander_ranger", 0.015],
						["background.legend_ranger", 0.01],
						["background.houndmaster", 0.01],
						["background.legend_muladi", 0.01],
					]
					foreach(beastmaster in beastmasters)
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
				
				local wearArmor = function()
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
				
				local hasHeavyArmor = function()
				{
					if (this.m.Type == this.Const.Companions.TypeList.Noodle || this.m.Type == this.Const.Companions.TypeList.Whitewolf || this.m.Type == this.Const.Companions.TypeList.TomeReanimation )
					{
						return true;
					}
					if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor)
					{
						return (this.m.Variant == 1 || this.m.Variant == 5);
					}
					return false;
				}
				
				local DamageType = function()
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
					else if (this.m.Type == this.Const.Companions.TypeList.Snake || this.m.Type == this.Const.Companions.TypeList.Schrat)
					{
						return 2;
					}
					else if (this.m.Type == this.Const.Companions.TypeList.Nacho || this.m.Type == this.Const.Companions.TypeList.Noodle)
					{
						return 1;
					}
					else if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor)
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
				if ( wearArmor() )
				{
					availableQuirks.extend([
						"scripts/skills/perks/perk_legend_full_force",
						"scripts/skills/perks/perk_mar_balance",
						"scripts/skills/perks/perk_mar_lithe"
						]);
				}				
				if ( hasHeavyArmor() )
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
				if (::mods_getRegisteredMod("mod_nggh_magic_concept") != null)
				{
					availableQuirks.push("scripts/skills/perks/perk_champion");
					if (this.m.Type <= this.Const.Companions.TypeList.HyenaFrenzied || this.m.Type >= this.Const.Companions.TypeList.Whitewolf )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_wolf_bite",
							"scripts/skills/perks/perk_hyena_bite",
							"scripts/skills/perks/perk_thick_hide",
							"scripts/skills/perks/perk_enrage_wolf",
							"scripts/skills/perks/perk_rabies"
						]);					
					}
					if (this.m.Type == this.Const.Companions.TypeList.Spider )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_spider_bite",
							"scripts/skills/perks/perk_spider_venom",
							"scripts/skills/perks/perk_spider_web"
						]);						
					}
					if (this.m.Type == this.Const.Companions.TypeList.Snake )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_giant_serpent",
							"scripts/skills/perks/perk_serpent_bite",
							"scripts/skills/perks/perk_serpent_drag",
							"scripts/skills/perks/perk_snake_venom"
						]);					
					}
					if (this.m.Type == this.Const.Companions.TypeList.Nacho )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_frenzy",
							"scripts/skills/perks/perk_nacho",
							"scripts/skills/perks/perk_nacho_eat"
						]);					
					}
					if (this.m.Type == this.Const.Companions.TypeList.Alp )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_mastery_nightmare",
							"scripts/skills/perks/perk_mastery_sleep",
							"scripts/skills/perks/perk_after_wake"
						]);					
					}
					if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_unhold_fling",
							"scripts/skills/perks/perk_unhold_hand_to_hand"
						]);					
					}					
					if (this.m.Type == this.Const.Companions.TypeList.Schrat )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_grow_shield",
							"scripts/skills/perks/perk_sapling",
							"scripts/skills/perks/perk_uproot",
							"scripts/skills/perks/perk_uproot_aoe"
						]);					
					}
					if (this.m.Type == this.Const.Companions.TypeList.Noodle )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_intimidate",
							"scripts/skills/perks/perk_lindwurm_acid",
							"scripts/skills/perks/perk_lindwurm_body"
						]);						
					}				
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
					if (DamageType() == 1 || DamageType() == 4)
					{
						availableQuirks.push("scripts/skills/perks/perk_ptr_deep_cuts");
					}
					else if (DamageType() == 3)
					{
						availableQuirks.push("scripts/skills/perks/perk_ptr_rattle");
					}

					if (this.m.Type == this.Const.Companions.TypeList.Noodle)
					{
						availableQuirks.push("scripts/skills/perks/perk_ptr_leverage");
					}					
					if ( hasHeavyArmor() )
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
		o.isPlayerControlled = function()
		{
			return this.getFaction() <= this.Const.Faction.PlayerAnimals && this.m.IsControlledByPlayer;
		}
	});	
});
