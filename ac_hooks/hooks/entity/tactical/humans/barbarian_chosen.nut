::modAccessoryCompanions.HooksMod.hook("scripts/entity/tactical/humans/barbarian_chosen", function( q )
{
	q.makeMiniboss = @(__original) function()
	{
		__original();
		local loot = this.new("scripts/items/accessory/wardog_item");
		loot.setType(this.Const.Companions.TypeList.Whitewolf);
		loot.giverandXP();
		loot.updateCompanion();
		this.m.Items.equip(loot);
	}
});