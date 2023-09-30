this.companions_noodle <- this.inherit("scripts/entity/tactical/enemies/lindwurm", {
	m = {
		Tail = null,
		Item = null,
		Name = "Lindwurm"
	},

	function create()
	{
		this.lindwurm.create();
		this.m.IsActingImmediately = true;
		this.m.ConfidentMoraleBrush = "icon_confident";
	}
	
	function isGuest()
	{
		return true;
	}
	
	function setItem( _i )
	{
		if (typeof _i == "instance")
		{
			this.m.Item = _i;
		}
		else
		{
			this.m.Item = this.WeakTableRef(_i);
		}
	}

	function setName( _n )
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
		this.lindwurm.onDeath(_killer, _skill, _tile, _fatalityType);
		if (this.m.Item != null && !this.m.Item.isNull())
		{
			this.m.Item.setEntity(null);

			if (this.m.Item.getContainer() != null)
			{
				if (this.m.Item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
				{
					this.m.Item.getContainer().removeFromBag(this.m.Item.get());
				}
				else
				{
					this.m.Item.getContainer().unequip(this.m.Item.get());
				}
			}

			this.m.Item = null;
		}
	}

	function onFactionChanged()
	{
		this.lindwurm.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("body_blood").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);

		if (!this.Tactical.State.isScenarioMode())
		{
			local f = this.World.FactionManager.getFaction(this.getFaction());

			if (f != null)
			{
				this.getSprite("socket").setBrush(f.getTacticalBase());
			}
		}
		else
		{
			this.getSprite("socket").setBrush(this.Const.FactionBase[this.getFaction()]);
		}
	}

	function onActorKilled(_actor, _tile, _skill)
	{
		this.lindwurm.onActorKilled(_actor, _tile, _skill);

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

	function onInit()
	{
		this.lindwurm.onInit();
		if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		{
			this.m.Tail.die();
			this.m.Tail = null;
		}
		if (this.m.Tail == null)
		{
			local myTile = this.getTile();
			local spawnTile;

			if (myTile.hasNextTile(this.Const.Direction.NE) && myTile.getNextTile(this.Const.Direction.NE).IsEmpty)
			{
				spawnTile = myTile.getNextTile(this.Const.Direction.NE);
			}
			else if (myTile.hasNextTile(this.Const.Direction.SE) && myTile.getNextTile(this.Const.Direction.SE).IsEmpty)
			{
				spawnTile = myTile.getNextTile(this.Const.Direction.SE);
			}
			else if (myTile.hasNextTile(this.Const.Direction.N) && myTile.getNextTile(this.Const.Direction.N).IsEmpty)
			{
				spawnTile = myTile.getNextTile(this.Const.Direction.N);
			}
			else if (myTile.hasNextTile(this.Const.Direction.S) && myTile.getNextTile(this.Const.Direction.S).IsEmpty)
			{
				spawnTile = myTile.getNextTile(this.Const.Direction.S);
			}
			else if (myTile.hasNextTile(this.Const.Direction.NW) && myTile.getNextTile(this.Const.Direction.NW).IsEmpty)
			{
				spawnTile = myTile.getNextTile(this.Const.Direction.NW);
			}
			else if (myTile.hasNextTile(this.Const.Direction.SW) && myTile.getNextTile(this.Const.Direction.SW).IsEmpty)
			{
				spawnTile = myTile.getNextTile(this.Const.Direction.SW);
			}

			if (spawnTile != null)
			{
				this.m.Tail = this.WeakTableRef(this.Tactical.spawnEntity("scripts/companions/types/companions_noodle_tail", spawnTile.Coords.X, spawnTile.Coords.Y, this.getID()));
				this.m.Tail.m.Body = this.WeakTableRef(this);
				//this.m.Tail.getSprite("body").Color = body.Color;
				//this.m.Tail.getSprite("body").Saturation = body.Saturation;
			}
		}		
		//this.addSprite("socket").setBrush("bust_base_player");
	}

	function applyCompanionScaling()
	{
		local propertiesNew =
		{
			ActionPoints = 7,
			Hitpoints = this.m.Item.m.Attributes.Hitpoints,
			Stamina = this.m.Item.m.Attributes.Stamina,
			Bravery = this.m.Item.m.Attributes.Bravery,
			Initiative = this.m.Item.m.Attributes.Initiative,
			MeleeSkill = this.m.Item.m.Attributes.MeleeSkill,
			RangedSkill = this.m.Item.m.Attributes.RangedSkill,
			MeleeDefense = this.m.Item.m.Attributes.MeleeDefense,
			RangedDefense = this.m.Item.m.Attributes.RangedDefense,
			Armor = [400, 200],
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			FatigueRecoveryRate = 30
		};
		local propertiesBase = this.m.BaseProperties;
		propertiesBase.setValues(propertiesNew);
		this.m.CurrentProperties = propertiesBase;
		this.m.Hitpoints = propertiesBase.Hitpoints;


		foreach(quirk in this.m.Item.m.Quirks)
		{
			local perk = this.new(quirk);
			if ("IsForceEnabled" in perk.m)
			{
				perk.m.IsForceEnabled = true;
			}
			this.m.Skills.add(perk);
		}


		if (this.m.Tail != null)
		{
			this.m.Tail.setItem(this.m.Item);
			this.m.Tail.applyCompanionScaling();
		}
	}
});
