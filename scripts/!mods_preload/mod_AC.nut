::mods_registerMod("mod_AC", 1.18, "Accessory Companions");
::mods_queue("mod_AC", null, function()
{
	///// extends maximum tooltip height in order to fit companion details and makes sure long tooltips don't go outside of the window
	::mods_registerCSS("companions_tooltip.css");
	::mods_registerJS("companions_tooltip.js");


	///// hide the Beastmaster background within the Houndmaster background
	::mods_hookNewObject("skills/backgrounds/houndmaster_background", function(o)
	{
		///// avoids houndmaster_background.getTooltip double hook for "Backgrounds and Attribute Ranges" compatibility
		if (::mods_getRegisteredMod("mod_BAR") == null || (::mods_getRegisteredMod("mod_BAR") != null && ::mods_getRegisteredMod("mod_BAR").Version < 1.05))
		{
			o.getTooltip = function()
			{
				local ret = [
					{
						id = 1,
						type = "title",
						text = this.getName()
					},
					{
						id = 2,
						type = "description",
						text = this.getDescription()
					},
					{
						id = 14,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = "Beasts unleashed by this character will start at confident morale."
					}
				];

				if (this.m.ID == "background.companions_beastmaster")
				{
					ret.push({
						id = 55,
						type = "text",
						icon = "ui/icons/special.png",
						text = "Higher chance of success when taming beasts."
					});
				}

				return ret;
			}
		}

		o.applyBeastmasterModification <- function()
		{
			this.m.ID = "background.companions_beastmaster";
			this.m.Name = "Beastmaster";
			this.m.Icon = "ui/backgrounds/background_beastmaster_ac.png";
			this.m.BackgroundDescription = "Beastmasters are used to handle various beasts.";
			this.m.GoodEnding = "Beasts were not simply \'beasts\' to %name%, despite his title as \'beastmaster.\' To him, they were the most loyal friends of his life. After leaving the company, he discovered an ingenious way to breed the animals specifically tailored to the desires of the nobility. Wanted a brutish beast for a guard? He could do it. Wanted something small and cuddly for the children? He could do that, too. The former mercenary now earns an incredible earning doing what he loves - working with beasts.";
			this.m.BadEnding = "What\'s merely a beast to one man is a loyal companion to %name%. After leaving the company, the beastmaster went out to work for the nobility. Unfortunately, he refused to let hundreds of his beasts be used as a battle vanguard to be thrown away for some short-lived tactical advantage. He was hanged for his \'traitorous ideals\'.";
			this.m.HiringCost = 160;
			this.m.DailyCost = 14;
			this.m.Excluded = [
				"trait.fear_beasts",
				"trait.hate_beasts",
				"trait.craven",
				"trait.dastard",
				"trait.fainthearted",
				"trait.insecure",
				"trait.ailing",
				"trait.bleeder",
				"trait.tiny",
				"trait.fragile",
				"trait.asthmatic",
				"trait.clubfooted",
				"trait.cocky"
			];
			this.m.ExcludedTalents = [
				this.Const.Attributes.RangedSkill,
				this.Const.Attributes.RangedDefense
			];
			this.m.Titles = [
				"the Beastmaster",
				"the Tamer"
			];
			this.m.Faces = this.Const.Faces.AllMale;
			this.m.Hairs = this.Const.Hair.UntidyMale;
			this.m.HairColors = this.Const.HairColors.All;
			this.m.Beards = this.Const.Beards.Untidy;
			this.m.Bodies = this.Const.Bodies.AllMale;
			this.m.IsLowborn = false;			
			this.m.Level = this.Math.rand(1, 2);
		}

		o.onBuildDescription = function()
		{
			if (this.m.ID == "background.companions_beastmaster")
			{
				return "{%name%\'s fondness for beasts started after his father won a serpent in a shooting contest. | When a direwolf saved him from a bear, %name% dedicated his life to beasts of all sorts. | Seeing a webknecht stave off a would-be robber, %name%\'s fondness for beasts only grew. | A young, bird-hunting %name% quickly saw the honor, loyalty, and workmanship of a trained beast. | Once bitten by a wild hyena, %name% confronted his fear of beasts by learning to train them.} {The beastmaster spent many years working for a local lord. He gave up the post after the liege struck one of his post-ferals down just for sport. | Quick with training the wildlife, the beastmaster put his post-ferals into a lucrative traveling tradeshow. | The man made a great deal of money on the beast-fighting circuits, his post-ferals renowned for their easily commanded - and unleashed - ferocity. | Employed by lawmen, the beastmaster used his strong-nosed post-ferals to hunt down many a criminal element. | Used by a local lord, many of the beastmaster\'s post-ferals found their way onto the battlefield. | For many years, the beastmaster used his post-ferals to help lift the spirits of orphaned children and the crippled.} {Now, though, %name% seeks a change of vocation. | When he heard word of a mercenary\'s pay, %name% decided to try his hand at being a sellsword. | Approached by a sellsword to buy one of his creatures, %name% became more interested in the prospect of he, himself, becoming a mercenary. | Tired of training creatures for this purpose or that, %name% seeks to train himself for... well, this purpose or that. | An interesting prospect, you can only hope %name% is as loyal as the creatures he once commanded.}";
			}
			else
			{
				return "{%name%\'s fondness for dogs started after his father won a pup in a shooting contest. | When a dog saved him from a bear, %name% dedicated his life to the canine lot. | Seeing a dog stave off a would-be robber, %name%\'s fondness for the mutts only grew. | A young, bird-hunting %name% quickly saw the honor, loyalty, and workmanship of a dog. | Once bitten by a wild dog, %name% confronted his fear of canines by learning to train them.} {The houndmaster spent many years working for a local lord. He gave up the post after the liege struck a dog down just for sport. | Quick with training his mongrels, the houndmaster put his dogs into a lucrative traveling tradeshow. | The man made a great deal of money on the dog-fighting circuits, his mutts renowned for their easily commanded - and unleashed - ferocity. | Employed by lawmen, the houndmaster used his strong-nosed dogs to hunt down many a criminal element. | Used by a local lord, many of the houndmaster\'s dogs found their way onto the battlefield. | For many years, the houndmaster used his dogs to help lift the spirits of orphaned children and the crippled.} {Now, though, %name% seeks a change of vocation. | When he heard word of a mercenary\'s pay, %name% decided to try his hand at being a sellsword. | Approached by a sellsword to buy one of his dogs, %name% became more interested in the prospect of he, himself, becoming a mercenary. | Tired of training dogs for this purpose or that, %name% seeks to train himself for... well, this purpose or that. | An interesting prospect, you can only hope %name% is as loyal as the dogs he once commanded.}";
			}
		}

		o.onChangeAttributes = function()
		{
			if (this.m.ID == "background.companions_beastmaster")
			{
				local c = {
					Hitpoints = [10, 5],
					Bravery = [10, 10],
					Stamina = [10, 5],
					MeleeSkill = [0, 0],
					RangedSkill = [0, 0],
					MeleeDefense = [6, 6],
					RangedDefense = [0, 0],
					Initiative = [10, 5]
				};
				return c;
			}
			else
			{
				local c = {
					Hitpoints = [5, 0],
					Bravery = [5, 5],
					Stamina = [5, 0],
					MeleeSkill = [0, 0],
					RangedSkill = [0, 0],
					MeleeDefense = [3, 3],
					RangedDefense = [0, 0],
					Initiative = [5, 0]
				};
				return c;
			}
		}

		o.onAddEquipment = function()
		{
			if (this.m.ID == "background.companions_beastmaster")
			{
				local items = this.getContainer().getActor().getItems();

				///// mainhand
				local r = this.Math.rand(1, 2);
				if (r == 1)
				{
					local rr = this.Math.rand(1, 2);
					if (rr == 1)
					{
						items.equip(this.new("scripts/items/weapons/battle_whip"));
					}
					else
					{
						items.equip(this.new("scripts/items/weapons/barbarians/thorned_whip"));
					}
				}
				else
				{
					local rr = this.Math.rand(1, 16);
					if (rr == 1)
					{
						items.equip(this.new("scripts/items/weapons/dagger"));
					}
					else if (rr == 2)
					{
						items.equip(this.new("scripts/items/weapons/dagger"));
					}
					else if (rr == 3)
					{	
						items.equip(this.new("scripts/items/weapons/shortsword"));
					}
					else if (rr == 4)
					{
						items.equip(this.new("scripts/items/weapons/falchion"));
					}
					else if (rr == 5)
					{
						items.equip(this.new("scripts/items/weapons/bludgeon"));
					}
					else if (rr == 6)
					{
						items.equip(this.new("scripts/items/weapons/morning_star"));
					}
					else if (rr == 7)
					{
						items.equip(this.new("scripts/items/weapons/militia_spear"));
					}
					else if (rr == 8)
					{
						items.equip(this.new("scripts/items/weapons/boar_spear"));
					}
					else if (rr == 9)
					{
						items.equip(this.new("scripts/items/weapons/hatchet"));
					}
					else if (rr == 10)
					{
						items.equip(this.new("scripts/items/weapons/hand_axe"));
					}
					else if (rr == 11)
					{
						items.equip(this.new("scripts/items/weapons/reinforced_wooden_flail"));
					}
					else if (rr == 12)
					{
						items.equip(this.new("scripts/items/weapons/reinforced_wooden_flail"));
					}
					else if (rr == 13)
					{
						items.equip(this.new("scripts/items/weapons/butchers_cleaver"));
					}
					else if (rr == 14)
					{
						items.equip(this.new("scripts/items/weapons/scramasax"));
					}
					else if (rr == 15)
					{
						items.equip(this.new("scripts/items/weapons/pickaxe"));
					}
					else if (rr == 16)
					{
						items.equip(this.new("scripts/items/weapons/military_pick"));
					}
				}

				///// offhand
				local r = this.Math.rand(1, 2);
				if (r == 1)
				{
					items.equip(this.new("scripts/items/tools/throwing_net"));
				}
				else
				{
					local rr = this.Math.rand(1, 2);
					if (rr == 1)
					{
						items.equip(this.new("scripts/items/shields/buckler_shield"));
					}
					else
					{
						items.equip(this.new("scripts/items/shields/wooden_shield"));
					}
				}

				///// helmet
				local r = this.Math.rand(1, 3);
				if (r == 1)
				{
					items.equip(this.new("scripts/items/helmets/open_leather_cap"));
				}
				else if (r == 2)
				{
					items.equip(this.new("scripts/items/helmets/full_leather_cap"));
				}
				else if (r == 3)
				{
					items.equip(this.new("scripts/items/helmets/rusty_mail_coif"));
				}

				///// armor
				local r = this.Math.rand(1, 5);
				if (r == 1)
				{
					items.equip(this.new("scripts/items/armor/ragged_surcoat"));
				}
				else if (r == 2)
				{
					items.equip(this.new("scripts/items/armor/blotched_gambeson"));
				}
				else if (r == 3)
				{
					items.equip(this.new("scripts/items/armor/padded_leather"));
				}
				else if (r == 4)
				{
					items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
				}
				else if (r == 5)
				{
					items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
				}
			}
			else
			{
				local items = this.getContainer().getActor().getItems();
				local r;

				if (this.Math.rand(1, 100) >= 50)
				{
					items.equip(this.new("scripts/items/tools/throwing_net"));
				}

				r = this.Math.rand(0, 0);

				if (r == 0)
				{
					items.equip(this.new("scripts/items/armor/ragged_surcoat"));
				}

				r = this.Math.rand(0, 1);

				if (r == 0)
				{
					items.equip(this.new("scripts/items/helmets/open_leather_cap"));
				}
			}
		}

		o.serializeRawDescription <- function()
		{
			if (this.m.ID == "background.companions_beastmaster")
			{
				local cloneRawDescription = this.m.RawDescription;
				local serializedRawDescription = cloneRawDescription + "\nmod_AC=Beastmaster";
				return serializedRawDescription;
			}

			return this.m.RawDescription;
		}

		o.deserializeRawDescription <- function(_rd)
		{
			local nameMod = "\nmod_AC=Beastmaster";
			local findMod = _rd.find(nameMod);
			if (findMod != null)
			{
				local slicedRaw = _rd.slice(0, findMod);
				this.m.RawDescription = slicedRaw;
				this.applyBeastmasterModification();
			}
			else
			{
				this.m.RawDescription = _rd;
			}
		}

		o.onSerialize <- function(_out)
		{
			this.skill.onSerialize(_out);
			_out.writeString(this.m.Description);
			_out.writeString(this.serializeRawDescription());
			_out.writeU8(this.m.Level);
			_out.writeBool(this.m.IsNew);
			_out.writeF32(this.m.DailyCostMult);
		}

		o.onDeserialize <- function(_in )
		{
			this.skill.onDeserialize(_in);
			this.m.Description = _in.readString();
			this.deserializeRawDescription(_in.readString());
			this.m.Level = _in.readU8();
			this.m.IsNew = _in.readBool();

			if (_in.getMetaData().getVersion() >= 39)
			{
				this.m.DailyCostMult = _in.readF32();
			}
			else
			{
				this.m.DailyCostMult = 1.0;
			}
		}
	});


	///// arrays holding Descriptions of various settlements, part of the process to separate Beastmaster and Houndmaster drafting locations
	local BeastmasterSettlementsLarge = [
		// citadels
		"This massive citadel guards a warport and the surrounding trade routes. It is a seat of power for nobility and home to a large garrison.",
		"A massive citadel towering over the open plains surrounding it. A seat of power to nobles, and housing large armed forces for a firm grip on the region.",
		"This citadel towers high over the surrounding forests and dominates the region.",
		"This massive stone citadel is built into the steep mountains. A large number of men are stationed here to hold a firm grip on the land.",
		"This large citadel looks wide over the endless snow and is a stronghold against anything that may come down from the far north. As people flocked to its protection over the years, the many houses and workshops in its vicinity now also grant shelter and supply to travelers, mercenaries and adventurers in the area.",
		"This mighty citadel towers high above the surrounding steppe and is the seat of power in the region. It houses a large garrison and offers all kinds of services valuable to travellers and mercenaries.",
		"A large citadel towering high over the surrounding tundra and securing the large and open region. Many come here to resupply, make repairs and rest until venturing on.",

		// cities
		"A large city surrounded by lush green meadows, orchards and fields. Food stocks are usually filled to the brim.",
		"A big harbor city relying on trade and fishing, and an important hub for travellers arriving or leaving by ship.",
		"A prospering city located close to the forest with its main produce being valuable timber and venison.",
		"A large city far up north. Traders, travelers and adventurers come here for shelter from snow and storms.",
		"A large city thriving in the southern steppe by trading and producing valuable goods and fine arts.",
		"A collection of many smaller settlements spread out over dry spots in the swampy area to form one modestly sized city.",
		"Surrounded by barren tundra, this large city has lasted as an important trading hub and home to thinkers and fine arts."
	];
	local BeastmasterSettlementsMedium = [
		// keeps
		"This mighty stone keep surrounded by forest acts as a base of operations in the area.",
		"A stone keep that is towering high over the surrounding mountains. Lookouts on the towers can see approaching troops from miles away.",
		"A stone keep controlling routes through and access to the surrounding swamps and marshes.",

		// villages
		"An established village close to the forest living mainly from lumber cutting and game.",
		"A stretched out settlement nestled into the surrounding mountains. The hammering of pickaxes against stone can be heard from a distance.",
		"A somewhat larger settlement spread out across various dry and firm spots in the swamp."
	];
	local HoundmasterSettlementsSmall = [
		// hamlets
		"A village living off of lumber and everything the forest offers.",
		"A small settlement in a swampy area. The people living here sure know hardship."
	];


	///// add drafts to select settlements, part of the process to separate Beastmaster and Houndmaster drafting locations
	::mods_hookBaseClass("entity/world/settlement", function(o)
	{
		while(!("updateRoster" in o)) o = o[o.SuperName];
		local updateRoster = o.updateRoster;
		o.updateRoster = function(_force = false)
		{
			if (!this.m.DraftList.find("houndmaster_background"))
			{
				if (BeastmasterSettlementsLarge.find(this.m.Description))
				{
					this.m.DraftList.append("houndmaster_background");
					this.m.DraftList.append("houndmaster_background");
				}
				else if (BeastmasterSettlementsMedium.find(this.m.Description) || HoundmasterSettlementsSmall.find(this.m.Description))
				{
					this.m.DraftList.append("houndmaster_background");
				}
			}

			updateRoster(_force = false);
		}
	});


	///// give players the ability to tame beasts
	::mods_hookBaseClass("entity/tactical/human", function(o)
	{
		while(!("onInit" in o)) o = o[o.SuperName];
		local onInit = o.onInit;
		o.onInit = function()
		{
			onInit();
			if (this.m.IsControlledByPlayer && !this.getSkills().hasSkill("actives.companions_tame"))
				this.m.Skills.add(this.new("scripts/companions/player/companions_tame"));
		}
	});


	///// necromancers have a chance to drop the Tome of Reanimation when killed
	::mods_hookBaseClass("entity/tactical/actor", function(o)
	{
		while(!("onDeath" in o)) o = o[o.SuperName];
		local onDeath = o.onDeath;
		o.onDeath = function(_killer, _skill, _tile, _fatalityType)
		{
			onDeath(_killer, _skill, _tile, _fatalityType);
			if (this.m.Type == this.Const.EntityType.Necromancer && (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals))
			{
				if (this.Math.rand(1, 1000) <= this.Const.Companions.TameChance.Default)
				{
					local type = this.Const.Companions.TypeList.TomeReanimation;
					local matchNum = 0;
					local size = this.Tactical.getMapSize();
					for( local x = 0; x < size.X; x = ++x )
					{
						for( local y = 0; y < size.Y; y = ++y )
						{
							local tile = this.Tactical.getTileSquare(x, y);
							if (tile.IsContainingItems)
							{
								foreach( item in tile.Items )
								{
									if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "setType" in item)
									{
										if (item.getType() == type)
											++matchNum;
									}
								}
							}
						}
					}

					local stash = this.World.Assets.getStash().getItems();
					foreach(item in stash)
					{
						if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "setType" in item)
						{
							if (item.getType() == type)
								++matchNum;
						}
					}

					local brothers = this.World.getPlayerRoster().getAll();
					foreach(bro in brothers)
					{
						local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
						if (acc != null && "setType" in acc)
						{
							if (acc.getType() == type)
								++matchNum;
						}
					}

					if (matchNum < this.Const.Companions.Library[type].MaxPerCompany)
					{
						local loot = this.new("scripts/items/accessory/wardog_item");
						loot.setType(type);
						loot.updateCompanion();
						loot.drop(_tile);
					}
				}
			}
		}
	});


	///// give companions experience when the player kills something, turn a newly drafted Houndmaster into a Beastmaster if drafted settlement is of "Beastmaster-type"
	::mods_hookNewObject("entity/tactical/player", function(o)
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

		local setStartValuesEx = o.setStartValuesEx;
		o.setStartValuesEx = function( _backgrounds, _addTraits = true, _gender = -1, _addEquipment = true )
		{
			setStartValuesEx( _backgrounds, _addTraits = true, _gender = -1, _addEquipment = true );
			//if (this.m.Background.m.ID == "background.houndmaster" && this.World.State.getCurrentTown() != null && (BeastmasterSettlementsLarge.find(this.World.State.getCurrentTown().m.Description) || BeastmasterSettlementsMedium.find(this.World.State.getCurrentTown().m.Description)))
			if (true)
			{
				this.m.Background = null;
				this.m.Title = "";
				this.m.Talents = [];
				this.m.Items.clear();

				local remove = this.m.Skills.query(this.Const.SkillType.Background);
				foreach(r in remove)
				{
					if (r.getID() != "special.mood_check")
						this.m.Skills.removeByID(r.getID());
				}

				local background = this.new("scripts/skills/backgrounds/houndmaster_background");
				background.applyBeastmasterModification();
				this.m.Skills.add(background);
				this.m.Background = background;
				this.m.Ethnicity = this.m.Background.getEthnicity();
				
				local attributes = background.buildPerkTree();
				if (this.getFlags().has("PlayerZombie"))
				{
					this.m.StarWeights = background.buildAttributes("zombie", attributes);
				}
				else if (this.getFlags().has("PlayerSkeleton"))
				{
					this.m.StarWeights = background.buildAttributes("skeleton", attributes);
				}
				else
				{
					this.m.StarWeights = background.buildAttributes(null, attributes);
				}
				
				background.buildDescription();

				if (_addEquipment)
				{
					background.addEquipment();
				}
				
				background.buildDescription(true);
				this.m.Skills.update();
				local p = this.m.CurrentProperties;
				this.m.Hitpoints = p.Hitpoints;

				if (_addTraits)
				{
					this.fillTalentValues(3);
					this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
				}
			}
		}
	});


	///// make reanimated zombies grant the company experience when they kill something
	::mods_hookBaseClass("entity/tactical/enemies/zombie", function(o)
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
					if (onActorKilled != null) onActorKilled(_actor, _tile, _skill);
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
				}
			}
		}
	});


	///// make reanimated skeletons grant the company experience when they kill something
	::mods_hookBaseClass("entity/tactical/skeleton", function(o)
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
					if (onActorKilled != null) onActorKilled(_actor, _tile, _skill);
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
				}
			}
		}
	});


	///// equipped companions add to player party strength
	::mods_hookNewObject("entity/world/player_party", function(o)
	{
		if (!("mod_AC" in o))
		{
			o.mod_AC <- true;
			local updateStrength = o.updateStrength;
			o.updateStrength = function ()
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
	::mods_hookNewObject("items/misc/wardog_armor_upgrade_item", function(o)
	{
		o.onUse = function(_actor, _item = null)
		{
			local dog = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) : _item;
			if (dog == null || !("setType" in dog))
			{
				return false;
			}
			if (dog.getType() != this.Const.Companions.TypeList.Wardog && dog.getType() != this.Const.Companions.TypeList.Warhound)
			{
				return false;
			}

			local new_dog;
			if (dog.getType() == this.Const.Companions.TypeList.Wardog)
			{
				new_dog = this.new("scripts/items/accessory/armored_wardog_item");
				new_dog.setType(this.Const.Companions.TypeList.WardogArmor);
			}
			else
			{
				new_dog = this.new("scripts/items/accessory/armored_warhound_item");
				new_dog.setType(this.Const.Companions.TypeList.WarhoundArmor);
			}

			new_dog.setName(dog.getName());
			new_dog.setVariant(dog.getVariant());
			new_dog.setLevel(dog.getLevel());
			new_dog.setXP(dog.getXP());
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
	::mods_hookNewObject("items/misc/wardog_heavy_armor_upgrade_item", function(o)
	{
		o.onUse = function(_actor, _item = null)
		{
			local dog = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) : _item;
			if (dog == null || !("setType" in dog))
			{
				return false;
			}
			if (dog.getType() != this.Const.Companions.TypeList.Wardog && dog.getType() != this.Const.Companions.TypeList.WardogArmor && dog.getType() != this.Const.Companions.TypeList.Warhound && dog.getType() != this.Const.Companions.TypeList.WarhoundArmor)
			{
				return false;
			}

			local new_dog;
			if (dog.getType() == this.Const.Companions.TypeList.Wardog || dog.getType() == this.Const.Companions.TypeList.WardogArmor)
			{
				new_dog = this.new("scripts/items/accessory/heavily_armored_wardog_item");
				new_dog.setType(this.Const.Companions.TypeList.WardogArmorHeavy);
			}
			else
			{
				new_dog = this.new("scripts/items/accessory/heavily_armored_warhound_item");
				new_dog.setType(this.Const.Companions.TypeList.WarhoundArmorHeavy);
			}

			new_dog.setName(dog.getName());
			new_dog.setVariant(dog.getVariant());
			new_dog.setLevel(dog.getLevel());
			new_dog.setXP(dog.getXP());
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
				else if (this.isKindOf(this, "armored_wardog_item"))
				{
					this.m.ID = "accessory.armored_wardog";
					this.setType(this.Const.Companions.TypeList.WardogArmor);
				}
				else if (this.isKindOf(this, "heavily_armored_wardog_item"))
				{
					this.m.ID = "accessory.heavily_armored_wardog";
					this.setType(this.Const.Companions.TypeList.WardogArmorHeavy);
				}
				else if (this.isKindOf(this, "warhound_item"))
				{
					this.m.ID = "accessory.warhound";
					this.setType(this.Const.Companions.TypeList.Warhound);
				}
				else if (this.isKindOf(this, "armored_warhound_item"))
				{
					this.m.ID = "accessory.armored_warhound";
					this.setType(this.Const.Companions.TypeList.WarhoundArmor);
				}
				else if (this.isKindOf(this, "heavily_armored_warhound_item"))
				{
					this.m.ID = "accessory.heavily_armored_warhound";
					this.setType(this.Const.Companions.TypeList.WarhoundArmorHeavy);
				}
				else if (this.isKindOf(this, "wolf_item"))
				{
					this.m.ID = "accessory.warwolf";
					this.setType(this.Const.Companions.TypeList.Warwolf);
				}
				else if (this.isKindOf(this, "legend_warbear_item"))
				{
					this.m.ID = "accessory.legend_warbear";
					this.setType(this.Const.Companions.TypeList.Warbear);
				}
				else if (this.isKindOf(this, "legend_white_wolf_item"))
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
				if (this.Const.Companions.Library[this.m.Type].BasicQuirks.len() != 0)
				{
					foreach(quirk in this.Const.Companions.Library[this.m.Type].BasicQuirks)
					{
						if (this.m.Quirks.find(quirk) == null)
							this.m.Quirks.push(quirk);
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
				this.m.Value = this.Math.floor(this.Const.Companions.Library[this.m.Type].Value + ((this.m.Level - 1.00) * (this.Const.Companions.Library[this.m.Type].Value / 32.00)));
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
					return this.Const.Companions.Library[this.m.Type].NameUnleashed + " (" + this.m.Name + ")";
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

				local result = [
					{
						id = 1,
						type = "title",
						text = this.getName()
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
						text = "Level " + this.m.Level
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
						text = this.m.Type == this.Const.Companions.TypeList.TomeReanimation ? "This power of this incantation:" : "This individual\'s base attributes:"
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
						text = this.m.Type == this.Const.Companions.TypeList.TomeReanimation ? "And its additional effects:" : "And the quirks they possess:"
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
				leash.setItem(this);
				leash.applyCompanionModification();
				this.addSkill(leash);
			}

			o.onCombatFinished <- function()
			{
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

				_xp = _xp * 0.67;
				_xp = _xp * this.Const.Combat.GlobalXPMult;

				if (this.m.Level >= 11)
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
					local attributeValue = this.m.Level <= 11 ? this.Math.rand(attributeMin, attributeMax) : 1;
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

				local availableQuirks = [];
				foreach(quirk in this.Const.Companions.AttainableQuirks)
				{
					if (this.m.Quirks.find(quirk) == null)
						availableQuirks.push(quirk);
				}
				if (this.Const.DLC.Unhold)
				{
					foreach(quirk in this.Const.Companions.AttainableQuirksDLCUnhold)
					{
						if (this.m.Quirks.find(quirk) == null)
							availableQuirks.push(quirk);
					}
				}
				if (this.Const.DLC.Wildmen)
				{
					foreach(quirk in this.Const.Companions.AttainableQuirksDLCWildmen)
					{
						if (this.m.Quirks.find(quirk) == null)
							availableQuirks.push(quirk);
					}
				}
				if (this.Const.DLC.Desert)
				{
					foreach(quirk in this.Const.Companions.AttainableQuirksDLCDesert)
					{
						if (this.m.Quirks.find(quirk) == null)
							availableQuirks.push(quirk);
					}
				}
//				if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation)
				if (this.m.Type <= this.Const.Companions.TypeList.Noodle)
				{
					foreach(quirk in this.Const.Companions.AttainableQuirksBeasts)
					{
						if (this.m.Quirks.find(quirk) == null)
							availableQuirks.push(quirk);
					}
				}

				while (this.m.Level < this.Const.LevelXP.len() && this.m.XP >= this.Const.LevelXP[this.m.Level])
				{
					++this.m.Level;
					this.updateCompanion();
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
					if (availableQuirks.len() != 0 && this.m.Level < 11)
					{
						local rng = this.Math.rand(0, availableQuirks.len() - 1);
						this.m.Quirks.push(availableQuirks[rng]);
						availableQuirks.remove(rng);
					}
					if (this.m.Level == 11)
					{
						if (availableQuirks.len() != 0 && this.m.Type == this.Const.Companions.TypeList.TomeReanimation)
						{
							local rng = this.Math.rand(0, availableQuirks.len() - 1);
							this.m.Quirks.push(availableQuirks[rng]);
							availableQuirks.remove(rng);
						}
						else
						{
							this.m.Quirks.push("scripts/companions/quirks/companions_good_boy");
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

			o.serializeCompanionName <- function()
			{
				local nameCopy = this.m.Name;
				local serializedName = nameCopy += "\nmod_AC=" + this.m.Type + "," + this.m.Level + "," + this.m.XP + ",A=" + this.m.Attributes.Hitpoints + "," + this.m.Attributes.Stamina + "," + this.m.Attributes.Bravery + "," + this.m.Attributes.Initiative + "," + this.m.Attributes.MeleeSkill + "," + this.m.Attributes.RangedSkill + "," + this.m.Attributes.MeleeDefense + "," + this.m.Attributes.RangedDefense + ",Q=";

				foreach(i, quirk in this.m.Quirks)
				{
					local getQuirk = this.new(quirk);
					serializedName += this.Const.Companions.SerializeQuirks.find(getQuirk.m.ID);
					if (i < this.m.Quirks.len() - 1) serializedName += ",";
				}

				return serializedName;
			}

			o.deserializeCompanionName <- function(_cn)
			{
				local nameMod = "\nmod_AC=";
				local findMod = _cn.find(nameMod);
				if (findMod != null)
				{
					local slicedName = _cn.slice(0, findMod);
					local slicedDetails = _cn.slice(findMod + nameMod.len());
					local nameAttributes = "A=";
					local findAttributes = slicedDetails.find(nameAttributes);
					local slicedBasics = slicedDetails.slice(0, findAttributes - 1);
					local arrayBasics = split(slicedBasics, ",");
					this.m.Type = arrayBasics[0].tointeger();
					this.m.Level = arrayBasics[1].tointeger();
					this.m.XP = arrayBasics[2].tointeger();

					slicedDetails = slicedDetails.slice(findAttributes + nameAttributes.len());
					local nameQuirks = "Q=";
					local findQuirks = slicedDetails.find(nameQuirks);
					local slicedAttributes = slicedDetails.slice(0, findQuirks - 1);
					local arrayAttributes = split(slicedAttributes, ",");
					this.m.Attributes.Hitpoints = arrayAttributes[0].tointeger();
					this.m.Attributes.Stamina = arrayAttributes[1].tointeger();
					this.m.Attributes.Bravery = arrayAttributes[2].tointeger();
					this.m.Attributes.Initiative = arrayAttributes[3].tointeger();
					this.m.Attributes.MeleeSkill = arrayAttributes[4].tointeger();
					this.m.Attributes.RangedSkill = arrayAttributes[5].tointeger();
					this.m.Attributes.MeleeDefense = arrayAttributes[6].tointeger();
					this.m.Attributes.RangedDefense = arrayAttributes[7].tointeger();
			
					slicedDetails = slicedDetails.slice(findQuirks + nameQuirks.len());
					local arrayQuirks = split(slicedDetails, ",");
					this.m.Quirks.resize(arrayQuirks.len());
					foreach(i, quirk in this.m.Quirks)
					{
						this.m.Quirks[i] = this.Const.Companions.DeserializeQuirks[arrayQuirks[i].tointeger()];
					}

					this.m.Name = slicedName;
				}
				else
				{
					this.m.Name = _cn;
				}
			}

			o.onSerialize <- function(_out)
			{
				this.accessory.onSerialize(_out);
				_out.writeString(this.serializeCompanionName());
			}

			o.onDeserialize <- function(_in)
			{
				this.accessory.onDeserialize(_in);
				this.deserializeCompanionName(_in.readString());
				this.updateCompanion();
			}
		}
	}


	::mods_hookBaseClass("items/accessory/accessory", mod_AC_foundation);
	::mods_hookBaseClass("items/accessory/accessory_dog", mod_AC_foundation);
	::mods_hookBaseClass("items/accessory/wardog_item", mod_AC_foundation);
	::mods_hookBaseClass("items/accessory/warhound_item", mod_AC_foundation);
});
