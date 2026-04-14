this.beast_tamer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.beast_tamer";
		this.m.Name = "Beast Tamer";
		this.m.Icon = "ui/backgrounds/beast_tamer_background.png";
		this.m.BackgroundDescription = "Beast Tamers are both rare and ostracized, but a life in the wilderness has forged them into hardy people.";
		this.m.GoodEnding = "Ever an outcast, %name% returned home and used the crowns gained from their adventures to buy a home far away from those who scorned them in the past. The link between nature and %name% strengthened, acting a safe safe haven for those wronged or on the run.";
		this.m.BadEnding = "Living on the divide was a dangerous business, in attempting to return home they were driven out by northern militia on a border town with encroaching barbarians. Alone, hungry and desperate. %name% was easy prey for the wild animals they once called kin.";
		this.m.HiringCost = 300;
		this.m.DailyCost = 16;
		this.m.Excluded = [
			"trait.weasel",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.hesitant",
			"trait.fainthearted",
			"trait.craven",
			"trait.legend_seductive",
			"trait.hate_beasts",
			"trait.fear_beasts"
		];

		this.m.Faces = this.Const.Faces.AllWhiteMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;

		this.m.Level = this.Math.rand(1, 3);
		this.m.BackgroundType = this.Const.BackgroundType.Ranger | this.Const.BackgroundType.Combat;

		this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[2];
		this.m.Modifiers.Hunting = this.Const.LegendMod.ResourceModifiers.Hunting[2];
		this.m.Modifiers.Scout = this.Const.LegendMod.ResourceModifiers.Scout[3];
		this.m.Modifiers.Terrain = [
			0.0, // ?
			0.0, //ocean
			0.00,//plains
			0.030, //swamp
			0.01, //hills
			0.030, //forest
			0.030, //forest
			0.030, //forest_leaves
			0.030, //autumn_forest
			0.03, //mountains
			0.0, // ?
			0.00, //farmland
			0.020, // snow
			0.020, // badlands
			0.020, //highlands
			0.01, //stepps
			0.0, //ocean
			0.01, //desert
			0.01 //oasis
		];

		this.m.PerkTreeDynamicMins.Defense = 3;
		this.m.PerkTreeDynamicMins.Enemy = 0;
		this.m.PerkTreeDynamic = {
			Weapon = [],
			Defense = [
				this.Const.Perks.HeavyArmorTree,
				this.Const.Perks.MediumArmorTree,
				this.Const.Perks.LightArmorTree
			],
			Traits = [],
			Enemy = [],
			Class = [
				this.Const.Perks.HoundmasterClassTree
			],
			Magic = [],
		};
	}

	function onBuildDescription()
	{
		return "{Despite wearing their clothing and speaking their language, %name% has always been regarded with contempt by their fellow humans who prefer to call them \'freak\' over anything else. | Life on the edge of society taught %name% about a lot of things - self reliance, animal kinship, and how to effectively fell a man at 30 paces with an flint-tipped spear. }{Once a northerner, %name% dresses, speaks and acts much like the mossymen. Much to the irritation of some of the local inhabitants. | %name%'s presence is seen as a threat by some and an abomination by others. | %name% assures you that this way of life is not as painful as it may seem, despite the occasional insults from the locals. }{%name% stands out to everyone around them - at a glance they appear to be your typical hermit wandering the streets or moving across the lands. | %name% is a self appointed outcast, or perhaps a victim of shifting territories and warring cultures. }{%name%'s existence is quite simple - life at the rim of society allows them to appreciate the more natural things in life. Nature, landscapes and the occasional nuzzling from a furry friend. | The aggression and violence of humanity is what led %name% to adopt more of their strange customs, perhaps feeling that trading multiple tyrants for a vicious pet would be a favourable transaction. | %name% remarks they moved only for the food, but you suspect they came for a little bit more than that.}"
	}

	//Default Male
	function setGender(_gender = -1)
	{
		if (_gender == -1) _gender = ::Legends.Mod.ModSettings.getSetting("GenderEquality").getValue() == "Disabled" ? 0 : ::Math.rand(0, 1);

		if (_gender != 1) return;
		this.m.Faces = this.Const.Faces.PrettyFemale;
		this.m.Hairs = this.Const.Hair.AllFemale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		this.m.Bodies = this.Const.Bodies.FemaleSkinny;
		this.addBackgroundType(this.Const.BackgroundType.Female);
		// this.m.GoodEnding = "todo endings";
		// this.m.BadEnding = "todo endings";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				5
			],
			Bravery = [
				5,
				5
			],
			Stamina = [
				2,
				5
			],
			MeleeSkill = [
				0,
				5
			],
			RangedSkill = [
				12,
				16
			],
			MeleeDefense = [
				2,
				3
			],
			RangedDefense = [
				2,
				5
			],
			Initiative = [
				10,
				15
			]
		};
		return c;
	}

	function onAdded()
	{
		if (::mods_getRegisteredMod("mod_sellswords") != null)
			this.m.Container.add(this.new("scripts/skills/perks/perk_legend_dogwhisperer"));

		this.character_background.onAdded();
	}

	function buildPerkTree()
	{
		this.character_background.buildPerkTree();

		if (::mods_getRegisteredMod("mod_sellswords") != null)
		{
			if (!this.m.IsNew)
			return;

			this.addPerk(::Const.Perks.PerkDefs.LegendDogWhisperer, 6, false)
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local pet = this.new("scripts/items/accessory/wardog_item");
		local r;
		r = this.Math.rand(1, 4);

		switch (r)
		{
			case 1:
				items.equip(this.new("scripts/items/weapons/hand_axe"));
				break;
			case 2:
				items.equip(this.new("scripts/items/weapons/boar_spear"));
				break;
			case 3:
				items.equip(this.new("scripts/items/weapons/morning_star"));
				break;
			default:
				items.equip(this.new("scripts/items/weapons/javelin"));
				break;
		}

		r = this.Math.rand(1, 10);
		switch (r)
		{
			case 1:
				pet.setType(this.Const.Companions.TypeList.Direwolf);
				items.equip(pet);
				break;
			case 2:
				pet.setType(this.Const.Companions.TypeList.DirewolfFrenzied);
				items.equip(pet);
				break;
			case 3:
				pet.setType(this.Const.Companions.TypeList.Hyena);
				items.equip(pet);
				break;
			case 4:
				pet.setType(this.Const.Companions.TypeList.HyenaFrenzied);
				items.equip(pet);
				break;
			case 5:
				pet.setType(this.Const.Companions.TypeList.Spider);
				items.equip(pet);
				break;
			case 6:
				pet.setType(this.Const.Companions.TypeList.Snake);
				items.equip(pet);
				break;
			case 7:
				pet.setType(this.Const.Companions.TypeList.Nacho);
				items.equip(pet);
				break;
			case 8:
				pet.setType(this.Const.Companions.TypeList.Alp);
				items.equip(pet);
				break;
			case 9:
				pet.setType(this.Const.Companions.TypeList.BasiliskDrone);
				items.equip(pet);
				break;
			default:
				pet.setType(this.Const.Companions.TypeList.Warbear);
				items.equip(pet);
				break;
		}

		if (this.Math.rand(1, 100) <= 50)
			items.equip(this.new("scripts/items/tools/throwing_net"));
		else
			items.equip(this.new("scripts/items/tools/reinforced_throwing_net"));

		items.equip(this.Const.World.Common.pickArmor([
			[1, "ragged_surcoat"],
			[1, "thick_tunic"],
			[1, "leather_tunic"],
			[1, "padded_leather"],
			[1, "gambeson"],
			[1, "patched_mail_shirt"],
			[1, "worn_mail_shirt"]
		]));

		items.equip(this.Const.World.Common.pickHelmet([
			[1, "hood"],
			[1, "dark_cowl"],
			[1, "barbarians/bear_headpiece"],
			[1, "open_leather_cap"],
			[1, "dented_nasal_helmet"],
			[1, "nasal_helmet_with_rusty_mail"]
		]));
	}

});