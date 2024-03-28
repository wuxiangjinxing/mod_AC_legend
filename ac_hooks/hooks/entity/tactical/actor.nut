::modAccessoryCompanions.HooksMod.hook("scripts/entity/tactical/actor", function( q ) 
{
	q.m.ActorFactionForAC <- 0;
	
	q.getActorFactionForAC <- @(__original) function()
	{
		return this.m.ActorFactionForAC
	}
	
	q.onDeath = @(__original) function(_killer, _skill, _tile, _fatalityType)
	{
		this.m.ActorFactionForAC = this.getFaction();
		__original( _killer, _skill, _tile, _fatalityType );
	}
	
	q.isPlayerControlled = @(__original) function()
	{
		return this.getFaction() <= this.Const.Faction.PlayerAnimals && this.m.IsControlledByPlayer;
	}

	q.onResurrected = @(__original) function(_info)
	{
		__original(_info);
		this.getFlags().add("IsSummoned");
	}
});	