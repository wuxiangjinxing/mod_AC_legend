::modAccessoryCompanions.HooksMod.hook("scripts/skills/actives/legend_drums_of_life_skill", function( q )
{
	q.onUse = @(__original) function(_user, _targetTile)
	{
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());
	
		foreach( a in actors )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}
	
			if (myTile.getDistanceTo(a.getTile()) > 8)
			{
				continue;
			}
	
			if (a.isAlliedWith(_user))
			{
				a.getSkills().add(this.new("scripts/skills/effects/legend_drums_of_life_effect"));
			}
		}
	
		this.getContainer().add(this.new("scripts/skills/effects/legend_drums_of_life_effect"));
		return true;
	}
});