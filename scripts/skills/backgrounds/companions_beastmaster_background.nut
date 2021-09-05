this.companions_beastmaster_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.companions_beastmaster";
		this.m.Name = "Beastmaster";
		this.m.Icon = "ui/backgrounds/background_beastmaster_ac.png";
		this.m.BackgroundDescription = "Beastmasters are used to handling various beasts and monsters.";
		this.m.GoodEnding = "Beasts were not simply \'beasts\' to %name%, despite his title as \'beastmaster.\' To him, they were the most loyal friends of his life. After leaving the company, he discovered an ingenious way to breed the creatures specifically tailored to the desires of the nobility. Wanted a brutish beast for a guard? He could do it. Wanted something small and cuddly for the children? He could do that, too. The former mercenary now earns an incredible earning doing what he loves - working with beasts.";
		this.m.BadEnding = "What\'s merely a beast to one man is a loyal companion to %name%. After leaving the company, the beastmaster went out to work for the nobility. Unfortunately, he refused to let hundreds of his beasts be used as a battle vanguard to be thrown away for some short-lived tactical advantage. He was hanged for his \'traitorous ideals\'.";
		this.m.HiringCost = 90;
		this.m.DailyCost = 30;
		this.m.Excluded = [
		"trait.fear_beasts",
		"trait.hate_beasts",
		"trait.craven",
		"trait.dastard",
		"trait.night_blind",
		"trait.fainthearted",
		"trait.weasel",
		"trait.insecure",
		"trait.ailing",
		"trait.bleeder",
		"trait.tiny",
		"trait.fragile",
		"trait.frail",
		"trait.asthmatic",
		"trait.clubfooted",
		"trait.clumsy",
		"trait.hesitant",
		"trait.slack",
		"trait.superstitious",
		"trait.cocky",
		"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Beastmaster",
			"the Tamer",
			"the Creature Keeper",
			"the Monster Manager",
			"the Menagerie Maestro"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BackgroundType = this.Const.BackgroundType.Combat | this.Const.BackgroundType.Druid | this.Const.BackgroundType.Ranger;
		this.m.Level = this.Math.rand(1, 3);
		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Merciless;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.Good;
		this.m.Modifiers.Hunting = this.Const.LegendMod.ResourceModifiers.Hunting[3];
		this.m.Modifiers.Scout = this.Const.LegendMod.ResourceModifiers.Scout[3];
		this.m.Modifiers.Gathering = this.Const.LegendMod.ResourceModifiers.Gather[2];
		this.m.Modifiers.Training = this.Const.LegendMod.ResourceModifiers.Training[2];
		this.m.PerkTreeDynamic = {
			Weapon = [
				this.Const.Perks.StavesTree,
				this.Const.Perks.ThrowingTree,
				this.Const.Perks.CleaverTree,
				this.Const.Perks.MaceTree,
				this.Const.Perks.PolearmTree
			],
			Defense = [
			    this.Const.Perks.LightArmorTree,
				this.Const.Perks.MediumArmorTree
			],
			Traits = [
				this.Const.Perks.ViciousTree,
				this.Const.Perks.FastTree,
				this.Const.Perks.TrainedTree,
				this.Const.Perks.OrganisedTree,
				this.Const.Perks.SturdyTree,
				this.Const.Perks.IndestructibleTree
			],
			Enemy = [],
			Class = [
				this.Const.Perks.HoundmasterClassTree,
				this.Const.Perks.BeastClassTree
			],
			Magic = []
		};
	}

	function setGender( _gender = -1 )
	{
		local r = _gender;

		if (_gender == -1)
		{
			r = 0;

			if (this.LegendsMod.Configs().LegendGenderEnabled())
			{
				r = this.Math.rand(0, 1);
			}
		}

		if (r != 1)
		{
			return;
		}

		this.m.Faces = this.Const.Faces.AllFemale;
		this.m.Hairs = this.Const.Hair.AllFemale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		this.m.Bodies = this.Const.Bodies.FemaleSkinny;
		this.m.IsFemaleBackground = true;
		this.m.GoodEnding = "Beasts were not simply \'beasts\' to %name%, despite her title as \'beastmaster.\' To her, they were the most loyal friends of her life. After leaving the company, he discovered san ingenious way to breed the animals specifically tailored to the desires of the nobility. Wanted a brutish beast for a guard? She could do it. Wanted something small and cuddly for the children? She could do that, too. The former mercenary now earns an incredible earning doing what she loves - working with beasts.";
        this.m.BadEnding = "What\'s merely a beast to some folks is a loyal companion to %name%. After leaving the company, the beastmaster went out to work for the nobility. Unfortunately, she refused to let hundreds of her beasts be used as a battle vanguard to be thrown away for some short-lived tactical advantage. She was hanged for her \'traitorous ideals\'.";
    }
	function getTooltip()
	{
		return [
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
				text = "Beasts unleashed by this character will start at confident morale. Beasts handled by this character gain more experience. Higher chance of success when taming beasts."
			}
		];
	}

	function onBuildDescription()
	{
		if (this.m.IsFemaleBackground == true)
		{
			return "{{%name%\'s affection for beasts started after her father won a serpent in a shooting contest. | When a direwolf saved her from a bear, %name% dedicated her life to beasts of all sorts. | Seeing a webknecht stave off a would-be robber, %name%\'s fondness for beasts only grew. | A young, bird-hunting %name% quickly saw the honor, loyalty, and workmanship of a trained beast. | Once bitten by a wild hyena, %name% confronted her fear of beasts by learning to train them.} {The beastmaster spent many years working for a local lord. She gave up the post after the liege struck one of her post-ferals down just for sport. | Quick with training the wildlife, the beastmaster put her post-ferals into a lucrative traveling tradeshow. | The woman made a great deal of money on the beast-fighting circuits, her post-ferals renowned for their easily commanded - and unleashed - ferocity. | Employed by lawmen, the beastmaster used her strong-nosed post-ferals to hunt down many a criminal element. | Used by a local lord, many of the beastmaster\'s post-ferals found their way onto the battlefield. | For many years, the beastmaster used her post-ferals to help lift the spirits of orphaned children and the crippled.} {Now, though, %name% seeks a change of vocation. | When she heard word of a mercenary\'s pay, %name% decided to try her hand at being a sellsword. | Approached by a sellsword to buy one of her creatures, %name% became more interested in the prospect of she, herself, becoming a mercenary. | Tired of training creatures for this purpose or that, %name% seeks to train herself for... well, this purpose or that. | An interesting prospect, you can only hope %name% is as loyal as the creatures she once commanded.}";
		}
		else
		{
			return "{%name%\'s affection for beasts started after his father won a serpent in a shooting contest. | When a direwolf saved him from a bear, %name% dedicated his life to beasts of all sorts. | Seeing a webknecht stave off a would-be robber, %name%\'s fondness for beasts only grew. | A young, bird-hunting %name% quickly saw the honor, loyalty, and workmanship of a trained beast. | Once bitten by a wild hyena, %name% confronted his fear of beasts by learning to train them.} {The beastmaster spent many years working for a local lord. He gave up the post after the liege struck one of his post-ferals down just for sport. | Quick with training the wildlife, the beastmaster put his post-ferals into a lucrative traveling tradeshow. | The man made a great deal of money on the beast-fighting circuits, his post-ferals renowned for their easily commanded - and unleashed - ferocity. | Employed by lawmen, the beastmaster used his strong-nosed post-ferals to hunt down many a criminal element. | Used by a local lord, many of the beastmaster\'s post-ferals found their way onto the battlefield. | For many years, the beastmaster used his post-ferals to help lift the spirits of orphaned children and the crippled.} {Now, though, %name% seeks a change of vocation. | When he heard word of a mercenary\'s pay, %name% decided to try his hand at being a sellsword. | Approached by a sellsword to buy one of his creatures, %name% became more interested in the prospect of he, himself, becoming a mercenary. | Tired of training creatures for this purpose or that, %name% seeks to train himself for... well, this purpose or that. | An interesting prospect, you can only hope %name% is as loyal as the creatures he once commanded.}";
       }
     }

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				5
			],
			Bravery = [
				10,
				10
			],
			Stamina = [
				10,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				6,
				6
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				10,
				5
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.LegendsMod.Configs().LegendTherianthropyEnabled())
		{
			if (this.Math.rand(1, 50) == 1)
			{
				this.getContainer().add(this.new("scripts/skills/injury_permanent/legend_lycanthropy_injury"));
			}
		}
	}

	function onAddEquipment()
	{

		local items = this.getContainer().getActor().getItems();


		if (items.hasEmptySlot(this.Const.ItemSlot.Accessory))
		{
		local r;

		r = this.Math.rand(1, 100);

if (r <= 44) //1
{
    items.equip(this.new("scripts/items/accessory/armored_warhound_item"));
}
else if (r <= 89) //2
{
    items.equip(this.new("scripts/items/accessory/armored_wardog_item"));
}
else if (r <= 92) //3
{
    items.equip(this.new("scripts/items/accessory/wolf_item"));
}
else if (r <= 97) //4
{
    local newCompanion5 = this.new("scripts/items/accessory/wardog_item");
    newCompanion5.setType(this.Const.Companions.TypeList.Spider);
    items.equip(newCompanion5);
}
else if (r == 98) //5
{     
    local newCompanion3 = this.new("scripts/items/accessory/wardog_item");
    newCompanion3.setType(this.Const.Companions.TypeList.Hyena);
    items.equip(newCompanion3);
}
else if (r == 99) //6
{
    local newCompanion1 = this.new("scripts/items/accessory/wardog_item");
    newCompanion1.setType(this.Const.Companions.TypeList.Direwolf);
    items.equip(newCompanion1);
}
else if (r == 100) //6
{
   local newCompanion6 = this.new("scripts/items/accessory/wardog_item");
   newCompanion6.setType(this.Const.Companions.TypeList.Snake);
   items.equip(newCompanion6);
}
        }
		if (items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/legend_glaive",
				"weapons/oriental/heavy_southern_mace",
				"weapons/oriental/light_southern_mace",
				"weapons/oriental/polemace",
				"weapons/goedendag",
				"weapons/fighting_spear",
				"weapons/billhook",
				"weapons/spetum",
				"weapons/pike",
				"weapons/battle_whip",
				"weapons/battle_whip",
				"weapons/fighting_spear",
				"weapons/two_handed_mace"
			];

			if (this.Const.DLC.Wildmen)
			{
				weapons.extend([
					"weapons/barbarians/two_handed_spiked_mace",
					"weapons/barbarians/thorned_whip",
					"weapons/barbarians/antler_cleaver"
				]);
			}

			items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(this.Const.ItemSlot.Offhand))
		{
			local offhand = [
				"tools/throwing_net",
				"tools/reinforced_throwing_net"
			];
			items.equip(this.new("scripts/items/" + offhand[this.Math.rand(0, offhand.len() - 1)]));
		}
		items.equip(this.Const.World.Common.pickArmor([
			[
				1,
				"gambeson",
			],
			[
				1,
				"leather_tunic",
			],
			[
				1,
				"barbarians/thick_furs_armor",
			],
			[
				1,
				"barbarians/reinforced_animal_hide_armor",
			],
			[
				1,
				"barbarians/hide_and_bone_armor",
			],
			[
				1,
				"oriental/padded_vest",
			],
			[
				1,
				"oriental/southern_mail_shirt",
			],
			[
				1,
				"oriental/thick_nomad_robe",
			],
			[
				1,
				"light_scale_armor",
			],
			[
				1,
				"mail_shirt"
			],
		]));
		items.equip(this.Const.World.Common.pickHelmet([
			[
				1,
				"barbarians/beastmasters_headpiece",
			],
			[
				1,
				"barbarians/beastmasters_headpiece",
			],
			[
				1,
				"barbarians/bear_headpiece",
			],
			[
				1,
				"dented_nasal_helmet",
			],
            [
				1,
				"dark_cowl",
			],
			[
				1,
				"full_aketon_cap",
			],
			[
				1,
				"mail_coif",
			],
			[
				1,
				"nordic_helmet"
			]

		]));
	}

});
