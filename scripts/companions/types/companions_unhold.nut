this.companions_unhold <- this.inherit("scripts/entity/tactical/enemies/unhold", {
	m = {
		Item = null,
		Name = "Unhold"
	},
	function create()
	{
		this.unhold.create();
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
		local var = _v;
		if (_v == 4) var = 2;
		if (_v == 5) var = 1;

		this.getSprite("body").setBrush("bust_unhold_body_0" + var);
		this.getSprite("head").setBrush("bust_unhold_head_0" + var);
		this.setDirty(true);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.unhold.onDeath(_killer, _skill, _tile, _fatalityType);
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
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("armor").setHorizontalFlipping(flip);
		this.getSprite("helmet").setHorizontalFlipping(flip);
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
		this.actor.onActorKilled(_actor, _tile, _skill);

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
		this.unhold.onInit();
		this.addSprite("socket").setBrush("bust_base_player");
	}
	
	function applyCompanionScaling()
	{
		local variantHitpoints = (this.m.Item.m.Variant == 1 || this.m.Item.m.Variant == 5) ? 100 : 0;
		local variantBravery = (this.m.Item.m.Variant == 1 || this.m.Item.m.Variant == 5) ? 20 : 0;
		local variantInitiative = (this.m.Item.m.Variant == 1 || this.m.Item.m.Variant == 5) ? 10 : 0;
		local variantMeleeSkill = (this.m.Item.m.Variant == 1 || this.m.Item.m.Variant == 5) ? 5 : 0;
		local variantRangedDefense = this.m.Item.m.Variant == 3 ? 5 : 0;
		local variantArmor = (this.m.Item.m.Variant == 1 || this.m.Item.m.Variant == 5) ? 90 : 0;
		local propertiesNew =
		{
			ActionPoints = 9,
			Hitpoints = variantHitpoints + this.m.Item.m.Attributes.Hitpoints,
			Stamina = this.m.Item.m.Attributes.Stamina,
			Bravery = variantBravery + this.m.Item.m.Attributes.Bravery,
			Initiative = variantInitiative + this.m.Item.m.Attributes.Initiative,
			MeleeSkill = variantMeleeSkill + this.m.Item.m.Attributes.MeleeSkill,
			RangedSkill = this.m.Item.m.Attributes.RangedSkill,
			MeleeDefense = this.m.Item.m.Attributes.MeleeDefense,
			RangedDefense = variantRangedDefense + this.m.Item.m.Attributes.RangedDefense,
			Armor = [variantArmor, variantArmor],
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
			this.m.Skills.add(this.new(quirk));
		}
		if ((this.m.Item.m.Variant == 1 || this.m.Item.m.Variant == 5) && !this.getSkills().hasSkill("perk.killing_frenzy"))
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_killing_frenzy"));
		}

		if (this.m.Item.m.Variant == 5)
		{
			this.m.Items.equip(this.new("scripts/items/armor/barbarians/unhold_armor_heavy"));
			this.m.Items.equip(this.new("scripts/items/helmets/barbarians/unhold_helmet_heavy"));
		}
		else if (this.m.Item.m.Variant == 4)
		{
			this.m.Items.equip(this.new("scripts/items/armor/barbarians/unhold_armor_light"));
			this.m.Items.equip(this.new("scripts/items/helmets/barbarians/unhold_helmet_light"));
		}
	}
});
