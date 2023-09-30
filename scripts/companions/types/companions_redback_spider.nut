this.companions_redback_spider <- this.inherit("scripts/entity/tactical/enemies/legend_redback_spider", {
	m = {
		Size = 1.0,
		DistortTargetA = null,
		DistortTargetPrevA = this.createVec(0, 0),
		DistortTargetB = null,
		DistortTargetPrevB = this.createVec(0, 0),
		DistortTargetC = null,
		DistortTargetPrevC = this.createVec(0, 0),
		DistortAnimationStartTimeA = 0,
		IsFlipping = false,
		Item = null,
		Name = "Redback Spider"
	},
	function create()
	{
		this.legend_redback_spider.create();
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
		this.getSprite("body").setBrush("bust_spider_redback_body_0" + _v);
		this.getSprite("head").setBrush("bust_spider_redback_head_01");
		this.setDirty(true);
		this.setSize(this.Math.rand(70, 90) * 0.01);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.legend_redback_spider.onDeath(_killer, _skill, _tile, _fatalityType);
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
		this.legend_redback_spider.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("legs_front").setHorizontalFlipping(flip);
		this.getSprite("legs_back").setHorizontalFlipping(flip);
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
		this.legend_redback_spider.onActorKilled(_actor, _tile, _skill);

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
		this.legend_redback_spider.onInit();
		//this.addSprite("socket").setBrush("bust_base_player");
	}

	function applyCompanionScaling()
	{
		local propertiesNew =
		{
			ActionPoints = 16,
			Hitpoints = this.m.Item.m.Attributes.Hitpoints,
			Stamina = this.m.Item.m.Attributes.Stamina,
			Bravery = this.m.Item.m.Attributes.Bravery,
			Initiative = this.m.Item.m.Attributes.Initiative,
			MeleeSkill = this.m.Item.m.Attributes.MeleeSkill,
			RangedSkill = this.m.Item.m.Attributes.RangedSkill,
			MeleeDefense = this.m.Item.m.Attributes.MeleeDefense,
			RangedDefense = this.m.Item.m.Attributes.RangedDefense,
			Armor = [240, 240],
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			FatigueRecoveryRate = 20
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
