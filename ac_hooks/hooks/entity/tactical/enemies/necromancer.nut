::modAccessoryCompanions.HooksMod.hook("scripts/entity/tactical/enemies/necromancer", function( q ) 
{

	q.makeMiniboss = @(__original) function()
	{
		__original();
		local loot = this.new("scripts/items/accessory/wardog_item");
		loot.setType(this.Const.Companions.TypeList.TomeReanimation);
		loot.updateCompanion();
		this.m.Items.equip(loot);
	}
	
	q.onDeath = @(__original) function(_killer, _skill, _tile, _fatalityType)
	{
		__original(_killer, _skill, _tile, _fatalityType);
		if ((this.m.Type == this.Const.EntityType.Necromancer) && _killer != null && (_killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals))
		{
			if (this.Math.rand(1, 100) == 1)
			{
				local loot = this.new("scripts/items/accessory/wardog_item");
				loot.setType(this.Const.Companions.TypeList.TomeReanimation);
				loot.updateCompanion();
				loot.drop(_tile);
			}
		}
	}
});