this.companions_nacho <- this.inherit("scripts/entity/tactical/enemies/ghoul", {
	m = {
		Item = null,
		Name = "Nachzehrer",
		Size = 1,
		Head = 1,
		ScaleStartTime = 0
	},

	function create()
	{
		this.ghoul.create();
		this.m.IsActingImmediately = true;
		this.m.ConfidentMoraleBrush = "icon_confident";
	}

	function setItem(_i)
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
		this.m.Head = _v;
		this.m.Size = this.m.Item.m.Level >= 7 ? 3 : this.m.Item.m.Level >= 4 ? 2 : 1;
		if (this.m.Size == 1)
		{
			this.getSprite("body").setBrush("bust_ghoul_body_01");
			this.getSprite("head").setBrush("bust_ghoul_head_01");
			this.getSprite("status_rooted").Scale = 0.45;
			this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
		}
		else
		{
			this.getSprite("body").setBrush("bust_ghoul_body_0" + this.m.Size);
			this.getSprite("head").setBrush("bust_ghoul_0" + this.m.Size + "_head_0" + this.m.Head);
			this.getSprite("injury").setBrush("bust_ghoul_0" + this.m.Size + "_injured");
			this.getSprite("status_rooted").Scale = 0.5;
			this.getSprite("status_rooted_back").Scale = 0.5;
			this.setSpriteOffset("status_rooted", this.createVec(-4, 10));
			this.setSpriteOffset("status_rooted_back", this.createVec(-4, 10));
		}
		this.setDirty(true);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.ghoul.onDeath(_killer, _skill, _tile, _fatalityType);
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
		this.ghoul.onFactionChanged();
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
		this.ghoul.onActorKilled(_actor, _tile, _skill);

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
		this.ghoul.onInit();
		this.addSprite("socket").setBrush("bust_base_player");
	}

	function applyCompanionScaling()
	{
		local propertiesNew =
		{
			ActionPoints = 9,
			Hitpoints = this.m.Item.m.Attributes.Hitpoints,
			Stamina = this.m.Item.m.Attributes.Stamina,
			Bravery = this.m.Item.m.Attributes.Bravery,
			Initiative = this.m.Item.m.Attributes.Initiative,
			MeleeSkill = this.m.Item.m.Attributes.MeleeSkill,
			RangedSkill = this.m.Item.m.Attributes.RangedSkill,
			MeleeDefense = this.m.Item.m.Attributes.MeleeDefense,
			RangedDefense = this.m.Item.m.Attributes.RangedDefense,
			Armor = [0, 0],
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			FatigueRecoveryRate = 15
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
	}
});
