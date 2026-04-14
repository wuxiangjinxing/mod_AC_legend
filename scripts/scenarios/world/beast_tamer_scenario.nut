this.beast_tamer_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.beast_tamers";
		this.m.Name = "Beast Tamers";
		this.m.Description = "[p=c][img]gfx/ui/events/event_102.png[/img][/p][p]Where others see monsters to slay, you see potential allies—loyal, lethal, and fierce. It's perilous work, but few can match the bond between man and beast, and fewer still dare stand in your path.\n\n[color=#bcad8c]Furry Friends:[/color] Start with a band of Beast Tamers and their companions, as well as a chance to find others that support your cause.\n[color=#bcad8c]Wild Living:[/color] See tracks and enemies from further away.\n[color=#bcad8c]Professional Tamers:[/color] Double your chance to tame beasts and each new recruit gains [color=#008060]Dog Whisperer[/color].\n[color=#bcad8c]Prejudice:[/color] Most people do not trust your kind, get 10% worse prices.[/p]";
		this.m.Difficulty = 2;
		this.m.Order = 44;
		this.m.IsFixedLook = true;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 3; i++ )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.improveMood(1.0, "Glad to still be alive");
			bro.worsenMood(1.5, "Lost most of your friends due to the raid");

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();


		bros[0].setStartValuesEx([
			"houndmaster_background"
		]);
		bros[0].getBackground().m.RawDescription = "%name% saved you in the terrible ambush that destroyed your home. The Houndmaster does not hang this fact over you, for you have saved %name% many a times yourself. This lover of beasts suffers no emotion that does not bid well in this world, and that alone makes for a sound mercenary.";
		bros[0].setPlaceInFormation(13);
		bros[0].setVeteranPerks(2);
		bros[0].addInjury(this.Const.Injury.Brawl);
 		bros[0].getSprite("socket").setBrush("bust_base_beasthunters");
		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Initiative] = 2;
		talents[this.Const.Attributes.RangedSkill] = 2;
		talents[this.Const.Attributes.RangedDefense] = 2;
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items.equip(this.new("scripts/items/weapons/crossbow"));
		items.equip(this.new("scripts/items/ammo/legend_armor_piercing_bolts"));

		bros[1].setStartValuesEx([
			"beast_tamer_background"
		]);
		bros[1].getBackground().m.RawDescription = "A young whelp from the city, %name% got a start in beast taming by rooting out the warrens of \'vicious rabbits\', as one puts it. You are not sure how true that is, but regardless %name% has demonstrated greats feats of arms on the battlefield more times than you can count.";
		bros[1].setPlaceInFormation(3);
		bros[1].setVeteranPerks(2);
		bros[1].addLightInjury();
 		bros[1].getSprite("socket").setBrush("bust_base_beasthunters");
		bros[1].m.Talents = [];
		local talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Fatigue] = 2;
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.MeleeDefense] = 2;
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/hand_axe"));

		bros[2].setStartValuesEx([
			"beast_tamer_background"
		]);
		bros[2].getBackground().m.RawDescription = "Grizzled vets are a rarity in the taming business, and %name% sure ain\'t one. Instead, the \'tamer\' started the foray into monster kinship by reading books instead of training the sword. Still a good enough warrior at heart, it is the study and preparation that gives %name% the edge in battle.";
		bros[2].setPlaceInFormation(5);
		bros[2].setVeteranPerks(2);
		bros[2].addLightInjury();
 		bros[2].getSprite("socket").setBrush("bust_base_beasthunters");
		bros[2].m.Talents = [];
		local talents = bros[2].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Hitpoints] = 2;
		talents[this.Const.Attributes.MeleeDefense] = 2;
		talents[this.Const.Attributes.RangedDefense] = 2;
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/morning_star"));

		foreach( bro in bros )
		{
			bro.m.PerkPoints = 1;
			bro.m.LevelUps = 1;
			bro.m.Level = 2;
		}

		this.World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);
		this.World.Flags.set("HasLegendCampHunting", true);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/bread_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/tools/reinforced_throwing_net"));
		this.World.Assets.getStash().add(this.new("scripts/items/tools/reinforced_throwing_net"));
		this.World.Assets.m.Money = this.Math.round(this.World.Assets.m.Money * 0.75);
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() == 1)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		this.World.Flags.set("HomeVillage", randomVillage.getName());
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else if (tile.Type != this.Const.World.TerrainType.Plains && tile.Type != this.Const.World.TerrainType.Steppe && tile.Type != this.Const.World.TerrainType.Tundra && tile.Type != this.Const.World.TerrainType.Snow)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(11);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		randomVillage.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(-100.0, "Something about skibidi toilet, idk");
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/retirement_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.beast_tamer_intro");
		}, null);
	}

	function onInit()
	{
		this.starting_scenario.onInit();
		this.World.Assets.m.BuyPriceMult = 1.1;
		this.World.Assets.m.SellPriceMult = 0.9;
		this.World.Assets.m.FootprintVision = 1.5;
	}

	function onGenerateBro(bro)
	{
		if (bro.getBackground().getID() == "background.beast_tamer")
		{
			bro.m.HiringCost = this.Math.floor(bro.m.HiringCost * 0.8);
			bro.getBaseProperties().DailyWageMult *= 0.8;
			bro.getSprite("socket").setBrush("bust_base_beasthunters");
			bro.improveMood(1.5, "Loves beasts as much as you do");
		}
		else if (bro.getBackground().getID() == "background.houndmaster" || bro.getBackground().getID() == "background.legend_muladi")
		{
			bro.m.HiringCost = this.Math.floor(bro.m.HiringCost * 0.9);
			bro.getBaseProperties().DailyWageMult *= 0.9;
			bro.getSprite("socket").setBrush("bust_base_beasthunters");
			bro.improveMood(1.5, "Excited to learn your ways");
		}
		else if (bro.getSkills().getSkillByID("trait.fear_beasts"))
		{
			bro.m.HiringCost = this.Math.floor(bro.m.HiringCost * 2.0);
			bro.getBaseProperties().DailyWageMult *= 1.5;
			bro.worsenMood(1.5, "Is terrified for their life");
		}
		else if (bro.getSkills().getSkillByID("trait.hate_beasts"))
		{
			bro.m.HiringCost = this.Math.floor(bro.m.HiringCost * 2.0);
			bro.getBaseProperties().DailyWageMult *= 1.5;
			bro.worsenMood(1.5, "Hates beasts and those that associate with them");
		}

		bro.getSkills().update();
	}

	function onBuildPerkTree( _background )
	{
		this.addScenarioPerk(_background, this.Const.Perks.PerkDefs.LegendDogWhisperer);
	}

	function onUpdateHiringRoster( _roster )
	{
		this.addBroToRoster(_roster, "beast_tamer_background", 6);
		this.addBroToRoster(_roster, "houndmaster_background", 8);
	}

});