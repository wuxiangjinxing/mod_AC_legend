this.companions_delz_tenacity <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "quirk.delz_tenacity";
		this.m.Name = "Tenacity";
		this.m.Description = "This entity has an unusually tenacious streak.";
		this.m.Icon = "ui/traits/trait_icon_14.png";
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
		_properties.ThresholdToReceiveInjuryMult *= 1.30;
		_properties.RangedDefense += 5;
		_properties.MeleeDefense += 5;
		_properties.Hitpoints += 10;
		_properties.IsAffectedByLosingHitpoints = false;
	}
});
