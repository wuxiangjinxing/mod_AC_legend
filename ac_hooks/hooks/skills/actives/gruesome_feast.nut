::modAccessoryCompanions.HooksMod.hook("scripts/skills/actives/gruesome_feast", function( q ) 
{
	// wardogs and warhounds retain their name, variant, level, XP, attributes and quirks after an armor upgrade
	q.create = @(__original) function()
	{
		__original();
		this.m.IsTargeted = true;
	}
	
	q.onVerifyTarget = @(__original) function(_originTile, _targetTile)
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (!_originTile.IsCorpseSpawned)
		{
			return false;
		}

		if (!_originTile.Properties.get("Corpse").IsConsumable)
		{
			return false;
		}

		return true;
	}
});