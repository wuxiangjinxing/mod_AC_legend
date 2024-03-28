::modAccessoryCompanions.HooksMod.hook("scripts/entity/tactical/enemies/unhold", function( q ) 
{
	q.onInit = @(__original) function()
	{
		__original();
		if (::Is_PTR_Exist)
		{
			this.m.Skills.removeByID("perk.ptr_survival_instinct");
		}
	}
});