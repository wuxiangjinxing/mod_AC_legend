::modAccessoryCompanions.HooksMod.hook("scripts/states/world/asset_manager", function( q ) 
{
	q.update = @(__original) function(_worldState)
	{
		if (this.World.getTime().Hours != this.m.LastHourUpdated && this.m.IsConsumingAssets)
		{
			local roster = this.World.getPlayerRoster().getAll();
			foreach(bro in roster)
			{
				local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
				if (acc != null && "setType" in acc)
				{
					if (acc.getType() != null && acc.m.Wounds > 0)
					{
						acc.m.Wounds = this.Math.max(0, this.Math.floor(acc.m.Wounds - 2));
					}
				}
			}

			local stash = this.World.Assets.getStash().getItems();
			foreach(item in stash)
			{
				if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "setType" in item)
				{
					if (item.getType() != null && item.m.Wounds > 0)
					{
						item.m.Wounds = this.Math.max(0, this.Math.floor(item.m.Wounds - 2));
					}
				}
			}
		}

		__original(_worldState);
	}
});