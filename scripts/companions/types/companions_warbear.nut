this.companions_warbear <- this.inherit("scripts/entity/tactical/legend_warbear", {
	m = {
		Item = null,
		Name = "Bear"
	},
	function onActorKilled( _actor, _tile, _skill )
	{
		this.legend_warbear.onActorKilled(_actor, _tile, _skill);

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
					{
						acc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
					}
				}
			}
		}
	}

	function isGuest()
	{
		return true;
	}

	function setVariant( _v )
	{
	}

	function applyCompanionScaling()
	{
		local propertiesNew = {
			ActionPoints = 9,
			Hitpoints = this.m.Item.m.Attributes.Hitpoints,
			Stamina = this.m.Item.m.Attributes.Stamina,
			Bravery = this.m.Item.m.Attributes.Bravery,
			Initiative = this.m.Item.m.Attributes.Initiative,
			MeleeSkill = this.m.Item.m.Attributes.MeleeSkill,
			RangedSkill = this.m.Item.m.Attributes.RangedSkill,
			MeleeDefense = this.m.Item.m.Attributes.MeleeDefense,
			RangedDefense = this.m.Item.m.Attributes.RangedDefense,
			Armor = [
				50,
				50
			],
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			FatigueRecoveryRate = 30
		};
		local propertiesBase = this.m.BaseProperties;
		propertiesBase.setValues(propertiesNew);
		this.m.CurrentProperties = propertiesBase;
		this.m.Hitpoints = propertiesBase.Hitpoints;

		foreach( quirk in this.m.Item.m.Quirks )
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

