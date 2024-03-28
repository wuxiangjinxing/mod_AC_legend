::modAccessoryCompanions.HooksMod.hook("scripts/skills/actives/nightmare_skill", function( q ) 
{
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Infuses a terrible nightmare that can damage the mind of your target.";
		this.m.Icon = "skills/active_117.png";
		this.m.IconDisabled = "skills/active_117_sw.png";
		this.m.Overlay = "active_117";
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 4;
	}
	
	q.getTooltip = @(__original) function()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Damage is reduced by target\'s [color=" + ::Const.UI.Color.NegativeValue + "]Resolve[/color]"
			}
		]);
		
		return ret;
	}
	
	q.isUsable = @(__original) function()
	{
		if (this.getContainer().getActor().isPlayerControlled())
		{
			return this.skill.isUsable();
		}
	
		return __original();
	}
	
	q.onVerifyTarget = @(__original) function(_originTile, _targetTile)
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		
		return _targetTile.getEntity().getSkills().getSkillByID("effects.sleeping") != null;
	}
});