this.companions_basilisk_sentry <- this.inherit("scripts/entity/tactical/enemies/legend_basilisk_sentry", {
	m = {
		Item = null,
		Name = "Basilisk Sentry"
	},

	function create()
	{
		this.legend_basilisk_sentry.create();
		this.m.IsActingImmediately = true;
		this.m.ConfidentMoraleBrush = "icon_confident";
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
		this.legend_basilisk_sentry.onDeath(_killer, _skill, _tile, _fatalityType);
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
		this.legend_basilisk_sentry.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);

		if (!this.Tactical.State.isScenarioMode())
		{
			local f = this.World.FactionManager.getFaction(this.getFaction());

			if (f != null)
				this.getSprite("socket").setBrush(f.getTacticalBase());		}
		else
			this.getSprite("socket").setBrush(this.Const.FactionBase[this.getFaction()]);
	}

	function onActorKilled(_actor, _tile, _skill)
	{
		this.legend_basilisk_sentry.onActorKilled(_actor, _tile, _skill);

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
		this.legend_basilisk_sentry.onInit();
		//this.addSprite("socket").setBrush("bust_base_player");
	}
	
	function applyCompanionScaling()
	{
		local propertiesNew =
		{
			ActionPoints = 8,
			Hitpoints = this.m.Item.m.Attributes.Hitpoints,
			Stamina = this.m.Item.m.Attributes.Stamina,
			Bravery = this.m.Item.m.Attributes.Bravery,
			Initiative = this.m.Item.m.Attributes.Initiative,
			MeleeSkill = this.m.Item.m.Attributes.MeleeSkill,
			RangedSkill = this.m.Item.m.Attributes.RangedSkill,
			MeleeDefense = this.m.Item.m.Attributes.MeleeDefense,
			RangedDefense = this.m.Item.m.Attributes.RangedDefense,
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			FatigueRecoveryRate = 30,
			Armor = [
				120,
				75
			]
		};
		local propertiesBase = this.m.BaseProperties;
		propertiesBase.setValues(propertiesNew);
		this.m.CurrentProperties = propertiesBase;
		this.m.Hitpoints = propertiesBase.Hitpoints;

		if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) 
		{
			propertiesBase.MeleeDefense += 5;
			propertiesBase.RangedDefense += 5;
		}

		foreach(quirk in this.m.Item.m.Quirks)
		{
			local perk = this.new(quirk);
			if ("IsForceEnabled" in perk.m)
				perk.m.IsForceEnabled = true;
			this.m.Skills.add(perk);			
		}
	}

});