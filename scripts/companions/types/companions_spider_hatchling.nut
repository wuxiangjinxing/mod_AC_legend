this.companions_spider_hatchling <- this.inherit("scripts/companions/types/companions_spider", {
	m = {
		Name = "Webknecht Hatchling",
		ParentEggs = null
	},
	function create()
	{
		this.spider.create();
		this.m.IsActingImmediately = true;
		this.m.ConfidentMoraleBrush = "icon_confident";
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.spider.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onActorKilled(_actor, _tile, _skill)
	{
		this.spider.onActorKilled(_actor, _tile, _skill);

		if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local XPgroup = _actor.getXPValue();

			local parentEggs = this.m.ParentEggs;
			if (parentEggs != null)
				parentEggs.addXP(this.Math.max(1, this.Math.floor(XPgroup)));

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

	function applyCompanionScaling()
	{
		local parentEggs = this.m.ParentEggs;
		local propertiesNew =
		{
			ActionPoints = 11,
			Hitpoints = parentEggs.m.CurrentProperties.Hitpoints,
			Stamina = parentEggs.m.CurrentProperties.Stamina,
			Bravery = parentEggs.m.CurrentProperties.Bravery,
			Initiative = parentEggs.m.CurrentProperties.Initiative,
			MeleeSkill = parentEggs.m.CurrentProperties.MeleeSkill,
			RangedSkill = parentEggs.m.CurrentProperties.RangedSkill,
			MeleeDefense = parentEggs.m.CurrentProperties.MeleeDefense,
			RangedDefense = parentEggs.m.CurrentProperties.RangedDefense,
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

});