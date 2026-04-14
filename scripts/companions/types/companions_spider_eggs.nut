this.companions_spider_eggs <- this.inherit("scripts/entity/tactical/enemies/spider_eggs", {
	m = {
		Item = null,
		Name = "Webknecht Eggs",
		MaxSpawnCount = 10
	},
	function create()
	{
		this.spider_eggs.create();
		this.m.IsActingImmediately = true;
	}

	function isGuest()
	{
		return true;
	}

	function setItem(_i)
	{
		if (typeof _i == "instance")
			this.m.Item = _i;
		else
			this.m.Item = this.WeakTableRef(_i);
	}

	function setName(_n)
	{
		this.m.Name = _n;
	}

	function getName()
	{
		return this.m.Name;
	}

	function setVariant(_v)
	{
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.spider_eggs.onDeath(_killer, _skill, _tile, _fatalityType);
		if (this.m.Item != null && !this.m.Item.isNull())
		{
			this.m.Item.setEntity(null);

			if (this.m.Item.getContainer() != null)
			{
				if (this.m.Item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
					this.m.Item.getContainer().removeFromBag(this.m.Item.get());
				else
					this.m.Item.getContainer().unequip(this.m.Item.get());
			}

			this.m.Item = null;
		}
	}

	function onFactionChanged()
	{
		this.spider_eggs.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);

		if (!this.Tactical.State.isScenarioMode())
		{
			local f = this.World.FactionManager.getFaction(this.getFaction());

			if (f != null)
				this.getSprite("socket").setBrush(f.getTacticalBase());
		}
		else
			this.getSprite("socket").setBrush(this.Const.FactionBase[this.getFaction()]);
	}

	function onActorKilled(_actor, _tile, _skill)
	{
		this.spider_eggs.onActorKilled(_actor, _tile, _skill);

		if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local XPgroup = _actor.getXPValue();
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

			foreach( bro in brothers )
			{
				bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));

				local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
				if (acc != null && "setType" in acc)
					if (acc.getType() != null)
						acc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
			}
		}
	}

	function onInit()
	{
		this.spider_eggs.onInit();
	}

	function applyCompanionScaling()
	{
		local propertiesNew =
		{
			ActionPoints = 11,
			Hitpoints = this.m.Item.m.Attributes.Hitpoints,
			Stamina = this.m.Item.m.Attributes.Stamina,
			Bravery = this.m.Item.m.Attributes.Bravery,
			Initiative = this.m.Item.m.Attributes.Initiative,
			MeleeSkill = this.m.Item.m.Attributes.MeleeSkill,
			RangedSkill = this.m.Item.m.Attributes.RangedSkill,
			MeleeDefense = this.m.Item.m.Attributes.MeleeDefense,
			RangedDefense = this.m.Item.m.Attributes.RangedDefense,
			Armor = [20, 20],
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			FatigueRecoveryRate = 20
		};
		local propertiesBase = this.m.BaseProperties;
		propertiesBase.setValues(propertiesNew);
		this.m.CurrentProperties = propertiesBase;
		this.m.Hitpoints = propertiesBase.Hitpoints;
	}

	function registerSpawnEvent()
	{
		this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, this.onSpawn.bindenv(this), this.getTile());
	}

	function onSpawn( _tile )
	{
		if (_tile.IsEmpty)
			return;

		if (!_tile.IsOccupiedByActor || _tile.getEntity().getType() != this.Const.EntityType.SpiderEggs || ::Tactical.TurnSequenceBar.getCurrentRound() < 1 + this.getSpawnDelay())
			return;

		if (this.Tactical.Entities.isEnemyRetreating())
			return;

		local tile;

		for( local i = 0; i < 6; i = i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = _tile.getNextTile(i);

				if (!nextTile.IsEmpty || this.Math.abs(nextTile.Level - _tile.Level) > 1)
				{
				}
				else
				{
					tile = nextTile;
					break;
				}
			}

			i = ++i;
		}

		if (this.m.Count < this.getMaxSpawnCount())
		{
			if (tile != null)
			{
				local spawn = this.Tactical.spawnEntity("scripts/companions/types/companions_spider_hatchling", tile.Coords);
				spawn.setSize(this.Math.rand(60, 75) * 0.01);
				spawn.setFaction(this.getFaction());
				spawn.m.XP = spawn.m.XP / 2;
				spawn.m.ParentEggs = this;

				foreach(quirk in this.m.Item.m.Quirks)
				{
					local perk = this.new(quirk);
					if ("IsForceEnabled" in perk.m)
						perk.m.IsForceEnabled = true;
					spawn.m.Skills.add(perk);
				}

				++this.m.Count;
				this.registerSpawnEvent();
			}
		}
	}

});