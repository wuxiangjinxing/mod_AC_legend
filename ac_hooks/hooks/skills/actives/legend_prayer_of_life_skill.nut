::modAccessoryCompanions.HooksMod.hook("scripts/skills/actives/legend_prayer_of_life_skill", function( q )
{
	q.onUse = @(__original) function(_user, _targetTile)
	{
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getAllInstancesAsArray();
	
		foreach( a in actors )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}
	
			if (myTile.getDistanceTo(a.getTile()) > 1)
			{
				continue;
			}
	
			if (a.isAlliedWith(_user) && ::MSU.isKindOf(a, "player") && !::MSU.isNull(a.getBackground()))
			{
				if (!a.getBackground().isBackgroundType(this.Const.BackgroundType.ConvertedCultist) && !a.getSkills().hasSkill("effects.legend_prayer_of_life"))
				{
					local effect = this.new("scripts/skills/effects/legend_prayer_of_life_effect");
					effect.m.Resolve = this.getContainer().getActor().getBravery();
					a.getSkills().add(effect);
				}
			}
	
			local skills = a.getSkills();
	
			//if (skills.hasSkill("racial.skeleton") || skills.hasSkill("actives.zombie_bite") || skills.hasSkill("racial.vampire") || skills.hasSkill("racial.ghost"))
			if (!skills.hasSkill("effects.disintegrating") && a.getFlags().has("undead"))
			{
				if (!skills.hasSkill("effects.disintegrating"))
				{
					skills.add(this.new("scripts/skills/effects/disintegrating_effect"));
				}
			}
		}
	
		return true;
	}
});