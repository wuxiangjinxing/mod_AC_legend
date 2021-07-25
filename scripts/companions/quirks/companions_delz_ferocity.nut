this.companions_delz_ferocity <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "quirk.delz.ferocity";
		this.m.Name = "Ferocity";
		this.m.Description =  "This entity has an unusually ferocious streak.";
		this.m.Icon = "ui/perks/perk_16.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
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
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.ThresholdToInflictInjuryMult *= 0.90;
		_properties.MeleeSkill += 5;
		_properties.Initiative += 5;
		_properties.Bravery += 10;
		_properties.IsAffectedByFleeingAllies = false;
		_properties.IsAffectedByDyingAllies = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		if (!_targetEntity.m.BaseProperties.IsAffectedByInjuries)
		{
			_properties.DamageTotalMult *= 1.05;
		}
	}

});

